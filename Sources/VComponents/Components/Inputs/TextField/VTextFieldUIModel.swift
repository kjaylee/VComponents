//
//  VTextFieldUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI
import VCore

// MARK: - V Text Field UI Model
/// Model that describes UI.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VTextFieldUIModel {
    // MARK: Properties - Global
    /// Spacing between header, textfield, and footer. Set to `3`.
    public var headerTextFieldAndFooterSpacing: CGFloat = 3

    /// Textfield height. Set to `50`.
    public var height: CGFloat = 50

#if !(os(macOS) || os(watchOS))
    /// Keyboard type. Set to `default`.
    public var keyboardType: UIKeyboardType = .default
#endif

#if !(os(macOS) || os(watchOS))
    /// Text content type. Set to `nil`.
    public var textContentType: UITextContentType? = nil
#endif

    /// Indicates if auto correction is enabled. Set to `nil`.
    public var isAutocorrectionEnabled: Bool? = nil

#if !(os(macOS) || os(watchOS))
    /// Auto capitalization type. Set to `nil`.
    public var autocapitalization: TextInputAutocapitalization? = nil
#endif

    // MARK: Properties - Corners
    /// Textfield corner radius. Set to `12`.
    public var cornerRadius: CGFloat = 12

    // MARK: Properties - Background
    /// Background colors.
    public var backgroundColors: StateColors = .init(
        enabled: Color.makeDynamic((235, 235, 235, 1), (60, 60, 60, 1)),
        focused: Color.makeDynamic((220, 220, 220, 1), (80, 80, 80, 1)),
        disabled: Color.makeDynamic((245, 245, 245, 1), (50, 50, 50, 1))
    )

    // MARK: Properties - Border
    /// Border width. Set to `0`.
    ///
    /// To hide border, set to `0`.
    public var borderWidth: CGFloat = 0

    /// Border colors.
    public var borderColors: StateColors = .clearColors

    // MARK: Properties - Header
    /// Header title text frame alignment. Set to `leading`.
    public var headerTitleTextFrameAlignment: HorizontalAlignment = .leading

    /// Header title text line type. Set to `multiline` with `leading` alignment and `1...2` lines.
    public var headerTitleTextLineType: TextLineType = {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            .multiLine(alignment: .leading, lineLimit: 1...2)
        } else {
            .multiLine(alignment: .leading, lineLimit: 2)
        }
    }()

    /// Header title text colors.
    public var headerTitleTextColors: StateColors = .init(
        enabled: Color.secondary,
        focused: Color.secondary,
        disabled: Color.secondary.opacity(0.75)
    )

    /// Header title text font. Set to `footnote`.
    public var headerTitleTextFont: Font = .footnote

    /// Header footer horizontal margin. Set to `10`.
    public var headerMarginHorizontal: CGFloat = 10

    // MARK: Properties - Footer
    /// Footer title text frame alignment. Set to `leading`.
    public var footerTitleTextFrameAlignment: HorizontalAlignment = .leading

    /// Footer title text line type. Set to `multiline` with `leading` alignment and `1...5` lines.
    public var footerTitleTextLineType: TextLineType = {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            .multiLine(alignment: .leading, lineLimit: 1...5)
        } else {
            .multiLine(alignment: .leading, lineLimit: 5)
        }
    }()

    /// Footer title text colors.
    public var footerTitleTextColors: StateColors = .init(
        enabled: Color.secondary,
        focused: Color.secondary,
        disabled: Color.secondary.opacity(0.75)
    )

    /// Footer title text font. Set to `footnote`.
    public var footerTitleTextFont: Font = .footnote

    /// Footer horizontal margin. Set to `10`.
    public var footerMarginHorizontal: CGFloat = 10

    // MARK: Properties - TextField Content
    /// Content type. Set to `default`.
    public var contentType: ContentType = .default

    /// Content horizontal margin. Set to `15`.
    public var contentMarginHorizontal: CGFloat = 15

    /// Spacing between text and buttons. Set to `10`.
    public var textAndButtonSpacing: CGFloat = 10

    // MARK: Properties - Text
    /// Text alignment. Set to `leading`.
    public var textAlignment: TextAlignment = .leading

    /// Text colors.
    public var textColors: StateColors = .init(
        enabled: Color.primary,
        focused: Color.primary,
        disabled: Color.primary.opacity(0.3)
    )

    /// Text font. Set to `body`.
    public var textFont: Font = .body

    // MARK: Properties - Placeholder Text
    /// Placeholder text colors.
    public var placeholderTextColors: StateColors = .init(Color.secondary)

    /// Placeholder text font. Set to `body`.
    public var placeholderTextFont: Font = .body

    // MARK: Properties - Clear Button
    /// Indicates if textfield has clear button. Set to `true`.
    public var hasClearButton: Bool = true

    /// Clear button icon.
    public var clearButtonIcon: Image = ImageBook.xMark.renderingMode(.template)

    /// Model for customizing clear button.
    /// `size` is set to `(22, 22)`,
    /// `backgroundColors` are changed,
    /// `iconSize` is set to `(8, 8)`,
    /// `iconColors` are changed,
    /// `hitBox` is set to `zero`,
    /// `haptic` is set to `nil`.
    public var clearButtonSubUIModel: VRectangularButtonUIModel = {
        var uiModel: VRectangularButtonUIModel = .init()

        uiModel.size = CGSize(dimension: 22)

        uiModel.backgroundColors = VRectangularButtonUIModel.StateColors(
            enabled: Color.makeDynamic((170, 170, 170, 1), (40, 40, 40, 1)),
            pressed: Color.makeDynamic((150, 150, 150, 1), (20, 20, 20, 1)),
            disabled: Color.makeDynamic((220, 220, 220, 1), (40, 40, 40, 1))
        )

        uiModel.iconSize = CGSize(dimension: 8)
        uiModel.iconColors = VRectangularButtonUIModel.StateColors(Color.makeDynamic((255, 255, 255, 1), (230, 230, 230, 1)))

        uiModel.hitBox = .zero

#if os(iOS)
        uiModel.haptic = nil
#endif

        return uiModel
    }()

    /// Clear button appear and disappear animation. Set to `nil`.
    public var clearButtonAppearDisappearAnimation: Animation? = nil

    // MARK: Properties - Secure
    /// Visibility button icon (off).
    public var visibilityOffButtonIcon: Image = ImageBook.visibilityOff.renderingMode(.template)

    /// Visibility button icon (on).
    public var visibilityOnButtonIcon: Image = ImageBook.visibilityOn.renderingMode(.template)

    /// Model for customizing visibility button.
    /// `iconSize` is set to `(20, 20)`,
    /// `iconColors` are changed,
    /// `hitBox` is set to `zero`,
    /// `haptic` is set to `nil`.
    public var visibilityButtonSubUIModel: VPlainButtonUIModel = {
        var uiModel: VPlainButtonUIModel = .init()

        uiModel.iconSize = CGSize(dimension: 20)
        uiModel.iconColors = VPlainButtonUIModel.StateColors(
            enabled: Color.makeDynamic((70, 70, 70, 1), (240, 240, 240, 1)),
            pressed: Color.primary.opacity(0.3),
            disabled: Color.primary.opacity(0.3)
        )

        uiModel.hitBox = .zero

#if os(iOS)
        uiModel.haptic = nil
#endif

        return uiModel
    }()

    // MARK: Properties - Search
    /// Search button icon.
    public var searchButtonIcon: Image = ImageBook.magnifyGlass.renderingMode(.template)

    /// Indicates if `resizable(capInsets:resizingMode)` modifier is applied to search icon. Set to `true`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var isSearchIconResizable: Bool = true

    /// Search icon content mode. Set to `fit`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var searchIconContentMode: ContentMode? = .fit

    /// Search icon size. Set to `(15, 15)`.
    public var searchIconSize: CGSize? = .init(dimension: 15)

    /// Search icon colors.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var searchIconColors: StateColors? = .init(
        enabled: Color.makeDynamic((70, 70, 70, 1), (240, 240, 240, 1)),
        focused: Color.makeDynamic((70, 70, 70, 1), (240, 240, 240, 1)),
        disabled: Color.primary.opacity(0.3)
    )

    /// Search icon opacities. Set to `nil`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var searchIconOpacities: StateOpacities?

    /// Search icon font. Set to `nil.`
    ///
    /// Can be used for setting different weight to SF symbol icons.
    /// To achieve this, `isSearchIconResizable` should be set to `false`, and `searchIconSize` should be set to `nil`.
    public var searchIconFont: Font?

    // MARK: Properties - Submit Button
    /// Submit button type. Set to `return`.
    public var submitButton: SubmitLabel = .return

    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Content Type
    /// Enumeration that represents content type, such as `standard`, `secure`, or `search`.
    @CaseDetection
    public enum ContentType: Int, CaseIterable {
        // MARK: Cases
        /// Standard.
        case standard

        /// Secure.
        ///
        /// Visibility icon is present, and securities, such as copying is enabled.
        case secure

        /// Search.
        ///
        /// Magnification icon is present.
        case search

        // MARK: Initializers
        /// Default value. Set to `standard`.
        public static var `default`: Self { .standard }
    }

    // MARK: State Colors
    /// Model that contains colors for component states.
    public typealias StateColors = GenericStateModel_EnabledFocusedDisabled<Color>

    // MARK: State Opacities
    /// Model that contains colors for component opacities.
    public typealias StateOpacities = GenericStateModel_EnabledFocusedDisabled<CGFloat>
}

// MARK: - Factory (Content Types)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VTextFieldUIModel {
    /// `VTextFieldUIModel` with secure content type.
    public static var secure: Self {
        var uiModel: Self = .init()
        
        uiModel.contentType = .secure
        
        return uiModel
    }
    
    /// `VTextFieldUIModel` with search content type.
    public static var search: Self {
        var uiModel: Self = .init()
        
        uiModel.contentType = .search
        
        return uiModel
    }
}

// MARK: - Factory (Highlights)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VTextFieldUIModel {
    /// `VTextFieldUIModel` that applies green color scheme.
    public static var success: Self {
        var uiModel: Self = .init()
        
        uiModel.borderWidth = 1.5
        uiModel.applySuccessColorScheme()
        
        return uiModel
    }
    
    /// `VTextFieldUIModel` that applies yellow color scheme.
    public static var warning: Self {
        var uiModel: Self = .init()
        
        uiModel.borderWidth = 1.5
        uiModel.applyWarningColorScheme()
        
        return uiModel
    }
    
    /// `VTextFieldUIModel` that applies error color scheme.
    public static var error: Self {
        var uiModel: Self = .init()
        
        uiModel.borderWidth = 1.5
        uiModel.applyErrorColorScheme()
        
        return uiModel
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VTextFieldUIModel {
    /// Applies green color scheme to `VTextFieldUIModel`.
    public mutating func applySuccessColorScheme() {
        applyHighlightedColors(
            border: Color.makeDynamic((85, 195, 135, 1), (45, 150, 75, 1)),
            headerTitleTextAndFooterTitleText: Color.makeDynamic((85, 175, 135, 1), (85, 195, 135, 1))
        )
    }

    /// Applies yellow color scheme to `VTextFieldUIModel`.
    public mutating func applyWarningColorScheme() {
        applyHighlightedColors(
            border: Color.makeDynamic((255, 190, 35, 1), (240, 150, 20, 1)),
            headerTitleTextAndFooterTitleText: Color.makeDynamic((235, 170, 35, 1), (255, 190, 35, 1))
        )
    }

    /// Applies red color scheme to `VTextFieldUIModel`.
    public mutating func applyErrorColorScheme() {
        applyHighlightedColors(
            border: Color.makeDynamic((235, 110, 105, 1), (215, 60, 55, 1)),
            headerTitleTextAndFooterTitleText: Color.makeDynamic((215, 110, 105, 1), (235, 110, 105, 1))
        )
    }
    
    private mutating func applyHighlightedColors(
        border: Color,
        headerTitleTextAndFooterTitleText: Color
    ) {
        borderColors.enabled = border
        borderColors.focused = border
        
        headerTitleTextColors.enabled = headerTitleTextAndFooterTitleText
        headerTitleTextColors.focused = headerTitleTextAndFooterTitleText
        
        footerTitleTextColors.enabled = headerTitleTextAndFooterTitleText
        footerTitleTextColors.focused = headerTitleTextAndFooterTitleText
    }
}
