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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    //@StateObject private var modelData = ModelData()
    var body: some Scene {
        WindowGroup {
            let viewModel = AppViewModel()
            ContentView()
                .environmentObject(viewModel)
                //.environmentObject(modelData)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    //var ref: DatabaseReference! = Database.database().reference()
}
