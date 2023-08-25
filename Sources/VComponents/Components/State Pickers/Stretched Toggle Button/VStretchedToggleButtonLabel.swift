//
//  VStretchedToggleButtonLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 25.08.23.
//

import SwiftUI

// MARK: - V Stretched Toggle Button Label
@available(tvOS, unavailable)
@available(watchOS, unavailable)
enum VStretchedToggleButtonLabel<Label> where Label: View {
    case title(title: String)
    case iconTitle(icon: Image, title: String)
    case label(label: (VStretchedToggleButtonInternalState) -> Label)
}
