//
//  VDisclosureGroup.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/11/21.
//

import SwiftUI
import VCore

// MARK: - V Disclosure Group
/// Expandable container component that hosts content.
///
///     @State private var state: VDisclosureGroupState = .expanded
///
///     var body: some View {
///         ZStack(alignment: .top, content: {
///             ColorBook.canvas.ignoresSafeArea()
///
///             VDisclosureGroup(
///                 state: $state,
///                 headerTitle: "Lorem Ipsum",
///                 content: {
///                     ColorBook.accentBlue
///                         .frame(height: 150)
///                 }
///             )
///             .padding()
///         })
///     }
///
/// Component can be also initialized with `Bool`.
///
///     @State private var isExpanded: Bool = true
///
///     var body: some View {
///         VDisclosureGroup(
///             state: Binding(isExpanded: $isExpanded),
///             ...
///         )
///     }
///
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VDisclosureGroup<HeaderLabel, Content>: View
    where
        HeaderLabel: View,
        Content: View
{
    // MARK: Properties - UI Model
    private let uiModel: VDisclosureGroupUIModel
    @Environment(\.displayScale) private var displayScale: CGFloat

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Binding private var state: VDisclosureGroupState
    private var internalState: VDisclosureGroupInternalState {
        .init(
            isEnabled: isEnabled,
            isExpanded: state == .expanded
        )
    }

    // MARK: Properties - Header
    private let headerLabel: VDisclosureGroupHeaderLabel<HeaderLabel>

    // MARK: Properties - Content
    private let content: () -> Content
    
    // MARK: Initializers
    /// Initializes `VDisclosureGroup` with header title and content.
    public init(
        uiModel: VDisclosureGroupUIModel = .init(),
        state: Binding<VDisclosureGroupState>,
        headerTitle: String,
        @ViewBuilder content: @escaping () -> Content
    )
        where HeaderLabel == Never
    {
        self.uiModel = uiModel
        self._state = state
        self.headerLabel = .title(title: headerTitle)
        self.content = content
    }
    
    /// Initializes `VDisclosureGroup` with header and content.
    public init(
        uiModel: VDisclosureGroupUIModel = .init(),
        state: Binding<VDisclosureGroupState>,
        @ViewBuilder headerLabel: @escaping (VDisclosureGroupInternalState) -> HeaderLabel,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.uiModel = uiModel
        self._state = state
        self.headerLabel = .label(label: headerLabel)
        self.content = content
    }
    
    // MARK: Body
    public var body: some View {
        VGroupBox(uiModel: uiModel.groupBoxSubUIModel, content: {
            PlainDisclosureGroup(
                uiModel: uiModel.plainDisclosureGroupSubUIModel,
                isExpanded: Binding(
                    get: { internalState == .expanded },
                    set: { expandCollapseFromHeaderTap($0) }
                ),
                label: { header },
                content: {
                    VStack(spacing: 0, content: {
                        divider
                        contentView
                    })
                }
            )
        })
        .applyIf(uiModel.appliesExpandCollapseAnimation, transform: {
            $0
                .animation(uiModel.expandCollapseAnimation, value: isEnabled)
                .animation(uiModel.expandCollapseAnimation, value: state) // +withAnimation
        })
    }
    
    private var header: some View {
        HStack(spacing: 0, content: {
            Group(content: {
                switch headerLabel {
                case .title(let title):
                    Text(title)
                        .lineLimit(1)
                        .foregroundColor(uiModel.headerTitleTextColors.value(for: internalState))
                        .font(uiModel.headerTitleTextFont)
                    
                case .label(let label):
                    label(internalState)
                }
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            .allowsHitTesting(false)
            
            Spacer()
            
            VRectangularButton(
                uiModel: uiModel.disclosureButtonSubUIModel,
                action: expandCollapse,
                icon: uiModel.disclosureButtonIcon.renderingMode(.template)
            )
            .rotationEffect(Angle(radians: uiModel.disclosureButtonAngles.value(for: internalState)))
        })
        .padding(uiModel.headerMargins)
    }
    
    @ViewBuilder private var divider: some View {
        if uiModel.dividerHeight.toPoints(scale: displayScale) > 0 {
            Rectangle()
                .frame(height: uiModel.dividerHeight.toPoints(scale: displayScale))
                .padding(uiModel.dividerMargins)
                .foregroundColor(uiModel.dividerColor)
        }
    }
    
    private var contentView: some View {
        content()
            .frame(maxWidth: .infinity)
            .padding(uiModel.contentMargins)
    }
    
    // MARK: Actions
    private func expandCollapse() {
        // Not affected by animation flag
        withAnimation(uiModel.expandCollapseAnimation, { state.setNextState() })
    }
    
    private func expandCollapseFromHeaderTap(_ isExpanded: Bool) {
        guard
            uiModel.expandsAndCollapsesOnHeaderTap,
            isExpanded ^^ (internalState == .expanded)
        else {
            return
        }
        
        expandCollapse()
    }
}

// MARK: - Previews
// Developmental only
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VDisclosureGroup_Previews: PreviewProvider {
    // Configuration
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var dynamicTypeSize: DynamicTypeSize? { nil }
    private static var colorScheme: ColorScheme { .light }
    
    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            StatesPreview().previewDisplayName("States")
            InsettedContentPreview().previewDisplayName("Insetted Content")
        })
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
        .preferredColorScheme(colorScheme)
    }
    
    // Data
    private static var headerTitle: String { "Lorem Ipsum".pseudoRTL(languageDirection) }
    
    private static func content() -> some View {
        ColorBook.accentBlue
            .frame(height: 100)
    }
    
    // Previews (Scenes)
    private struct Preview: View {
        @State private var state: VDisclosureGroupState = .expanded
        
        var body: some View {
            PreviewContainer(hasLayer: false, content: {
                VDisclosureGroup(
                    state: $state,
                    headerTitle: headerTitle,
                    content: content
                )
                .padding()
            })
        }
    }
    
    private struct StatesPreview: View {
        var body: some View {
            PreviewContainer(hasLayer: false, content: {
                PreviewRow(
                    axis: .vertical,
                    title: "Collapsed",
                    content: {
                        VDisclosureGroup(
                            state: .constant(.collapsed),
                            headerTitle: headerTitle,
                            content: content
                        )
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    title: "Expanded",
                    content: {
                        VDisclosureGroup(
                            state: .constant(.expanded),
                            headerTitle: headerTitle,
                            content: content
                        )
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    title: "Pressed (Button)",
                    content: {
                        VDisclosureGroup(
                            uiModel: {
                                var uiModel: VDisclosureGroupUIModel = .init()
                                uiModel.disclosureButtonSubUIModel.backgroundColors.enabled = uiModel.disclosureButtonSubUIModel.backgroundColors.pressed
                                uiModel.disclosureButtonSubUIModel.iconColors.enabled = uiModel.disclosureButtonSubUIModel.iconColors.pressed
                                return uiModel
                            }(),
                            state: .constant(.collapsed),
                            headerTitle: headerTitle,
                            content: content
                        )
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    title: "Disabled",
                    content: {
                        VDisclosureGroup(
                            uiModel: { // Needed for some reason
                                var uiModel: VDisclosureGroupUIModel = .init()
                                uiModel.disclosureButtonSubUIModel.backgroundColors.enabled = uiModel.disclosureButtonSubUIModel.backgroundColors.disabled
                                uiModel.disclosureButtonSubUIModel.iconColors.enabled = uiModel.disclosureButtonSubUIModel.iconColors.disabled
                                return uiModel
                            }(),
                            state: .constant(.expanded),
                            headerTitle: headerTitle,
                            content: content
                        )
                        .disabled(true)
                    }
                )
            })
        }
    }
    
    private struct InsettedContentPreview: View {
        var body: some View {
            PreviewContainer(hasLayer: false, content: {
                PreviewRow(
                    axis: .vertical,
                    title: "Insetted Content",
                    content: {
                        VDisclosureGroup(
                            uiModel: .insettedContent,
                            state: .constant(.expanded),
                            headerTitle: headerTitle,
                            content: content
                        )
                    }
                )
            })
        }
    }
}
