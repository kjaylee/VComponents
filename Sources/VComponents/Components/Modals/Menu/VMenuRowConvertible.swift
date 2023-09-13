//
//  VMenuRowConvertible.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.05.23.
//

import SwiftUI

// MARK: - V Menu Group Row Convertible
/// Type that allows for conversion to `VMenuGroupRowProtocol`.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public protocol VMenuGroupRowConvertible {
    /// Converts self to `VMenuGroupRowProtocol` `Array`.
    func toRows() -> [any VMenuGroupRowProtocol]
}

@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Array: VMenuGroupRowConvertible where Element == any VMenuGroupRowProtocol {
    public func toRows() -> [any VMenuGroupRowProtocol] { self }
}

@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension EmptyView: VMenuGroupRowConvertible {
    public func toRows() -> [any VMenuGroupRowProtocol] { [] }
}

// MARK: - V Menu Picker Row Convertible
/// Type that allows for conversion to `VMenuPickerRowProtocol`.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public protocol VMenuPickerRowConvertible {
    /// Converts self to `VMenuPickerRowProtocol` `Array`.
    func toRows() -> [any VMenuPickerRowProtocol]
}

@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Array: VMenuPickerRowConvertible where Element == any VMenuPickerRowProtocol {
    public func toRows() -> [any VMenuPickerRowProtocol] { self }
}

@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension EmptyView: VMenuPickerRowConvertible {
    public func toRows() -> [any VMenuPickerRowProtocol] { [] }
}
