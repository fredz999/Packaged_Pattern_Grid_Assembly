//
//  File.swift
//  
//
//  Created by Jon on 10/04/2023.
//

import Foundation
import SwiftUI

public class Underlying_Data_Cell:Identifiable,Equatable,Hashable {
    
    public static func == (lhs: Underlying_Data_Cell, rhs: Underlying_Data_Cell) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public var id = UUID()
    
    public var dataCell_X_Number : Int

    var in_Highlighted_Set : Bool = false

    var in_Resize_Set : Bool = false
    
    var in_Potential_Edge_Set : Bool = false

    var in_Delete_Square_Set : Bool = false
    
    var in_Delete_Trail_Set : Bool = false
    
    var in_Passive_Cursor_Set : Bool = false
    
    var in_MultiSelectBackground_Set : Bool = false
    
    var in_MultiSelectNote_Set : Bool = false
    
    
    
    var in_Potential_Set : Bool = false
    
    var in_Prohibited_Clashing_Cell_Set : Bool = false
    
    var in_Prohibited_Moving_Cell_Set : Bool = false
    
    var in_MoveNote_Cursor_Set : Bool = false
    
    var in_activate_Moved_Away_From_Set : Bool = false
 
    func handleVisibleStateChange(type : E_VisibleStateChangeType) {

        if type == .activate_Move_Away_From_Cell {
            if in_activate_Moved_Away_From_Set == false {
                in_activate_Moved_Away_From_Set = true
            }
            if let lclDataVals = currentConnectedDataVals {
                lclDataVals.update_Cell_Set_Membership(status_Update_TypeParam: .movedAwayFrom_Set  , value: in_activate_Moved_Away_From_Set)
            }
            print("alterCursorState(_9")
            alterCursorState(thisCellInNote: nil, cell_In_Moving_Prohibition: nil, cell_In_Clashing_Prohibition: nil, cursorMoveMode: .in_Move )
        }
        else if type == .deActivate_Move_Away_From_Cell {
            if in_activate_Moved_Away_From_Set == true {
                in_activate_Moved_Away_From_Set = false
            }
            if let lclDataVals = currentConnectedDataVals {
                lclDataVals.update_Cell_Set_Membership(status_Update_TypeParam: .movedAwayFrom_Set  , value: in_activate_Moved_Away_From_Set)
            }
            print("alterCursorState(_10")
            alterCursorState(thisCellInNote: nil, cell_In_Moving_Prohibition: nil, cell_In_Clashing_Prohibition: nil, cursorMoveMode: .inactive)
        }
        //--------------------------------------------------------------------------------------------------------------------------------------------
         if type == .activate_Prohibited_Moving_Cell {
            if in_Prohibited_Moving_Cell_Set == false {
                in_Prohibited_Moving_Cell_Set=true
            }
            if let lclDataVals = currentConnectedDataVals {
                lclDataVals.update_Cell_Set_Membership(status_Update_TypeParam: .prohibitedMovingSet , value: in_Prohibited_Moving_Cell_Set)
                print("alterCursorState(_11")
                alterCursorState(thisCellInNote: nil, cell_In_Moving_Prohibition: true, cell_In_Clashing_Prohibition: nil, cursorMoveMode: nil)
            }
        }
        else if type == .deActivate_Prohibited_Moving_Cell {
            if in_Prohibited_Moving_Cell_Set == true{in_Prohibited_Moving_Cell_Set=false}
            if let lclDataVals = currentConnectedDataVals {
                lclDataVals.update_Cell_Set_Membership(status_Update_TypeParam: .prohibitedMovingSet , value: in_Prohibited_Moving_Cell_Set)
                print("alterCursorState(_12")
                alterCursorState(thisCellInNote: nil, cell_In_Moving_Prohibition: false, cell_In_Clashing_Prohibition: nil, cursorMoveMode: nil)
            }
        }
        //--------------------------------------------------------------------------------------------------------------------------------------------
        else if type == .activate_Prohibited_Clashing_Cell {
            if in_Prohibited_Clashing_Cell_Set == false{in_Prohibited_Clashing_Cell_Set=true}
            if let lclDataVals = currentConnectedDataVals{
                lclDataVals.update_Cell_Set_Membership(status_Update_TypeParam: .prohibitedClashingSet , value: in_Prohibited_Clashing_Cell_Set)
                print("alterCursorState(_13")
                alterCursorState(thisCellInNote: nil, cell_In_Moving_Prohibition: nil, cell_In_Clashing_Prohibition: true, cursorMoveMode: nil)
            }
        }
        else if type == .deActivate_Prohibited_Clashing_Cell {
            if in_Prohibited_Clashing_Cell_Set == true{in_Prohibited_Clashing_Cell_Set=false}
            if let lclDataVals = currentConnectedDataVals{
                lclDataVals.update_Cell_Set_Membership(status_Update_TypeParam: .prohibitedClashingSet , value: in_Prohibited_Clashing_Cell_Set)
            }
            print("alterCursorState(_14")
            alterCursorState(thisCellInNote: nil, cell_In_Moving_Prohibition: nil, cell_In_Clashing_Prohibition: false, cursorMoveMode: nil)
        }
        //--------------------------------------------------------------------------------------------------------------------------------------------
        else if type == .activate_Passive_Cursor_Set {
            if in_Passive_Cursor_Set == false {
                in_Passive_Cursor_Set = true
                if let lclDataVals = currentConnectedDataVals {
                    lclDataVals.update_Cell_Set_Membership(status_Update_TypeParam: .passiveCursorSet, value: in_Passive_Cursor_Set)
                }
            }
        }
        
        else if type == .deActivate_Passive_Cursor_Set{
            if in_Passive_Cursor_Set == true {
                in_Passive_Cursor_Set = false
                if let lclDataVals = currentConnectedDataVals {
                    lclDataVals.update_Cell_Set_Membership(status_Update_TypeParam: .passiveCursorSet, value: in_Passive_Cursor_Set)
                }
            }
        }
        
        else if type == .deActivate_Multiselect_Background_Set{
            if in_MultiSelectBackground_Set == true {
                in_MultiSelectBackground_Set = false
                if let lclDataVals = currentConnectedDataVals {
                    lclDataVals.update_Cell_Set_Membership(status_Update_TypeParam: .multiSelectBackGroundSet, value: in_MultiSelectBackground_Set)
                }
            }
        }
        
        else if type == .activate_Multiselect_Background_Set {
            if in_MultiSelectBackground_Set == false {
                in_MultiSelectBackground_Set = true
                if let lclDataVals = currentConnectedDataVals {
                    lclDataVals.update_Cell_Set_Membership(status_Update_TypeParam: .multiSelectBackGroundSet, value: in_MultiSelectBackground_Set)
                }
            }
        }
        
        else if type == .activate_Multiselect_Note_Set {
            if in_MultiSelectNote_Set == false{
                in_MultiSelectNote_Set = true
                if let lclDataVals = currentConnectedDataVals {
                    lclDataVals.update_Cell_Set_Membership(status_Update_TypeParam: .multiSelectNoteSet, value: in_MultiSelectNote_Set)
                }
            }
        }
        
        else if type == .deActivate_Multiselect_Note_Set {
            if in_MultiSelectNote_Set == true {
                in_MultiSelectNote_Set = false
                if let lclDataVals = currentConnectedDataVals {
                    lclDataVals.update_Cell_Set_Membership(status_Update_TypeParam: .multiSelectNoteSet, value: in_MultiSelectNote_Set)
                }
            }
        }
        
        else if type == .activate_Delete_Square_Set {
            if in_Delete_Square_Set == false {
                in_Delete_Square_Set = true
                if let lclDataVals = currentConnectedDataVals {
                    lclDataVals.update_Cell_Set_Membership(status_Update_TypeParam: .deleteSquareSet , value: in_Delete_Square_Set)
                }
            }
        }
        
        else if type == .deActivate_Delete_Square_Set {
            if in_Delete_Square_Set == true {
                in_Delete_Square_Set = false
                if let lclDataVals = currentConnectedDataVals {
                    lclDataVals.update_Cell_Set_Membership(status_Update_TypeParam: .deleteSquareSet, value: in_Delete_Square_Set)
                }
            }
        }
        
        else if type == .activate_Potential_Set {
            if in_Potential_Set == false {
                in_Potential_Set = true
                if let lclDataVals = currentConnectedDataVals {
                    lclDataVals.update_Cell_Set_Membership(status_Update_TypeParam: .potentialSet , value: in_Potential_Set)
                }
            }
        }
        
        else if type == .deActivate_Potential_Set {
            if in_Potential_Set == true {
                in_Potential_Set = false
                if let lclDataVals = currentConnectedDataVals{
                    lclDataVals.update_Cell_Set_Membership(status_Update_TypeParam: .potentialSet , value: in_Potential_Set)
                }
            }
        }
        
        else if type == .activate_Resize_Set {
            if in_Resize_Set == false {
                in_Resize_Set = true
                if let lclDataVals = currentConnectedDataVals {
                    lclDataVals.update_Cell_Set_Membership(status_Update_TypeParam: .resizeSet , value: in_Resize_Set)
                }
            }
        }
        
        else if type == .deActivate_Resize_Set {
            if in_Resize_Set == true {
                in_Resize_Set = false
                if let lclDataVals = currentConnectedDataVals{
                    lclDataVals.update_Cell_Set_Membership(status_Update_TypeParam: .resizeSet , value: in_Resize_Set)
                }
            }
        }
        
    }

    var note_Im_In : Note?
    
    var parentLine : Underlying_Data_Line
    
    weak var currentConnectedDataVals : Data_Vals_Holder?

    var note_Reset_Status : E_CellStatus
    public var currentType : E_CellStatus
//    {
//        didSet{
//            if currentType != .start_Blank || currentType != .mid_Blank || currentType != .end_Blank{
//                print("got set somehow")
//            }
//        }
//    }
    public var fourStatus : E_CellStatus
    public var sixStatus : E_CellStatus
    
    public var four_Four_Sub_Index : Int
    public var four_Four_Cell_Index : Int
    public var six_Eight_Sub_Index : Int
    public var six_Eight_Cell_Index : Int
    
    public var four_Four_Half_Sub_Index : Int
    public var four_Four_Half_Cell_Index : Int
    public var six_Eight_Half_Sub_Index : Int
    public var six_Eight_Half_Cell_Index : Int
    
    public init(xNumParam:Int
    ,yNumParam:Int
    ,parentLineParam: Underlying_Data_Line
    ,fourStatusParam:E_CellStatus
    ,sixStatusParam:E_CellStatus
    ,initialStatusParam:E_CellStatus
    ,fourFourSubIndexParam:Int
    ,sixEightSubIndexParam:Int
    ,four_Four_Cell_Index_Param:Int
    ,six_Eight_Cell_Index_Param:Int
    ,four_Four_Half_Sub_Index_Param:Int
    ,four_Four_Half_Cell_Index_Param:Int
    ,six_Eight_Half_Sub_Index_Param:Int
    ,six_Eight_Half_Cell_Index_Param:Int
    ){
    four_Four_Sub_Index = fourFourSubIndexParam
    four_Four_Cell_Index = four_Four_Cell_Index_Param
    six_Eight_Sub_Index = sixEightSubIndexParam
    six_Eight_Cell_Index = six_Eight_Cell_Index_Param
    four_Four_Half_Sub_Index = four_Four_Half_Sub_Index_Param
    four_Four_Half_Cell_Index = four_Four_Half_Cell_Index_Param
    six_Eight_Half_Sub_Index = six_Eight_Half_Sub_Index_Param
    six_Eight_Half_Cell_Index = six_Eight_Half_Cell_Index_Param

    dataCell_X_Number = xNumParam
    parentLine = parentLineParam
    
    fourStatus = fourStatusParam
    sixStatus = sixStatusParam
    
    currentType = initialStatusParam
    note_Reset_Status = initialStatusParam
    }
    
    public func react_To_Timing_Change(timingParam:E_CentralGridTiming){
        if timingParam == .fourFour {
            if currentType == .start_Blank || currentType == .mid_Blank || currentType == .end_Blank {
                change_Type(newType: fourStatus)
            }
            note_Reset_Status = fourStatus
        }
        else if timingParam == .sixEight {
            if currentType == .start_Blank || currentType == .mid_Blank || currentType == .end_Blank {
                change_Type(newType: sixStatus)
            }
            note_Reset_Status = sixStatus
        }
    }
    
    public func change_Type(newType:E_CellStatus){
        currentType = newType
        if let lcl_Data_Vals = currentConnectedDataVals {
            if lcl_Data_Vals.referenced_currentStatus != newType {
                lcl_Data_Vals.referenced_currentStatus = newType
            }
        }
    }
    
    public func change_Highlight(highlightStatusParam:Bool){
        if in_Highlighted_Set != highlightStatusParam {
            in_Highlighted_Set = highlightStatusParam
            if let lcl_Data_Vals = currentConnectedDataVals {
                lcl_Data_Vals.update_Cell_Set_Membership(status_Update_TypeParam: .highlightedSet, value: highlightStatusParam)
            }
        }
    }
    
    public func reset_To_Original(){
        if currentType == .single_Note || currentType == .start_Note || currentType == .mid_Note || currentType == .end_Note {
            currentType = note_Reset_Status
            if note_Im_In != nil {note_Im_In = nil}
            if let lcl_Data_Vals = currentConnectedDataVals {
                
                lcl_Data_Vals.updateValsFromNewData(
                newXNum: dataCell_X_Number
                , newYNum: parentLine.line_Y_Num
                , newCellNoteStatus: note_Reset_Status)

                //lcl_Data_Vals.externallySetCursorState.is_Over_Note_Cell = false
                
                //alterCursorState(thisCellInNote: false, rewritePermitted: nil, cursorMoveMode: nil)
                print("alterCursorState(_15")
                alterCursorState(thisCellInNote: false, cell_In_Moving_Prohibition: nil, cell_In_Clashing_Prohibition: nil, cursorMoveMode: nil)
                
                if in_Passive_Cursor_Set == true {
                    if lcl_Data_Vals.statusColor != lcl_Data_Vals.colors.cursor_Over_Blank_Passive_Color{lcl_Data_Vals.statusColor = lcl_Data_Vals.colors.cursor_Over_Blank_Passive_Color}
                }
            }
        }
    }
    
    func alterCursorState(thisCellInNote:Bool?,cell_In_Moving_Prohibition:Bool?,cell_In_Clashing_Prohibition:Bool?,cursorMoveMode:E_Cursor_Move_Mode?){
        //print("alterCursorState(")
        if let lclCurrDataVals = currentConnectedDataVals {

            if let lclThisIsCellInNote = thisCellInNote {
                if lclCurrDataVals.externallySetCursorState.is_Over_Note_Cell != lclThisIsCellInNote{
                    lclCurrDataVals.externallySetCursorState.is_Over_Note_Cell = lclThisIsCellInNote
                }
            }
                
            if let lclMoving_Prohibition = cell_In_Moving_Prohibition {
                if lclCurrDataVals.externallySetCursorState.cell_In_Moving_Prohibition != lclMoving_Prohibition{
                    lclCurrDataVals.externallySetCursorState.cell_In_Moving_Prohibition = lclMoving_Prohibition
                }
            }
            
            if let lclClashing_Prohibition = cell_In_Clashing_Prohibition {
                if lclCurrDataVals.externallySetCursorState.cell_In_Clashing_Prohibition != lclClashing_Prohibition{
                    lclCurrDataVals.externallySetCursorState.cell_In_Clashing_Prohibition = lclClashing_Prohibition
                }
            }
            
            if let lclcursorMoveMode = cursorMoveMode {
                if lclCurrDataVals.externallySetCursorState.cursor_Move_Mode != lclcursorMoveMode{
                    lclCurrDataVals.externallySetCursorState.cursor_Move_Mode = lclcursorMoveMode
                }
            }
            
        }
    }
    
    
}
