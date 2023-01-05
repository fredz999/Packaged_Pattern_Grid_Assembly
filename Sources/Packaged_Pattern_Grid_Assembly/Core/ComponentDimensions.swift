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
    
    
    public var slider_Width : CGFloat = 36
    public var ui_Unit_Width : CGFloat = 24
    public var ui_Unit_Height : CGFloat = 16
    
    public let pattern_Grid_Unit_VerticalEdge_Width : CGFloat = 1
    public let pattern_Grid_Unit_HorzEdge_Width : CGFloat = 1
    
    //============== Central Grid SECTION =========================
    public let DATA_final_Line_Y_Index : Int = 64
    
    @Published public var pattern_Grid_Sub_Cell_Width : CGFloat = 8
    @Published public var pattern_Grid_Cell_Sub_Unit_Count : Int = 2
    
    @Published public var curr_cursor_X_Offset : CGFloat = 0
    @Published public var cursor_X_Jump : CGFloat = 16
    @Published public var cursor_Y_Jump : CGFloat = 16
    @Published public var pattern_Grid_Unit_Width : CGFloat = 8
    @Published public var pattern_Grid_Unit_Height : CGFloat = 16 // 24 or 16
    var cellArray_Write_Addition : Int = 1
    

    
    var initial_Right_Boundary : CGFloat = 368
    public var current_Rightward_Boundary : CGFloat = 368
    
    public func set_Current_Rightward_Boundary(newRightBoundary:Int){
        let newRightBoundaryFloat = cursor_X_Jump*CGFloat(newRightBoundary)
        current_Rightward_Boundary = newRightBoundaryFloat
    }
    
    var initial_Left_Boundary : CGFloat = 0
    public var current_Leftward_Boundary : CGFloat = 0
    
    public func set_Current_Leftward_Boundary(newLeftBoundary:Int){
        let newLeftBoundaryFloat = cursor_X_Jump*CGFloat(newLeftBoundary)
        current_Leftward_Boundary = newLeftBoundaryFloat
    }
    
    @Published public var dataGrid_X_Unit_Count : Int = 48
    public let visualGrid_Y_Unit_Count : Int = 12
    
    public let cellFontSize : CGFloat = 12
    //============== CURSOR SECTION =========================
    public var Horz_Cursor_Slider_Width : CGFloat = 384
    public var Horz_Cursor_Slider_Height : CGFloat = 36
    
    public var Horz_Cursor_Slider_Line_Height : CGFloat = 384
    public var Horz_Cursor_Slider_Line_Width : CGFloat = 1
    
    public let Vert_Cursor_Slider_Width : CGFloat = 36
    public let Vert_Cursor_Slider_Height : CGFloat = 192
    
    public let Vert_Cursor_Slider_Line_Height : CGFloat = 4
    public let Vert_Cursor_Slider_Line_Width : CGFloat = 384
    
    public func return_H_Slider_Y_Offset() -> CGFloat{
        let retval = (pattern_Grid_Unit_Height*CGFloat(visualGrid_Y_Unit_Count)) + ui_Unit_Height
        return retval
    }
    
    public func return_V_Slider_Offset() -> CGSize {
        let width = pattern_Grid_Unit_Width*CGFloat(dataGrid_X_Unit_Count)
        let height = ui_Unit_Height
        let returnSize = CGSize(width: width, height: height)
        return returnSize
    }
    
    public var patternTimingConfiguration : E_CentralGridTiming = .sixEight
    
    public func flip_Timing_Signature(){
        if patternTimingConfiguration == .fourFour {
            patternTimingConfiguration = .sixEight
            pattern_Grid_Cell_Sub_Unit_Count = 2
            cursor_X_Jump = 8
            cellArray_Write_Addition = 1
        }
        else if patternTimingConfiguration == .sixEight {
            patternTimingConfiguration = .fourFour
            pattern_Grid_Cell_Sub_Unit_Count = 3
            cursor_X_Jump = 24
            cellArray_Write_Addition = 2
        }
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
