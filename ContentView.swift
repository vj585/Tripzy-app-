
import SwiftUI
import UIKit

struct WelcomeView: View {
    var body: some View {
        
        NavigationStack {
            VStack {
                Spacer()
                
                Image("applogo") // Replace with actual logo
                    .resizable()
                    .scaledToFit()
                    .frame(width: 190, height:190 )
                
                Text("Welcome to Tripzy!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                    .padding(.bottom)
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    FeatureRow(icon: "camera.fill", iconColor: .blue, title: "Capture Your Journey", description: "Snap and store your travel moments.")
                    
                    FeatureRow(icon: "map.fill", iconColor: .green, title: "Plan Your Next Adventure", description: "Store all trip details in one place.")
                    
                    FeatureRow(icon: "play.rectangle.fill", iconColor: .purple, title: "Relive Memories with Reels", description: "Turn photos into video stories.")
                }
                .padding(.horizontal, 20)

                .padding(.all)

 
                Spacer()
                Image("paperplane") // Replace with your actual image name
                                .resizable()
                                .scaledToFit()
                                .frame(width: 350, height: 380)
                                .position(x: 180, y:100) // Adjust position
                                .opacity(0.3)
        


                NavigationLink(destination: UserInfoView()) {
                    Text("Next")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
            }
            
        }
        
    }
}

struct FeatureRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .font(.system(size: 30))
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}


// MARK: - User Info View (First Screen)
struct UserInfoView: View {
    @State private var name: String = ""
    @State private var age: String = ""
    @FocusState private var isNameFocused: Bool
    @State private var navigateToNextScreen = false
    
    var body: some View {
        NavigationStack {
            VStack {
            
                
                Image("applogo") // Replace with actual logo
                    .resizable()
                    .scaledToFit()
                    .frame(width: 170, height: 170)

                Text("Tripzy")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding([.bottom, .trailing])
                    .padding()
                
                TextField("Enter your name", text: $name)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                    .focused($isNameFocused)

                TextField("Enter your age", text: $age)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                    .keyboardType(.numberPad)


                NavigationLink(destination: HomeView(userName: name), isActive: $navigateToNextScreen) {
                    EmptyView()
                }

                Button(action: {
                    navigateToNextScreen = true
                }) {
                    Text("Save & Continue")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.all)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 10)

                Spacer()
            }
            .padding()
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

// MARK: - Home View (Second Screen)
import SwiftUI

import SwiftUI

import SwiftUI

import SwiftUI

import SwiftUI

import SwiftUI

struct HomeView: View {
    var userName: String
    @State private var visitedTrips: [Trip] = []
    @State private var plannedTrips: [PlannedTrip] = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Fixed Header
                VStack {
                    HStack {
                        Image("applogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                        
                        Text("Tripzy")
                            .font(.title)
                            .bold()
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.systemBackground)) // Adapts to light/dark mode
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                
                // Scrollable Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Welcome Message
                        Text("Hi, \(userName) 👋🏻")
                            .font(.largeTitle)
                            .bold()
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                        
                        // Add New Trip & View Trips
                        VStack(spacing: 15) {
                            NavigationLink(destination: NewTripView()) {
                                VStack {
                                    Image(systemName: "plus")
                                        .font(.largeTitle)
                                        .foregroundColor(Color.black)
                                    Text("Add New Trip")
                                        .foregroundColor(.black)
                                        .font(.headline)
                                }
                                .frame(width: 150, height: 150)
                                .background(Color(.systemGray))
                                .cornerRadius(20)
                                .shadow(radius: 5)
                            }
                            
                            NavigationLink(destination: TripListView()) {
                                HStack {
                                    Text("View My Trips ")
                                        .font(.headline)
                                    Image(systemName: "suitcase.fill")
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            
                            NavigationLink(destination: PlanTripView(plannedTrips: $plannedTrips)) {
                                HStack {
                                    Image(systemName: "calendar.badge.plus")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                    Text("Plan New Trip")
                                        .font(.title3)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                                .shadow(radius: 4)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Visited Trips Section
                        if !visitedTrips.isEmpty {
                            Text("Visited Trips✈️")
                                .font(.headline)
                                .padding(.horizontal, 20)
                                .padding(.top, 10)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(visitedTrips.prefix(5)) { trip in
                                        NavigationLink(destination: TripDetailView(trip: trip)) {
                                            TripCard(trip: trip)
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        // Planned Trips Section
                        if !plannedTrips.isEmpty {
                            Text("Planned Trips📝")
                                .font(.headline)
                                .padding(.horizontal, 20)
                                .padding(.top, 10)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(plannedTrips.prefix(5)) { trip in
                                        NavigationLink(destination: PlannedTripDetailView(trip: trip)) {
                                            PlannedTripCard(trip: trip)
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
                .onAppear {
                    DispatchQueue.main.async {
                        loadTrips()
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func loadTrips() {
        visitedTrips = Trip.loadTrips().filter { !$0.photoData.isEmpty }
        plannedTrips = PlannedTrip.loadPlannedTrips()
    }
}




struct TripCard: View {
    var trip: Trip
    
    var body: some View {
        VStack(alignment: .leading) {
            if let firstImageData = trip.photoData.first,
               let image = UIImage(data: firstImageData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 100)
                    .foregroundColor(.gray)
            }
            
            Text(trip.name)
                .font(.headline)
                .lineLimit(1)
                .padding(.top, 5)
        }
        .frame(width: 150)
    }
}

struct PlannedTripCard: View {
    var trip: PlannedTrip
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                Rectangle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(height: 100)
                    .cornerRadius(10)

                Image(systemName: "calendar")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .padding(8)
                    .foregroundColor(.blue)
            }

            Text(trip.name)
                .font(.headline)
                .lineLimit(1)
                .padding(.top, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(width: 150)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}




struct PlannedTripDetailView: View {
    var trip: PlannedTrip
    @State private var itinerary: [ChecklistItem]
    @State private var packingList: [ChecklistItem]
    @Environment(\.presentationMode) var presentationMode
    
    init(trip: PlannedTrip) {
        self.trip = trip
        _itinerary = State(initialValue: trip.itinerary.map { ChecklistItem(title: $0.title, isChecked: UserDefaults.standard.bool(forKey: "itinerary_\(trip.id)_\($0.title)")) })
        _packingList = State(initialValue: trip.packingList.map { ChecklistItem(title: $0.title, isChecked: UserDefaults.standard.bool(forKey: "packing_\(trip.id)_\($0.title)")) })
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text(trip.name)
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Itinerary")
                        .font(.title)
                        .bold()
                    ChecklistView(items: $itinerary)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .shadow(radius: 2)
                    
                    Text("Packing List")
                        .font(.title)
                        .bold()
                    ChecklistView(items: $packingList)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .shadow(radius: 2)
                }
                .padding(.horizontal)
                
                Button(action: saveChanges) {
                    Text("Save Changes")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
    
    private func saveChanges() {
        for item in itinerary {
            UserDefaults.standard.set(item.isChecked, forKey: "itinerary_\(trip.id)_\(item.title)")
        }
        for item in packingList {
            UserDefaults.standard.set(item.isChecked, forKey: "packing_\(trip.id)_\(item.title)")
        }
        presentationMode.wrappedValue.dismiss()
    }
}



struct ChecklistItem: Identifiable, Codable {
    let id = UUID()
    var title: String
    var isChecked: Bool
}


struct ChecklistView: View {
    @Binding var items: [ChecklistItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach($items) { $item in
                HStack {
                    Button(action: { item.isChecked.toggle() }) {
                        Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(item.isChecked ? .green : .gray)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Text(item.title)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                .padding(.vertical, 5)
            }
        }
        .padding(.horizontal)
    }
}

struct SectionHeader: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .padding(.top, 10)
            .padding(.horizontal)
    }
}



// ✅ Date Formatter (Remains the same)
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()



import SwiftUI

import SwiftUI

struct PlanTripView: View {
    @Binding var plannedTrips: [PlannedTrip]
    
    @State private var destination: String = ""
    @State private var itineraryList: [ListItem] = []
    @State private var packingList: [ListItem] = []
    @State private var tripReminder: Bool = UserDefaults.standard.bool(forKey: "TripReminder")
    @State private var newItineraryItem: String = ""
    @State private var newPackingItem: String = ""

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                
                    TextField("Enter Destination", text: $destination)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    // **🔥 Itinerary Section**
                    VStack(alignment: .leading) {
                        Text("Itinerary")
                            .font(.headline)
                            .padding(.horizontal)

                        HStack {
                            TextField("Add an itinerary item", text: $newItineraryItem)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            Button(action: {
                                if !newItineraryItem.isEmpty {
                                    itineraryList.append(ListItem(title: newItineraryItem, isChecked: false))
                                    newItineraryItem = ""
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.blue)
                                    .font(.title)
                            }
                        }
                        .padding(.horizontal)

                        ForEach($itineraryList.indices, id: \.self) { index in
                            HStack {
                                TextField("Edit itinerary item", text: $itineraryList[index].title)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())

                                Image(systemName: itineraryList[index].isChecked ? "checkmark.circle.fill" : "circle")
                                    .onTapGesture {
                                        itineraryList[index].isChecked.toggle()
                                    }
                            }
                            .padding(.horizontal)
                        }
                    }

                    // **🔥 Packing List Section**
                    VStack(alignment: .leading) {
                        Text("Packing List")
                            .font(.headline)
                            .padding(.horizontal)

                        HStack {
                            TextField("Add a packing item", text: $newPackingItem)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            Button(action: {
                                if !newPackingItem.isEmpty {
                                    packingList.append(ListItem(title: newPackingItem, isChecked: false))
                                    newPackingItem = ""
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.blue)
                                    .font(.title)
                            }
                        }
                        .padding(.horizontal)

                        ForEach($packingList.indices, id: \.self) { index in
                            HStack {
                                TextField("Edit packing item", text: $packingList[index].title)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())

                                Image(systemName: packingList[index].isChecked ? "checkmark.circle.fill" : "circle")
                                    .onTapGesture {
                                        packingList[index].isChecked.toggle()
                                    }
                            }
                            .padding(.horizontal)
                        }
                    }

                    Toggle("Receive reminders", isOn: $tripReminder)
                        .padding(.horizontal)
                        .onChange(of: tripReminder) { newValue in
                            UserDefaults.standard.set(newValue, forKey: "TripReminder")
                        }

                    Spacer()

                    Button(action: saveTripPlan) {
                        Text("Save Plan")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
                .onAppear {
                    resetLists()
                }
            }
            .navigationTitle("Plan Your New Trip")
            
        }
    }

    /// **🔥 Clears lists when planning a new trip**
    private func resetLists() {
        itineraryList = []
        packingList = []
    }

    /// **🔥 Saves the planned trip & updates HomeView**
    private func saveTripPlan() {
        let plannedTrip = PlannedTrip(
            name: destination,
            startDate: Date(),
            endDate: Date(),
            itinerary: itineraryList,
            packingList: packingList
        )

        plannedTrips.append(plannedTrip)
        PlannedTrip.savePlannedTrips(plannedTrips)

        presentationMode.wrappedValue.dismiss()
    }
}


// **🔥 UserDefaults Helper**
import Foundation

struct UserDefaultsHelper {
    static func loadList(forKey key: String) -> [ListItem] {
        if let data = UserDefaults.standard.data(forKey: key),
           let decodedList = try? JSONDecoder().decode([ListItem].self, from: data) {
            return decodedList
        }
        return []
    }
    
    static func saveList(_ list: [ListItem], forKey key: String) {
        if let encodedData = try? JSONEncoder().encode(list) {
            UserDefaults.standard.set(encodedData, forKey: key)
        }
    }
}


// **🔥 ListItem Model**
struct ListItem: Codable, Identifiable {
    var id = UUID()
    var title: String
    var isChecked: Bool
}

struct PlannedTrip: Codable, Identifiable {
    var id = UUID()
    var name: String
    var startDate: Date
    var endDate: Date
    var itinerary: [ListItem] = []  // ✅ Add this
    var packingList: [ListItem] = []  // ✅ Add this

    static func loadPlannedTrips() -> [PlannedTrip] {
        if let data = UserDefaults.standard.data(forKey: "PlannedTrips"),
           let decodedTrips = try? JSONDecoder().decode([PlannedTrip].self, from: data) {
            return decodedTrips
        }
        return []
    }

    static func savePlannedTrips(_ trips: [PlannedTrip]) {
        if let encodedData = try? JSONEncoder().encode(trips) {
            UserDefaults.standard.set(encodedData, forKey: "PlannedTrips")
        }
    }
}




// MARK: - New Trip View (Third Screen)
import PhotosUI  // Needed for image selection

struct NewTripView: View {
    @State private var tripName: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var tripabout: String = ""
    @State private var selectedImages: [UIImage] = []
    @State private var showImagePicker = false

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("New Trip")
                .font(.largeTitle)
                .bold()
                .padding()

            TextField("Enter trip name", text: $tripName)
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .padding(.horizontal)

            DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .padding()

            DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .padding()

            TextField("Tell about your trip:", text: $tripabout)
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(selectedImages, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit() // Ensures images keep their original aspect ratio
                            .frame(width: UIScreen.main.bounds.width, height: 170) // Adjust height as needed
                            .clipped()
                            .cornerRadius(20)
                            .shadow(radius: 5)
                    }
                }
                .padding(.horizontal, 20)
            }


            Button(action: {
                showImagePicker = true
            }) {
                HStack {
                    Text("Add Trip Photos")
                        .font(.headline)
                    
                    Image(systemName: "photo.artframe")
                        .font(.headline)
                }
                .padding()
                .frame(maxWidth: .infinity) // Expands the entire HStack, not just the image
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()
}
            .padding(.horizontal)

            Spacer()

            Button(action: {
                saveTrip()
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Create Trip")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            }
        }
        .padding()
        .onTapGesture {
            hideKeyboard()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImages: $selectedImages)
        }
    }

    private func saveTrip() {
        let imageDataArray = selectedImages.map { $0.jpegData(compressionQuality: 0.8) ?? Data() }
        let newTrip = Trip(
            name: tripName,
            startDate: startDate,
            endDate: endDate,
            tripabout: tripabout,
            photoData: imageDataArray,
            itinerary: [], // Empty itinerary list for new trips
            packingList: [] // Empty packing list for new trips
        )

        var trips = Trip.loadTrips()
        trips.append(newTrip)

        Trip.saveTrips(trips)

        print("✅ Trip saved: \(newTrip.name), with \(newTrip.photoData.count) photos")
    }


}

// MARK: - Trip List View (Fourth Screen)
struct TripListView: View {
    @State private var trips: [Trip] = []

    var body: some View {
        NavigationStack {
            VStack {
                if trips.isEmpty {
                    VStack {
                        Text("No trips available. Add a new trip!")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
                        Button(action: {
                            // Navigate to add trip screen (Implement accordingly)
                        }) {
                            Label("Add Trip", systemImage: "plus")
                                .font(.title2)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                } else {
                    List(trips) { trip in
                        NavigationLink(destination: TripDetailView(trip: trip)) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(trip.name)
                                    .font(.headline)
                                    .bold()

                                Text("Start: \(formatDate(trip.startDate))")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)

                                Text("End: \(formatDate(trip.endDate))")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            }
            .navigationTitle("My Trips")
            .toolbar {

            }
            .onAppear {
                trips = Trip.loadTrips() // Reload trips when view appears
            }
        }
    }
}

import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 0 // 0 means unlimited selection
        config.filter = .images // Only allow images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            for result in results {
                result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                    if let image = object as? UIImage {
                        DispatchQueue.main.async {
                            self.parent.selectedImages.append(image)
                        }
                    }
                }
            }
        }
    }
}



import AVFoundation
import AVKit


struct VideoPlayerView: UIViewControllerRepresentable {
    let videoURL: URL

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        return playerViewController
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        if uiViewController.player?.currentItem == nil {
            let player = AVPlayer(url: videoURL)
            uiViewController.player = player
        }
    }
}
// ✅ TripDetailView remains unchanged

import SwiftUI
import AVKit

import SwiftUI
import AVKit

import SwiftUI
import AVKit


struct TripPlannerView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Plan Your Trip")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Button("Close") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
    }
}
import SwiftUI
import AVKit

struct TripDetailView: View {
    let trip: Trip
    @State private var videoURL: URL?
    @State private var isPresentingVideo = false // ✅ Control full-screen playback

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // 📌 Trip Title
                Text(trip.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 5)

                // 📌 Trip Date
                Text("Trip Date: \(trip.startDate, formatter: dateFormatter) - \(trip.endDate, formatter: dateFormatter)")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                // 📌 Trip Description
                if !trip.tripabout.isEmpty {
                    Text(trip.tripabout)
                        .font(.body)
                        .padding(.bottom, 10)
                } else {
                    Text("No description available.")
                        .italic()
                        .foregroundColor(.gray)
                }

                // 📌 Display Photos
                if !trip.photos.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(trip.photos, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 150)
                                    .clipped()
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.bottom, 10)
                } else {
                    Text("No photos available.")
                        .italic()
                        .foregroundColor(.gray)
                }

                // 🎬 "Play Reel" Button
                Button(action: createReel) {
                    Text("Play Reel")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(trip.photos.isEmpty ? Color.gray : Color.blue)
                        .cornerRadius(10)
                }
                .disabled(trip.photos.isEmpty)
            }
            .padding()
        }
        .fullScreenCover(isPresented: $isPresentingVideo) { // ✅ Open Full-Screen Player
            if let videoURL = videoURL {
                FullScreenVideoPlayer(videoURL: videoURL)
            }
        }
    }

    // 🎬 Create and Play Video Reel
    private func createReel() {
        guard !trip.photos.isEmpty else {
            print("❌ No photos to create reel")
            return
        }

        VideoCreator.createVideo(from: trip.photos, withAudio: nil) { url in
            DispatchQueue.main.async {
                if let url = url {
                    print("✅ Video created at: \(url)")
                    self.videoURL = url
                    isPresentingVideo = true
                } else {
                    print("❌ Failed to create video")
                }
            }
        }
    }
}

// 📆 Date Formatter

import SwiftUI
import AVKit

struct FullScreenVideoPlayer: UIViewControllerRepresentable {
    let videoURL: URL

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerVC = AVPlayerViewController()
        let player = AVPlayer(url: videoURL)

        playerVC.player = player
        playerVC.modalPresentationStyle = .fullScreen

        print("🎬 Attempting to play video at \(videoURL.path)")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            player.play()
            print("▶️ AVPlayer should now start playing")
        }

        return playerVC
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}


// Date Formatter


struct EditTripView: View {
    @Binding var trip: Trip
    @State private var selectedImages: [UIImage] = []
    @State private var showImagePicker = false

    var body: some View {
        VStack {
            Text("Add Photos to \(trip.name)")
                .font(.title2)
                .bold()

            ScrollView(.horizontal) {
                HStack {
                    ForEach(selectedImages, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            .padding()

            Button(action: {
                showImagePicker = true
            }) {
                Text("Select Photos")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            Button(action: {
                savePhotos()
            }) {
                Text("Save Photos")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            Spacer()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImages: $selectedImages)
        }
    }

    private func savePhotos() {
        let newPhotoData = selectedImages.compactMap { $0.jpegData(compressionQuality: 0.8) }
        trip.photoData.append(contentsOf: newPhotoData) // Append new images
        var trips = Trip.loadTrips()
        if let index = trips.firstIndex(where: { $0.id == trip.id }) {
            trips[index] = trip
            Trip.saveTrips(trips)
        }
    }
}

struct TripItem: Codable {
    var title: String
    var isChecked: Bool
}



// MARK: - Data Model for Trip
import UIKit

struct Trip: Codable, Identifiable {
    var id = UUID()
    var name: String
    var startDate: Date
    var endDate: Date
    var tripabout: String
    var photoData: [Data]
    var itinerary: [ListItem]
    var packingList: [ListItem]
    
    var photos: [UIImage] {
        photoData.compactMap { UIImage(data: $0) }
    }
    
    init(name: String, startDate: Date, endDate: Date, tripabout: String, photoData: [Data], itinerary: [ListItem], packingList: [ListItem]) {
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.tripabout = tripabout
        self.photoData = photoData
        self.itinerary = itinerary
        self.packingList = packingList
    }
    
    static func loadTrips() -> [Trip] {
        if let data = UserDefaults.standard.data(forKey: "trips") {
            let decoder = JSONDecoder()
            return (try? decoder.decode([Trip].self, from: data)) ?? []
        }
        return []
    }
    
    static func saveTrips(_ trips: [Trip]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(trips) {
            UserDefaults.standard.set(data, forKey: "trips")
        }
    }
}






// MARK: - Helper Functions
func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: date)
}

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


// MARK: - App Entry Point
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
