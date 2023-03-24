//
//  GlobalUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 08.03.23.
//

import SwiftUI
import VCore

// MARK: - Global UI Model
struct GlobalUIModel {
    // MARK: Initializers
    private init() {}
    
    // MARK: Common
    struct Common {
        // MARK: Properties - Container
        static var containerCornerRadius: CGFloat { 15 }
        static var containerContentMargin: CGFloat { 15 }
        static var containerHeaderMargins: EdgeInsets_LeadingTrailingTopBottom { .init(horizontal: containerContentMargin, vertical: 10) }
                
        // MARK: Properties - Shadow
        static let shadowColorEnabled: Color = .init(module: "Shadow")
        static let shadowColorDisabled: Color = .init(module: "Shadow.Disabled")
        
        // MARK: Properties - Header and Footer
        static var headerTextLineType: TextLineType { .singleLine }
        static var headerFont: Font { .system(size: 14) }
        
        static var footerTextLineType: TextLineType = {
            if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
                return .multiLine(alignment: .leading, lineLimit: 1...5)
            } else {
                return .multiLine(alignment: .leading, lineLimit: 5)
            }
        }()
        static var footerFont: Font { .system(size: 13) }
        
        static var headerComponentFooterSpacing: CGFloat { 3 }
        static var headerFooterMarginHorizontal: CGFloat { 10 }
        
        // MARK: Properties - Divider and Separator
        static let dividerHeight: CGFloat = 2 / MultiplatformConstants.screenScale
        static let dividerColor: Color = .init(module: "Divider")
        
        static let separatorHeight: CGFloat = 1 / MultiplatformConstants.screenScale
        static var separatorColor: Color { dividerColor }
        
        static var dividerDashColorEnabled: Color { .init(module: "DividerDash") }
        static var dividerDashColorDisabled: Color { .init(module: "DividerDash.Disabled") }
        
        // MARK: Properties - Circular Button
        static var circularButtonGrayDimension: CGFloat { 30 }
        static var circularButtonGrayIconDimension: CGFloat { 12 }
        
        static var circularButtonLayerColorEnabled: Color { .init(module: "CircularButton.Layer") }
        static var circularButtonLayerColorPressed: Color { .init(module: "CircularButton.Layer.Pressed") }
        static var circularButtonLayerColorDisabled: Color { .init(module: "CircularButton.Layer.Disabled") }
        
        static var circularButtonIconGrayColor: Color { .init(module: "CircularButton.Icon.Gray") }
        
        static var circularButtonIconPrimaryColorEnabled: Color { ColorBook.primary }
        static var circularButtonIconPrimaryColorPressed: Color { ColorBook.primary } // Looks better
        static var circularButtonIconPrimaryColorDisabled: Color { ColorBook.primaryPressedDisabled }
        
        // MARK: Properties - Bar
        static var barHeight: CGFloat {
#if os(watchOS)
            return 5
#else
            return 10
#endif
        }
        static var barCornerRadius: CGFloat { barHeight/2 }
        
        // MARK: Properties - Misc
        static var minimumScaleFactor: CGFloat { 0.75 }
        
        static let dimmingViewColor: Color = .init(module: "DimmingView")
        
        static var grabberColor: Color { .init(module: "Grabber") }
        
        // MARK: Properties - Private
        fileprivate static var customLabelOpacitySpecialState: CGFloat { 0.3 }
        
        // MARK: Initializers
        private init() {}
    }
    
    // MARK: Buttons
    struct Buttons {
        // MARK: Properties
        static var dimensionSmall: CGFloat { 32 }
        static var dimensionLarge: CGFloat { 56 }
        
        static var cornerRadiusSmall: CGFloat { 16 }
        static var cornerRadiusLarge: CGFloat { 24 }
        
        static var labelMargins: EdgeInsets_HorizontalVertical { .init(horizontal: 15, vertical: 3) }
        static var labelMarginsRounded: EdgeInsets_HorizontalVertical { .init(3) }
        
        static var transparentLayerLabelEnabled: Color { ColorBook.controlLayerBlue }
        static var transparentLayerLabelPressed: Color { ColorBook.controlLayerBluePressed }
        static var transparentLayerLabelDisabled: Color { ColorBook.controlLayerBlueDisabled.opacity(0.5) } // Looks better

        static var iconDimensionSmall: CGFloat { 16 }
        static var iconDimensionMedium: CGFloat { 20 }
        static var iconDimensionLarge: CGFloat { 24 }
        
        static var customLabelOpacityPressedLoadingDisabled: CGFloat { Common.customLabelOpacitySpecialState }
        
        static var iconTitleSpacing: CGFloat { 8 }
        
        // MARK: Initializers
        private init() {}
    }
    
    // MARK: State Pickers
    struct StatePickers {
        // MARK: Properties
        static var dimensionSmall: CGFloat { 16 }
        
        static var statePickerLabelSpacing: CGFloat { 5 }
        
        static var titleTextLineType: TextLineType = {
            if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
                return .multiLine(alignment: .leading, lineLimit: 1...2)
            } else {
                return .multiLine(alignment: .leading, lineLimit: 2)
            }
        }()
        static var font: Font {
#if os(iOS)
            return .system(size: 15)
#elseif canImport(AppKit)
            return .system(size: 13)
#else
            fatalError() // Not supported
#endif
        }
        
        static var titleColor: Color {
#if os(iOS)
            return ColorBook.primary
#elseif canImport(AppKit)
            return ColorBook.primary.opacity(0.85) // Similar to `NSColor.controlTextColor`
#else
            fatalError() // Not supported
#endif
        }
        
        static var titleColorDisabled: Color {
#if os(iOS)
            return ColorBook.primaryPressedDisabled
#elseif canImport(AppKit)
            return ColorBook.primaryPressedDisabled.opacity(0.85) // Similar to `NSColor.controlTextColor`
#else
            fatalError() // Not supported
#endif
        }
        
        static var customLabelOpacityDisabled: CGFloat { Common.customLabelOpacitySpecialState }
        
        static var stateChangeAnimation: Animation { .easeIn(duration: 0.1) }
        
        // MARK: Initializers
        private init() {}
    }
    
    // MARK: Item Pickers
    struct ItemPickers {
        // MARK: Properties
        static var customContentOpacityDisabled: CGFloat { Common.customLabelOpacitySpecialState }
        
        // MARK: Initializers
        private init() {}
    }
    
    // MARK: Value Pickers
    struct ValuePickers {
        // MARK: Properties
        static var sliderThumbDimension: CGFloat { 20 }
        static var sliderThumbCornerRadius: CGFloat { 10 }
        static var sliderThumbShadowRadius: CGFloat {
#if os(iOS)
            return 2
#elseif canImport(AppKit)
            return 1
#else
            fatalError() // Not supported
#endif
        }
        static var sliderThumbShadowOffset: CGSize {
#if os(iOS)
            return .init(width: 0, height: 2)
#elseif canImport(AppKit)
            return .init(width: 0, height: 1)
#else
            fatalError() // Not supported
#endif
 }
        
        // MARK: Initializers
        private init() {}
    }
    
    // MARK: Inputs
    struct Inputs {
        // MARK: Properties
        static var height: CGFloat { 50 }
        static var cornerRadius: CGFloat { 12 }
        
        static var layerGrayColorFocused: Color { .init(module: "Input.Layer.Gray.Focused") }
        static var layerGreenColorFocused: Color { .init(module: "Input.Layer.Green.Focused") }
        static var layerYellowColorFocused: Color { .init(module: "Input.Layer.Yellow.Focused") }
        static var layerRedColorFocused: Color { .init(module: "Input.Layer.Red.Focused") }
        
        static var headerFooterGreenColor: Color { .init(module: "Input.HeaderFooter.Green") }
        static var headerFooterYellowColor: Color { .init(module: "Input.HeaderFooter.Yellow") }
        static var headerFooterRedColor: Color { .init(module: "Input.HeaderFooter.Red") }
        
        static var clearButtonLayerEnabled: Color { .init(module: "Input.ClearButton.Layer") }
        static var clearButtonLayerPressed: Color { .init(module: "Input.ClearButton.Layer.Pressed") }
        static var clearButtonLayerDisabled: Color { .init(module: "Input.ClearButton.Layer.Disabled") }
        static var clearButtonIcon: Color { .init(module: "Input.ClearButton.Icon") }
        
        static var visibilityButtonEnabled: Color { .init(module: "Input.VisibilityButton.Icon") }
        static var visibilityButtonPressedDisabled: Color { ColorBook.primaryPressedDisabled }
        
        static var searchIconEnabledFocused: Color { .init(module: "Input.SearchIcon") }
        static var searchIconDisabled: Color { ColorBook.primaryPressedDisabled }
        
        // MARK: Initializers
        private init() {}
    }
    
    // MARK: Modals
    struct Modals {
        // MARK: Properties
        static var labelCloseButtonSpacing: CGFloat { 10 }
        
        static var headerFont: Font { .system(size: 17, weight: .bold) }
        
        static var poppingAppearAnimation: BasicAnimation? { .init(curve: .linear, duration: 0.05) }
        static var poppingDisappearAnimation: BasicAnimation? { .init(curve: .easeIn, duration: 0.05) }
        static var poppingAnimationScaleEffect: CGFloat { 1.01 }
        static var poppingAnimationOpacity: CGFloat { 0.5 }
        static var poppingAnimationBlur: CGFloat { 3 }
        
        static var slidingAppearAnimation: BasicAnimation? { .init(curve: .easeInOut, duration: 0.3) }
        static var slidingDisappearAnimation: BasicAnimation? { .init(curve: .easeInOut, duration: 0.3) }
        
        // MARK: Initializers
        private init() {}
    }
    
    // MARK: Messages
    struct Messages {
        // MARK: Properties
        static var layerGray: Color { ColorBook.layerGray }
        static var layerGreen: Color { .init(module: "Message.Layer.Green") }
        static var layerYellow: Color { .init(module: "Message.Layer.Yellow") }
        static var layerRed: Color { .init(module: "Message.Layer.Red") }
        
        // MARK: Initializers
        private init() {}
    }
    
    // MARK: Indicators
    struct Indicators {
        // MARK: Properties
        static var pageIndicatorDotDimension: CGFloat {
#if os(tvOS)
            return 20
#elseif os(watchOS)
            return 7
#else
            return 10
#endif
        }
        static var pageIndicatorSpacing: CGFloat {
#if os(tvOS)
            return 10
#elseif os(watchOS)
            return 3
#else
            return 5
#endif
        }
        
        static var pageIndicatorStandardUnselectedDotScale: CGFloat { 0.85 }
        
        static var pageIndicatorCompactVisibleDots: Int { 7 }
        static var pageIndicatorCompactCenterDots: Int { 3 }
        static var pageIndicatorCompactEdgeDotScale: CGFloat { 0.5 }
        
        // MARK: Initializers
        private init() {}
    }
}
