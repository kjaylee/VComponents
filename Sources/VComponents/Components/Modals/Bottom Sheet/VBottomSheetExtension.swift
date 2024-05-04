//
//  VBottomSheetExtension.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/21/21.
//

import SwiftUI
import VCore

// MARK: - Bool
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {
    /// Presents bottom sheet when `Bool` is `true`.
    ///
    /// Modal component that draws a background, and hosts pull-up content on the bottom of the screen.
    ///
    /// UI Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// `vBottomSheet` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    ///     @State private var isPresented: Bool = false
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true },
    ///             title: "Present"
    ///         )
    ///         .vBottomSheet(
    ///             id: "some_bottom_sheet",
    ///             uiModel: .scrollableContent,
    ///             isPresented: $isPresented,
    ///             content: {
    ///                 List(content: {
    ///                     ForEach(0..<20, content: { number in
    ///                         VListRow(uiModel: .noFirstAndLastSeparators(isFirst: number == 0), content: {
    ///                             Text(String(number))
    ///                                 .frame(maxWidth: .infinity, alignment: .leading)
    ///                         })
    ///                     })
    ///                 })
    ///                 .vListStyle()
    ///                 .vBottomSheetHeaderTitle("Lorem Ipsum Dolor Sit Amet")
    ///             }
    ///         )
    ///     }
    ///
    public func vBottomSheet(
        id: String,
        uiModel: VBottomSheetUIModel = .init(),
        heightState: Binding<SheetHeight>, // External control for sheet height
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> some View
    ) -> some View {
        self
            .presentationHost(
                id: id,
                isPresented: isPresented,
                content: {
                    VBottomSheet<_>(
                        uiModel: uiModel,
                        heightState: heightState,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        content: content
                    )
                }
            )
    }
}

// MARK: - Item
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {
    /// Presents bottom sheet when `Bool` is `true`.
    ///
    /// Modal component that draws a background, and hosts pull-up content on the bottom of the screen.
    ///
    /// UI Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// `vBottomSheet` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    ///     struct BottomSheetItem: Identifiable {
    ///         let id: UUID = .init()
    ///     }
    ///
    ///     @State private var bottomSheetItem: BottomSheetItem?
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { bottomSheetItem = BottomSheetItem() },
    ///             title: "Present"
    ///         )
    ///         .vBottomSheet(
    ///             id: "some_bottom_sheet",
    ///             uiModel: .scrollableContent,
    ///             item: $bottomSheetItem,
    ///             content: { item in
    ///                 List(content: {
    ///                     ForEach(0..<20, content: { number in
    ///                         VListRow(uiModel: .noFirstAndLastSeparators(isFirst: number == 0), content: {
    ///                             Text(String(number))
    ///                                 .frame(maxWidth: .infinity, alignment: .leading)
    ///                         })
    ///                     })
    ///                 })
    ///                 .vListStyle()
    ///                 .vBottomSheetHeaderTitle("Lorem Ipsum Dolor Sit Amet")
    ///             }
    ///         )
    ///     }
    ///
    public func vBottomSheet<Item>(
        id: String,
        uiModel: VBottomSheetUIModel = .init(),
        heightState: Binding<SheetHeight>, // External control for sheet height
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> some View
    ) -> some View
        where Item: Identifiable
    {
        item.wrappedValue.map { PresentationHostDataSourceCache.shared.set(key: id, value: $0) }
        
        return self
            .presentationHost(
                id: id,
                item: item,
                content: {
                    VBottomSheet<_>(
                        uiModel: uiModel,
                        heightState: heightState,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        content: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                content(item)
                            }
                        }
                    )
                }
            )
    }
}
