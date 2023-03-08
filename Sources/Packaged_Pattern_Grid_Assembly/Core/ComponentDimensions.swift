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
    
    @Published public var curr_cursor_X_Offset : CGFloat = 0
    
    @Published public var cursor_Y_Jump : CGFloat = 16
    
    var initial_Right_Boundary : CGFloat = 380
    @Published public var potential_Note_Rightward_Boundary : CGFloat = 380
    
    var initial_Left_Boundary : CGFloat = 0
    @Published public var potential_Note_Leftward_Boundary : CGFloat = 0
    
    @Published public var dataGrid_X_Unit_Count : Int = 96
    public let visualGrid_Y_Unit_Count : Int = 12
    
    public let cellFontSize : CGFloat = 12
    //============== CURSOR SECTION =========================
    public var Horz_Cursor_Slider_Width : CGFloat = 384
    public var Horz_Cursor_Slider_Height : CGFloat = 36
    
    public var Horz_Cursor_Slider_Line_Height : CGFloat = 384
    public var Horz_Cursor_Slider_Line_Width : CGFloat = 1
    
    public let Vert_Cursor_Slider_Width : CGFloat = 36
    public let Vert_Cursor_Slider_Height : CGFloat = 192
    
    public let Vert_Cursor_Slider_Line_Height : CGFloat = 1
    public let Vert_Cursor_Slider_Line_Width : CGFloat = 384
    
    public func return_H_Slider_Y_Offset() -> CGFloat{
        let retval = (pattern_Grid_Unit_Height*CGFloat(visualGrid_Y_Unit_Count)) + ui_Unit_Height
        return retval
    }
    
    public func return_V_Slider_Offset() -> CGSize {
        let width = pattern_Grid_Sub_Cell_Width*CGFloat(dataGrid_X_Unit_Count)
        let height = ui_Unit_Height
        let returnSize = CGSize(width: width, height: height)
        return returnSize
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
    
    var currentFourFourPosition : CGFloat = 0
    var currentSixEightPosition : CGFloat = 0
    
    var currentFourFourDataIndex : Int = 0
    var currentSixEightDataIndex : Int = 0
    
    var nearestLeftFourFourCellStartIndex : Int = 0
    var nearestLeftSixEightCellStartIndex : Int = 0
    
    
    func test_X_Position(currValParam:CGFloat,computedLineParam:inout CGFloat){
        
        let lesserSetFourFour = four_Four_Slider_Positions.filter{$0.x_Position_Float <= currValParam}
        
        if let lclMaxLesserFour = lesserSetFourFour.max(by:{$0.x_Position_Int < $1.x_Position_Int}) {
            if lclMaxLesserFour.x_Position_Float != currentFourFourPosition{currentFourFourPosition = lclMaxLesserFour.x_Position_Float}
            if lclMaxLesserFour.x_Position_Int != currentFourFourDataIndex{currentFourFourDataIndex = lclMaxLesserFour.x_Position_Int}
        }
        
        let lesserSetSixEight = six_Eight_Slider_Positions.filter{$0.x_Position_Float <= currValParam}
        
        if let lclMaxLesserSix = lesserSetSixEight.max(by:{$0.x_Position_Int < $1.x_Position_Int}) {
            if lclMaxLesserSix.x_Position_Float != currentSixEightPosition{currentSixEightPosition = lclMaxLesserSix.x_Position_Float}
            if lclMaxLesserSix.x_Position_Int != currentSixEightDataIndex{currentSixEightDataIndex = lclMaxLesserSix.x_Position_Int}
        }
        
        if patternTimingConfiguration == .fourFour {
            if computedLineParam != currentFourFourPosition{
                computedLineParam = currentFourFourPosition
                Central_State.Static_Central_State.cursor_Slider_Update()
            }
        }
        
        else if patternTimingConfiguration == .sixEight {
            if computedLineParam != currentSixEightPosition {
                computedLineParam = currentSixEightPosition
                Central_State.Static_Central_State.cursor_Slider_Update()
            }
        }
        
    }
    
    func test_Y_Position(currValParam:CGFloat,computedLineParam:inout CGFloat){
        let divided = currValParam/pattern_Grid_Unit_Height
        let intDivided = Int(divided)
        if intDivided != Central_State.Static_Central_State.currentYCursor_Slider_Position {
            Central_State.Static_Central_State.currentYCursor_Slider_Position = intDivided
            Central_State.Static_Central_State.cursor_Slider_Update()
            computedLineParam = CGFloat(intDivided) * pattern_Grid_Unit_Height
        }
    }

    public func flip_Timing_Signature_Dimensions(){
        if patternTimingConfiguration == .fourFour {
            patternTimingConfiguration = .sixEight
            pattern_Grid_Cell_Sub_Unit_Count = 4
        }
        else if patternTimingConfiguration == .sixEight {
            patternTimingConfiguration = .fourFour
            pattern_Grid_Cell_Sub_Unit_Count = 6
        }
    }
    
//    init(){
//        Init_Tracker.Static_Init_Tracker.registerClass(classParam: .ComponentDimensions)
//    }
    
    public static let StaticDimensions = ComponentDimensions()
    
}

public class ComponentColors {
    public var cursorSwiperColor : Color = Color(red:0.5,green:1,blue:0)
    public var cursorSliderLineColor : Color = Color(red:0.5,green:1,blue:0)
    
    //public var cursorNotWriting : Color = Color(red:0.4,green:0.8,blue:0)
    //public var cursorWriting : Color = Color(red:0.5,green:1,blue:0)
    
    public var potentialColor : Color = Color(red: 0, green: 1, blue: 1)
    
    //public var writeButtonColor : Color = Color(red: 0, green: 0.6, blue: 0)
    
    //public var writeButtonFontColor : Color = Color(red: 1, green: 1, blue: 1)
    // ================================================================================
    // ================================================================================
    public var prohibited_Cell_Color : Color = Color(red:0.6,green:0,blue:0)
    public var potential_Cell_Color : Color = Color(red:0.6,green:0,blue:0.6)

    public var passiveMode_Cursor_Color : Color = .pink
    public var deleteNoteMode_Cursor_Color : Color = Color(red:1,green:0.5,blue:0)
    
    public var moveNoteMode_Cursor_Color : Color = Color(red:0.3,green:1,blue:1)
    //public var moveNote_Note_Color : Color = Color(red:1,green:1,blue:1)
    //public var grid_Note_Highlighted_Move_Color : Color = Color(red:1,green:1,blue:1)
    
    

    public var grid_Note_Color : Color = Color(red:0.4,green:0.8,blue:0)
    
    public var grid_Note_Highlighted_Color : Color = Color(red:0.5,green:1,blue:0)
    
    
    
    public var grid_Note_Highlighted_Resize_Color : Color = Color(red:0,green:1,blue:1)
    
    public var viable_Set_Combined_Color : Color = Color(red:0.3,green:0.6,blue:0)
    public var grid_Blank_Color : Color = Color(red:0.2,green:0.4,blue:0)
    
    public static let StaticColors = ComponentColors()
}
