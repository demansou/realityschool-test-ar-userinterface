//
//  ModelDelegationManager.swift
//  test-ar-userinterface
//
//  Created by Daniel Mansour on 12/28/21.
//

import Foundation
import RealityKit

class ModelDeletionManager: ObservableObject {
    @Published var entitySelectedForDeletion: ModelEntity? = nil {
        willSet(newValue) {
            // Selecting new entitySelectedForDeletion, no prior selection
            if self.entitySelectedForDeletion == nil, let newlySelectedModelEntity = newValue {
                print("Selecting new entitySelectedForDeletion, no prior selection.")

                // Higlight newlySelectedModelEntity
                let component = ModelDebugOptionsComponent(visualizationMode: .lightingDiffuse)
                newlySelectedModelEntity.modelDebugOptions = component
            }

            // Selecting new entitySelectedForDeletion, had a prior selection
            else if let previouslySelectedModelEntity = self.entitySelectedForDeletion, let newlySelectedModelEntity = newValue {
                print ("Selecting new entitySelectedForDeletion, had a prior selection")

                // Unhighlight previouslySelectedModelEntity
                previouslySelectedModelEntity.modelDebugOptions = nil

                // Highlight newlySelectedModelEntity
                let component = ModelDebugOptionsComponent(visualizationMode: .lightingDiffuse)
                newlySelectedModelEntity.modelDebugOptions = component
            }

            // Clearing entitySelectedForDeletion
            else if newValue == nil {
                // Clearing entitySelectedForDeletion
                self.entitySelectedForDeletion?.modelDebugOptions = nil
            }
        }
    }
}
