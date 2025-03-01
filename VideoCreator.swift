import AVFoundation
import UIKit
import AVKit

class VideoCreator {
    static func createVideo(from images: [UIImage], withAudio audioURL: URL?, completion: @escaping @Sendable (URL?) -> Void) {
        let settings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: 1080,
            AVVideoHeightKey: 1920
        ]
        
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("trip_reel.mp4")

        if FileManager.default.fileExists(atPath: tempURL.path) {
            try? FileManager.default.removeItem(at: tempURL)
        }
        
        guard let videoWriter = try? AVAssetWriter(outputURL: tempURL, fileType: .mp4) else {
            print("❌ Error: Couldn't create AVAssetWriter")
            DispatchQueue.main.async { completion(nil) }
            return
        }
        
        let writerInput = AVAssetWriterInput(mediaType: .video, outputSettings: settings)
        let pixelBufferSettings: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB,
            kCVPixelBufferWidthKey as String: 1080,
            kCVPixelBufferHeightKey as String: 1920
        ]
        
        let pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: writerInput, sourcePixelBufferAttributes: pixelBufferSettings)
        videoWriter.add(writerInput)
        videoWriter.startWriting()
        videoWriter.startSession(atSourceTime: .zero)
        
        let frameDuration = CMTime(seconds: 1.0, preferredTimescale: 600)
        var frameCount = 0

        writerInput.requestMediaDataWhenReady(on: DispatchQueue.global(qos: .background)) {
            let pixelBufferPool = pixelBufferAdaptor.pixelBufferPool
            
            for (index, image) in images.enumerated() {
                let targetSize = CGSize(width: 1080, height: 1920)
                let fixedImage = resizeImage(image: image, targetSize: targetSize)
                
                if let pixelBuffer = pixelBuffer(from: fixedImage, pixelBufferPool: pixelBufferPool) {
                    let presentationTime = CMTimeMultiply(frameDuration, multiplier: Int32(frameCount))
                    if pixelBufferAdaptor.append(pixelBuffer, withPresentationTime: presentationTime) {
                        print("✅ Image \(index + 1) added successfully at \(presentationTime.seconds) sec")
                    } else {
                        print("❌ Failed to append image \(index + 1)")
                    }
                    frameCount += 1
                } else {
                    print("❌ Failed to convert image \(index + 1) to pixel buffer")
                }
            }

            writerInput.markAsFinished()
            videoWriter.finishWriting {
                if videoWriter.status == .completed {
                    print("✅ Video successfully created at: \(tempURL.path)")
                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let destinationURL = documentsURL.appendingPathComponent("trip_reel.mp4")
                    
                    if FileManager.default.fileExists(atPath: destinationURL.path) {
                        try? FileManager.default.removeItem(at: destinationURL)
                    }
                    
                    do {
                        try FileManager.default.moveItem(at: tempURL, to: destinationURL)
                        print("✅ Video moved to: \(destinationURL)")
                        
                        if let audioURL = audioURL {
                            VideoCreator.addAudio(to: destinationURL, from: audioURL) { finalURL in
                                completion(finalURL ?? destinationURL)
                            }
                        } else {
                            completion(destinationURL)
                            DispatchQueue.main.async {
                                let player = AVPlayer(url: destinationURL)
                                let playerViewController = AVPlayerViewController()
                                playerViewController.player = player
                                if let topVC = UIApplication.shared.windows.first?.rootViewController {
                                    topVC.present(playerViewController, animated: true) {
                                        player.play()
                                    }
                                }
                            }
                        }
                    } catch {
                        print("❌ Error moving video file: \(error.localizedDescription)")
                        completion(nil)
                    }
                } else {
                    print("❌ Video writing failed: \(videoWriter.error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                }
            }
        }
    }

    static func addAudio(to videoURL: URL, from audioURL: URL, completion: @escaping (URL?) -> Void) {
        let mixComposition = AVMutableComposition()
        
        let videoAsset = AVURLAsset(url: videoURL)
        let audioAsset = AVURLAsset(url: audioURL)
        
        guard let videoTrack = videoAsset.tracks(withMediaType: .video).first,
              let audioTrack = audioAsset.tracks(withMediaType: .audio).first else {
            print("❌ Error: Could not retrieve video or audio tracks")
            completion(nil)
            return
        }
        
        let videoCompositionTrack = mixComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        let audioCompositionTrack = mixComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        do {
            try videoCompositionTrack?.insertTimeRange(CMTimeRange(start: .zero, duration: videoAsset.duration), of: videoTrack, at: .zero)
            try audioCompositionTrack?.insertTimeRange(CMTimeRange(start: .zero, duration: videoAsset.duration), of: audioTrack, at: .zero)
        } catch {
            print("❌ Error inserting tracks: \(error.localizedDescription)")
            completion(nil)
            return
        }
        
        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("trip_reel_with_audio.mp4")
        
        if FileManager.default.fileExists(atPath: outputURL.path) {
            try? FileManager.default.removeItem(at: outputURL)
        }
        
        guard let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality) else {
            print("❌ Error: Could not create AVAssetExportSession")
            completion(nil)
            return
        }
        
        exporter.outputURL = outputURL
        exporter.outputFileType = .mp4
        exporter.exportAsynchronously {
            DispatchQueue.main.async {
                completion(exporter.status == .completed ? outputURL : nil)
            }
        }
    }

    private static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let originalSize = image.size
        let aspectRatio = min(targetSize.width / originalSize.width, targetSize.height / originalSize.height)

        let newSize = CGSize(
            width: originalSize.width * aspectRatio,
            height: originalSize.height * aspectRatio
        )

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { context in
            UIColor.black.setFill() // Fill background with black
            context.fill(CGRect(origin: .zero, size: targetSize))

            let xOffset = (targetSize.width - newSize.width) / 2
            let yOffset = (targetSize.height - newSize.height) / 2

            image.draw(in: CGRect(x: xOffset, y: yOffset, width: newSize.width, height: newSize.height))
        }
    }


    private static func pixelBuffer(from image: UIImage, pixelBufferPool: CVPixelBufferPool?) -> CVPixelBuffer? {
        guard let pixelBufferPool = pixelBufferPool else {
            print("❌ Pixel buffer pool is nil")
            return nil
        }

        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferPoolCreatePixelBuffer(nil, pixelBufferPool, &pixelBuffer)

        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            print("❌ Failed to create pixel buffer")
            return nil
        }

        CVPixelBufferLockBaseAddress(buffer, [])

        guard let pixelData = CVPixelBufferGetBaseAddress(buffer),
              let cgImage = image.cgImage else {
            print("❌ Failed to get CGImage or pixel buffer data")
            CVPixelBufferUnlockBaseAddress(buffer, [])
            return nil
        }

        let bufferWidth = CVPixelBufferGetWidth(buffer)
        let bufferHeight = CVPixelBufferGetHeight(buffer)

        let imageSize = image.size
        let aspectRatio = min(CGFloat(bufferWidth) / imageSize.width, CGFloat(bufferHeight) / imageSize.height)

        let newSize = CGSize(width: imageSize.width * aspectRatio, height: imageSize.height * aspectRatio)
        let xOffset = (CGFloat(bufferWidth) - newSize.width) / 2
        let yOffset = (CGFloat(bufferHeight) - newSize.height) / 2

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(
            data: pixelData,
            width: bufferWidth,
            height: bufferHeight,
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
        )

        guard let ctx = context else {
            print("❌ Failed to create CGContext")
            CVPixelBufferUnlockBaseAddress(buffer, [])
            return nil
        }

        ctx.setFillColor(UIColor.black.cgColor)
        ctx.fill(CGRect(x: 0, y: 0, width: bufferWidth, height: bufferHeight))

        ctx.draw(cgImage, in: CGRect(x: xOffset, y: yOffset, width: newSize.width, height: newSize.height))

        CVPixelBufferUnlockBaseAddress(buffer, [])

        return buffer
    }


}
