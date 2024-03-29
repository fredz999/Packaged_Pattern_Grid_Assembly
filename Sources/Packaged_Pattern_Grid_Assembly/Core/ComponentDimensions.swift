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
    
    public var data_Y_Slider_Cell_Overlay_Width : CGFloat = 72
    public var ui_Unit_Width : CGFloat = 24
    public var ui_Unit_Height : CGFloat = 16
    
    public let pattern_Grid_Unit_VerticalEdge_Width : CGFloat = 1
    public let pattern_Grid_Unit_HorzEdge_Width : CGFloat = 1
    
    public let cursor_Horz_Slider_Jump_Addition : CGFloat = 24
    
    //============== Central Grid SECTION =========================
    public let DATA_final_Line_Y_Index : Int = 64
    
    @Published public var curr_cursor_X_Offset : CGFloat = 0
    
    @Published public var cursor_Y_Jump : CGFloat = 16
    
    var initial_Right_Boundary : CGFloat = 380
    @Published public var potential_Note_Rightward_Boundary : CGFloat = 380
    
    var initial_Left_Boundary : CGFloat = 0
    @Published public var potential_Note_Leftward_Boundary : CGFloat = 0
    
    @Published public var dataGrid_X_Unit_Count : Int = 96
    public let visualGrid_Y_Unit_Count : Int = 12
    public let visualGrid_Y_Unit_Count_Final_Index : Int = 11
    
    public let cellFontSize : CGFloat = 12
    //============== CURSOR SECTION =========================
    public var Horz_Cursor_Slider_Width : CGFloat = 384
    public var Horz_Cursor_Slider_Height : CGFloat = 24
    
    public var Horz_Cursor_Slider_Line_Height : CGFloat = 384
    public var Horz_Cursor_Slider_Line_Width : CGFloat = 1
    
    public let Vert_Cursor_Slider_Width : CGFloat = 24
    public let Vert_Cursor_Slider_Height : CGFloat = 192
    
    public let Vert_Cursor_Slider_Line_Height : CGFloat = 1
    public let Vert_Cursor_Slider_Line_Width : CGFloat = 384
    
    public func return_H_Slider_Y_Offset() -> CGFloat {
        let retval = (pattern_Grid_Unit_Height*CGFloat(visualGrid_Y_Unit_Count)) + ui_Unit_Height
        return retval
    }
    
    public var patternTimingConfiguration : E_CentralGridTiming = .fourFour
    @Published public var pattern_Grid_Unit_Height : CGFloat = 16
    @Published public var pattern_Grid_Sub_Cell_Height : CGFloat = 15
    @Published public var pattern_Grid_Cell_Sub_Unit_Count : Int = 6
    @Published public var pattern_Grid_Sub_Cell_Width : CGFloat = 4
    
    public var pattern_Start_Blank_Width : CGFloat = 3
    public var pattern_Start_Blank_XOffset : CGFloat = 1
    public var pattern_Mid_End_XOffset : CGFloat = 0
    
    var four_Four_Slider_Positions = Set<Cell_X_Descriptor>() 
    var six_Eight_Slider_Positions = Set<Cell_X_Descriptor>()
    var single_Cell_Slider_Positions = Set<Cell_X_Descriptor>()
    
    var currentFourFourPosition : CGFloat = 0
    var currentSixEightPosition : CGFloat = 0
    var currentSingleCellPosition : CGFloat = 0
    
    var currentFourFourDataIndex : Int = 0
    var currentSixEightDataIndex : Int = 0
    var currentSingleCellDataIndex : Int = 0

    public func flip_Timing_Signature_Dimensions() {
        if patternTimingConfiguration == .fourFour {
            patternTimingConfiguration = .sixEight
            pattern_Grid_Cell_Sub_Unit_Count = 4
        }
        else if patternTimingConfiguration == .sixEight {
            patternTimingConfiguration = .fourFour
            pattern_Grid_Cell_Sub_Unit_Count = 6
        }
    }

    public static let StaticDimensions = ComponentDimensions()
    
}

public class ComponentColors {
    
    public var cursorSwiperColor : Color = Color(red:0.5,green:1,blue:0)
    public var cursorSliderLineColor : Color = Color(red:0.5,green:1,blue:0)
    
    
    
    
    
    public var deleteNoteMode_Cursor_Color : Color = Color(red:1,green:0.5,blue:0)
    public var moveNoteMode_Cursor_Color : Color = Color(red:0.5,green:0.5,blue:0)
    
    public var cursor_Over_Blank_Passive_Color : Color = Color(red:0.6,green:0,blue:0.6)
    public var cursor_Over_Note_Passive_Color : Color = .yellow
    
    public var cursor_Over_Note_Move_Permitted : Color = .blue
    public var cursor_Over_Note_Move_Prohibited : Color = Color(red:0.4,green:0,blue:0)
    public var cursor_Over_Blank_Move_Permitted : Color = .red
    public var cursor_Over_Blank_Move_Prohibited : Color = .cyan
    
    public var prohibited_Clashing_Cell_Color : Color = Color(red:0.6,green:0,blue:0)
    public var prohibited_Moving_Cell_Color : Color = Color(red:0.8,green:0,blue:0)
    public var prohibited_Cursor_Cell_Color : Color = Color(red:1,green:0.1,blue:0.1)

//    public var cursor_Over_Note_CopyMove_Permitted : Color = .green
//    public var cursor_Over_Note_CopyMove_Prohibited : Color = .blue
//    public var cursor_Over_Blank_CopyMove_Permitted : Color = .brown
//    public var cursor_Over_Blank_CopyMove_Prohibited : Color = .cyan
    
    
    

    
    public var multiSelectBackGroundColor : Color = Color(red:0.3,green:0.5,blue:0.1)
    
    public var multiSelectedNoteColor : Color = Color(red:1,green:1,blue:0)
    
    public var selectedNoteColor : Color = Color(red:0.5,green:1,blue:0)

    public var potentialColor : Color = Color(red: 0, green: 1, blue: 1)

    
    


    
    
    
    public var grid_Note_Color : Color = Color(red:0.4,green:0.8,blue:0)
    
    public var movedFromNoteColor : Color = Color(red:0.4,green:0.4,blue:0)
    
    public var grid_Note_Highlighted_Color : Color = Color(red:0.5,green:1,blue:0)
    
    public var grid_Note_Resizing_Color : Color = Color(red:0.5,green:0,blue:1)

    
    
    public var grid_Blank_Color : Color = Color(red:0.2,green:0.4,blue:0)
    
    public static let StaticColors = ComponentColors()
    
}
