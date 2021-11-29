//
//  Users.swift
//  BellarmineServiceApp
//
//  Created by Max Diess on 11/28/21.
//

import Foundation
import SwiftUI
import CoreLocation
import Firebase

struct Users: Hashable, Codable {
    var userId: [services]
}

class Model: ObservableObject {
    @Published var list = [services]()
    
}
