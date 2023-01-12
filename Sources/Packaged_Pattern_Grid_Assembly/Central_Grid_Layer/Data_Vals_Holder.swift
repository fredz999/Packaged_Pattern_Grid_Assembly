//
//  File.swift
//  
//
//  Created by Jon on 27/12/2022.
//

import Foundation
import SwiftUI

public class Data_Vals_Holder : ObservableObject {
    let dimensions = ComponentDimensions.StaticDimensions
    let colors = ComponentColors.StaticColors
    @Published public var referenced_dataCell_X_Number : Int
    @Published public var referenced_dataCell_Y_Number : Int
    @Published public var sub_Cell_Width : CGFloat
    @Published public var sub_Cell_Height : CGFloat
    @Published public var cell_X_Offset : CGFloat = 0
    
    @Published public var referenced_isHighlighted : Bool = false{
        didSet{
            if referenced_isHighlighted == true{statusColor = colors.grid_Note_Highlighted_Color}
            else if referenced_isHighlighted == false {
                if referenced_currentStatus == .start_Note
                    || referenced_currentStatus == .mid_Note
                    || referenced_currentStatus == .end_Note {
                    if statusColor != colors.grid_Note_Color{statusColor = colors.grid_Note_Color}
                }
                else{
                    if statusColor != colors.grid_Blank_Color{statusColor = colors.grid_Blank_Color}
                }
            }
        }
    }
    
    @Published public var in_Viable_Set : Bool = false {
        didSet {
            if in_Viable_Set == true{statusColor = colors.viable_Set_Color}
            else if in_Viable_Set == false{
                statusColor = colors.grid_Blank_Color
            }
        }
    }
    
    //TODO: Datavals memory
    @Published public var referenced_currentStatus : E_CellStatus {
        didSet{
            if referenced_currentStatus == .start_Note
                || referenced_currentStatus == .mid_Note
                || referenced_currentStatus == .end_Note {
                if statusColor != colors.grid_Note_Color{statusColor = colors.grid_Note_Color}
                if sub_Cell_Width != dimensions.pattern_Grid_Sub_Cell_Width{sub_Cell_Width = dimensions.pattern_Grid_Sub_Cell_Width}
                if cell_X_Offset != dimensions.pattern_Mid_End_XOffset{cell_X_Offset = dimensions.pattern_Mid_End_XOffset}
            }
            else {
                if statusColor != colors.grid_Blank_Color{statusColor = colors.grid_Blank_Color}
                if referenced_currentStatus == .start_Blank{
                    if sub_Cell_Width != dimensions.pattern_Start_Blank_Width {sub_Cell_Width = dimensions.pattern_Start_Blank_Width}
                    if cell_X_Offset != dimensions.pattern_Start_Blank_XOffset{cell_X_Offset = dimensions.pattern_Start_Blank_XOffset}
                }
                else if referenced_currentStatus != .start_Blank{
                    if sub_Cell_Width != dimensions.pattern_Grid_Sub_Cell_Width {sub_Cell_Width = dimensions.pattern_Grid_Sub_Cell_Width}
                    if cell_X_Offset != dimensions.pattern_Mid_End_XOffset{cell_X_Offset = dimensions.pattern_Mid_End_XOffset}
                }
            }
        }
    }
    
   @Published public var statusColor : Color

   public var referenced_note_Im_In : Note?
   
   public init(xNumParam:Int,yNumParam:Int,typeParam:E_CellStatus,cellWidthParam:CGFloat,cellHeightParam:CGFloat,xOffsetParam:CGFloat){
   cell_X_Offset = xOffsetParam
   sub_Cell_Width = cellWidthParam
   sub_Cell_Height = cellHeightParam
   referenced_dataCell_X_Number = xNumParam
   referenced_dataCell_Y_Number = yNumParam
   referenced_currentStatus = typeParam
   statusColor = colors.grid_Blank_Color
   }

    
    func updateValsFromNewData(newXNum:Int,newYNum:Int,newCellStatus:E_CellStatus,newNoteImIn:Note?,isHighlightedParan:Bool){
    if referenced_dataCell_X_Number != newXNum{referenced_dataCell_X_Number = newXNum}
    if referenced_dataCell_Y_Number != newYNum{referenced_dataCell_Y_Number = newYNum}
    if referenced_isHighlighted != isHighlightedParan{referenced_isHighlighted = isHighlightedParan}
    if referenced_currentStatus != newCellStatus{referenced_currentStatus = newCellStatus}

    if let lclCurrentNote = referenced_note_Im_In {
        if let lclNewNote = newNoteImIn {
            if lclNewNote != lclCurrentNote {
                referenced_note_Im_In = lclNewNote
            }
        }
        else if newNoteImIn == nil{
            referenced_note_Im_In = nil
        }
    }
    else if referenced_note_Im_In == nil {
        if let lclNewNote = newNoteImIn {
            referenced_note_Im_In = lclNewNote
        }
    }
   }
    
    
    

}
