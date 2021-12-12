//
//  SettingsView.swift
//  test-ar-userinterface
//
//  Created by Daniel Mansour on 12/11/21.
//

import SwiftUI

enum Setting {
    case peopleOcclusion
    case objectOcclusion
    case objectReceivesLighting
    case lidarDebug
    case multiUser
    
    var label: String {
        get {
            switch self {
            case .peopleOcclusion, .objectOcclusion:
                return "Occlusion"
            case .objectReceivesLighting:
                return "Receives Lighting"
            case .lidarDebug:
                return "LiDAR"
            case .multiUser:
                return "MultiUser"
            }
        }
    }
    
    var systemIconName: String {
        get {
            switch self {
            case .peopleOcclusion:
                return "person"
            case .objectOcclusion:
                return "cube.box.fill"
            case .objectReceivesLighting:
                return "light.max"
            case .lidarDebug:
                return "light.min"
            case .multiUser:
                return "person.2"
            }
        }
    }
}

struct SettingsView: View {
    @Binding var showSettings: Bool
    
    var body: some View {
        NavigationView {
            SettingsGrid()
                .navigationBarTitle(Text("Settings"), displayMode: .inline)
                .navigationBarItems(trailing:
                    Button(action: {
                    self.showSettings.toggle()
                    }) {
                        Text("Done").bold()
                    })
        }
    }
}

struct SettingsGrid: View {
    @EnvironmentObject var sessionSettings: SessionSettings
    
    private var gridItemLayout = [GridItem(.adaptive(minimum: 100, maximum: 100), spacing: 25)]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItemLayout, spacing: 25) {
                SettingToggleButton(setting: .peopleOcclusion, isOn: $sessionSettings.isPeopleOcclusionEnabled)
                SettingToggleButton(setting: .objectOcclusion, isOn: $sessionSettings.isObjectOcclusionEnabled)
                SettingToggleButton(setting: .objectReceivesLighting, isOn: $sessionSettings.isObjectReceivesLightingEnabled)
                SettingToggleButton(setting: .lidarDebug, isOn: $sessionSettings.isLidarDebugEnabled)
                SettingToggleButton(setting: .multiUser, isOn: $sessionSettings.isMultiUserEnabled)
            }
        }
        .padding(.top, 35)
    }
}

struct SettingToggleButton: View {
    let setting: Setting
    @Binding var isOn: Bool
    
    var body: some View {
        Button(action: {
            self.isOn.toggle()
            print("\(#file) - \(self.setting): \(self.isOn)")
        }) {
            VStack {
                Image(systemName: self.setting.systemIconName)
                    .font(.system(size: 35))
                    .foregroundColor(self.isOn ? .green : Color(UIColor.secondaryLabel))
                
                Text(self.setting.label)
                    .font(.system(size: 17, weight: .medium, design: .default))
                    .foregroundColor(self.isOn ? Color(UIColor.label) : Color(UIColor.secondaryLabel))
                    .padding(.top, 5)
            }
            .frame(width: 100, height: 100)
            .background(Color(UIColor.secondarySystemFill))
            .cornerRadius(20.0)
        }
    }
}
