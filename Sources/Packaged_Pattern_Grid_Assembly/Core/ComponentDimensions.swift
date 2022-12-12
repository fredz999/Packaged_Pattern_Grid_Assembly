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
    
    public var ui_Unit_Width : CGFloat = 22
    public var ui_Unit_Height : CGFloat = 22
    
    public let pattern_Grid_Unit_VerticalEdge_Width : CGFloat = 1
    public let pattern_Grid_Unit_HorzEdge_Width : CGFloat = 1
    
    //============== Central Grid SECTION =========================
    public let DATA_final_Line_Y_Index : Int = 64
    
    public var pattern_Grid_Unit_Width : CGFloat = 16  // 22 or 16
    public var pattern_Grid_Unit_Height : CGFloat = 16 // 22 or 16
    
    public var dataGrid_X_Unit_Count : Int = 22 // 16 or 22
    public var visualGrid_X_Unit_Count : Int = 22 // 16 or 22
    public let visualGrid_Y_Unit_Count : Int = 12
    
    public let cellFontSize : CGFloat = 12
    //============== CURSOR SECTION =========================
    public var Horz_Cursor_Slider_Width : CGFloat = 352
    public var Horz_Cursor_Slider_Height : CGFloat = 22
    
    public var Horz_Cursor_Slider_Line_Height : CGFloat = 352
    public var Horz_Cursor_Slider_Line_Width : CGFloat = 1
    
    public let Vert_Cursor_Slider_Width : CGFloat = 22
    public let Vert_Cursor_Slider_Height : CGFloat = 352
    
    public let Vert_Cursor_Slider_Line_Height : CGFloat = 1
    public let Vert_Cursor_Slider_Line_Width : CGFloat = 352
    
    public func return_H_Slider_Y_Offset() -> CGFloat{
        let retval = (pattern_Grid_Unit_Height*CGFloat(visualGrid_Y_Unit_Count)) + ui_Unit_Height
        return retval
    }
    
    public func return_V_Slider_Offset()->CGSize{
        let width = pattern_Grid_Unit_Width*CGFloat(visualGrid_X_Unit_Count)
        let height = ui_Unit_Height
        let returnSize = CGSize(width: width, height: height)
        return returnSize
    }
    
    
    public func setGridMeasurements(isTriplet:Bool){
        if isTriplet == true{
            visualGrid_X_Unit_Count = 22
            dataGrid_X_Unit_Count = 22
            pattern_Grid_Unit_Width = 16
            pattern_Grid_Unit_Height = 16
        }
        else if isTriplet == false{
            visualGrid_X_Unit_Count = 16
            dataGrid_X_Unit_Count = 16
            pattern_Grid_Unit_Width = 22
            pattern_Grid_Unit_Height = 22
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
