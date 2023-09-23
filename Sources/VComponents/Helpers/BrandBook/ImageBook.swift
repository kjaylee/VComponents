//
//  ImageBook.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI

// MARK: - Image Book
struct ImageBook {
    // MARK: Properties
    static let checkmarkOn: Image = .init(.checkmarkOn) // Mirrored for RTL languages
    static let checkmarkIndeterminate: Image = .init(.checkmarkIndeterminate)

    static let minus: Image = .init(.minus)
    static let plus: Image = .init(.plus)

    static let magnifyGlass: Image = .init(.magnifyGlass) // Doesn't mirror, like `UISearchBar.searchable(text:)`

    static let visibilityOff: Image = .init(.visibilityOff) // Mirrored for RTL languages
    static let visibilityOn: Image = .init(.visibilityOn)

    static let xMark: Image = .init(.xMark)

    static let chevronUp: Image = .init(.chevronUp)

    // MARK: Initializers
    private init() {}
}
