//
//  VSegmentedPicker.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/7/21.
//

import SwiftUI

// MARK:- V Segmented Picker
/// Item picker component that selects from a set of mutually exclusive values, and displays their representative content horizontally
///
/// Component ca be initialized with data, VPickableItem, or VPickableTitledItem
///
/// Model, state, title, subtitle, and disabled indexes can be passed as parameters
///
/// # Usage Example #
///
/// ```
/// enum PickerRow: Int, CaseIterable, VPickableTitledItem {
///     case red, green, blue
///
///     var pickerTitle: String {
///         switch self {
///         case .red: return "Red"
///         case .green: return "Green"
///         case .blue: return "Blue"
///         }
///     }
/// }
///
/// @State var selection: PickerRow = .red
///
/// var body: some View {
///     VSegmentedPicker(selection: $selection)
/// }
/// ```
///
public struct VSegmentedPicker<Data, Content>: View
    where
        Data: RandomAccessCollection,
        Data.Index == Int,
        Content: View
{
    // MARK: Properties
    private let model: VSegmentedPickerModel
    
    @Binding private var selectedIndex: Int
    
    private let state: VSegmentedPickerState
    @State private var pressedIndex: Int? = nil
    private func rowState(for index: Int) -> VSegmentedPickerRowState { .init(
        isEnabled: state.isEnabled && !disabledIndexes.contains(index),
        isPressed: pressedIndex == index
    ) }
    
    private let title: String?
    private let subtitle: String?
    private let disabledIndexes: Set<Int>
    
    private let data: Data
    private let content: (Data.Element) -> Content
    
    @State private var rowWidth: CGFloat = .zero
    
    // MARK: Initializers
    public init(
        model: VSegmentedPickerModel = .init(),
        selectedIndex: Binding<Int>,
        state: VSegmentedPickerState = .enabled,
        title: String? = nil,
        subtitle: String? = nil,
        disabledIndexes: Set<Int> = .init(),
        data: Data,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.model = model
        self._selectedIndex = selectedIndex
        self.state = state
        self.title = title
        self.subtitle = subtitle
        self.disabledIndexes = disabledIndexes
        self.data = data
        self.content = content
    }

    public init(
        model: VSegmentedPickerModel = .init(),
        selectedIndex: Binding<Int>,
        state: VSegmentedPickerState = .enabled,
        title: String? = nil,
        subtitle: String? = nil,
        disabledIndexes: Set<Int> = .init(),
        titles: [String]
    )
        where
            Data == Array<String>,
            Content == VBaseTitle
    {
        self.init(
            model: model,
            selectedIndex: selectedIndex,
            state: state,
            title: title,
            subtitle: subtitle,
            disabledIndexes: disabledIndexes,
            data: titles,
            content: { title in
                VBaseTitle(
                    title: title,
                    color: model.colors.textColor(for: state),
                    font: model.fonts.rows,
                    type: .oneLine
                )
            }
        )
    }

    public init<Item>(
        model: VSegmentedPickerModel = .init(),
        selection: Binding<Item>,
        state: VSegmentedPickerState = .enabled,
        title: String? = nil,
        subtitle: String? = nil,
        disabledItems: Set<Item> = .init(),
        @ViewBuilder content: @escaping (Item) -> Content
    )
        where
            Data == Array<Item>,
            Item: VPickableItem
    {
        self.init(
            model: model,
            selectedIndex: .init(
                get: { selection.wrappedValue.rawValue },
                set: { selection.wrappedValue = Item(rawValue: $0)! }
            ),
            state: state,
            title: title,
            subtitle: subtitle,
            disabledIndexes: .init(disabledItems.map { $0.rawValue }),
            data: .init(Item.allCases),
            content: content
        )
    }

    public init<Item>(
        model: VSegmentedPickerModel = .init(),
        selection: Binding<Item>,
        state: VSegmentedPickerState = .enabled,
        title: String? = nil,
        subtitle: String? = nil,
        disabledItems: Set<Item> = .init()
    )
        where
            Data == Array<Item>,
            Content == VBaseTitle,
            Item: VPickableTitledItem
    {
        self.init(
            model: model,
            selectedIndex: .init(
                get: { selection.wrappedValue.rawValue },
                set: { selection.wrappedValue = Item(rawValue: $0)! }
            ),
            state: state,
            title: title,
            subtitle: subtitle,
            disabledIndexes: .init(disabledItems.map { $0.rawValue }),
            data: .init(Item.allCases),
            content: { item in
                VBaseTitle(
                    title: item.pickerTitle,
                    color: model.colors.textColor(for: state),
                    font: model.fonts.rows,
                    type: .oneLine
                )
            }
        )
    }
}

// MARK:- Body
extension VSegmentedPicker {
    public var body: some View {
        VStack(alignment: .leading, spacing: model.layout.titleSpacing, content: {
            titleView
            pickerView
            subtitleView
        })
    }
    
    private var pickerView: some View {
        ZStack(alignment: .leading, content: {
            background
            indicator
            rows
            dividers
        })
            .frame(height: model.layout.height)
            .cornerRadius(model.layout.cornerRadius)
    }
    
    @ViewBuilder private var titleView: some View {
        if let title = title, !title.isEmpty {
            VBaseTitle(
                title: title,
                color: model.colors.titleColor(for: state),
                font: model.fonts.title,
                type: .oneLine
            )
                .padding(.horizontal, model.layout.titlePaddingHor)
                .opacity(model.colors.foregroundOpacity(state: state))
        }
    }
    
    @ViewBuilder private var subtitleView: some View {
        if let subtitle = subtitle, !subtitle.isEmpty {
            VBaseTitle(
                title: subtitle,
                color: model.colors.subtitleColor(for: state),
                font: model.fonts.subtitle,
                type: .multiLine(limit: nil, alignment: .leading)
            )
                .padding(.horizontal, model.layout.titlePaddingHor)
                .opacity(model.colors.foregroundOpacity(state: state))
        }
    }
    
    private var background: some View {
        model.colors.backgroundColor(for: state)
    }
    
    private var indicator: some View {
        RoundedRectangle(cornerRadius: model.layout.indicatorCornerRadius)
            .padding(model.layout.indicatorMargin)
            .frame(width: rowWidth)
            .scaleEffect(indicatorScale)
            .offset(x: rowWidth * .init(selectedIndex))
            .animation(model.animation)
            
            .foregroundColor(model.colors.indicatorColor(for: state))
            .shadow(
                color: model.colors.indicatorShadowColor(for: state),
                radius: model.layout.indicatorShadowRadius,
                y: model.layout.indicatorShadowOffsetY
            )
    }
    
    private var rows: some View {
        HStack(spacing: 0, content: {
            ForEach(0..<data.count, content: { i in
                VBaseButton(
                    isEnabled: state.isEnabled && !disabledIndexes.contains(i),
                    action: { selectedIndex = i },
                    onPress: { pressedIndex = $0 ? i : nil },
                    content: {
                        content(data[i])
                            .padding(model.layout.actualRowContentMargin)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)

                            .font(model.fonts.rows)
                            .opacity(foregroundOpacity(for: i))

                            .readSize(onChange: { rowWidth = $0.width })
                    }
                )
            })
        })
    }
    
    private var dividers: some View {
        HStack(spacing: 0, content: {
            ForEach(0..<data.count, content: { i in
                Spacer()

                if i <= data.count-2 {
                    Divider()
                        .opacity(dividerOpacity(for: i))
                        .frame(height: model.layout.dividerHeight)
                }
            })
        })
    }
}

// MARK:- State Indication
private extension VSegmentedPicker {
    var indicatorScale: CGFloat {
        switch selectedIndex {
        case pressedIndex: return model.layout.indicatorPressedScale
        case _: return 1
        }
    }
    
    func foregroundOpacity(for index: Int) -> Double {
        model.colors.foregroundOpacity(state: rowState(for: index))
    }
    
    func dividerOpacity(for index: Int) -> Double {
        let isBeforeIndicator: Bool = index < selectedIndex
        
        switch isBeforeIndicator {
        case false: return index - selectedIndex < 1 ? 0 : 1
        case true: return selectedIndex - index <= 1 ? 0 : 1
        }
    }
}

// MARK:- Preview
struct VSegmentedPicker_Previews: PreviewProvider {
    @State private static var selection: Items = .one
    private enum Items: Int, CaseIterable, VPickableTitledItem {
        case one
        case two
        case three

        var pickerTitle: String {
            switch self {
            case .one: return "One"
            case .two: return "Two"
            case .three: return "Three"
            }
        }
    }

    static var previews: some View {
        VSegmentedPicker(selection: $selection)
            .padding(20)
    }
}
