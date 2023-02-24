//
//  VPageIndicatorDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 2/6/21.
//

import SwiftUI
import Combine
import VComponents
import VCore

// MARK: - V Page Indicator Demo View
struct VPageIndicatorDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Page Indicator" }
    
    private let total: Int = 15
    @State private var selectedIndex: Int = 0
    
    @State private var pageIndicatorType: VPageIndicatorTypeHelper = .automatic

    // MARK: Body
    var body: some View {
        DemoView(
            component: component,
            settings: settings
        )
            .inlineNavigationTitle(Self.navBarTitle)
            .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect().eraseToAnyPublisher(), perform: updateValue)
    }
    
    private func component() -> some View {
        DemoTitledSettingView(
            title: "\(selectedIndex+1)/\(total)",
            content: {
                VPageIndicator(
                    type: pageIndicatorType.indicatorType,
                    total: total,
                    selectedIndex: selectedIndex
                )
            }
        )
    }
    
    private func settings() -> some View {
        VSegmentedPicker(
            selection: $pageIndicatorType,
            headerTitle: "Type",
            footerTitle: pageIndicatorType.description
        )
    }

    // MARK: Timer
    fileprivate func updateValue(_ output: Date) {
        var valueToSet: Int = selectedIndex + 1
        if valueToSet > total-1 { valueToSet = 0 }
        
        selectedIndex = valueToSet
    }
}

// MARK: - Helpers
private enum VPageIndicatorTypeHelper: Int, StringRepresentableHashableEnumeration {
    case finite
    case infinite
    case automatic
    
    var stringRepresentation: String {
        switch self {
        case .finite: return "Finite"
        case .infinite: return "Infinite"
        case .automatic: return "Automatic"
        }
    }
    
    var description: String {
        switch self {
        case .finite: return "Finite number of dots would be displayed"
        case .infinite: return "Infinite dots are possible, but limited numbers are displayed. Scrolling with carousel effect may become enabled."
        case .automatic: return "Type that switches between \"Finite\" and \"Infinite\""
        }
    }
    
    var indicatorType: VPageIndicatorType {
        switch self {
        case .finite: return .finite
        case .infinite: return .infinite()
        case .automatic: return .automatic()
        }
    }
}

// MARK: - Preview
struct VPageIndicatorDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VPageIndicatorDemoView()
    }
}
