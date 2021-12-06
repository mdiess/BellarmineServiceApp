//
//  ContentView.swift
//  BellarmineServiceApp
//
//  Created by Max Diess on 11/21/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AppViewModel // initializes an environment object that inherits from AppViewModel
    var dataStorage: DataStorage
    var body: some View {
        Home(dataStorage: dataStorage) // front page of the app is shown to be the Home struct
            .environmentObject(AppViewModel()) // need to add this for the environment object present
    }
}

struct ContentView_Previews: PreviewProvider { // just for previewing the app on the side-- not useful
    static var previews: some View {
        ContentView(dataStorage: DataStorage())
    }
}
