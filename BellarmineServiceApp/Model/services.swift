//
//  services.swift
//  BellarmineServiceApp
//
//  Created by Max Diess on 11/21/21.
//

import Foundation
import SwiftUI
import CoreLocation
import FirebaseFirestore

struct services: Hashable, Codable, Identifiable { // struct to initializes all the variables in the service opportunities
    var id: String
    var title: String
    var place: String
    var city: String
    var description: String
    var isFavorite: Bool
    var year: Int
    
    private var imageName: String
    //var latitude: Double
    //var longitude: Double
    var image: Image {
        Image(imageName) // makes the string for the imageName input an image
    }
    
    private var coordinates: Coordinates
    var locationCoordinate: CLLocationCoordinate2D{
        CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude) // converts the coordinate variables to actual coordinates
    }
    struct Coordinates: Hashable, Codable {
        var latitude: Double
        var longitude: Double
    }
}
/*
class ModelData: ObservableObject {
    @Published var list = [services]()
    func getData() {
        let db = Firestore.firestore()
        db.collection("Service Opportunities").getDocuments { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                       self.list = snapshot.documents.map { a in
                           return services(id: a.documentID,
                                           title: a["title"] as? String ?? "",
                                           place: a["place"] as? String ?? "",
                                           city: a["city"] as? String ?? "",
                                           description: a["description"] as? String ?? "",
                                           imageName: a["imageName"] as? String ?? "",
                                           latitude: a["latitude"] as? Double ?? 0,
                                           longitude: a["longitude"] as? Double ?? 0)
                       }
                   }
               } else {
                   
               }
            }
        }
    }
}
*/
