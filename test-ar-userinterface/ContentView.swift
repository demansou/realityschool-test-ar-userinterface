//
//  ContentView.swift
//  test-ar-userinterface
//
//  Created by Daniel Mansour on 12/9/21.
//

import SwiftUI

struct ContentView : View {
    @EnvironmentObject var placementSettings: PlacementSettings
    @EnvironmentObject var modelsViewModel: ModelsViewModel
    @EnvironmentObject var modelDeletionManager: ModelDeletionManager

    @State private var selectedControlMode: Int = 0
    @State private var isControlsVisible: Bool = true
    @State private var showBrowse: Bool = false
    @State private var showSettings: Bool = false

    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer()
            
            if self.placementSettings.selectedModel != nil {
                PlacementView()
            } else if self.modelDeletionManager.entitySelectedForDeletion != nil {
                DeletionView()
            }else {
                ControlView(selectedControlMode: $selectedControlMode, isControlsVisible: $isControlsVisible, showBrowse: $showBrowse, showSettings: $showSettings)
            }
            
            
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear() {
            self.modelsViewModel.fetchData()
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PlacementSettings())
            .environmentObject(SessionSettings())
            .environmentObject(SceneManager())
            .environmentObject(ModelsViewModel())
            .environmentObject(ModelDeletionManager())
    }
}
#endif
