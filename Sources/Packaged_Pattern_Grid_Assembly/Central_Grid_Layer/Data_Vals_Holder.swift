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
    
    
    
    private var referenced_in_Prohibited_Clashing_Set : Bool = false
    
    private var referenced_in_Prohibited_Moving_Set : Bool = false
    
    private var referenced_in_Prohibited_Cursor_Set : Bool = false
    
    private var referenced_in_Cursor_Set : Bool = false
    
    private var referenced_in_Potential_Set : Bool = false
    
    private var referenced_in_Resize_Set : Bool = false
    
    private var referenced_in_Delete_Square_Set : Bool = false
    
    private var referenced_in_PassiveCursor_Set : Bool = false
    
    private var referenced_in_MultiSelect_BackGround_Set : Bool = false
    
    private var referenced_in_MultiSelect_Note_Set : Bool = false
    
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
    
    private var referenced_in_MoveCursor_Set : Bool = false
    
    private var referenced_in_MoveAway_Set : Bool = false
    
    public func update_Cell_Set_Membership(status_Update_TypeParam:status_Update_Type,value:Bool){

        if status_Update_TypeParam == .movedAwayFrom_Set {
            if value == true {
                if referenced_in_MoveAway_Set == false {
                    referenced_in_MoveAway_Set = true
                }
            }
            else if value == false {
                if referenced_in_MoveAway_Set == true {
                    referenced_in_MoveAway_Set = false
                }
            }
        }
        
        if status_Update_TypeParam == .prohibitedClashingSet {
            if value == true {
                if referenced_in_Prohibited_Clashing_Set == false{
                    referenced_in_Prohibited_Clashing_Set=true
                }
            }
            else if value == false {
                if referenced_in_Prohibited_Clashing_Set == true{
                    referenced_in_Prohibited_Clashing_Set=false
                }
            }
        }
        
        else if status_Update_TypeParam == .prohibitedMovingSet {
            if value == true {
                if referenced_in_Prohibited_Moving_Set == false{
                    referenced_in_Prohibited_Moving_Set=true
                }
            }
            else if value == false {
                if referenced_in_Prohibited_Moving_Set == true{
                    referenced_in_Prohibited_Moving_Set=false
                }
            }
        }

        else if status_Update_TypeParam == .passiveCursorSet  {
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
        
        else if status_Update_TypeParam == .resizeSet {
            if value == true {
                if referenced_in_Resize_Set == false {
                    referenced_in_Resize_Set=true
                }
            }
            else if value == false {
                if referenced_in_Resize_Set == true{referenced_in_Resize_Set=false}
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
        
        else if status_Update_TypeParam == .highlightedSet {
            if value == true {
                if referenced_in_Highlighted_Set == false{referenced_in_Highlighted_Set=true}
            }
            else if value == false {
                if referenced_in_Highlighted_Set == true{referenced_in_Highlighted_Set=false}
            }
        }
        
        else if status_Update_TypeParam == .multiSelectBackGroundSet {
            if value == true {
                if referenced_in_MultiSelect_BackGround_Set == false{referenced_in_MultiSelect_BackGround_Set=true}
            }
            else if value == false {
                if referenced_in_MultiSelect_BackGround_Set == true{referenced_in_MultiSelect_BackGround_Set=false}
            }
        }
        
        else if status_Update_TypeParam == .multiSelectNoteSet {
            if value == true {
                if referenced_in_MultiSelect_Note_Set == false{referenced_in_MultiSelect_Note_Set=true}
            }
            else if value == false {
                if referenced_in_MultiSelect_Note_Set == true{referenced_in_MultiSelect_Note_Set=false}
            }
        }
        
        process_Visual_Status()
    }
    
    func process_Visual_Status(){
        if check_In_MoveCursor_Set() == false {
            if check_In_Passive_Cursor_Set() == false {
                if check_Cell_Not_In_Note() == false {
                    check_Highlighted()
                    check_In_MultiSelect_Note_Set()
                    check_In_Prohib_Clashing_Set()
                    check_In_MovedAwayFrom_Set() 
                }
                else if check_Cell_Not_In_Note() == true {
                    check_In_MultiSelect_BackGround_Set()
                    check_In_Potential_Set()
                    check_In_Resize_Set()
                    check_In_Potential_Set()
                    check_In_Prohib_Moving_Set()
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
            if statusColor != colors.grid_Note_Highlighted_Color{statusColor = colors.selectedNoteColor}
        }
        else if referenced_in_Highlighted_Set == false {
            if statusColor != colors.grid_Note_Color {statusColor = colors.grid_Note_Color}
        }
    }
    
    func check_In_Passive_Cursor_Set()->Bool{
        var retVal = false
        if referenced_in_PassiveCursor_Set == true {
            retVal = true
            if statusColor != colors.passiveMode_Cursor_Color{statusColor = colors.passiveMode_Cursor_Color}
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
    
    func check_In_Prohib_Clashing_Set() {
        if referenced_in_Prohibited_Clashing_Set == true {
            if statusColor != colors.prohibited_Clashing_Cell_Color{statusColor = colors.prohibited_Clashing_Cell_Color}
        }
    }
    
    func check_In_Prohib_Moving_Set() {
        if referenced_in_Prohibited_Moving_Set == true {
            if statusColor != colors.prohibited_Moving_Cell_Color{statusColor = colors.prohibited_Moving_Cell_Color}
        }
    }
    
    func check_In_MultiSelect_BackGround_Set(){
        if referenced_in_MultiSelect_BackGround_Set == true {
            if statusColor != colors.multiSelectBackGroundColor{statusColor = colors.multiSelectBackGroundColor}
        }
    }
    func check_In_MultiSelect_Note_Set(){
        if referenced_in_MultiSelect_Note_Set == true {
            if statusColor != colors.multiSelectedNoteColor{statusColor = colors.multiSelectedNoteColor}
        }
    }
    
    func check_In_Potential_Set() {
        if referenced_in_Potential_Set == true {
            if statusColor != colors.potentialColor{statusColor = colors.potentialColor}
        }
    }
    
    func check_In_Resize_Set() {
        if referenced_in_Resize_Set == true {
            if statusColor != .purple{statusColor = .purple}
        }
    }
    
    func check_In_MovedAwayFrom_Set() {
        if referenced_in_MoveAway_Set == true {
            if statusColor != .black{statusColor = .black}
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
    
    func updateValsFromNewData(newXNum:Int,newYNum:Int,newCellNoteStatus:E_CellStatus,newNoteImIn:Note?){
    if referenced_dataCell_X_Number != newXNum{referenced_dataCell_X_Number = newXNum}
    if referenced_dataCell_Y_Number != newYNum{referenced_dataCell_Y_Number = newYNum}
    if referenced_currentStatus != newCellNoteStatus{referenced_currentStatus = newCellNoteStatus}
        
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
    case passiveCursorSet
    
    case prohibitedClashingSet
    case prohibitedMovingSet
    case prohibitedCursorSet
    
    case moveNote_Cursor_Set
    case movedAwayFrom_Set
    
    
    case potentialSet
    case resizeSet
    case potentialEdgeSet
    case multiSelectBackGroundSet
    case multiSelectNoteSet
}
