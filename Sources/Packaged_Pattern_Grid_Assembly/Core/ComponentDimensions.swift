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
    
    public func set_Potential_Note_Rightward_Boundary(newRightBoundary:Int){
        if newRightBoundary != dataGrid_X_Unit_Count{
            let newRightBoundaryFloat = cursor_X_Jump*CGFloat(newRightBoundary)
            potential_Note_Rightward_Boundary = newRightBoundaryFloat
        }
        else if newRightBoundary == dataGrid_X_Unit_Count{
            potential_Note_Rightward_Boundary = initial_Right_Boundary
        }
    }
    
    var initial_Left_Boundary : CGFloat = 0
    @Published public var potential_Note_Leftward_Boundary : CGFloat = 0
    
    public func set_Potential_Note_Leftward_Boundary(newLeftBoundary:Int){
        if newLeftBoundary == 0{
            potential_Note_Leftward_Boundary = initial_Left_Boundary
        }
        else if newLeftBoundary != 0{
            let newLeftBoundaryFloat = cursor_X_Jump*CGFloat(newLeftBoundary)
            potential_Note_Leftward_Boundary = newLeftBoundaryFloat
        }
    }
    
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
    
    // this is an array of underllying data nums
    // I want to have this mechanism basically reliant on cell numbers
    // so I can assign the new cell num to a h-slider prior to changing timing
    // when I change timing I go to nearest lower x bracket
    
    var four_Four_Slider_Positions = Set<CGFloat>()
    var six_Eight_Slider_Positions = Set<CGFloat>()
    var currentFourFourPosition : CGFloat = 0
    var currentSixEightPosition : CGFloat = 0
    
    func testPosition(currValParam:CGFloat,computedLineParam:inout CGFloat){
        //set both of them regardless but only alter the computedLineParam if needed
        
        // selection here not right....noeeds to be the max of the set that are less
        let lesserSetFourFour = four_Four_Slider_Positions.filter{$0 < currValParam}
        if let lclMaxLesserFour = lesserSetFourFour.max(){
            if lclMaxLesserFour != currentFourFourPosition{currentFourFourPosition = lclMaxLesserFour}
        }
        
        let lesserSetSixEight = six_Eight_Slider_Positions.filter{$0 < currValParam}
        if let lclMaxLesserSix = lesserSetSixEight.max(){
            if lclMaxLesserSix != currentSixEightPosition{currentSixEightPosition = lclMaxLesserSix}
        }
        
        if patternTimingConfiguration == .fourFour {
            if computedLineParam != currentFourFourPosition{computedLineParam = currentFourFourPosition}
        }
        else if patternTimingConfiguration == .sixEight {
            if computedLineParam != currentSixEightPosition{computedLineParam = currentSixEightPosition}
        }
    }
    
    var cursor_X_Jump_Initial : CGFloat = 4
    @Published public var cursor_X_Jump : CGFloat = 12
    
    var cursor_X_Jump_Multiplier : Int = 3 {
        didSet {
            cursor_X_Jump = cursor_X_Jump_Initial * CGFloat(cursor_X_Jump_Multiplier)
        }
    }

    public func flip_Timing_Signature_Dimensions(){
        if patternTimingConfiguration == .fourFour {
            patternTimingConfiguration = .sixEight
            pattern_Grid_Cell_Sub_Unit_Count = 4
            cursor_X_Jump_Multiplier = 2
        }
        else if patternTimingConfiguration == .sixEight {
            patternTimingConfiguration = .fourFour
            pattern_Grid_Cell_Sub_Unit_Count = 6
            cursor_X_Jump_Multiplier = 3
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
    // ================================================================================
    // ================================================================================

    public var prohibited_Cell_Color : Color = Color(red:0.8,green:0,blue:0)
    public var potential_Cell_Color : Color = Color(red:0.6,green:0,blue:0.6)
    public var potential_Edge_Cell_Color : Color = .pink //Color(red:0.8,green:0,blue:0.8)
    
    public var grid_Note_Color : Color = Color(red:0.4,green:0.8,blue:0)
    public var grid_Note_Highlighted_Color : Color = Color(red:0.5,green:1,blue:0)
    public var viable_Set_Combined_Color : Color = Color(red:0.3,green:0.6,blue:0)
    public var grid_Blank_Color : Color = Color(red:0.2,green:0.4,blue:0)
    
    public static let StaticColors = ComponentColors()
}
