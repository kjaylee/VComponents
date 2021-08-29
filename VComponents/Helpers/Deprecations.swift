//
//  Deprecations.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/12/21.
//

import SwiftUI

// MARK:- V Web Link
@available(*, deprecated, renamed: "VWebLink")
public typealias VLink = VWebLink

@available(*, deprecated, renamed: "VWebLinkPreset")
public typealias VLinkPreset = VWebLinkPreset

@available(*, deprecated, renamed: "VWebLinkState")
public typealias VLinkState = VWebLinkState

// MARK:- V Navigation View
extension VNavigationViewModel.Colors {
    @available(*, deprecated, renamed: "bar")
    public var background: Color {
        get { bar }
        set { bar = newValue }
    }
}

// MARK:- V List
@available(*, deprecated, renamed: "VList")
public typealias VSection = VList

@available(*, deprecated, renamed: "VListLayoutType")
public typealias VSectionLayoutType = VListLayoutType

@available(*, deprecated, renamed: "VListModel")
public typealias VSectionModel = VListModel

// MARK:- V Section List
@available(*, deprecated, renamed: "VSectionList")
public typealias VTable = VSectionList

@available(*, deprecated, renamed: "VSectionListLayoutType")
public typealias VTableLayoutType = VSectionListLayoutType

@available(*, deprecated, renamed: "VSectionListModel")
public typealias VTableModel = VSectionListModel

@available(*, deprecated, renamed: "VSectionListSectionViewModelable")
public typealias VTableSection = VSectionListSectionViewModelable

@available(*, deprecated, renamed: "VSectionListRowViewModelable")
public typealias VTableRow = VSectionListRowViewModelable

@available(*, deprecated, renamed: "VSectionListSectionViewModelable")
public typealias VSectionListSection = VSectionListSectionViewModelable

@available(*, deprecated, renamed: "VSectionListRowViewModelable")
public typealias VSectionListRow = VSectionListRowViewModelable

// MARK:- V Lazy Scroll View
@available(*, deprecated, renamed: "VLazyScrollView")
public typealias VLazyList = VLazyScrollView

@available(*, deprecated, renamed: "VLazyScrollViewType")
public typealias VLazyListType = VLazyScrollViewType

@available(*, deprecated, renamed: "VLazyScrollViewModelVertical")
public typealias VLazyListModelVertical = VLazyScrollViewModelVertical

@available(*, deprecated, renamed: "VLazyScrollViewModelHorizontal")
public typealias VLazyListModelHorizontal = VLazyScrollViewModelHorizontal
