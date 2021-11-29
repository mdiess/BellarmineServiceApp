//
//  modelData.swift
//  BellarmineServiceApp
//
//  Created by Max Diess on 11/21/21.
//

import Foundation
import Combine

final class ModelData: ObservableObject {
@Published var Services: [services] = load("data.json") // loads in the data from the data file
}

func load<T: Decodable>(_ filename: String) -> T { // function is used to parse through the data and use it in the app
    let data: Data
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
} // stops the function with fatal errors if it cannot parse through the data from the file

