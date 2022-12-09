//
//  File.swift
//  
//
//  Created by Jon on 16/11/2022.
//

import Foundation
import SwiftUI

public class ComponentDimensions {
    
    public let backGroundWidth : CGFloat = 375
    public let backGroundHeight : CGFloat = 647
    
    //============== Y SLIDER SECTION =======================
    public let ui_Unit_Width : CGFloat = 30
    public let ui_Unit_Height : CGFloat = 30
    
    public let pattern_Grid_Unit_Width : CGFloat = 16
    public let pattern_Grid_Unit_Height : CGFloat = 16
    
    public let pattern_Grid_Unit_VerticalEdge_Width : CGFloat = 1
    public let pattern_Grid_Unit_HorzEdge_Width : CGFloat = 1
    
    public let dataGrid_X_Unit_Count : Int = 16
    public let DATA_final_Line_Y_Index : Int = 64
    
    public let visualGrid_Y_Unit_Count : Int = 16
    public let visualGrid_X_Unit_Count : Int = 16
    
    public let cellFontSize : CGFloat = 12
    //============== CURSOR SECTION =========================
    public var Horz_Cursor_Slider_Width : CGFloat = 300
    public var Horz_Cursor_Slider_Height : CGFloat = 30
    
    public var Horz_Cursor_Slider_Line_Height : CGFloat = 300
    public var Horz_Cursor_Slider_Line_Width : CGFloat = 1
    
    public let Vert_Cursor_Slider_Width : CGFloat = 30
    public let Vert_Cursor_Slider_Height : CGFloat = 300
    
    public let Vert_Cursor_Slider_Line_Height : CGFloat = 1
    public let Vert_Cursor_Slider_Line_Width : CGFloat = 300
    
    public static let StaticDimensions = ComponentDimensions()
}

public class ComponentColors {
    public var cursorSwiperColor : Color = Color(red:0.5,green:1,blue:0)
    public var cursorSliderLineColor : Color = Color(red:0.5,green:1,blue:0)
    
    public var cursorNotWriting : Color = Color(red:0.4,green:0.8,blue:0)
    public var cursorWriting : Color = Color(red:0.5,green:1,blue:0)
    
    public var potentialColor : Color = Color(red: 0, green: 1, blue: 1)
    
    public var writeButtonColor : Color = Color(red: 0, green: 0.6, blue: 0)
    public var writeButtonFontColor : Color = Color(red: 1, green: 1, blue: 1)
    
    public static let StaticColors = ComponentColors()
}
