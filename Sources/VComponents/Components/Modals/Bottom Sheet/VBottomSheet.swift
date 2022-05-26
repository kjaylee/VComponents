//
//  VBottomSheet.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/21/21.
//

import SwiftUI
import VCore

// MARK: - V Bottom Sheet
struct VBottomSheet<HeaderLabel, Content>: View
    where
        HeaderLabel: View,
        Content: View
{
    // MARK: Properties
    @Environment(\.presentationHostPresentationMode) private var presentationMode: PresentationHostPresentationMode
    @StateObject private var interfaceOrientationChangeObserver: InterfaceOrientationChangeObserver = .init()
    
    private let model: VBottomSheetModel
    
    private let presentHandler: (() -> Void)?
    private let dismissHandler: (() -> Void)?
    
    private let headerLabel: VBottomSheetHeaderLabel<HeaderLabel>
    private let content: () -> Content
    
    private var hasHeader: Bool { headerLabel.hasLabel || model.misc.dismissType.hasButton }
    private var hasGrabber: Bool { model.misc.dismissType.contains(.pullDown) || model.layout.sizes._current.size.heights.isResizable }
    private var hasDivider: Bool { hasHeader && model.layout.dividerHeight > 0 }
    
    @State private var isInternallyPresented: Bool = false
    
    @State private var grabberDividerHeight: CGFloat = 0
    @State private var offset: CGFloat
    @State private var offsetBeforeDrag: CGFloat? // Used for adding to translation
    @State private var currentDragValue: DragGesture.Value? // Used for storing "last" value for writing in `previousDragValue`. Equals to `dragValue` in methods.
    @State private var previousDragValue: DragGesture.Value? // Used for calculating velocity

    // MARK: Initializers
    init(
        model: VBottomSheetModel,
        onPresent presentHandler: (() -> Void)?,
        onDismiss dismissHandler: (() -> Void)?,
        headerLabel: VBottomSheetHeaderLabel<HeaderLabel>,
        content: @escaping () -> Content
    ) {
        self.model = model
        self.presentHandler = presentHandler
        self.dismissHandler = dismissHandler
        self.headerLabel = headerLabel
        self.content = content
        
        _offset = .init(initialValue: model.layout.sizes._current.size.heights.idealOffset)
    }

    // MARK: Body
    var body: some View {
        ZStack(content: {
            dimmingView
            bottomSheet
        })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.container, edges: .all)
            .onAppear(perform: animateIn)
            .onChange(
                of: presentationMode.isExternallyDismissed,
                perform: { if $0 && isInternallyPresented { animateOutFromExternalDismiss() } }
            )
            .onChange(of: interfaceOrientationChangeObserver.orientation, perform: { _ in resetHeightFromOrientationChange() })
    }
    
    private var dimmingView: some View {
        model.colors.dimmingView
            .ignoresSafeArea()
            .onTapGesture(perform: {
                if model.misc.dismissType.contains(.backTap) { animateOut() }
            })
    }
    
    private var bottomSheet: some View {
        ZStack(content: {
            VSheet(model: model.sheetModel)
                .shadow(
                    color: model.colors.shadow,
                    radius: model.colors.shadowRadius,
                    x: model.colors.shadowOffset.width,
                    y: model.colors.shadowOffset.height
                )
                .if(!model.misc.isContentDraggable, transform: { // NOTE: Frame must come before DragGesture
                    $0
                        .frame(height: model.layout.sizes._current.size.heights.max)
                        .offset(y: isInternallyPresented ? offset : model.layout.sizes._current.size.heights.hiddenOffset)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged(dragChanged)
                                .onEnded(dragEnded)
                        )
                })
                    
            VStack(spacing: 0, content: {
                VStack(spacing: 0, content: {
                    grabber
                    header
                    divider
                })
                    .readSize(onChange: { grabberDividerHeight = $0.height })

                contentView
            })
                .frame(maxHeight: .infinity, alignment: .top)
                .if(!model.misc.isContentDraggable, transform: { // NOTE: Frame must come before DragGesture
                    $0
                        .frame(height: model.layout.sizes._current.size.heights.max)
                        .offset(y: isInternallyPresented ? offset : model.layout.sizes._current.size.heights.hiddenOffset)
                })
        })
            .frame(width: model.layout.sizes._current.size.width)
            .if(model.misc.isContentDraggable, transform: {  // NOTE: Frame must come before DragGesture
                $0
                    .frame(height: model.layout.sizes._current.size.heights.max)
                    .offset(y: isInternallyPresented ? offset : model.layout.sizes._current.size.heights.hiddenOffset)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged(dragChanged)
                            .onEnded(dragEnded)
                    )
            })
            .ignoresSafeArea(.container, edges: .all)
            .ignoresSafeArea(.keyboard, edges: model.layout.ignoredKeybordSafeAreaEdges)
    }

    @ViewBuilder private var grabber: some View {
        if hasGrabber {
            RoundedRectangle(cornerRadius: model.layout.grabberCornerRadius)
                .frame(size: model.layout.grabberSize)
                .padding(model.layout.grabberMargins)
                .foregroundColor(model.colors.grabber)
        }
    }

    @ViewBuilder private var header: some View {
        if hasHeader {
            HStack(alignment: model.layout.headerAlignment, spacing: model.layout.labelCloseButtonSpacing, content: {
                Group(content: {
                    if model.misc.dismissType.contains(.leadingButton) {
                        closeButton
                    } else if model.misc.dismissType.contains(.trailingButton) {
                        closeButtonCompensator
                    }
                })
                    .frame(maxWidth: .infinity, alignment: .leading)

                Group(content: {
                    switch headerLabel {
                    case .empty:
                        EmptyView()
                        
                    case .title(let title):
                        VText(
                            color: model.colors.headerTitle,
                            font: model.fonts.header,
                            text: title
                        )
                        
                    case .custom(let label):
                        label()
                    }
                })
                    .layoutPriority(1)

                Group(content: {
                    if model.misc.dismissType.contains(.trailingButton) {
                        closeButton
                    } else if model.misc.dismissType.contains(.leadingButton) {
                        closeButtonCompensator
                    }
                })
                    .frame(maxWidth: .infinity, alignment: .trailing)
            })
                .padding(model.layout.headerMargins)
        }
    }

    @ViewBuilder private var divider: some View {
        if hasDivider {
            Rectangle()
                .frame(height: model.layout.dividerHeight)
                .padding(model.layout.dividerMargins)
                .foregroundColor(model.colors.divider)
        }
    }

    private var contentView: some View {
        ZStack(content: {
            if !model.misc.isContentDraggable {
                Color.clear
                    .contentShape(Rectangle())
            }
            
            content()
                .padding(model.layout.contentMargins)
        })
            .safeAreaMarginInsets(edges: model.layout.contentSafeAreaEdges)
            .frame(maxWidth: .infinity)
            .if(
                model.layout.autoresizesContent,
                ifTransform: { $0.frame(height: model.layout.sizes._current.size.heights.max - offset - grabberDividerHeight) },
                elseTransform: { $0.frame(maxHeight: .infinity) }
            )
    }

    private var closeButton: some View {
        VSquareButton.close(
            model: model.closeButtonSubModel,
            action: animateOut
        )
    }
    
    private var closeButtonCompensator: some View {
        Spacer()
            .frame(width: model.layout.closeButtonDimension)
    }

    // MARK: Animation
    private func animateIn() {
        withBasicAnimation(
            model.animations.appear,
            body: { isInternallyPresented = true },
            completion: {
                DispatchQueue.main.async(execute: { presentHandler?() })
            }
        )
    }

    private func animateOut() {
        withBasicAnimation(
            model.animations.disappear,
            body: { isInternallyPresented = false },
            completion: {
                presentationMode.dismiss()
                DispatchQueue.main.async(execute: { dismissHandler?() })
            }
        )
    }

    private func animateOutFromDrag() {
        withBasicAnimation(
            model.animations.pullDownDismiss,
            body: { isInternallyPresented = false },
            completion: {
                presentationMode.dismiss()
                DispatchQueue.main.async(execute: { dismissHandler?() })
            }
        )
    }
    
    private func animateOutFromExternalDismiss() {
        withBasicAnimation(
            model.animations.disappear,
            body: { isInternallyPresented = false },
            completion: {
                presentationMode.externalDismissCompletion()
                DispatchQueue.main.async(execute: { dismissHandler?() })
            }
        )
    }

    // MARK: Gestures
    private func dragChanged(dragValue: DragGesture.Value) {
        if offsetBeforeDrag == nil { offsetBeforeDrag = offset }
        guard let offsetBeforeDrag = offsetBeforeDrag else { fatalError() }
        
        previousDragValue = currentDragValue
        currentDragValue = dragValue
        
        let newOffset: CGFloat = offsetBeforeDrag + dragValue.translation.height

        withAnimation(.linear(duration: 0.1), { // Gets rid of stuttering
            offset = {
                switch newOffset {
                case ...model.layout.sizes._current.size.heights.maxOffset:
                    return model.layout.sizes._current.size.heights.maxOffset
                    
                case model.layout.sizes._current.size.heights.minOffset...:
                    switch model.misc.dismissType.contains(.pullDown) {
                    case false: return model.layout.sizes._current.size.heights.minOffset
                    case true: return newOffset
                    }
                    
                default:
                    return newOffset
                }
            }()
        })
    }

    private func dragEnded(dragValue: DragGesture.Value) {
        defer {
            offsetBeforeDrag = nil
            previousDragValue = nil
            currentDragValue = nil
        }
        
        let velocityExceedsNextAreaSnapThreshold: Bool =
            abs(dragValue.velocity(inRelationTo: previousDragValue).height) >=
            abs(model.layout.velocityToSnapToNextHeight)
        
        switch velocityExceedsNextAreaSnapThreshold {
        case false:
            guard let offsetBeforeDrag = offsetBeforeDrag else { return }
            
            animateOffsetOrPullDismissFromSnapAction(.dragEndedSnapAction(
                heights: model.layout.sizes._current.size.heights,
                canPullDownToDismiss: model.misc.dismissType.contains(.pullDown),
                pullDownDismissDistance: model.layout.pullDownDismissDistance,
                offset: offset,
                offsetBeforeDrag: offsetBeforeDrag,
                translation: dragValue.translation.height
            ))
            
        case true:
            animateOffsetOrPullDismissFromSnapAction(.dragEndedHighVelocitySnapAction(
                heights: model.layout.sizes._current.size.heights,
                offset: offset,
                velocity: dragValue.velocity(inRelationTo: previousDragValue).height
            ))
        }
    }
    
    private func animateOffsetOrPullDismissFromSnapAction(_ snapAction: VBottomSheetSnapAction) {
        switch snapAction {
        case .dismiss: animateOutFromDrag()
        case .snap(let newOffset): withAnimation(model.animations.heightSnap, { offset = newOffset })
        }
    }
    
    // MARK: Orientation
    private func resetHeightFromOrientationChange() {
        offset = model.layout.sizes._current.size.heights.idealOffset
    }
}

// MARK: - Preview
struct VBottomSheet_Previews: PreviewProvider {
    @State static var isPresented: Bool = true

    static var previews: some View {
        VPlainButton(
            action: { /*isPresented = true*/ },
            title: "Present"
        )
            .vBottomSheet(
                model: {
                    var model: VBottomSheetModel = .init()
                    model.layout.autoresizesContent = true
                    model.layout.contentSafeAreaEdges.insert(.bottom)
                    return model
                }(),
                isPresented: $isPresented,
                headerTitle: "Lorem Ipsum Dolor Sit Amet",
                content: {
                    VList(data: 0..<20, content: { num in
                        Text(String(num))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    })
                }
            )
    }
}
