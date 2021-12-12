//
//  CustomARView.swift
//  test-ar-userinterface
//
//  Created by Daniel Mansour on 12/10/21.
//

import RealityKit
import ARKit
import FocusEntity
import SwiftUI
import Combine

class CustomARView: ARView {
    var focusEntity: FocusEntity?
    var sessionSettings: SessionSettings
    
    private var peopleOcclusionCancellable: AnyCancellable?
    private var objectOcclusionCancellable: AnyCancellable?
    private var objectReceivesLightingCancellable: AnyCancellable?
    private var lidarDebugCancellable: AnyCancellable?
    private var multiUserCancellable: AnyCancellable?
    
    required init(frame frameRect: CGRect, sessionSettings: SessionSettings) {
        self.sessionSettings = sessionSettings
        
        super.init(frame: frameRect)
        
        self.focusEntity = FocusEntity(on: self, focus: .classic)
        
        configure()
        
        self.initializeSettings()
        
        self.setupSubscribers()
    }
    
    required init(frame frameRect: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        
        session.run(config)
    }
    
    private func initializeSettings() {
        self.updatePeopleOcclusion(isEnabled: self.sessionSettings.isPeopleOcclusionEnabled)
        self.updateObjectOcclusion(isEnabled: self.sessionSettings.isObjectOcclusionEnabled)
        self.updateObjectReceivesLighting(isEnabled: self.sessionSettings.isObjectReceivesLightingEnabled)
        self.updateLidarDebug(isEnabled: self.sessionSettings.isLidarDebugEnabled)
        self.updateMultiUser(isEnabled: self.sessionSettings.isMultiUserEnabled)
    }
    
    private func setupSubscribers() {
        self.peopleOcclusionCancellable = self.sessionSettings.$isPeopleOcclusionEnabled.sink { [weak self] isEnabled in
            self?.updatePeopleOcclusion(isEnabled: isEnabled)
        }
        
        self.objectOcclusionCancellable = self.sessionSettings.$isObjectOcclusionEnabled.sink { [weak self] isEnabled in
            self?.updateObjectOcclusion(isEnabled: isEnabled)
        }
        
        self.objectReceivesLightingCancellable = self.sessionSettings.$isObjectReceivesLightingEnabled.sink { [weak self] isEnabled in
            self?.updateObjectReceivesLighting(isEnabled: isEnabled)
        }
        
        self.lidarDebugCancellable = self.sessionSettings.$isLidarDebugEnabled.sink { [weak self] isEnabled in
            self?.updateLidarDebug(isEnabled: isEnabled)
        }
        
        self.multiUserCancellable = self.sessionSettings.$isMultiUserEnabled.sink { [weak self] isEnabled in
            self?.updateMultiUser(isEnabled: isEnabled)
        }
    }
    
    private func updatePeopleOcclusion(isEnabled: Bool) {
        print("\(#file): isPeopleOcclusionEnabled is now \(isEnabled).")
        guard ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) else {
            return
        }
        
        guard let configuration = self.session.configuration as? ARWorldTrackingConfiguration else {
            return
        }
        
        if configuration.frameSemantics.contains(.personSegmentationWithDepth) {
            configuration.frameSemantics.remove(.personSegmentationWithDepth)
        } else {
            configuration.frameSemantics.insert(.personSegmentationWithDepth)
        }
        
        self.session.run(configuration)
    }
    
    private func updateObjectOcclusion(isEnabled: Bool) {
        print("\(#file): isObjectOcclusionEnabled is now \(isEnabled).")
        
        if self.environment.sceneUnderstanding.options.contains(.occlusion) {
            self.environment.sceneUnderstanding.options.remove(.occlusion)
        } else {
            self.environment.sceneUnderstanding.options.insert(.occlusion)
        }
    }
    
    private func updateObjectReceivesLighting(isEnabled: Bool) {
        print("\(#file): isObjectLightingEnabled is now \(isEnabled).")
        
        if self.environment.sceneUnderstanding.options.contains(.receivesLighting) {
            self.environment.sceneUnderstanding.options.remove(.receivesLighting)
        } else {
            self.environment.sceneUnderstanding.options.insert(.receivesLighting)
        }
    }
    
    private func updateLidarDebug(isEnabled: Bool) {
        print("\(#file): isLidarDebugEnabled is now \(isEnabled).")
        if self.debugOptions.contains(.showSceneUnderstanding) {
            self.debugOptions.remove(.showSceneUnderstanding)
        } else {
            self.debugOptions.insert(.showSceneUnderstanding)
        }
    }
    
    private func updateMultiUser(isEnabled: Bool) {
        print("\(#file): isMultiUserEnabled is now \(isEnabled).")
    }
}
