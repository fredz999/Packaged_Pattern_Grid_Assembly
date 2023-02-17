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

    private var referenced_in_Highlighted_Set : Bool = false
    
    private var referenced_in_Prohibited_Set : Bool = false
    
    private var referenced_in_Cursor_Set : Bool = false
    
    private var referenced_in_Potential_Set : Bool = false
    
    private var referenced_in_Potential_Edge_Set : Bool = false

    @Published public var referenced_currentStatus : E_CellStatus
    {
        didSet{
     
            if referenced_currentStatus == .start_Note
                || referenced_currentStatus == .mid_Note
                || referenced_currentStatus == .end_Note {
                
                if statusColor != colors.grid_Note_Color && referenced_in_Cursor_Set == false {statusColor = colors.grid_Note_Color}
                else if referenced_in_Cursor_Set == true{
                    statusColor = colors.cursor_Set_Cell_Color
                }
                
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
    
    public func update_Cell_Set_Membership(status_Update_TypeParam:status_Update_Type,value:Bool){
        //update_Cell_Set_Membership(status_Update_TypeParam: .highlighted, value: true)
                                   
        if status_Update_TypeParam == .potentialSet {
            if value == true {
                if referenced_in_Potential_Set == false {
                    referenced_in_Potential_Set=true
                }
            }
            else if value == false {
                if referenced_in_Potential_Set == true{referenced_in_Potential_Set=false}
            }
        }
        else if status_Update_TypeParam == .cursorSet {
            if value == true {
                if referenced_in_Cursor_Set == false {
                    referenced_in_Cursor_Set=true
                }
            }
            else if value == false {
                if referenced_in_Cursor_Set == true{referenced_in_Cursor_Set=false}
            }
        }
        
        else if status_Update_TypeParam == .highlighted {
            if value == true {
                if referenced_in_Highlighted_Set == false{referenced_in_Highlighted_Set=true}
            }
            else if value == false {
                if referenced_in_Highlighted_Set == true{referenced_in_Highlighted_Set=false}
            }
        }
        
        else if status_Update_TypeParam == .prohibitedSet {
            if value == true {
                if referenced_in_Prohibited_Set == false{referenced_in_Prohibited_Set=true}
            }
            else if value == false {
                if referenced_in_Prohibited_Set == true{referenced_in_Prohibited_Set=false}
            }
        }
        
        process_Visual_Status()
    }
    
    func process_Visual_Status(){
        if check_In_Cursor_Set() == false{

            if check_Cell_Not_In_Note() == false {
                check_Highlighted()
            }
            else if check_Cell_Not_In_Note() == true {
                if check_In_Potential_Set() == true {
                    check_In_Prohib_Set()
                }
            }
        }
    }
    
    func check_Cell_Not_In_Note()->Bool{
        var retval = true
        if referenced_currentStatus == .start_Blank
            || referenced_currentStatus == .mid_Blank
            || referenced_currentStatus == .end_Blank {
            if statusColor != colors.grid_Blank_Color{statusColor = colors.grid_Blank_Color}
        }
        else if referenced_currentStatus == .start_Note
            || referenced_currentStatus == .mid_Note
            || referenced_currentStatus == .end_Note {
            retval = false
            if statusColor != colors.grid_Note_Color{statusColor = colors.grid_Note_Color}
        }
        return retval
    }
    
    func check_Highlighted(){
        if referenced_in_Highlighted_Set == true {
            if statusColor != colors.grid_Note_Highlighted_Color{statusColor = colors.grid_Note_Highlighted_Color}
        }
    }
    
    func check_In_Cursor_Set()->Bool{
        var retVal = false
        if referenced_in_Cursor_Set == true {
            retVal = true
            if statusColor != colors.cursor_Set_Cell_Color{statusColor = colors.cursor_Set_Cell_Color}
        }
        return retVal
    }
    
    
//      func check_In_Cursor_Set() {
//            if referenced_in_Cursor_Set == true {
//                if statusColor != colors.cursor_Set_Cell_Color{statusColor = colors.cursor_Set_Cell_Color}
//            }
//        }

    
    func check_In_Prohib_Set() {
        if referenced_in_Prohibited_Set == true {
            if statusColor != colors.prohibited_Cell_Color{statusColor = colors.prohibited_Cell_Color}
        }
    }
    
    
    
    func check_In_Potential_Set() -> Bool {
        var retVal = false
        if referenced_in_Potential_Set == true{
            retVal = true
            if statusColor != colors.potentialColor{statusColor = colors.potentialColor}
        }
        return retVal
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
    
    func updateValsFromNewData(newXNum:Int,newYNum:Int,newCellNoteStatus:E_CellStatus,newNoteImIn:Note?){
    if referenced_dataCell_X_Number != newXNum{referenced_dataCell_X_Number = newXNum}
    if referenced_dataCell_Y_Number != newYNum{referenced_dataCell_Y_Number = newYNum}
        
    if referenced_currentStatus != newCellNoteStatus{referenced_currentStatus = newCellNoteStatus}
        // have a seperate func for color change

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

public enum status_Update_Type {
    case highlighted
    case cursorSet
    case prohibitedSet
    case potentialSet
    case potentialEdgeSet
}
