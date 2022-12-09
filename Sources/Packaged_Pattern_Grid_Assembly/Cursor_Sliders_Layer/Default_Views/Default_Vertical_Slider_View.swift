//
//  File.swift
//  
//
//  Created by Jon on 17/11/2022.
//

import Foundation
import SwiftUI

public struct Default_Vertical_Slider_View : View {
    let dimensions = ComponentDimensions.StaticDimensions
    let colors = ComponentColors.StaticColors
    @ObservedObject var cursor_Vertical_Slider_Store : Cursor_Vertical_Slider_Store
    public var body: some View {
        return ZStack(alignment: .topLeading) {
            Default_V_Slider() //.offset(x: 0,y: 0)//y:dimensions.Horz_Cursor_Slider_Height)
            Default_V_Slider_Line().offset(x:-dimensions.Horz_Cursor_Slider_Width, y: 50)//dimensions.Horz_Cursor_Slider_Height)
        }.gesture(cursor_Vertical_Slider_Store.slideDragGesture)
    }
}

public struct Default_V_Slider : View {
    let dimensions = ComponentDimensions.StaticDimensions
    let colors = ComponentColors.StaticColors
    public var body : some View {
        Rectangle().frame(width: dimensions.Vert_Cursor_Slider_Width,height: dimensions.Vert_Cursor_Slider_Height)
        .foregroundColor(colors.cursorSwiperColor)
    }
}

public struct Default_V_Slider_Line : View {
    let dimensions = ComponentDimensions.StaticDimensions
    let colors = ComponentColors.StaticColors
    public var body : some View {
        Rectangle().frame(width: dimensions.Vert_Cursor_Slider_Line_Width,height: dimensions.Vert_Cursor_Slider_Line_Height)
        .foregroundColor(colors.cursorSliderLineColor)
    }
}
