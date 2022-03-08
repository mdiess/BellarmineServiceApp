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
