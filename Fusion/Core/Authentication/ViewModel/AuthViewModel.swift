//
//  AuthViewModel.swift
//  Fusion
//
//  Created by Cristina Berlinschi on 22/12/2023.
// AuthViewModel is responsible for everything that has to do with authenticating a user, updating UI, errors and networking
// Inspired by: https://www.youtube.com/watch?v=QJHmhLGv-_0&ab_channel=AppStuffc by App Stuff

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol AuthenticationFormProtocol{ //Everywhere there is a form e.g sign up, This authentication form protocol will be implemented which will determine the logic whether or not the form is valid
    var formIsValid: Bool {get}
}


@MainActor //Main actor ensures my UI changes are published on the main thread
class AuthViewModel: ObservableObject {
    @Published var userSession : FirebaseAuth.User? //tells us if a user is logged in or not, user from database
    @Published var currentUser: User? //user database model
       
    
    
    init () {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do{
            let result = try await Auth.auth().signIn(withEmail: email, password: password) //calls signin function
            self.userSession = result.user
            await fetchUser() //fetches user from database
        } catch {
            print("Debug: Failed to log in with error \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws { //creates a user in background with firebase
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password) //what I get back from firebase packet manager
            self.userSession = result.user //once I get result back, I set the user session property
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            
            
            // Attempt to encode the user
            // Encoding is taking a user object and encodes it into JSON data and uploads it to Firebase
            // It is then Decoded in the User file by the 'Codable' protocol
            guard let encodedUser = try? Firestore.Encoder().encode(user) else {
                print("Error: User could not be encoded")
                return
            }
            
            // Now encodedUser is safely unwrapped
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("Debug: failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func signOut() { //when signing out it takes you back to log in page and signs user out
        do {
            try Auth.auth().signOut() //signs user out on backend
            self.userSession = nil // wipes out user session and takes user back to login screen
            self.currentUser = nil // wipes out current user data model
        } catch {
            print("Debug: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() {
        
    }
    
    func fetchUser() async { //information I get back from database
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
        
        print("Debug: Current user is \(String(describing: self.currentUser))")
    }
}
