//
//  VMenuSection.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 30.06.22.
//

import SwiftUI
import VCore

// MARK: - V Menu Group Section
/// Grouped container view that adds hierarchy to `VMenuGroupRowProtocol`s.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VMenuGroupSection: VMenuSectionProtocol {
    // MARK: Properties
    public var headerTitle: String?
    private let rows: () -> [any VMenuGroupRowProtocol]
    
    // MARK: Initializers
    /// Initializes `VMenuGroupSection` with rows.
    public init(
        headerTitle: String? = nil,
        @VMenuGroupRowBuilder rows: @escaping () -> [any VMenuGroupRowProtocol]
    ) {
        self.headerTitle = headerTitle
        self.rows = rows
    }

    // MARK: Identifiable
    public var id: Int { headerTitle.hashValue }

    // MARK: Section Protocol
    //public var headerTitle: String?
    
    public func makeBody() -> AnyView {
        .init(
            ForEach(
                rows(),
                id: \.id,
                content: { row in row.makeBody() }
            )
        )
    }
}

// MARK: - V Menu Picker Section
/// Container view with picker that adds hierarchy to `VMenuPickerRowProtocol`s.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VMenuPickerSection<Data, ID>: VMenuSectionProtocol
    where
        Data: RandomAccessCollection,
        Data.Element: Hashable,
        ID: Hashable
{
    // MARK: Properties
    public var headerTitle: String?

    @Binding private var selection: Data.Element

    private let data: Data
    private let _id: KeyPath<Data.Element, ID>
    private let content: (Data.Element) -> VMenuPickerRowProtocol

    // MARK: Initializers
    /// Initializes `VMenuPickerSection` with selection, data, id, and row content.
    public init(
        headerTitle: String? = nil,
        selection: Binding<Data.Element>,
        data: Data,
        id: KeyPath<Data.Element, ID>,
        rows content: @escaping (Data.Element) -> VMenuPickerRowProtocol
    ) {
        self.headerTitle = headerTitle
        self._selection = selection
        self.data = data
        self._id = id
        self.content = content
    }

    // MARK: Initializers - Identifiable
    /// Initializes `VMenuPickerSection` with selection, data, and row content.
    public init(
        headerTitle: String? = nil,
        selection: Binding<Data.Element>,
        data: Data,
        rows content: @escaping (Data.Element) -> VMenuPickerRowProtocol
    )
        where
            Data.Element: Identifiable,
            ID == Data.Element.ID
    {
        self.headerTitle = headerTitle
        self._selection = selection
        self.data = data
        self._id = \.id
        self.content = content
    }
    
    // MARK: Initializers - String Representable
    /// Initializes `VSegmentedPicker` with `StringRepresentable` API.
    public init<T>(
        headerTitle: String? = nil,
        selection: Binding<T>
    )
        where
            Data == Array<T>,
            T: Identifiable & CaseIterable & StringRepresentable,
            ID == T.ID
    {
        self.headerTitle = headerTitle
        self._selection = selection
        self.data = Array(T.allCases)
        self._id = \.id
        self.content = { VMenuPickerRow(title: $0.stringRepresentation) }
    }

    // MARK: Identifiable
    public var id: Int { headerTitle.hashValue }

    // MARK: Section Protocol
    //public var headerTitle: String?
    
    public func makeBody() -> AnyView {
        .init(
            Picker(
                selection: $selection,
                content: {
                    ForEach(data, id: _id, content: { element in
                        content(element).makeBody()
                            .tag(element) // TODO: `Picker` requires tag. Remove this when custom component is added.
                    })
                },
                label: EmptyView.init
            )
            .pickerStyle(.inline)
        )
    }
}
