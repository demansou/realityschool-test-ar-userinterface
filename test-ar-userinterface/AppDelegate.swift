//
//  AppDelegate.swift
//  test-ar-userinterface
//
//  Created by Daniel Mansour on 12/9/21.
//

import UIKit
import SwiftUI
import Firebase

@main
struct TestArUserInterface: App {
    @StateObject var placementSettings = PlacementSettings()
    @StateObject var sessionSettings = SessionSettings()
    @StateObject var sceneManager = SceneManager()
    @StateObject var modelsViewModel = ModelsViewModel()
    @StateObject var modelDeletionManager = ModelDeletionManager()

    init() {
        FirebaseApp.configure()

        // Anonymous authentication with Firebase
        Auth.auth().signInAnonymously { authResult, error in
            guard let user = authResult?.user else {
                print("FAILED: Anonymous authentication with Firebase.")
                return
            }

            let uid = user.uid
            print("Firebase: Anonymous user authentication with uid: \(uid).")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(placementSettings)
                .environmentObject(sessionSettings)
                .environmentObject(sceneManager)
                .environmentObject(modelsViewModel)
                .environmentObject(modelDeletionManager)
        }
    }
}
