//
//  File.swift
//  
//
//  Created by Jon on 16/11/2022.
//

import Foundation
import SwiftUI

public class ComponentDimensions : ObservableObject {
    
    public let backGroundWidth : CGFloat = 375
    public let backGroundHeight : CGFloat = 647
    
    public var ui_Unit_Width : CGFloat = 24
    public var ui_Unit_Height : CGFloat = 16
    
    public let pattern_Grid_Unit_VerticalEdge_Width : CGFloat = 1
    public let pattern_Grid_Unit_HorzEdge_Width : CGFloat = 1
    
    //============== Central Grid SECTION =========================
    public let DATA_final_Line_Y_Index : Int = 64
    
    @Published public var pattern_Grid_Sub_Cell_Width : CGFloat = 8
    @Published public var pattern_Grid_Cell_Sub_Unit_Count : Int = 2
    
    //@Published public var pattern_Grid_Unit_Width : CGFloat = 24  // 24 or 16
    @Published public var pattern_Grid_Unit_Width : CGFloat = 16
    @Published public var pattern_Grid_Unit_Height : CGFloat = 16 // 24 or 16
    
    @Published public var dataGrid_X_Unit_Count : Int = 48
    public let visualGrid_Y_Unit_Count : Int = 12
    
    public let cellFontSize : CGFloat = 12
    //============== CURSOR SECTION =========================
    public var Horz_Cursor_Slider_Width : CGFloat = 384
    public var Horz_Cursor_Slider_Height : CGFloat = 24
    
    public var Horz_Cursor_Slider_Line_Height : CGFloat = 384
    public var Horz_Cursor_Slider_Line_Width : CGFloat = 1
    
    public let Vert_Cursor_Slider_Width : CGFloat = 24
    public let Vert_Cursor_Slider_Height : CGFloat = 192 // this has to be sought from function (num y grid units-1 * grid unit height)
    
    public let Vert_Cursor_Slider_Line_Height : CGFloat = 1
    public let Vert_Cursor_Slider_Line_Width : CGFloat = 384
    
    public func return_H_Slider_Y_Offset() -> CGFloat{
        let retval = (pattern_Grid_Unit_Height*CGFloat(visualGrid_Y_Unit_Count)) + ui_Unit_Height
        return retval
    }
    
    public func return_V_Slider_Offset()->CGSize{
        let width = pattern_Grid_Unit_Width*CGFloat(dataGrid_X_Unit_Count)
        let height = ui_Unit_Height
        let returnSize = CGSize(width: width, height: height)
        return returnSize
    }
    
    public var patternTimingConfiguration : E_CentralGridTiming = .fourFour

    public func flip_Timing_Signature(){
    let count48 = pattern_Grid_Cell_Sub_Unit_Count * Central_State.Static_Central_State.currentXCursor_Slider_Position
    print("b4 change unit_Count: ",pattern_Grid_Cell_Sub_Unit_Count,"48 pos: ",count48.description)
    if patternTimingConfiguration == .fourFour {
        patternTimingConfiguration = .sixEight
        pattern_Grid_Cell_Sub_Unit_Count = 3
        pattern_Grid_Unit_Width = 24
        // TODO: eval cursor position
    }
    else if patternTimingConfiguration == .sixEight {
        patternTimingConfiguration = .fourFour
        pattern_Grid_Cell_Sub_Unit_Count = 2
        pattern_Grid_Unit_Width = 16
    }
    let count482 = pattern_Grid_Cell_Sub_Unit_Count * Central_State.Static_Central_State.currentXCursor_Slider_Position
    print("after change unit_Count: ",pattern_Grid_Cell_Sub_Unit_Count,"48 pos: ",count482.description)
        
    //let currFourEight = Central_State.Static_Central_State.currentXCursor_Slider_Position * pattern_Grid_Cell_Sub_Unit_Count
//    print("currX: ",Central_State.Static_Central_State.currentXCursor_Slider_Position.description
//          ,", number of the 48 cells im over: ",currFourEight.description
//          ,", sub unit count: ",pattern_Grid_Cell_Sub_Unit_Count.description)

    }
    
    
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
