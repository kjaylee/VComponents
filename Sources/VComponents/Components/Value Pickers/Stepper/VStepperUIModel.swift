//
//  VStepperUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/4/21.
//

import SwiftUI
import VCore

// MARK: - V Stepper UI Model
/// Model that describes UI.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VStepperUIModel {
    // MARK: Properties - Global
    /// Stepper size. Set to `(94, 32)`.
    public var size: CGSize = .init(width: 94, height: 32)

    // MARK: Properties - Corner
    /// Stepper corner radius. Set to `7`.
    public var cornerRadius: CGFloat = 7

    // MARK: Properties - Background
    /// Background colors.
    public var backgroundColors: StateColors = .init(
        enabled: Color.makePlatformDynamic((235, 235, 235, 1), (60, 60, 60, 1)),
        disabled: Color.makePlatformDynamic((245, 245, 245, 1), (50, 50, 50, 1))
    )

    // MARK: Properties - Button Background
    /// Plus and minus button background colors.
    public var buttonBackgroundColors: ButtonStateColors = .init(
        enabled: Color.clear,
        pressed: Color.makeDynamic((200, 200, 200, 1), (90, 90, 90, 1)),
        disabled: Color.clear
    )

    // MARK: Properties - Button Icon
    /// Minus button icon.
    public var buttonIconMinus: Image = ImageBook.minus.renderingMode(.template)

    /// Plus button icon.
    public var buttonIconPlus: Image = ImageBook.plus.renderingMode(.template)

    /// Indicates if `resizable(capInsets:resizingMode)` modifier is applied to button icon. Set to `true`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var isButtonIconResizable: Bool = true

    /// Button icon content mode. Set to `fit`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var buttonIconContentMode: ContentMode? = .fit

    /// Button icon size. Set to `(14, 14)`.
    public var buttonIconSize: CGSize? = .init(dimension: 14)

    /// Button icon colors.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var buttonIconColors: ButtonStateColors? = .init(
        enabled: Color.primary,
        pressed: Color.primary,
        disabled: Color.primary.opacity(0.3)
    )

    /// Button icon opacities. Set to `nil`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var buttonIconOpacities: ButtonStateOpacities?

    /// Button icon font. Set to `nil.`
    ///
    /// Can be used for setting different weight to SF symbol icons.
    /// To achieve this, `isButtonIconResizable` should be set to `false`, and `buttonIconSize` should be set to `nil`.
    public var buttonIconFont: Font?

    // MARK: Properties - Divider
    /// Plus and minus button divider size. Set to `(1, 19)`.
    public var dividerSize: CGSize = .init(width: 1, height: 19)

    /// Plus and minus button divider colors.
    public var dividerColors: StateColors = .init(
        enabled: Color.makeDynamic((210, 210, 210, 1), (80, 80, 80, 1)),
        disabled: Color.makeDynamic((235, 235, 235, 1), (60, 60, 60, 1))
    )
    
    // MARK: Properties - Transition
    /// Time interval after which long press incrementation begins. Set to `1` second.
    public var intervalToStartLongPressIncrement: TimeInterval = 1

    /// Exponent by which long press incrementation happens. Set to `2`.
    ///
    /// For instance, if exponent is set to `2`, increment would increase by a factor of `2` every second.
    /// So, `1`, `2`, `4`, `8` ... .
    public var longPressIncrementExponent: Int = 2

    // MARK: Properties - Haptic
#if os(iOS)
    /// Haptic feedback style on press. Set to `light`.
    public var hapticPress: UIImpactFeedbackGenerator.FeedbackStyle? = .light

    /// Haptic feedback style on long press. Set to `soft`.
    public var hapticLongPress: UIImpactFeedbackGenerator.FeedbackStyle? = .soft
#endif
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: State Colors
    /// Model that contains colors for component states.
    public typealias StateColors = GenericStateModel_EnabledDisabled<Color>

    // MARK: Button State Colors
    /// Model that contains colors for component states.
    public typealias ButtonStateColors = GenericStateModel_EnabledPressedDisabled<Color>

    // MARK: State Opacities
    /// Model that contains colors for component opacities.
    public typealias ButtonStateOpacities = GenericStateModel_EnabledPressedDisabled<CGFloat>
}
