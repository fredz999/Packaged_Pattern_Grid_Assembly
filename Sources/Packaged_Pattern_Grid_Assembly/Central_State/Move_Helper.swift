//
//  Move_Helper.swift
//  
//
//  Created by Jon on 27/02/2023.
//

import Foundation
import SwiftUI

class Move_Helper: P_Selectable_Mode {
    
    var mode_Active: Bool = false
    
    func activate_Mode(activationCell: Underlying_Data_Cell?) {
        if mode_Active == false {
            mode_Active = true
            if let lclCell = activationCell {
                snapshot_Cursor_X = lclCell.dataCell_X_Number
                snapshot_Cursor_Y = lclCell.dataCell_Y_Number
                note_Y_Val = lclCell.dataCell_Y_Number
            }
        }
    }
    
    func deactivate_Mode() {
        if mode_Active == true{mode_Active=false}
    }
    
    var parentCentralState : Central_State
    
    let dimensions = ComponentDimensions.StaticDimensions

    var note_Low_Index : Int?
    var note_High_Index : Int?
    var note_Y_Val : Int?
    var snapshot_Cursor_X : Int?
    var snapshot_Cursor_Y : Int?
    var snapShot_Note_Id_Param : UUID?
    
    var currLeftLimit : Int
    var currRightLimit : Int
    var lineBelowOpen : Bool
    var lineAboveOpen : Bool
    
    var potential_Moved_Set = Set<Underlying_Data_Cell>(){
        willSet {
            let delta = potential_Moved_Set.symmetricDifference(newValue)
            for cell in delta {
                cell.handleVisibleStateChange(type: .deActivate_Potential_Set)
            }
        }
        didSet {
            for cell in potential_Moved_Set {
                cell.handleVisibleStateChange(type : .activate_Potential_Set)
            }
        }
    }
    
    var prohibition_Indicator_Set = Set<Underlying_Data_Cell>(){
        willSet {
            let delta = prohibition_Indicator_Set.symmetricDifference(newValue)
            for cell in delta {
                cell.handleVisibleStateChange(type: .deActivate_Prohibited)
            }
        }
        didSet {
            for cell in prohibition_Indicator_Set {
                cell.handleVisibleStateChange(type : .activate_Prohibited)
            }
        }
    }
    
    var proposedSet = Set<Underlying_Data_Cell>()
    
    init(parentCentral_State_Param:Central_State){
        parentCentralState = parentCentral_State_Param
        currLeftLimit = 0
        currRightLimit = dimensions.dataGrid_X_Unit_Count-1
        lineBelowOpen = true
        lineAboveOpen = true
    }
    
    func movement_With_Note_Selected(){
        
        if let lclNote_Low_Index = note_Low_Index, let lclNote_High_Index = note_High_Index
        , let lclNote_Y_Val = note_Y_Val
        ,let lclSnapshot_X = snapshot_Cursor_X
        //,let lclSnapshot_Y = snapshot_Cursor_Y
        {

        let delta_X_Grid_Units = parentCentralState.curr_Data_Pos_X - lclSnapshot_X
        let delta_Y_Grid_Units = parentCentralState.curr_Data_Pos_Y - lclNote_Y_Val //lclSnapshot_Y

        let proposedNewMinIndex = lclNote_Low_Index + delta_X_Grid_Units
        let proposedNewMaxIndex = lclNote_High_Index + delta_X_Grid_Units
        let proposedNewYIndex = lclNote_Y_Val + delta_Y_Grid_Units

        if proposedNewMinIndex >= currLeftLimit && proposedNewMaxIndex <= currRightLimit {
            proposedSet = parentCentralState.currLineSet
            .filter{$0.dataCell_X_Number >= proposedNewMinIndex && $0.dataCell_X_Number <= proposedNewMaxIndex}
        }
        else if proposedNewMinIndex < currLeftLimit {
            proposedSet = parentCentralState.currLineSet
            .filter{$0.dataCell_X_Number >= currLeftLimit && $0.dataCell_X_Number <= (lclNote_High_Index - lclNote_Low_Index)}
        }
        else if proposedNewMaxIndex > currRightLimit {
            proposedSet = parentCentralState.currLineSet
            .filter{$0.dataCell_X_Number >=  currRightLimit-(lclNote_High_Index - lclNote_Low_Index)
                && $0.dataCell_X_Number <= currRightLimit
            }
        }
            
        potential_Moved_Set = proposedSet
            
        prohibition_Indicator_Set = proposedSet.filter({$0.note_Im_In != nil})
            
        }

    }
    
    func process_MoveNote_Cursor_Position() {
        if dimensions.patternTimingConfiguration == .fourFour {
//        move_Note_Cursor_Set = Central_State.Static_Central_State.currLineSet.filter({$0.four_Four_Half_Cell_Index == parentCentralState.currentData.four_Four_Half_Cell_Index})
            
            parentCentralState.current_Cursor_Set = parentCentralState.currLineSet.filter({$0.four_Four_Half_Cell_Index == parentCentralState.currentData.four_Four_Half_Cell_Index})
            print("parentCentralState.current_Cursor_Set count ",parentCentralState.current_Cursor_Set.description)
            
        }
        else if dimensions.patternTimingConfiguration == .sixEight {
//        move_Note_Cursor_Set = Central_State.Static_Central_State.currLineSet.filter({$0.six_Eight_Half_Cell_Index == parentCentralState.currentData.six_Eight_Half_Cell_Index})
        }
    }
    
    func nil_Cell_Sets(){
//        if move_Note_Cursor_Set.count > 0 {
//            for cell in move_Note_Cursor_Set {
//                cell.handleVisibleStateChange(type: .deActivate_MoveNote_Cursor_Set)
//            }
//            move_Note_Cursor_Set.removeAll()
//        }
//        if potential_Moved_Set.count > 0 {
//            move_Note_Cursor_Set.removeAll()
//        }
        if proposedSet.count > 0 {
            proposedSet.removeAll()
        }
        if prohibition_Indicator_Set.count > 0 {
            prohibition_Indicator_Set.removeAll()
        }
        if snapShot_Note_Id_Param != nil {
            snapShot_Note_Id_Param = nil
        }
    }
    
    func writeMovedNote_DeleteOldNote(){
        
        if potential_Moved_Set.count > 0, let lclSnapshotNote = snapShot_Note_Id_Param {
            
            if let currNoteCollection = parentCentralState.currentNoteCollection {
                
                currNoteCollection.delete_Note_By_Id(note_Id_Param: lclSnapshotNote)
                
                for cell in potential_Moved_Set {
                    cell.handleVisibleStateChange(type: .deActivate_Potential_Set)
                }
                
                currNoteCollection.write_Note_Data(cellSetParam: potential_Moved_Set)
            }
            nil_Cell_Sets()
        }
    }
    
}

protocol P_Selectable_Mode {
    var mode_Active : Bool{get set}
    func activate_Mode(activationCell : Underlying_Data_Cell?)
    func deactivate_Mode()
}




//    var move_Note_Cursor_Set = Set<Underlying_Data_Cell>(){
//        willSet {
//            let delta = move_Note_Cursor_Set.symmetricDifference(newValue)
//            for cell in delta {
//                cell.handleVisibleStateChange(type: .deActivate_MoveNote_Cursor_Set)
//            }
//        }
//        didSet {
//            if Central_State.Static_Central_State.currentPatternMode == .move_Mode {
//                var nillableNote : Note? = nil
//                for cell in move_Note_Cursor_Set {
//                    cell.handleVisibleStateChange(type: .activate_MoveNote_Cursor_Set)
//                    if let lclNote = cell.note_Im_In {
//                        nillableNote = lclNote
//                    }
//                }
//
//                if let lclNoteCollection = Central_State.Static_Central_State.note_Collection_Ref {
//                    if let lclNillableNote = nillableNote {
//                        lclNoteCollection.note_Collection_Highlight_Handler(noteParam: lclNillableNote)
//                    }
//                    else if nillableNote == nil {
//                        lclNoteCollection.note_Collection_Highlight_Handler(noteParam: nil)
//                    }
//                }
//
//            }
//        }
//    }
