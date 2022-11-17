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
            //            cursor_Vertical_Slider_Store.slider_View
            //            cursor_Vertical_Slider_Store.slider_Line_View.offset(x:-dimensions.Horz_Cursor_Slider_Width, y:cursor_Vertical_Slider_Store.computedLineDisplacement)
            Default_V_Slider()
            Default_V_Slider_Line()
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
