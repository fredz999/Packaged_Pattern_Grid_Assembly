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
    let centralState = Central_State.Static_Central_State
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
    
    private var referenced_in_Delete_Square_Set : Bool = false
    
    private var referenced_in_MoveCursor_Set : Bool = false
    
    private var referenced_in_PassiveCursor_Set : Bool = false

    @Published public var referenced_currentStatus : E_CellStatus
    {
        didSet{
     
            if referenced_currentStatus == .start_Note
                || referenced_currentStatus == .mid_Note
                || referenced_currentStatus == .end_Note {
                
                if statusColor != colors.grid_Note_Color && referenced_in_Cursor_Set == false {statusColor = colors.grid_Note_Color}
                
                if sub_Cell_Width != dimensions.pattern_Grid_Sub_Cell_Width{sub_Cell_Width = dimensions.pattern_Grid_Sub_Cell_Width}
                if cell_X_Offset != dimensions.pattern_Mid_End_XOffset{cell_X_Offset = dimensions.pattern_Mid_End_XOffset}
            }
            else {
                
                if statusColor != colors.grid_Blank_Color && referenced_in_Cursor_Set == false{
                    statusColor = colors.grid_Blank_Color
                }
                
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

        if status_Update_TypeParam == .passiveCursorSet  {
            if value == true {
                if referenced_in_PassiveCursor_Set == false {
                    referenced_in_PassiveCursor_Set = true
                }
            }
            else if value == false {
                if referenced_in_PassiveCursor_Set == true {
                    referenced_in_PassiveCursor_Set = false
                }
            }
        }
        
        else if status_Update_TypeParam == .moveNote_Cursor_Set {
            if value == true {
                if referenced_in_MoveCursor_Set == false {
                    referenced_in_MoveCursor_Set = true
                }
            }
            else if value == false {
                if referenced_in_MoveCursor_Set == true {
                    referenced_in_MoveCursor_Set = false
                }
            }
        }
        
        else if status_Update_TypeParam == .deleteSquareSet {
            if value == true {
                if referenced_in_Delete_Square_Set == false {
                    referenced_in_Delete_Square_Set = true
                }
            }
            else if value == false {
                if referenced_in_Delete_Square_Set == true {
                    referenced_in_Delete_Square_Set = false
                }
            }
        }
                                   
        else if status_Update_TypeParam == .potentialSet {
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
        
        else if status_Update_TypeParam == .prohibitedSet {
            if value == true {
                if referenced_in_Prohibited_Set == false{referenced_in_Prohibited_Set=true}
            }
            else if value == false {
                if referenced_in_Prohibited_Set == true{referenced_in_Prohibited_Set=false}
            }
        }
        
        else if status_Update_TypeParam == .highlightedSet {
            if value == true {
                if referenced_in_Highlighted_Set == false{referenced_in_Highlighted_Set=true}
            }
            else if value == false {
                if referenced_in_Highlighted_Set == true{referenced_in_Highlighted_Set=false}
            }
        }
        
        process_Visual_Status()
    }
    
    func process_Visual_Status(){
        if check_In_Delete_Square_Set() == false{
            
            if check_In_MoveCursor_Set() == false{
                
                if check_In_Passive_Cursor_Set() == false {
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
        if centralState.currentPatternMode == .passive{
            if referenced_in_Highlighted_Set == true {
                if statusColor != colors.grid_Note_Highlighted_Color{statusColor = .red}
            }
            else if referenced_in_Highlighted_Set == false {
                if statusColor != colors.grid_Note_Color {statusColor = colors.grid_Note_Color}
            }
        }
//        else if centralState.currentPatternMode == .writing{
//            if referenced_in_Highlighted_Set == true {
//                if statusColor != colors.grid_Note_Highlighted_Color{statusColor = .blue}
//            }
//            else if referenced_in_Highlighted_Set == false {
//                if statusColor != colors.grid_Note_Color {statusColor = colors.grid_Note_Color}
//            }
//        }
        else if centralState.currentPatternMode == .moving {
            if referenced_in_Highlighted_Set == true {
                if statusColor != colors.grid_Note_Highlighted_Color{statusColor = .white}
            }
            else if referenced_in_Highlighted_Set == false {
                if statusColor != colors.grid_Note_Color {statusColor = colors.grid_Note_Color}
            }
        }
        
    }
    
//    func check_Highlight_Type(){
//
//        print("check_Highlight_Type() called for xNum: ",referenced_dataCell_X_Number,", ",referenced_Highlight_Type.rawValue)
//        if referenced_Highlight_Type == .UnSelected{
//            if statusColor != colors.grid_Note_Color{statusColor = colors.grid_Note_Color}
//        }
//
//        if referenced_Highlight_Type == .Selected_Highlight{
//            //if statusColor != colors.grid_Note_Highlighted_Color{statusColor = colors.grid_Note_Highlighted_Color}
//            if statusColor != .pink{statusColor = .pink}
//        }
//        else if referenced_Highlight_Type == .Selected_For_Moving_Highlight{
//            if statusColor != colors.grid_Note_Highlighted_Move_Color{statusColor = colors.grid_Note_Highlighted_Move_Color}
//        }
//        else if referenced_Highlight_Type == .Selected_For_Resizing_Highlight{
//            if statusColor != colors.grid_Note_Highlighted_Resize_Color{statusColor = colors.grid_Note_Highlighted_Resize_Color}
//        }
//
//    }
    
    func check_In_Passive_Cursor_Set()->Bool{
        var retVal = false
        if referenced_in_PassiveCursor_Set == true {
            retVal = true
            if statusColor != colors.passiveMode_Cursor_Color{statusColor = colors.passiveMode_Cursor_Color}
        }
        return retVal
    }
    
    func check_In_Delete_Square_Set()->Bool{
        var retVal = false
        if referenced_in_Delete_Square_Set == true {
            retVal = true
            if statusColor != colors.deleteNoteMode_Cursor_Color{statusColor = colors.deleteNoteMode_Cursor_Color}
        }
        return retVal
    }
    
    func check_In_MoveCursor_Set()->Bool{
        var retVal = false
        if referenced_in_MoveCursor_Set == true {
            retVal = true
            if statusColor != colors.moveNoteMode_Cursor_Color{statusColor = colors.moveNoteMode_Cursor_Color}
        }
        return retVal
    }

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
    case highlightedSet
    case cursorSet
    case deleteSquareSet
    case moveNote_Cursor_Set
    case passiveCursorSet
    case prohibitedSet
    case potentialSet
    case potentialEdgeSet
}
