//
//  VModalDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/30/20.
//

import SwiftUI
import VComponents

// MARK: - V Modal Demo View
struct VModalDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Modal" }
    
    @State private var isPresented: Bool = false
    @State private var dismissType: VModalModel.Misc.DismissType = .default
    @State private var hasTitle: Bool = true
    @State private var hasDivider: Bool = VModalModel.Layout().headerDividerHeight > 0
    
    private var model: VModalModel {
        var model: VModalModel = .init()
        
        if !hasDivider && (hasTitle || dismissType.hasButton) {
            model.layout.headerMargins.bottom /= 2
            model.layout.contentMargins.top /= 2
        }
        
        model.layout.headerDividerHeight = hasDivider ? (model.layout.headerDividerHeight == 0 ? 1 : model.layout.headerDividerHeight) : 0
        model.colors.headerDivider = hasDivider ? (model.colors.headerDivider == .clear ? .gray : model.colors.headerDivider) : .clear
        
        model.misc.dismissType = dismissType
        
        return model
    }

    // MARK: Body
    var body: some View {
        DemoView(component: component, settings: settings)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        VPlainButton(
            action: { isPresented = true },
            title: "Present"
        )
            .if(hasTitle,
                ifTransform: {
                    $0
                        .vModal(isPresented: $isPresented, modal: {
                            VModal(
                                model: model,
                                headerTitle: "Lorem ipsum dolor sit amet",
                                content: { modalContent }
                            )
                        })
                }, elseTransform: {
                    $0
                        .vModal(isPresented: $isPresented, modal: {
                            VModal(
                                model: model,
                                content: { modalContent }
                            )
                        })
                }
            )
    }
    
    @ViewBuilder private func settings() -> some View {
        ToggleSettingView(isOn: $hasTitle, title: "Title")
        
        VStack(spacing: 3, content: {
            VText(color: ColorBook.primary, font: .callout, title: "Dismiss Method:")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal, showsIndicators: false, content: {
                HStack(content: {
                    ForEach(VModalModel.Misc.DismissType.all.elements, id: \.rawValue, content: { position in
                        dismissTypeView(position)
                    })
                })
            })
                .frame(maxWidth: .infinity, alignment: .leading)
        })
        
        ToggleSettingView(isOn: $hasDivider, title: "Divider")
    }
    
    private func dismissTypeView(_ position: VModalModel.Misc.DismissType) -> some View {
        VCheckBox(
            model: {
                var model: VCheckBoxModel = .init()
                model.layout.titleLabelLineLimit = 1
                return model
            }(),
            isOn: .init(
                get: { dismissType.contains(position) },
                set: { isOn in
                    switch isOn {
                    case false: dismissType.remove(position)
                    case true: dismissType.insert(position)
                    }
                }
            ),
            title: position.title
        )
    }
    
    private var modalContent: some View {
        ZStack(content: {
            VList(data: 0..<20, rowContent: { num in
                Text(String(num))
                    .frame(maxWidth: .infinity, alignment: .leading)
            })

            if dismissType.isEmpty {
                VStack(content: {
                    VText(
                        type: .multiLine(alignment: .center, limit: nil),
                        color: ColorBook.primaryWhite,
                        font: .system(size: 14, weight: .semibold),
                        title: "When there are no dismiss types, Modal can only be dismissed programatically"
                    )

                    VPlainButton(
                        model: {
                            var model: VPlainButtonModel = .init()
                            model.colors.title = .init(
                                enabled: ColorBook.primaryWhite,
                                pressed: ColorBook.primaryWhite,
                                disabled: ColorBook.primaryWhite
                            )
                            return model
                        }(),
                        action: { isPresented = false },
                        title: "Dismiss"
                    )
                })
                    .padding(15)
                    .background(Color.black.opacity(0.75))
                    .cornerRadius(10)
            }
        })
    }
}

// MARK: - Helpers
extension VModalModel.Misc.DismissType {
    fileprivate var title: String {
        switch self {
        case .leadingButton: return "Leading"
        case .trailingButton: return "Trailing"
        case .backTap: return "Back Tap"
        default: fatalError()
        }
    }
}

// MARK: - Preview
struct VModalDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VModalDemoView()
    }
}
