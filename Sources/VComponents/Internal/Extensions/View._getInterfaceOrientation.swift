//
//  View._getInterfaceOrientation.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 06.08.23.
//

import SwiftUI
import VCore

// MARK: - View Get Interface Orientation
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {
    func _getInterfaceOrientation(
        _ action: @escaping (_InterfaceOrientation) -> Void
    ) -> some View {
#if os(iOS) || targetEnvironment(macCatalyst)
        self
            .getInterfaceOrientation({ action(_InterfaceOrientation(uiIInterfaceOrientation: $0)) })
#else
        fatalError() // Not supported
#endif
    }
}

// MARK: - _ Interface Orientation
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
enum _InterfaceOrientation {
    // MARK: Cases
    case portrait
    case landscape

    // MARK: Initializers
#if os(iOS) || targetEnvironment(macCatalyst)
    init(uiIInterfaceOrientation: UIInterfaceOrientation) {
        if uiIInterfaceOrientation.isLandscape {
            self = .landscape
        } else {
            self = .portrait
        }
    }
#endif

    static func initFromSystemInfo() -> Self {
#if os(iOS) || targetEnvironment(macCatalyst)
        if UIDevice.current.orientation.isLandscape {
            return .landscape
        } else {
            return .portrait
        }
#else
        fatalError() // Not supported
#endif
    }
}
