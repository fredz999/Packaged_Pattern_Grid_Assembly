//
//  File.swift
//  
//
//  Created by Jon on 17/11/2022.
//

import Foundation
import SwiftUI

public struct Default_Horizontal_Slider_View : View {
    let dimensions = ComponentDimensions.StaticDimensions
    @ObservedObject var cursor_Horizontal_Slider_Store : Cursor_Horizontal_Slider_Store
    public var body: some View {
        return ZStack(alignment: .topLeading) {
//            cursor_Horizontal_Slider_Store.slider_View
//            cursor_Horizontal_Slider_Store.slider_Line_View.offset(x:cursor_Horizontal_Slider_Store.computedLineDisplacement,y:dimensions.pattern_Grid_Unit_Height)
            Default_H_Slider()
            Default_H_Slider_Line().offset(x:cursor_Horizontal_Slider_Store.computedLineDisplacement,y:dimensions.pattern_Grid_Unit_Height)
        }.gesture(cursor_Horizontal_Slider_Store.slideDragGesture)
    }
}

public struct Default_H_Slider : View {
    let dimensions = ComponentDimensions.StaticDimensions
    let colors = ComponentColors.StaticColors
    public var body : some View {
        Rectangle().frame(width: dimensions.Horz_Cursor_Slider_Width,height: dimensions.Horz_Cursor_Slider_Height)
        .foregroundColor(colors.cursorSwiperColor)
    }
}

public struct Default_H_Slider_Line : View {
    let dimensions = ComponentDimensions.StaticDimensions
    let colors = ComponentColors.StaticColors
    public var body : some View {
        Rectangle().frame(width: dimensions.Horz_Cursor_Slider_Line_Width,height: dimensions.Horz_Cursor_Slider_Line_Height)
        .foregroundColor(colors.cursorSliderLineColor)
    }
}
