import UIKit
import AVKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var selectedImages: [UIImage] = []
    var videoURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        let selectImagesButton = UIButton(type: .system)
        selectImagesButton.setTitle("Select Images", for: .normal)
        selectImagesButton.addTarget(self, action: #selector(selectImages), for: .touchUpInside)
        selectImagesButton.frame = CGRect(x: 50, y: 100, width: 200, height: 50)
        view.addSubview(selectImagesButton)
        
        let createReelButton = UIButton(type: .system)
        createReelButton.setTitle("Create Reel", for: .normal)
        createReelButton.addTarget(self, action: #selector(createReel), for: .touchUpInside)
        createReelButton.frame = CGRect(x: 50, y: 180, width: 200, height: 50)
        view.addSubview(createReelButton)
        
        let playReelButton = UIButton(type: .system)
        playReelButton.setTitle("Play Reel", for: .normal)
        playReelButton.addTarget(self, action: #selector(playReel), for: .touchUpInside)
        playReelButton.frame = CGRect(x: 50, y: 260, width: 200, height: 50)
        view.addSubview(playReelButton)
    }
    
    @objc func selectImages() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        picker.mediaTypes = ["public.image"]
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImages.append(image)
        }
        picker.dismiss(animated: true)
    }
    
    @objc func createReel() {
        guard !selectedImages.isEmpty else {
            print("❌ No images selected!")
            return
        }
        
        let audioURL: URL? = nil  // Set this if you want to add an audio track
        
        VideoCreator.createVideo(from: selectedImages, withAudio: audioURL) { [weak self] videoURL in
            guard let self = self, let videoURL = videoURL else {
                print("❌ Failed to create video")
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let fileManager = FileManager.default
                    let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let destinationURL = documentsURL.appendingPathComponent("trip_reel.mp4")

                    // Remove existing file if needed
                    if fileManager.fileExists(atPath: destinationURL.path) {
                        try fileManager.removeItem(at: destinationURL)
                    }
                    
                    // Move video from temp to documents directory
                    try fileManager.moveItem(at: videoURL, to: destinationURL)
                    
                    print("✅ Video saved at \(destinationURL)")
                    self.videoURL = destinationURL
                } catch {
                    print("❌ Error saving video: \(error.localizedDescription)")
                }
            }
        }
    }

    
    @objc func playReel() {
        guard let videoURL = videoURL else {
            print("❌ No video available to play")
            return
        }
        
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: videoURL.path) {
            print("❌ Video file does not exist at: \(videoURL.path)")
            return
        }

        print("🎬 Playing video from: \(videoURL)")
        
        DispatchQueue.main.async {
            let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                player.play()
            }
        }
    }


    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status", let player = object as? AVPlayer {
            if player.status == .failed {
                print("❌ Video playback error:", player.error?.localizedDescription ?? "Unknown error")
            }
        }
    }
}
