//
//  VAlertExtension.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI
import VCore

// MARK: - Bool
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {
    /// Modal component that presents alert with actions and hosts content.
    ///
    /// Alert can have one, two, or many buttons.
    /// Two buttons are stacked horizontally, while more are stacked vertically.
    ///
    /// Optionally, content can be presented with methods that have `content` argument.
    ///
    ///     @State private var isPresented: Bool = false
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true },
    ///             title: "Present"
    ///         )
    ///         .vAlert(
    ///             id: "some_alert",
    ///             isPresented: $isPresented,
    ///             title: "Lorem Ipsum",
    ///             message: "Lorem ipsum dolor sit amet",
    ///             actions: {
    ///                 VAlertButton(role: .primary, action: { print("Confirmed") }, title: "Confirm")
    ///                 VAlertButton(role: .cancel, action: { print("Cancelled") }, title: "Cancel")
    ///             }
    ///         )
    ///     }
    ///
    public func vAlert(
        id: String,
        uiModel: VAlertUIModel = .init(),
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: String?,
        message: String?,
        @VAlertButtonBuilder actions buttons: @escaping () -> [any VAlertButtonProtocol]
    ) -> some View {
        self
            .presentationHost(
                id: id,
                uiModel: uiModel.presentationHostUIModel,
                isPresented: isPresented,
                content: {
                    VAlert<Never>(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: title,
                        message: message,
                        content: .empty,
                        buttons: buttons()
                    )
                }
            )
    }
    
    /// Modal component that presents alert with actions and hosts content.
    ///
    /// For additional info, refer to `View.vAlert(id:isPresented:title:message:buttons)`.
    public func vAlert<Content>(
        id: String,
        uiModel: VAlertUIModel = .init(),
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: String?,
        message: String?,
        @ViewBuilder content: @escaping () -> Content,
        @VAlertButtonBuilder actions buttons: @escaping () -> [any VAlertButtonProtocol]
    ) -> some View
        where Content: View
    {
        self
            .presentationHost(
                id: id,
                uiModel: uiModel.presentationHostUIModel,
                isPresented: isPresented,
                content: {
                    VAlert<Content>(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: title,
                        message: message,
                        content: .content(content: content),
                        buttons: buttons()
                    )
                }
            )
    }
}

// MARK: - Item
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {
    /// Modal component that presents alert with actions and hosts content.
    ///
    /// For additional info, refer to `View.vAlert(id:isPresented:title:message:buttons)`.
    public func vAlert<Item>(
        id: String,
        uiModel: VAlertUIModel = .init(),
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: @escaping (Item) -> String?,
        message: @escaping (Item) -> String?,
        @VAlertButtonBuilder actions buttons: @escaping (Item) -> [any VAlertButtonProtocol]
    ) -> some View
        where Item: Identifiable
    {
        item.wrappedValue.map { PresentationHostDataSourceCache.shared.set(key: id, value: $0) }
        
        return self
            .presentationHost(
                id: id,
                uiModel: uiModel.presentationHostUIModel,
                item: item,
                content: {
                    VAlert<Never>(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                return title(item)
                            } else {
                                return ""
                            }
                        }(),
                        message: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                return message(item)
                            } else {
                                return ""
                            }
                        }(),
                        content: .empty,
                        buttons: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                return buttons(item)
                            } else {
                                return []
                            }
                        }()
                    )
                }
            )
    }
    
    /// Modal component that presents alert with actions and hosts content.
    ///
    /// For additional info, refer to `View.vAlert(id:isPresented:title:message:buttons)`.
    public func vAlert<Item, Content>(
        id: String,
        uiModel: VAlertUIModel = .init(),
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: @escaping (Item) -> String?,
        message: @escaping (Item) -> String?,
        @ViewBuilder content: @escaping (Item) -> Content,
        @VAlertButtonBuilder actions buttons: @escaping (Item) -> [any VAlertButtonProtocol]
    ) -> some View
        where
            Item: Identifiable,
            Content: View
    {
        item.wrappedValue.map { PresentationHostDataSourceCache.shared.set(key: id, value: $0) }
        
        return self
            .presentationHost(
                id: id,
                uiModel: uiModel.presentationHostUIModel,
                item: item,
                content: {
                    VAlert<Content>(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                return title(item)
                            } else {
                                return ""
                            }
                        }(),
                        message: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                return message(item)
                            } else {
                                return ""
                            }
                        }(),
                        content: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                return .content(content: { content(item) })
                            } else {
                                return .empty
                            }
                        }(),
                        buttons: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                return buttons(item)
                            } else {
                                return []
                            }
                        }()
                    )
                }
            )
    }
}

// MARK: - Presenting Data
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {
    /// Modal component that presents alert with actions and hosts content.
    ///
    /// For additional info, refer to `View.vAlert(id:isPresented:title:message:buttons)`.
    public func vAlert<T>(
        id: String,
        uiModel: VAlertUIModel = .init(),
        isPresented: Binding<Bool>,
        presenting data: T?,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: @escaping (T) -> String?,
        message: @escaping (T) -> String?,
        @VAlertButtonBuilder actions buttons: @escaping (T) -> [any VAlertButtonProtocol]
    ) -> some View {
        data.map { PresentationHostDataSourceCache.shared.set(key: id, value: $0) }
        
        return self
            .presentationHost(
                id: id,
                uiModel: uiModel.presentationHostUIModel,
                isPresented: isPresented,
                presenting: data,
                content: {
                    VAlert<Never>(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: {
                            if let data = data ?? PresentationHostDataSourceCache.shared.get(key: id) as? T {
                                return title(data)
                            } else {
                                return ""
                            }
                        }(),
                        message: {
                            if let data = data ?? PresentationHostDataSourceCache.shared.get(key: id) as? T {
                                return message(data)
                            } else {
                                return ""
                            }
                        }(),
                        content: .empty,
                        buttons: {
                            if let data = data ?? PresentationHostDataSourceCache.shared.get(key: id) as? T {
                                return buttons(data)
                            } else {
                                return []
                            }
                        }()
                    )
                }
            )
    }
    
    /// Modal component that presents alert with actions and hosts content.
    ///
    /// For additional info, refer to `View.vAlert(id:isPresented:title:message:buttons)`.
    public func vAlert<T, Content>(
        id: String,
        uiModel: VAlertUIModel = .init(),
        isPresented: Binding<Bool>,
        presenting data: T?,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: @escaping (T) -> String?,
        message: @escaping (T) -> String?,
        @ViewBuilder content: @escaping (T) -> Content,
        @VAlertButtonBuilder actions buttons: @escaping (T) -> [any VAlertButtonProtocol]
    ) -> some View
        where Content: View
    {
        data.map { PresentationHostDataSourceCache.shared.set(key: id, value: $0) }
        
        return self
            .presentationHost(
                id: id,
                uiModel: uiModel.presentationHostUIModel,
                isPresented: isPresented,
                presenting: data,
                content: {
                    VAlert<Content>(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: {
                            if let data = data ?? PresentationHostDataSourceCache.shared.get(key: id) as? T {
                                return title(data)
                            } else {
                                return ""
                            }
                        }(),
                        message: {
                            if let data = data ?? PresentationHostDataSourceCache.shared.get(key: id) as? T {
                                return message(data)
                            } else {
                                return ""
                            }
                        }(),
                        content: {
                            if let data = data ?? PresentationHostDataSourceCache.shared.get(key: id) as? T {
                                return .content(content: { content(data) })
                            } else {
                                return .empty
                            }
                        }(),
                        buttons: {
                            if let data = data ?? PresentationHostDataSourceCache.shared.get(key: id) as? T {
                                return buttons(data)
                            } else {
                                return []
                            }
                        }()
                    )
                }
            )
    }
}

// MARK: - Error
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {
    /// Modal component that presents alert with actions and hosts content.
    ///
    /// For additional info, refer to `View.vAlert(id:isPresented:title:message:buttons)`.
    public func vAlert<E>(
        id: String,
        uiModel: VAlertUIModel = .init(),
        isPresented: Binding<Bool>,
        error: E?,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: @escaping (E) -> String?,
        message: @escaping (E) -> String?,
        @VAlertButtonBuilder actions buttons: @escaping (E) -> [any VAlertButtonProtocol]
    ) -> some View
        where E: Error
    {
        error.map { PresentationHostDataSourceCache.shared.set(key: id, value: $0) }
        
        return self
            .presentationHost(
                id: id,
                uiModel: uiModel.presentationHostUIModel,
                isPresented: isPresented,
                error: error,
                content: {
                    VAlert<Never>(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: {
                            if let error = error ?? PresentationHostDataSourceCache.shared.get(key: id) as? E {
                                return title(error)
                            } else {
                                return ""
                            }
                        }(),
                        message: {
                            if let error = error ?? PresentationHostDataSourceCache.shared.get(key: id) as? E {
                                return message(error)
                            } else {
                                return ""
                            }
                        }(),
                        content: .empty,
                        buttons: {
                            if let error = error ?? PresentationHostDataSourceCache.shared.get(key: id) as? E {
                                return buttons(error)
                            } else {
                                return []
                            }
                        }()
                    )
                }
            )
    }
    
    /// Modal component that presents alert with actions and hosts content.
    ///
    /// For additional info, refer to `View.vAlert(id:isPresented:title:message:buttons)`.
    public func vAlert<E, Content>(
        id: String,
        uiModel: VAlertUIModel = .init(),
        isPresented: Binding<Bool>,
        error: E?,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: @escaping (E) -> String?,
        message: @escaping (E) -> String?,
        @ViewBuilder content: @escaping (E) -> Content,
        @VAlertButtonBuilder actions buttons: @escaping (E) -> [VAlertButton]
    ) -> some View
        where
            E: Error,
            Content: View
    {
        error.map { PresentationHostDataSourceCache.shared.set(key: id, value: $0) }
        
        return self
            .presentationHost(
                id: id,
                uiModel: uiModel.presentationHostUIModel,
                isPresented: isPresented,
                error: error,
                content: {
                    VAlert<Content>(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: {
                            if let error = error ?? PresentationHostDataSourceCache.shared.get(key: id) as? E {
                                return title(error)
                            } else {
                                return ""
                            }
                        }(),
                        message: {
                            if let error = error ?? PresentationHostDataSourceCache.shared.get(key: id) as? E {
                                return message(error)
                            } else {
                                return ""
                            }
                        }(),
                        content: {
                            if let error = error ?? PresentationHostDataSourceCache.shared.get(key: id) as? E {
                                return .content(content: { content(error) })
                            } else {
                                return .empty
                            }
                        }(),
                        buttons: {
                            if let error = error ?? PresentationHostDataSourceCache.shared.get(key: id) as? E {
                                return buttons(error)
                            } else {
                                return []
                            }
                        }()
                    )
                }
            )
    }
}
