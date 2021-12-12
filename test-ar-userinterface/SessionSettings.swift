//
//  SessionSettings.swift
//  test-ar-userinterface
//
//  Created by Daniel Mansour on 12/11/21.
//

import SwiftUI

class SessionSettings: ObservableObject {
    @Published var isPeopleOcclusionEnabled: Bool = false
    @Published var isObjectOcclusionEnabled: Bool = false
    @Published var isObjectReceivesLightingEnabled: Bool = false
    @Published var isLidarDebugEnabled: Bool = false
    @Published var isMultiUserEnabled: Bool = false
}
