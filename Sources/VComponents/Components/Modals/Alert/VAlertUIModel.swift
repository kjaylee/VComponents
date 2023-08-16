//
//  VAlertUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI
import VCore

// MARK: - V Alert UI Model
/// Model that describes UI.
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VAlertUIModel {
    // MARK: Properties - Global
    /// Color scheme. Set to `nil`.
    ///
    /// Since this is a modal, color scheme cannot be applied directly. Use this property instead.
    public var colorScheme: ColorScheme? = nil

    var presentationHostUIModel: PresentationHostUIModel {
        var uiModel: PresentationHostUIModel = .init()

        uiModel.keyboardResponsivenessStrategy = keyboardResponsivenessStrategy

        return uiModel
    }

    // MARK: Properties - Global Layout
    /// Alert sizes.
    /// Set to `0.75` ratio of screen width in portrait.
    /// Set to `0.5` ratio of screen width in landscape.
    public var widths: Widths = .init(
        portrait: .fraction(0.75),
        landscape: .fraction(0.5)
    )

    /// Additional margins applied to title text, message text, and content as a whole. Set to `15` leading, `15` trailing,`15` top, and `10` bottom.
    public var titleTextMessageTextAndContentMargins: Margins = .init(
        leading: GlobalUIModel.Common.containerContentMargin,
        trailing: GlobalUIModel.Common.containerContentMargin,
        top: GlobalUIModel.Common.containerContentMargin,
        bottom: 10
    )

    // MARK: Properties - Corners
    /// Rounded corners. Set to to `allCorners`.
    public var roundedCorners: RectCorner = .allCorners

    /// Indicates if left and right corners should switch to support RTL languages. Set to `true`.
    public var reversesLeftAndRightCornersForRTLLanguages: Bool = true

    /// Corner radius. Set to `20`.
    public var cornerRadius: CGFloat = 20

    // MARK: Properties - Background
    /// Background color.
    public var backgroundColor: Color = ColorBook.layer

    var groupBoxSubUIModel: VGroupBoxUIModel {
        var uiModel: VGroupBoxUIModel = .init()

        uiModel.roundedCorners = roundedCorners
        uiModel.reversesLeftAndRightCornersForRTLLanguages = reversesLeftAndRightCornersForRTLLanguages
        uiModel.cornerRadius = cornerRadius

        uiModel.backgroundColor = backgroundColor

        uiModel.contentMargins = .zero

        return uiModel
    }

    // MARK: Properties - Title
    /// Title text line type. Set to `multiline` with `center` alignment and `1...2` lines.
    public var titleTextLineType: TextLineType = {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            return .multiLine(alignment: .center, lineLimit: 1...2)
        } else {
            return .multiLine(alignment: .center, lineLimit: 2)
        }
    }()

    /// Title text color.
    public var titleTextColor: Color = ColorBook.primary

    /// Title text font. Set to `bold` `headline` (`17`).
    public var titleTextFont: Font = .headline.weight(.bold)

    /// Title text margins. Set to `0` leading, `0` trailing, `5` top, and `3` bottom.
    public var titleTextMargins: Margins = .init(
        leading: 0,
        trailing: 0,
        top: 5,
        bottom: 3
    )

    // MARK: Properties - Message
    /// Message line type. Set to `multiline` with `center` alignment and `1...5` lines.
    public var messageTextLineType: TextLineType = {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            return .multiLine(alignment: .center, lineLimit: 1...5)
        } else {
            return .multiLine(alignment: .center, lineLimit: 5)
        }
    }()

    /// Message text color.
    public var messageTextColor: Color = ColorBook.primary

    /// Message text font. Set to `subheadline` (`15`).
    public var messageTextFont: Font = .subheadline

    /// Message text margins. Set to `0` leading, `0` trailing, `3` top, and `5` bottom.
    public var messageTextMargins: Margins = .init(
        leading: 0,
        trailing: 0,
        top: 3,
        bottom: 5
    )

    // MARK: Properties - Content
    /// Content margins  Set to `0` leading, `0` trailing, `10` top, and `0` bottom.
    public var contentMargins: Margins = .init(
        leading: 0,
        trailing: 0,
        top: 10,
        bottom: 0
    )

    // MARK: Properties - Buttons
    /// Button height. Set to `40`.
    public var buttonHeight: CGFloat = 40

    /// Button corner radius. Set to `10`.
    public var buttonCornerRadius: CGFloat = 10

    /// Button margins. Set to `15` leading, `15` trailing, `10` top, and `15` bottom.
    public var buttonMargins: Margins = .init(
        leading: GlobalUIModel.Common.containerContentMargin,
        trailing: GlobalUIModel.Common.containerContentMargin,
        top: 10,
        bottom: GlobalUIModel.Common.containerContentMargin
    )

    /// Spacing between horizontal buttons.  Set to `10`.
    public var horizontalButtonSpacing: CGFloat = 10

    /// Spacing between vertical buttons.  Set to `5`.
    public var verticalButtonSpacing: CGFloat = 5

#if os(iOS)
    /// Button haptic feedback style. Set to `nil`.
    public var buttonHaptic: UIImpactFeedbackGenerator.FeedbackStyle? = nil
#endif

    // MARK: Properties - Button - Primary
    /// Primary button background colors.
    public var primaryButtonBackgroundColors: ButtonStateColors = .init(
        enabled: ColorBook.controlLayerBlue,
        pressed: ColorBook.controlLayerBluePressed,
        disabled: ColorBook.controlLayerBlueDisabled
    )

    /// Primary button title colors.
    public var primaryButtonTitleColors: ButtonStateColors = .init(ColorBook.primaryWhite)

    var primaryButtonSubUIModel: VStretchedButtonUIModel {
        var uiModel: VStretchedButtonUIModel = .init()

        uiModel.height = buttonHeight
        uiModel.cornerRadius = buttonCornerRadius

        uiModel.backgroundColors = primaryButtonBackgroundColors

        if #unavailable(iOS 15.0) { // Alternative to dynamic size upper limit
            uiModel.titleTextMinimumScaleFactor /= 2
        }
        uiModel.titleTextColors = primaryButtonTitleColors

#if os(iOS)
        uiModel.haptic = buttonHaptic
#endif

        return uiModel
    }

    // MARK: Properties - Button - Secondary
    /// Secondary button background colors.
    public var secondaryButtonBackgroundColors: ButtonStateColors = .init( // `clear` cannot be used, otherwise button won't register gestures
        enabled: ColorBook.layer,
        pressed: Color(module: "Alert.LayerColoredButton.Background.Pressed"),
        disabled: ColorBook.layer
    )

    /// Secondary button title colors.
    public var secondaryButtonTitleColors: ButtonStateColors = .init(
        enabled: ColorBook.accentBlue,
        pressed: ColorBook.accentBlue, // Looks better
        disabled: ColorBook.accentBluePressedDisabled
    )

    var secondaryButtonSubUIModel: VStretchedButtonUIModel {
        var uiModel: VStretchedButtonUIModel = .init()

        uiModel.height = buttonHeight
        uiModel.cornerRadius = buttonCornerRadius

        uiModel.backgroundColors = secondaryButtonBackgroundColors

        if #unavailable(iOS 15.0) { // Alternative to dynamic size upper limit
            uiModel.titleTextMinimumScaleFactor /= 2
        }
        uiModel.titleTextColors = secondaryButtonTitleColors

#if os(iOS)
        uiModel.haptic = buttonHaptic
#endif

        return uiModel
    }

    // MARK: Properties - Button - Destructive
    /// Destructive button background colors.
    public var destructiveButtonBackgroundColors: ButtonStateColors = .init( // `clear` cannot be used, otherwise button won't register gestures
        enabled: ColorBook.layer,
        pressed: Color(module: "Alert.LayerColoredButton.Background.Pressed"),
        disabled: ColorBook.layer
    )

    /// Destructive button title colors.
    public var destructiveButtonTitleColors: ButtonStateColors = .init(
        enabled: ColorBook.accentRed,
        pressed: ColorBook.accentRed, // Looks better
        disabled: ColorBook.accentRedPressedDisabled
    )

    var destructiveButtonSubUIModel: VStretchedButtonUIModel {
        var uiModel: VStretchedButtonUIModel = .init()

        uiModel.height = buttonHeight
        uiModel.cornerRadius = buttonCornerRadius

        uiModel.backgroundColors = destructiveButtonBackgroundColors

        if #unavailable(iOS 15.0) { // Alternative to dynamic size upper limit
            uiModel.titleTextMinimumScaleFactor /= 2
        }
        uiModel.titleTextColors = destructiveButtonTitleColors

#if os(iOS)
        uiModel.haptic = buttonHaptic
#endif

        return uiModel
    }

    // MARK: Properties - Keyboard Responsiveness
    /// Keyboard responsiveness strategy. Set to `default`.
    ///
    /// Changing this property after modal is presented may cause unintended behaviors.
    public var keyboardResponsivenessStrategy: PresentationHostUIModel.KeyboardResponsivenessStrategy? = .default

    /// Indicates if keyboard is dismissed when interface orientation changes. Set to `true`.
    public var dismissesKeyboardWhenInterfaceOrientationChanges: Bool = true

    // MARK: Properties - Dimming View
    /// Dimming view color.
    public var dimmingViewColor: Color = GlobalUIModel.Common.dimmingViewColor

    // MARK: Properties - Shadow
    /// Shadow color.
    public var shadowColor: Color = .clear

    /// Shadow radius. Set to `0`.
    public var shadowRadius: CGFloat = 0

    /// Shadow offset. Set to `zero`.
    public var shadowOffset: CGPoint = .zero

    // MARK: Properties - Transition
    /// Appear animation. Set to `linear` with duration `0.05`.
    public var appearAnimation: BasicAnimation? = GlobalUIModel.Modals.poppingAppearAnimation

    /// Disappear animation. Set to `easeIn` with duration `0.05`.
    public var disappearAnimation: BasicAnimation? = GlobalUIModel.Modals.poppingDisappearAnimation

    /// Scale effect during appear and disappear. Set to `1.01`.
    public var scaleEffect: CGFloat = GlobalUIModel.Modals.poppingAnimationScaleEffect

    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Widths
    /// Model that represents alert widths.
    public typealias Widths = ModalComponentSizes<Width>

    // MARK: Width
    /// Model that represents alert width.
    public typealias Width = SingleDimensionModalComponentSize

    // MARK: Margins
    /// Model that contains `leading`, `trailing`, `top`, and `bottom` margins.
    public typealias Margins = EdgeInsets_LeadingTrailingTopBottom

    /// Model that contains colors for button states.
    public typealias ButtonStateColors = GenericStateModel_EnabledPressedDisabled<Color>
}
