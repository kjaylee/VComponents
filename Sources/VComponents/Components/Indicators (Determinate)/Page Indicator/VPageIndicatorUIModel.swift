//
//  VPageIndicatorUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/6/21.
//

import SwiftUI
import VCore

// MARK: - V Page Indicator UI Model
/// Model that describes UI.
public struct VPageIndicatorUIModel {
    // MARK: Properties - General
    /// Direction. Set to `leftToRight`.
    public var direction: LayoutDirectionOmni = .leftToRight

    /// Dot spacing.
    /// Set to `5` on `iOS`.
    /// Set to `5` on `macOS`.
    /// Set to `10` on `tvOS`.
    /// Set to `3` on `watchOS`.
    public var spacing: CGFloat = GlobalUIModel.DeterminateIndicators.pageIndicatorSpacing

    // MARK: Properties - Dot
    /// Dot width, but height for vertical layouts.
    /// Set to `10` on `iOS`.
    /// Set to `10` on `macOS`.
    /// Set to `20` on `tvOS`.
    /// Set to `8` on `watchOS`.
    ///
    /// Set to `nil`, to make dot stretch to take available space.
    public var dotWidth: CGFloat? = GlobalUIModel.DeterminateIndicators.pageIndicatorDotDimension

    /// Dot height, but width for vertical layouts.
    /// Set to `10` on `iOS`.
    /// Set to `10` on `macOS`.
    /// Set to `20` on `tvOS`.
    /// Set to `8` on `watchOS`.
    public var dotHeight: CGFloat = GlobalUIModel.DeterminateIndicators.pageIndicatorDotDimension

    /// Unselected dot scale. Set to `0.85`.
    public var unselectedDotScale: CGFloat = GlobalUIModel.DeterminateIndicators.pageIndicatorStandardUnselectedDotScale

    /// Dot color.
    public var dotColor: Color = GlobalUIModel.DeterminateIndicators.pageIndicatorDotColor

    /// Selected dot color.
    public var selectedDotColor: Color = GlobalUIModel.DeterminateIndicators.pageIndicatorSelectedDotColor

    // MARK: Properties - Dot Border
    /// Border width. Set to `0.`
    ///
    /// To hide border, set to `0`.
    public var dotBorderWidth: CGFloat = 0

    /// Dot border color.
    public var dotBorderColor: Color = .clear

    /// Selected dot border color.
    public var selectedDotBorderColor: Color = .clear

    // MARK: Properties - Transition
    /// Indicates if `transition` animation is applied. Set to `true`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    ///
    /// If  animation is set to `nil`, a `nil` animation is still applied.
    /// If this property is set to `false`, then no animation is applied.
    ///
    /// One use-case for this property is to externally mutate state using `withAnimation(_:_:)` function.
    public var appliesTransitionAnimation: Bool = true

    /// Transition animation. Set to `linear` with duration `0.15`.
    public var transitionAnimation: Animation? = GlobalUIModel.DeterminateIndicators.pageIndicatorTransitionAnimation
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    init(
        direction: LayoutDirectionOmni,
        spacing: CGFloat,
        dotWidth: CGFloat?,
        dotHeight: CGFloat,
        unselectedDotScale: CGFloat,
        dotColor: Color,
        selectedDotColor: Color,
        dotBorderWidth: CGFloat,
        dotBorderColor: Color,
        selectedDotBorderColor: Color,
        appliesTransitionAnimation: Bool,
        transitionAnimation: Animation?
    ) {
        self.direction = direction
        self.spacing = spacing
        self.dotWidth = dotWidth
        self.dotHeight = dotHeight
        self.unselectedDotScale = unselectedDotScale
        self.dotColor = dotColor
        self.selectedDotColor = selectedDotColor
        self.dotBorderWidth = dotBorderWidth
        self.dotBorderColor = dotBorderColor
        self.selectedDotBorderColor = selectedDotBorderColor
        self.appliesTransitionAnimation = appliesTransitionAnimation
        self.transitionAnimation = transitionAnimation
    }
}

// MARK: - Factory
extension VPageIndicatorUIModel {
    /// `VPageIndicatorUIModel` with vertical layout.
    public static var vertical: Self {
        var uiModel: Self = .init()
        
        uiModel.direction = .topToBottom
        
        return uiModel
    }
}
