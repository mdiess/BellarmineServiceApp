//
//  BellarmineServiceAppApp.swift
//  BellarmineServiceApp
//
//  Created by Max Diess on 11/21/21.
//

import SwiftUI
import Firebase
import FirebaseDatabase

@main
struct BellarmineServiceAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate // initializes appDelegate
    @StateObject private var modelData = ModelData() // state object for the saved button
    var body: some Scene {
        WindowGroup {
            let dataStorage = DataStorage()
            let viewModel = AppViewModel() // initializes viewModel
            ContentView(dataStorage: dataStorage)
                .environmentObject(viewModel) // need environment objects for the environment objects in the main section of code
                .environmentObject(modelData) 
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate { // entire function is used to connect the firebase database with the app
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
