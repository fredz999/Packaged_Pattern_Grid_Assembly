//
//  Move_Helper.swift
//  
//
//  Created by Jon on 27/02/2023.
//

import Foundation
import SwiftUI

class Move_Helper: P_Selectable_Mode {
    
    let dimensions = ComponentDimensions.StaticDimensions
    
    var mode_Active: Bool = false

    var moving_Cell_Set_Holder_Array : [Moving_Cell_Set_Holder] = []
    
    func activate_Mode(activationCell: Underlying_Data_Cell?) {
        if mode_Active == false {
            mode_Active = true
            if let lclActivationCell = activationCell{
                
                snapshot_Cursor_X = lclActivationCell.dataCell_X_Number
                snapshot_Cursor_Y = lclActivationCell.dataCell_Y_Number
                
                if let lclCurrNoteCollection = parentCentralState.currentNoteCollection {
                    let selectedNotes = lclCurrNoteCollection.noteArray.filter{$0.highlighted == true}
                    
                    for selectedNote in selectedNotes {
                        let note_Movement_SnapShot = Note_Movement_SnapShot(note_Low_Index: selectedNote.lowest_Index
                        , note_High_Index: selectedNote.highest_Index, note_Y_Index_Param: selectedNote.note_Y_Number
                        , snapshotNoteIdParam: selectedNote.id)
                        let movingCellSetHolder = Moving_Cell_Set_Holder(initial_Snapshot_Param: note_Movement_SnapShot)
                        moving_Cell_Set_Holder_Array.append(movingCellSetHolder)
                    }
                    
                }
            }
        }
    }
    
    func deactivate_Mode() {
        if mode_Active == true {
            mode_Active=false
            writeMovedNote_DeleteOldNote()
        }
    }
    
    func enptyNoteSnapshots(){}
    
    var parentCentralState : Central_State

    var snapshot_Cursor_X : Int?
    var snapshot_Cursor_Y : Int?
    
    var currLeftLimit : Int
    var currRightLimit : Int
    var lineBelowOpen : Bool
    var lineAboveOpen : Bool

    init(parentCentral_State_Param:Central_State){
        parentCentralState = parentCentral_State_Param
        currLeftLimit = 0
        currRightLimit = dimensions.dataGrid_X_Unit_Count-1
        lineBelowOpen = true
        lineAboveOpen = true
    }
    
    func movement_With_Multi_Note_Selected(){
        for m in 0..<moving_Cell_Set_Holder_Array.count{
            var proposedSet = Set<Underlying_Data_Cell>()
            if let lclSnapshot_X = snapshot_Cursor_X,let lclSnapshot_Y = snapshot_Cursor_Y {
                let delta_X_Grid_Units = parentCentralState.curr_Data_Pos_X - lclSnapshot_X
                let delta_Y_Grid_Units = parentCentralState.curr_Data_Pos_Y - lclSnapshot_Y
                let proposedNewYNumber = moving_Cell_Set_Holder_Array[m].initial_Snapshot.note_Y_Index + delta_Y_Grid_Units
                
                let proposedNewMinIndex = moving_Cell_Set_Holder_Array[m].initial_Snapshot.note_Low_Index + delta_X_Grid_Units
                let proposedNewMaxIndex = moving_Cell_Set_Holder_Array[m].initial_Snapshot.note_High_Index + delta_X_Grid_Units

                let newLineSet : Set<Underlying_Data_Cell>
                = Set(parentCentralState.data_Grid.dataLineArray[proposedNewYNumber].dataCellArray)
                if proposedNewMinIndex >= currLeftLimit && proposedNewMaxIndex <= currRightLimit {
                    proposedSet = newLineSet
                    .filter{$0.dataCell_X_Number >= proposedNewMinIndex && $0.dataCell_X_Number <= proposedNewMaxIndex}
                }
                else if proposedNewMinIndex < currLeftLimit {
                    proposedSet = parentCentralState.currLineSet
                    .filter{$0.dataCell_X_Number >= currLeftLimit
                    && $0.dataCell_X_Number <= (moving_Cell_Set_Holder_Array[m].initial_Snapshot.note_High_Index - moving_Cell_Set_Holder_Array[m].initial_Snapshot.note_Low_Index)}
                }
                else if proposedNewMaxIndex > currRightLimit {
                    proposedSet = parentCentralState.currLineSet
                    .filter{$0.dataCell_X_Number >=  currRightLimit-(moving_Cell_Set_Holder_Array[m].initial_Snapshot.note_High_Index - moving_Cell_Set_Holder_Array[m].initial_Snapshot.note_Low_Index)
                    && $0.dataCell_X_Number <= currRightLimit
                    }
                }
                moving_Cell_Set_Holder_Array[m].potential_Moved_Set = proposedSet
                moving_Cell_Set_Holder_Array[m].prohibition_Indicator_Set = moving_Cell_Set_Holder_Array[m].potential_Moved_Set.filter({$0.note_Im_In != nil})
            }
        }
    }

    func writeMovedNote_DeleteOldNote(){
        
        for moving_Cell_Set in moving_Cell_Set_Holder_Array{
            
            if moving_Cell_Set.potential_Moved_Set.count > 0 {
                if let currNoteCollection = parentCentralState.currentNoteCollection {
                    
                    currNoteCollection.delete_Note_By_Id(note_Id_Param: moving_Cell_Set.initial_Snapshot.snapShot_Note_Id_Param)
                    
                    for cell in moving_Cell_Set.potential_Moved_Set{
                        cell.handleVisibleStateChange(type: .deActivate_Potential_Set)
                    }
                    
                    currNoteCollection.write_Note_Data(cellSetParam: moving_Cell_Set.potential_Moved_Set, fromMultiMove: true)
                    // add it to the moving stuff thing in here - until move mode goes aff
                    
                }
            }
        }
        nil_Cell_Sets()
    }
    
    func nil_Cell_Sets(){
        if let lclNoteCollection = parentCentralState.currentNoteCollection{
            for note in lclNoteCollection.noteArray{
                if note.note_Is_Pre_MultiSelected == true{print("note: ",note.id," is in a multiselect")}
                else if note.note_Is_Pre_MultiSelected != true{print("note: ",note.id," is not in a multiselect")}
            }
        }
        moving_Cell_Set_Holder_Array.removeAll()
    }
    
}

protocol P_Selectable_Mode {
    var mode_Active : Bool{get set}
    func activate_Mode(activationCell : Underlying_Data_Cell?)
    func deactivate_Mode()
}

class Note_Movement_SnapShot{
    var note_Low_Index : Int
    var note_High_Index : Int
    var note_Y_Index : Int
    var snapShot_Note_Id_Param : UUID
    init(note_Low_Index: Int, note_High_Index: Int,note_Y_Index_Param:Int,snapshotNoteIdParam:UUID) {
        self.note_Low_Index = note_Low_Index
        self.note_High_Index = note_High_Index
        snapShot_Note_Id_Param = snapshotNoteIdParam
        note_Y_Index = note_Y_Index_Param
    }
}

class Moving_Cell_Set_Holder {
    
    var initial_Snapshot : Note_Movement_SnapShot
    
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
    
    init(initial_Snapshot_Param:Note_Movement_SnapShot){
        initial_Snapshot = initial_Snapshot_Param
    }
    
    func updateSet(newSet:Set<Underlying_Data_Cell>){
            potential_Moved_Set = newSet
            prohibition_Indicator_Set = potential_Moved_Set.filter({$0.note_Im_In != nil})
        }

}
