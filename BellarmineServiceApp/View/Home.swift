//
//  Home.swift
//  BellarmineServiceApp
//
//  Created by Max Diess on 11/21/21.
//

import SwiftUI
import MapKit
import FirebaseAuth

class AppViewModel: ObservableObject {
    //@Published var username = ""
    let auth = Auth.auth()
    @Published var signedIn = false
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email,
                    password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            DispatchQueue.main.async {
                self?.signedIn = true
                //self?.username = email
            }
            //self?.username = email
        }
    }
    func signUp(email: String, password: String) {
        auth.createUser(withEmail: email,
                        password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            DispatchQueue.main.async {
                self?.signedIn = true
                //self?.username = email
            }
            //self?.username = email
        }
    }
    func signOut() {
        try? auth.signOut()
        self.signedIn = false
    }
}

struct Home: View {
    @EnvironmentObject var viewModel: AppViewModel
    var body: some View {
        NavigationView {
            if viewModel.signedIn {
                serviceList()
            } else {
                SignInView()
            }
        }
        .onAppear {
            viewModel.signedIn = viewModel.isSignedIn
        }
    }
}

struct SignInView: View {
    @State var email: String = ""
    @State var password: String = ""
    @EnvironmentObject var viewModel: AppViewModel
    var body: some View {
            VStack {
                Image("bcp").padding(.bottom, 75)
                TextField("Email Address", text: $email)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .frame(width: 300, height: 45)
                    .background(Color(red: 211/255, green: 211/255, blue: 211/255))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .cornerRadius(22)
                SecureField("Password", text: $password)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .frame(width: 300, height: 45)
                    .background(Color(red: 211/255, green: 211/255, blue: 211/255))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .cornerRadius(22)
                Button(action: {
                    guard !email.isEmpty, !password.isEmpty else {
                        return
                    }
                    viewModel.signIn(email: email, password: password)
                   // viewModel.username = email
                }) {
                    Text("Sign In")
                        .frame(width: 250, height: 45)
                        .foregroundColor(.white)
                        .background(Color(red: 102/255,green: 98/255,blue: 227/255))
                        .cornerRadius(22)
                        .font(.system(size: 16))
                        .shadow(radius: 10)
                }
                .padding(.top, 20)
                NavigationLink("Sign Up", destination: SignUpView())
                        .padding()
            }
        .navigationTitle("Sign In")
        .navigationBarBackButtonHidden(true)
    }
}

struct SignUpView: View {
    @State var email: String = ""
    @State var password: String = ""
    @EnvironmentObject var viewModel: AppViewModel
    var body: some View {
            VStack {
                Image("bcp").padding(.bottom, 75)
                TextField("Email Address", text: $email)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .frame(width: 300, height: 45)
                    .background(Color(red: 211/255, green: 211/255, blue: 211/255))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .cornerRadius(22)
                SecureField("Password", text: $password)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .frame(width: 300, height: 45)
                    .background(Color(red: 211/255, green: 211/255, blue: 211/255))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .cornerRadius(22)
                Button(action: {
                    guard !email.isEmpty, !password.isEmpty else {
                        return
                    }
                    viewModel.signUp(email: email, password: password)
                }) {
                    Text("Sign Up")
                        .frame(width: 250, height: 45)
                        .foregroundColor(.white)
                        .background(Color(red: 102/255,green: 98/255,blue: 227/255))
                        .cornerRadius(22)
                        .font(.system(size: 16))
                        .shadow(radius: 10)
                }
                .padding(.top, 20)
                Spacer()
                
            }
        .navigationTitle("Sign Up")
    }
}

struct serviceList: View {
    @EnvironmentObject var viewModel: AppViewModel
    var body: some View {
        List(Services) { Service in
            NavigationLink(destination: serviceDetail(Service: Service)) {
                serviceRow(Service: Service)
            }
        }
        .navigationTitle("Service Opportunities")
        .toolbar {
            NavigationLink(destination: ProfilePage()) {
                Image(systemName: "person.crop.circle")
            }
        }
    }
}

struct ProfilePage: View {
    @EnvironmentObject var viewModel: AppViewModel
    var body: some View {
            VStack {
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 150))
                        .foregroundColor(.gray)
                        .shadow(radius: 10)
                Text("Student Email")
               // Text(viewModel.username)
                        .fontWeight(.bold)
                        .font(.system(size: 40))
                    Divider()
                        .padding(.bottom, 20)
                Text("Enter your hours")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .frame(width: 250, height: 45)
                    .background(Color(red: 240/255, green: 240/255, blue: 240/255))
                    .cornerRadius(22)
                    .padding(.bottom, 10)
                CustomProgress()
                Spacer()
                NavigationLink(destination: SignInView().onAppear() {
                    viewModel.signOut()
                }) {
                    Text("Sign Out")
                        .foregroundColor(Color(red: 12/255, green: 78/255, blue: 97/255))
                }
            }
    }
}


struct CustomProgress: View {
    @State var hours: CGFloat = 0
    @State var inputHours: String = ""
    var body: some View {
        VStack {
            TextField("Hours", text: $inputHours)
                .frame(width: 250, height: 45)
                .background(Color(red: 211/255, green: 211/255, blue: 211/255))
                .cornerRadius(22)
                .multilineTextAlignment(.center)
                .shadow(radius: 1)
                .padding(.bottom, 10)
            ZStack(alignment: .leading) {
                ZStack {
                    Capsule()
                        .fill(Color.black.opacity(0.08))
                        .frame(width: 400, height: 30)
                        .shadow(radius: 10)
                }
                Capsule()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 12/255, green: 78/255, blue: 97/255), Color(red: 173/255, green: 216/255, blue: 230/255)]), startPoint: .leading, endPoint: .trailing))
                    .frame(width: hours, height: 30)
                    .cornerRadius(22)
                HStack {
                    if(hours/20 >= 20) {
                        Text(String(format: "%.0f", Double(hours/20)) + "/20")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .padding(.leading, 330)
                    } else {
                        Text(String(format: "%.1f", Double(hours/20)) + "/20")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .padding(.leading, 320)
                    }
                }
            }.padding(.bottom, 10)
            Button(action: {
                guard let n = NumberFormatter().number(from: inputHours) else { return }
                hours = hours + (CGFloat(truncating: n) * 20.0)
                if(hours > 400) {
                    hours = 400
                }
                inputHours = ""
            }) {
                Text("Submit")
                    .frame(width: 120, height: 45)
                    .foregroundColor(.white)
                    .background(Color(red: 12/255, green: 78/255, blue: 97/255))
                    .cornerRadius(22)
                    .shadow(radius: 10)
            }
        }
    }
}

struct serviceRow: View {
    var Service: services
    var body: some View {
        HStack {
            Service.image
                .resizable()
                .frame(width: 50, height: 50)
            Text(Service.title)
            Spacer()
        }
    }
}

struct serviceDetail: View {
    var Service: services
    var body: some View {
        ScrollView {
            VStack {
                mapview(coordinate: Service.locationCoordinate)
                    .frame(height: 300)
                    .ignoresSafeArea(edges: .top)
                circleimage(image: Service.image)
                    .offset(y: -130)
                    .padding(.bottom, -130)
                VStack(alignment: .leading) {
                    Text(Service.title)
                        .font(.title)
                        .foregroundColor(.red)
                    HStack {
                        Text(Service.place)
                            .font(.subheadline)
                        Spacer()
                        Text(Service.city)
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    Divider()
                    Text("About \(Service.title)")
                        .font(.title2)
                    Text(Service.description)
                }
                .padding()
                Spacer()
            }
        }
    }
}

struct circleimage: View {
    var image: Image
    var body: some View {
        image
            .clipShape(Circle())
            .font(.system(size: 100))
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 7)
            .background(Circle())
            .foregroundColor(.white)
    }
}

struct mapview: View {
    var coordinate: CLLocationCoordinate2D
    @State private var region = MKCoordinateRegion()
    var body: some View {
        Map(coordinateRegion: $region)
            .onAppear {
                setRegion(coordinate)
            }
    }
    private func setRegion(_ coordinate: CLLocationCoordinate2D){
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}