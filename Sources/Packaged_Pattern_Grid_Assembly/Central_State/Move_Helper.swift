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
            if let lclActivationCell = activationCell{
                snapshot_Cursor_X = lclActivationCell.dataCell_X_Number
                if let lclCurrNoteCollection = parentCentralState.currentNoteCollection {
                    let selectedNotes = lclCurrNoteCollection.noteArray.filter{$0.highlighted == true}
                    
                    for selectedNote in selectedNotes {
                        let note_Movement_SnapShot = Note_Movement_SnapShot(note_Low_Index: selectedNote.lowest_Index
                        , note_High_Index: selectedNote.highest_Index
                        , snapshotNoteIdParam: selectedNote.id)
                        noteSnapShotArray.append(note_Movement_SnapShot)
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
    
    let dimensions = ComponentDimensions.StaticDimensions
    
    var noteSnapShotArray : [Note_Movement_SnapShot] = []

//    var note_Low_Index : Int?
//    var note_High_Index : Int?
    var snapshot_Cursor_X : Int?
    
//    var note_Low_Index_Array : [Int] = []
//    var note_High_Index_lowNote_Array : [Int] = []
//    var snapshot_Cursor_X_Array : [Int] = []
    //var snapShot_Note_Id_Param : UUID?
    
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
    
//    func movement_With_Single_Note_Selected(){
//        if let lclNote_Low_Index = note_Low_Index, let lclNote_High_Index = note_High_Index
//        ,let lclSnapshot_X = snapshot_Cursor_X
//        {
//
//        let delta_X_Grid_Units = parentCentralState.curr_Data_Pos_X - lclSnapshot_X
//
//        let proposedNewMinIndex = lclNote_Low_Index + delta_X_Grid_Units
//        let proposedNewMaxIndex = lclNote_High_Index + delta_X_Grid_Units
//
//        if proposedNewMinIndex >= currLeftLimit && proposedNewMaxIndex <= currRightLimit {
//            proposedSet = parentCentralState.currLineSet
//            .filter{$0.dataCell_X_Number >= proposedNewMinIndex && $0.dataCell_X_Number <= proposedNewMaxIndex}
//        }
//        else if proposedNewMinIndex < currLeftLimit {
//            proposedSet = parentCentralState.currLineSet
//            .filter{$0.dataCell_X_Number >= currLeftLimit && $0.dataCell_X_Number <= (lclNote_High_Index - lclNote_Low_Index)}
//        }
//        else if proposedNewMaxIndex > currRightLimit {
//            proposedSet = parentCentralState.currLineSet
//            .filter{$0.dataCell_X_Number >=  currRightLimit-(lclNote_High_Index - lclNote_Low_Index)
//                && $0.dataCell_X_Number <= currRightLimit
//            }
//        }
//
//        potential_Moved_Set = proposedSet
//
//        prohibition_Indicator_Set = proposedSet.filter({$0.note_Im_In != nil})
//
//        }
//
//    }

    
    func movement_With_Multi_Note_Selected(){
        
        for moving_Note in noteSnapShotArray{
            
            if let lclSnapshot_X = snapshot_Cursor_X {
                let delta_X_Grid_Units = parentCentralState.curr_Data_Pos_X - lclSnapshot_X
                let proposedNewMinIndex = moving_Note.note_Low_Index + delta_X_Grid_Units
                let proposedNewMaxIndex = moving_Note.note_High_Index + delta_X_Grid_Units

                if proposedNewMinIndex >= currLeftLimit && proposedNewMaxIndex <= currRightLimit {
                    proposedSet = parentCentralState.currLineSet
                    .filter{$0.dataCell_X_Number >= proposedNewMinIndex && $0.dataCell_X_Number <= proposedNewMaxIndex}
                }
                else if proposedNewMinIndex < currLeftLimit {
                    proposedSet = parentCentralState.currLineSet
                    .filter{$0.dataCell_X_Number >= currLeftLimit && $0.dataCell_X_Number <= (moving_Note.note_High_Index - moving_Note.note_Low_Index)}
                }
                else if proposedNewMaxIndex > currRightLimit {
                    proposedSet = parentCentralState.currLineSet
                    .filter{$0.dataCell_X_Number >=  currRightLimit-(moving_Note.note_High_Index - moving_Note.note_Low_Index)
                        && $0.dataCell_X_Number <= currRightLimit
                    }
                }
                    
//                let newSet = potential_Moved_Set.union(proposedSet)
//                potential_Moved_Set = newSet
                //= proposedSet
                //prohibition_Indicator_Set = proposedSet.filter({$0.note_Im_In != nil})
                potential_Moved_Set = proposedSet
            }
        }
        prohibition_Indicator_Set = potential_Moved_Set.filter({$0.note_Im_In != nil})
        

    }
    
    
    
    func nil_Cell_Sets(){

//        if note_Low_Index != nil{note_Low_Index = nil}
//
//        if note_High_Index != nil{note_High_Index = nil}
//
//        if snapshot_Cursor_X != nil{snapshot_Cursor_X = nil}
//
//        if snapShot_Note_Id_Param != nil{snapShot_Note_Id_Param = nil}
        
        noteSnapShotArray.removeAll()

        if proposedSet.count > 0 {
            proposedSet.removeAll()
        }
        if prohibition_Indicator_Set.count > 0 {
            prohibition_Indicator_Set.removeAll()
        }
        if potential_Moved_Set.count > 0 {
            potential_Moved_Set.removeAll()
        }

    }
    
    func writeMovedNote_DeleteOldNote(){
        for note_Snapshot in noteSnapShotArray {
            if potential_Moved_Set.count > 0{
                //, let lclSnapshotNote = note_Snapshot.snapShot_Note_Id_Param {

                if let currNoteCollection = parentCentralState.currentNoteCollection {
                    
                    currNoteCollection.delete_Note_By_Id(note_Id_Param: note_Snapshot.snapShot_Note_Id_Param)
                    
                    for cell in potential_Moved_Set {
                        cell.handleVisibleStateChange(type: .deActivate_Potential_Set)
                    }
                    
                    currNoteCollection.write_Note_Data(cellSetParam: potential_Moved_Set)
                }
                nil_Cell_Sets()
            }
        }
        
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
    var snapShot_Note_Id_Param : UUID
    init(note_Low_Index: Int, note_High_Index: Int,snapshotNoteIdParam:UUID) {
        self.note_Low_Index = note_Low_Index
        self.note_High_Index = note_High_Index
        snapShot_Note_Id_Param = snapshotNoteIdParam
    }
}
