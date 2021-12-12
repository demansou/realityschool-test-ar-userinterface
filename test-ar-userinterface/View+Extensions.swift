//
//  View+Extensions.swift
//  test-ar-userinterface
//
//  Created by Daniel Mansour on 12/10/21.
//

import SwiftUI

extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}
