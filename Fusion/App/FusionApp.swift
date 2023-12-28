//
//  FusionApp.swift
//  Fusion
//
//  Created by Cristina Berlinschi on 06/12/2023.
//  Inspired by: https://www.youtube.com/watch?v=HJDCXdhQaP0&ab_channel=CodeWithChris by Code with Chris
//  Inspired by: https://www.youtube.com/watch?v=QJHmhLGv-_0&ab_channel=AppStuffc by App Stuff
//

import SwiftUI
import Firebase


@main
struct FusionApp: App {
    @StateObject var viewModel = AuthViewModel() //initialised here and used throughout the app


    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}

