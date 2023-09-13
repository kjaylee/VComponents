//
//  VDisclosureGroupState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/11/21.
//

import Foundation
import VCore

// MARK: - V Disclosure Group State
/// Enumeration that represents state, such as `collapsed` or `standard`.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public typealias VDisclosureGroupState = GenericState_CollapsedExpanded

// MARK: - V Disclosure Group Internal State
/// Enumeration that represents state, such as `collapsed`, `expanded`, or `disabled`.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public typealias VDisclosureGroupInternalState = GenericState_CollapsedExpandedDisabled
