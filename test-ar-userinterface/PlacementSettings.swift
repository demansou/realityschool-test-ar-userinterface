//
//  PlacementSettings.swift
//  test-ar-userinterface
//
//  Created by Daniel Mansour on 12/9/21.
//

import ARKit
import Combine
import RealityKit
import SwiftUI

struct ModelAnchor {
    var model: Model
    var anchor: ARAnchor?
}

class PlacementSettings: ObservableObject {
    
    // When the user selects a model in BrowseView, this property is set.
    @Published var selectedModel: Model? {
        willSet(newValue) {
            print("Setting selectedModel to \(String(describing: newValue?.name)).")
        }
    }
    
    // This property retains a record of placed models in the scene. The last element in the array is the most recently placed model.
    @Published var recentlyPlaced: [Model] = []

    // This property will keep track of all the content that has been confirmed for placement in the scene.
    var modelsConfirmedForPlacement: [ModelAnchor] = []
    
    // This property retains the cancellable object for our SceneEvents.Update subscriber.
    var sceneObserver: Cancellable?
}
