//
//  VWheelPicker.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI
import VCore

// MARK: - V Wheel Picker
/// Item picker component that selects from a set of mutually exclusive values, and displays their representative content in a scrollable wheel.
///
/// Best suited for `5`+ items.
///
///     private let data: [String] = [
///         "January", "February", "March",
///         "April", "May", "June",
///         "July", "August", "September",
///         "October", "November", "December"
///     ]
///
///     @State private var selection: String = "June"
///
///     var body: some View {
///         VWheelPicker(
///             selection: $selection,
///             data: data,
///             title: { $0 }
///         )
///         .padding()
///     }
///
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable) // Doesn't follow Human Interface Guidelines
public struct VWheelPicker<Data, ID, Content>: View
    where
        Data: RandomAccessCollection,
        Data.Element: Hashable,
        ID: Hashable,
        Content: View
{
    // MARK: Properties - UI Model
    private let uiModel: VWheelPickerUIModel

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    private var internalState: VWheelPickerInternalState {
        .init(isEnabled: isEnabled)
    }

    // MARK: Properties - Selection
    @Binding private var selection: Data.Element

    // MARK: Properties - Header & Footer
    private let headerTitle: String?
    private let footerTitle: String?

    // MARK: Properties - Data Source
    private let data: Data
    private let id: KeyPath<Data.Element, ID>
    private let content: VWheelPickerContent<Data.Element, Content>

    // MARK: Properties - Frame
    @State private var rowWidth: CGFloat = 0
    
    // MARK: Initializers
    /// Initializes `VWheelPicker` with selection, data, id, and row title.
    public init(
        uiModel: VWheelPickerUIModel = .init(),
        selection: Binding<Data.Element>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        data: Data,
        id: KeyPath<Data.Element, ID>,
        title: @escaping (Data.Element) -> String
    )
        where Content == Never
    {
        self.uiModel = uiModel
        self._selection = selection
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.data = data
        self.id = id
        self.content = .title(title: title)
    }
    
    /// Initializes `VWheelPicker` with selection, data, id, and row content.
    public init(
        uiModel: VWheelPickerUIModel = .init(),
        selection: Binding<Data.Element>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        data: Data,
        id: KeyPath<Data.Element, ID>,
        @ViewBuilder content: @escaping (VWheelPickerInternalState, Data.Element) -> Content
    ) {
        self.uiModel = uiModel
        self._selection = selection
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.data = data
        self.id = id
        self.content = .content(content: content)
    }

    // MARK: Initializers - Identifiable
    /// Initializes `VWheelPicker` with selection, data, and row title.
    public init(
        uiModel: VWheelPickerUIModel = .init(),
        selection: Binding<Data.Element>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        data: Data,
        title: @escaping (Data.Element) -> String
    )
        where
            Data.Element: Identifiable,
            ID == Data.Element.ID,
            Content == Never
    {
        self.uiModel = uiModel
        self._selection = selection
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.data = data
        self.id = \.id
        self.content = .title(title: title)
    }

    /// Initializes `VWheelPicker` with selection, data, and row content.
    public init(
        uiModel: VWheelPickerUIModel = .init(),
        selection: Binding<Data.Element>,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        data: Data,
        @ViewBuilder content: @escaping (VWheelPickerInternalState, Data.Element) -> Content
    )
        where
            Data.Element: Identifiable,
            ID == Data.Element.ID
    {
        self.uiModel = uiModel
        self._selection = selection
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.data = data
        self.id = \.id
        self.content = .content(content: content)
    }

    // MARK: Initializers - String Representable
    /// Initializes `VWheelPicker` with `StringRepresentable` API.
    public init<T>(
        uiModel: VWheelPickerUIModel = .init(),
        selection: Binding<T>,
        headerTitle: String? = nil,
        footerTitle: String? = nil
    )
        where
            Data == Array<T>,
            T: Identifiable & CaseIterable & StringRepresentable,
            ID == T.ID,
            Content == Never
    {
        self.uiModel = uiModel
        self._selection = selection
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.data = Array(T.allCases)
        self.id = \.id
        self.content = .title(title: { $0.stringRepresentation })
    }
    
    // MARK: Body
    public var body: some View {
        VStack(
            alignment: .leading,
            spacing: uiModel.headerPickerAndFooterSpacing,
            content: {
                header
                picker
                footer
            }
        )
    }
    
    @ViewBuilder private var header: some View {
        if let headerTitle, !headerTitle.isEmpty {
            Text(headerTitle)
                .multilineTextAlignment(uiModel.headerTitleTextLineType.textAlignment ?? .leading)
                .lineLimit(type: uiModel.headerTitleTextLineType.textLineLimitType)
                .foregroundColor(uiModel.headerTitleTextColors.value(for: internalState))
                .font(uiModel.headerTitleTextFont)

                .padding(.horizontal, uiModel.headerMarginHorizontal)
        }
    }

    @ViewBuilder private var footer: some View {
        if let footerTitle, !footerTitle.isEmpty {
            Text(footerTitle)
                .multilineTextAlignment(uiModel.footerTitleTextLineType.textAlignment ?? .leading)
                .lineLimit(type: uiModel.footerTitleTextLineType.textLineLimitType)
                .foregroundColor(uiModel.footerTitleTextColors.value(for: internalState))
                .font(uiModel.footerTitleTextFont)

                .padding(.horizontal, uiModel.footerMarginHorizontal)
        }
    }
    
    private var picker: some View {
        Picker(
            selection: $selection,
            content: rows,
            label: EmptyView.init
        )
        .pickerStyle(.wheel)
        .labelsHidden()
        .background(content: { background })
    }

    private var background: some View {
        uiModel.backgroundColors.value(for: internalState)
            .cornerRadius(uiModel.cornerRadius)
    }
    
    private func rows() -> some View {
        ForEach(data, id: id, content: { element in
            Group(content: {
                switch content {
                case .title(let title):
                    Text(title(element))
                        .lineLimit(1)
                        .minimumScaleFactor(uiModel.rowTitleTextMinimumScaleFactor)
                        .foregroundColor(uiModel.rowTitleTextColors.value(for: internalState))
                        .font(uiModel.rowTitleTextFont)

                case .content(let content):
                    content(internalState, element)
                }
            })
        })
    }
}

// MARK: - Preview
// Developmental only
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VWheelPicker_Previews: PreviewProvider {
    // Configuration
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var dynamicTypeSize: DynamicTypeSize? { nil }
    private static var colorScheme: ColorScheme { .light }
    
    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            StatesPreview().previewDisplayName("States")
        })
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
        .preferredColorScheme(colorScheme)
    }
    
    // Data
    private static var headerTitle: String { "Lorem ipsum dolor sit amet".pseudoRTL(languageDirection) }
    private static var footerTitle: String { "Lorem ipsum dolor sit amet, consectetur adipiscing elit".pseudoRTL(languageDirection) }
    
    private static var rowTitles: [String] {
        [
            "January", "February", "March",
            "April", "May", "June",
            "July", "August", "September",
            "October", "November", "December"
        ].map { $0.pseudoRTL(languageDirection) }
    }
    private static var selection: String { rowTitles[rowTitles.count/2] }
    
    // Previews (Scenes)
    private struct Preview: View {
        @State private var selection: String = VWheelPicker_Previews.selection
        
        var body: some View {
            PreviewContainer(content: {
                VWheelPicker(
                    selection: $selection,
                    headerTitle: headerTitle,
                    footerTitle: footerTitle,
                    data: rowTitles,
                    id: \.self,
                    title: { $0 }
                )
                .padding()
            })
        }
    }
    
    private struct StatesPreview: View {
        var body: some View {
            PreviewContainer(content: {
                PreviewRow(
                    axis: .vertical,
                    title: "Enabled",
                    content: {
                        VWheelPicker(
                            selection: .constant(selection),
                            headerTitle: headerTitle,
                            footerTitle: footerTitle,
                            data: rowTitles,
                            id: \.self,
                            title: { $0 }
                        )
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    title: "Disabled",
                    content: {
                        VWheelPicker(
                            selection: .constant(selection),
                            headerTitle: headerTitle,
                            footerTitle: footerTitle,
                            data: rowTitles,
                            id: \.self,
                            title: { $0 }
                        )
                        .disabled(true)
                    }
                )
            })
        }
    }
}
