//
//  Home.swift
//  BellarmineServiceApp
//
//  Created by Max Diess on 11/21/21.
//

/*
*****************************************************************************************************************************
 
 
 The admin view is based out of firebase and all administrators are given acces to the database.
 Through this administrator view, they can add new students, and service opportunities throught the back end.
 Students do not have this capability.
 

*****************************************************************************************************************************
*/

import SwiftUI
import MapKit
import FirebaseAuth
import FirebaseDatabase
import UIKit

class AppViewModel: ObservableObject {
    let auth = Auth.auth()
    @Published var signedIn = false //variable to keep track if user is signed in or not
    @Published var UID = "" //variable for the user id
    var isSignedIn: Bool { //Boolean variable checking if user is signed in
        return auth.currentUser != nil
    }
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, //checks with firebase database if user exists
                    password: password) { [weak self] result, error in
            guard result != nil, error == nil else { //checks if there are no errors and a successful login
                return
            }
            DispatchQueue.main.async { //pushes function to foreground, instead of operating in the background
                self?.signedIn = true //changes the signed in variable to true
            }
        }
        self.UID = email // sets the user id to the email address
    }
    func signUp(email: String, password: String) {
        auth.createUser(withEmail: email, //creates new user profile in the firebase database
                        password: password) { [weak self] result, error in
            guard result != nil, error == nil else { //checks if there are no errors and a successful login
                return
            }
            DispatchQueue.main.async { // pushes function to foreground, instead of operating in the background
                self?.signedIn = true //changes the signed in variable to true
            }
        }
        self.UID = email // sets the user id to the email address
    }
    func signOut() {
        try? auth.signOut() // checks to see if the program can sign out, and runs program if it can
        self.signedIn = false // sets the signed in variable to false
        self.UID = "" //sets the user id to blank
    }
}
/*
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var postData = ["Message", "Message2"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell")!
        cell.textLabel?.text = postData[indexPath.row]
        return cell
    }
    
    
}
*/
struct Home: View {
    @EnvironmentObject var viewModel: AppViewModel // initialize and environment object that inherits from AppViewModel
    var body: some View {
        NavigationView { // makes the pages in its scope be in navigation view
            if viewModel.signedIn { // check if the user is signed in
                serviceList() // goes to the front page if so
            } else {
                SignInView() // does not change pages if false
            }
        }
        .navigationBarBackButtonHidden(true) // hides back button to go back to the profile after signing out
        .navigationBarHidden(true) // hides the extra navigation bar after signing out
        .onAppear {
            viewModel.signedIn = viewModel.isSignedIn // allows the user to stay signed in after exiting the app
        }
    }
}

struct SignInView: View {
    @State var email: String = "" // initializes a variable for the user's email
    @State var password: String = "" // initializes a variable for the user's password
    @EnvironmentObject var viewModel: AppViewModel // initializes an environment object that inherits from AppViewModel
    var body: some View {
            VStack { // Aligns the structures in a vertical fashion down the page
                Image("bcp") //Adds school logo to top of the page
                    .padding(.bottom, 75)
                    .shadow(radius: 10)
                TextField("Email Address", text: $email) // creates a text field for the email address, and takes in the email variable
                    .autocapitalization(.none) //does not autocapitalize
                    .disableAutocorrection(true) //does not autocorrect
                    .frame(width: 300, height: 45) //the rest of these are to make the text field look nice
                    //.background(Color(red: 211/255, green: 211/255, blue: 211/255))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .cornerRadius(22)
                SecureField("Password", text: $password) // creates a text field that encrypts the password, and takes in the password variable
                    .autocapitalization(.none) //does not autocapitalize
                    .disableAutocorrection(true) //does not autocorrect
                    .frame(width: 300, height: 45) //the rest of these are to make the secure field look nice
                    //.background(Color(red: 211/255, green: 211/255, blue: 211/255))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .cornerRadius(22)
                Button(action: {
                    guard !email.isEmpty, !password.isEmpty else { // checks if either of the text fields are empty
                        return
                    }
                    viewModel.signIn(email: email, password: password) // if both are filled, runs the sign in function to check with database if the username and password is correct
                }) {
                    Text("Sign In") // a label on the button, so the user knows what it does
                        .frame(width: 250, height: 45) //all under this are to make the button look nice
                        .foregroundColor(.white)
                        .background(Color(red: 102/255,green: 98/255,blue: 227/255))
                        .cornerRadius(22)
                        .font(.system(size: 16))
                        .shadow(radius: 10)
                }
                .padding(.top, 20)
                NavigationLink("Sign Up", destination: SignUpView()) // adds a link under the sign in button that redirects the user to the sign up page if they do not have a login
                        .padding()
            }
        .navigationTitle("Sign In") //keeps "sign in" at the top
        .navigationBarBackButtonHidden(true) //makes the back button hidden if redirected through a navigation link
    }
}

struct SignUpView: View {
    @State var email: String = "" // initializes a variable for the email address
    @State var password: String = "" // initializes a variable for the password
    @EnvironmentObject var viewModel: AppViewModel // initializes an environment object that inherits from AppViewModel
    var body: some View {
            VStack { // Aligns the structures in a vertical way
                Image("bcp") // adds school logo to top of the page
                    .padding(.bottom, 75)
                    .shadow(radius: 10)
                TextField("Email Address", text: $email) //creates a text field for the user's email, and takes in the email variable
                    .autocapitalization(.none) // no autocapitalization
                    .disableAutocorrection(true) // no autocorrection
                    .frame(width: 300, height: 45) // the rest below are to make the text field look nice
                    //.background(Color(red: 211/255, green: 211/255, blue: 211/255))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .cornerRadius(22)
                SecureField("Password", text: $password) //creates a text field that encrypts the password, and takes in the password variable
                    .autocapitalization(.none) // no autocapitalization
                    .disableAutocorrection(true) // no autocorrection
                    .frame(width: 300, height: 45) // the rest below is to make the secure field look nice
                    //.background(Color(red: 211/255, green: 211/255, blue: 211/255))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .cornerRadius(22)
                Button(action: {
                    guard !email.isEmpty, !password.isEmpty else { // checks if either of the text fields are empty
                        return
                    }
                    viewModel.signUp(email: email, password: password) // if neither are empty, the sign up function is run
                }) {
                    Text("Sign Up") // text on the button to let the user know it's function
                        .frame(width: 250, height: 45) // the rest is to make the button look nice
                        .foregroundColor(.white)
                        .background(Color(red: 102/255,green: 98/255,blue: 227/255))
                        .cornerRadius(22)
                        .font(.system(size: 16))
                        .shadow(radius: 10)
                }
                .padding(.top, 20)
                Spacer()
                
            }
        .navigationTitle("Sign Up") // keeps "sign up" at the top
    }
}

struct serviceList: View {
    @EnvironmentObject var viewModel: AppViewModel // creates an environment object that inherits from AppViewModel
    @EnvironmentObject var modelData: ModelData // creates an environment object that inherits from ModelData
    @State private var showFavsOnly = false // initializes a variable to show if an opportunity is a favorite or not
    var filteredServices: [services] { // initializes variable to filter between showing only saved opportunities or not
        modelData.Services.filter { Service in
            (!showFavsOnly || Service.isFavorite) // checks if opportunity is favorite
        }
    }
    var body: some View {
        List { //creates a list view for all of the service opportunities
            Toggle(isOn: $showFavsOnly) { // creates a toggle button for saved opportunities
                Text("Saved Opportunities")
            }
            ForEach(filteredServices) { Service in // shows each of the service opportunities
                NavigationLink(destination: serviceDetail(Service: Service)) { //makes each of the opportunities a link
                    serviceRow(Service: Service) // redirects to the expanded view of the opportunity
                }
            }
        }
        .navigationTitle("Service Opportunities") // keeps "Service Opportunities" at the top of the page
        .toolbar {
            NavigationLink(destination: ProfilePage()) { // creates a button at the top of the page that goes to the profile page
                Image(systemName: "person.crop.circle") //image representing the button
                    .font(.system(size: 30))
                    .foregroundColor(Color(red: 170/255, green: 170/255, blue: 170/255))
            }
        }
    }
}

struct ProfilePage: View {
    @EnvironmentObject var viewModel: AppViewModel // initializes an environment object that inherits from AppViewModel
    var body: some View {
            VStack { //aligns the structures in a vertical way
                    Image(systemName: "person.crop.circle") // adds a pfp to the top of the page
                        .font(.system(size: 150))
                        .foregroundColor(.gray)
                        .shadow(radius: 10)
                //Text("Student Email")
                Text(viewModel.UID) // makes the user's screen name their email
                    .fontWeight(.bold)
                    .font(.system(size: 30))
                Divider()
                    .padding(.bottom, 20)
                Text("Enter your hours") // initializes the student enter service hours
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .frame(width: 250, height: 45)
                    .background(Color(red: 240/255, green: 240/255, blue: 240/255))
                    .cornerRadius(22)
                    .padding(.bottom, 10)
                CustomProgress() // calls the custom progress struct for the text field, progress bar, and submit button
                Spacer()
                NavigationLink(destination: Home().onAppear() { // creates a link back to the sign in page
                    viewModel.signOut() // runs the sign out function
                }) {
                    Text("Sign Out") // tells the user what the button does
                        .foregroundColor(Color(red: 12/255, green: 78/255, blue: 97/255))
                }
            }
    }
}


struct CustomProgress: View {
    @State var hours: CGFloat = 0 // initializes a variable for amount of service hours
    @State var inputHours: String = "" // initializes a variable to later be used for user input
    var body: some View {
        VStack {
            TextField("Hours", text: $inputHours) //creates a text field that takes in student service hours, and takes in the variable inputHours
                .frame(width: 250, height: 45) // makes the text field look nice
                .background(Color(red: 211/255, green: 211/255, blue: 211/255))
                .cornerRadius(22)
                .multilineTextAlignment(.center)
                .shadow(radius: 1)
                .padding(.bottom, 10)
            ZStack(alignment: .leading) { // aligns objects so they are on top of each other, and starting from the left side of the screen
                ZStack { // aligns objects so they are on top of each other
                    Capsule() // creates an oval shape to be the total amount of progress needed
                        .fill(Color.black.opacity(0.08)) // makes the oval look nice
                        .frame(width: 400, height: 30) // always spans across the entire screen
                        .shadow(radius: 10)
                }
                Capsule() // creates an oval shape to go on top of the other
                    .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 12/255, green: 78/255, blue: 97/255), Color(red: 173/255, green: 216/255, blue: 230/255)]), startPoint: .leading, endPoint: .trailing)) // makes the color of this bar go from dark to light
                    .frame(width: hours, height: 30) // takes in the hours variable, so that it changes length with user input
                    .cornerRadius(22)
                HStack { // aligns structures in a horizontal way
                    if(hours/20 >= 20) { // checks if hours / 20 is greater than or equal to 20
                        Text(String(format: "%.0f", Double(hours/20)) + "/20") // if so, writes down "20/20"
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .padding(.leading, 330)
                    } else {
                        Text(String(format: "%.1f", Double(hours/20)) + "/20") // else, writes down hours with one place behind the decimal /20
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .padding(.leading, 320)
                    }
                }
            }.padding(.bottom, 10)
            Button(action: { // creates button for submitting hours
                guard let n = NumberFormatter().number(from: inputHours) else { return } // changes inputHours to type NSObject
                hours = hours + (CGFloat(truncating: n) * 20.0) //adds new service hours onto total, and converts hours to type CGFloat
                if(hours > 400) { // if user submits more than 20 total hours, the bar only goes so far
                    hours = 400
                }
                inputHours = "" // clears the text field
            }) {
                Text("Submit") // lets user know what the button does
                    .frame(width: 120, height: 45) // makes it look nice
                    .foregroundColor(.white)
                    .background(Color(red: 12/255, green: 78/255, blue: 97/255))
                    .cornerRadius(22)
                    .shadow(radius: 10)
            }
        }
    }
}

struct serviceRow: View {
    var Service: services // initializes var of type services, which is a struct for data of the service opportunities
    var body: some View {
        HStack { // horizontal stack of the objects
            Service.image // adds a member variable of services to the picture field
                .resizable() // resizes the image
                .frame(width: 50, height: 50)
            Text(Service.title) // adds title of service opportunity to the right of the image
            Spacer() // makes all of this align aling the right side
            
            if Service.isFavorite {
                Image(systemName: "bookmark.fill")
                    .foregroundColor(.red)
            }
             
        }
    }
}

struct serviceDetail: View {
    @EnvironmentObject var modelData: ModelData // initializes an environment object that inherits from ModelData
    var Service: services // initializes var of type services, which is a struct for data of the service opportunities
    var serviceIndex: Int { // creates variable of the index of members in services
        modelData.Services.firstIndex(where: { $0.id == Service.id })!
    }
    var body: some View {
        ScrollView { // allows the user to scroll on the page
            VStack { // aligns the structures in vertical way
                mapview(coordinate: Service.locationCoordinate) // calls the struct mapview to be at the top of the page
                    .frame(height: 300) // sets dimensions of map
                    .ignoresSafeArea(edges: .top) // makes map look nice
                circleimage(image: Service.image) // calls the struct circleimage which makes the picture look nice
                    .offset(y: -130) // makes the emage be half on top of the map
                    .padding(.bottom, -130) // moves up the padding on the image
                VStack(alignment: .leading) { // aligns structures in a vertical way, with them starting on the right side
                    HStack { // aligns structures in a horizontal way
                        Text(Service.title) // adds title from services
                            .font(.title)
                            .foregroundColor(.red) //changes color for looks
                        SavedButton(isSet: $modelData.Services[serviceIndex].isFavorite) // calls struct saved button, and allows for toggle to only show saved opportunities
                    }
                    HStack { // aligns structures in a horizontal way
                        Text(Service.place) // tells what place the opportunity is in
                            .font(.subheadline)
                        Spacer() // makes place and city be on opposite sides of the page
                        Text(Service.city) // tells the city the opportunity is in
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    Divider()
                    Text("About \(Service.title)") // gives title for the about section
                        .font(.title2)
                    Text(Service.description) // gives the about section
                }
                .padding()
                Spacer()
            }
            //.navigationBarHidden(true)
        }
    }
}

struct circleimage: View {
    var image: Image // initializes variable the is an image
    var body: some View {
        image // takes in the image
            .clipShape(Circle()) // the rest of these are to put the image in a nice looking circular frame
            .font(.system(size: 100))
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 7)
            .background(Circle())
            .foregroundColor(.white)
    }
}

struct mapview: View {
    var coordinate: CLLocationCoordinate2D // initializes a variable of a type that is able to pinpoint the place on a map
    @State private var region = MKCoordinateRegion() // initializes a variable to show the region the coordinates are in
    var body: some View {
        Map(coordinateRegion: $region) // calls a function to show the map
            .onAppear {
                setRegion(coordinate) // goes to the region where the coordinates are
            }
    }
    private func setRegion(_ coordinate: CLLocationCoordinate2D){ // function to choose how much is shown on the map
        region = MKCoordinateRegion(
            center: coordinate, // center of the map is the exact place of the coordinates
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2) // chooses how far out the map zooms
        )
    }
}

struct SavedButton: View {
    @Binding var isSet: Bool // creates a boolean variable that can be changed-- binding connects the variable to the member in services, so that data can be changed as well
    var body: some View {
        Button {
            isSet.toggle() // creates the toggle button that has just two options
        } label: {
            Image(systemName: isSet ? "bookmark.fill" : "bookmark") // if it is on, the bookmark label is filled in, and see through if not
                //.labelStyle(.iconOnly)
                .foregroundColor(isSet ? .red : .gray) // bookmark is red if it is saved, outlined in gray if not
        }
    }
}

struct Home_Previews: PreviewProvider { // this whole struct is just used to preview the first page-- not useful
    static var previews: some View {
        Home()
    }
}

