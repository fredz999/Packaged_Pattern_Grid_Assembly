//
//  Move_Helper.swift
//  
//
//  Created by Jon on 27/02/2023.
//

import Foundation
import SwiftUI

class Move_Helper: P_Selectable_Mode {
    
    var selectableModeId: Int
    
    let dimensions = ComponentDimensions.StaticDimensions
    
    var mode_Active: Bool = false
    
    var moving_Cell_Set_Holder_Array : [Moving_Cell_Set_Holder] = []

    func activate_Mode(activationCell: Underlying_Data_Cell?) {
        if mode_Active == false {
            mode_Active = true
            if let lclActivationCell = activationCell{
                
                if let currCursorMin = parentCentralState.current_Cursor_Set.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                    snapshot_Cursor_Min_X = currCursorMin.dataCell_X_Number
                }
                snapshot_Cursor_Y = lclActivationCell.parentLine.line_Y_Num

                if let lclCurrNoteCollection = parentCentralState.currentNoteCollection {
                    let selectedNotes = lclCurrNoteCollection.noteArray.filter{$0.highlighted == true}
                    
                    for selectedNote in selectedNotes {
                        if let lclModifiable_Note_Data = selectedNote.modifiable_Note_Data{
                            let note_Movement_SnapShot = Note_Movement_SnapShot(note_Low_Index: lclModifiable_Note_Data.lowest_X_Index
                            , note_High_Index: lclModifiable_Note_Data.highest_X_Index
                            , note_Y_Index_Param: lclModifiable_Note_Data.containing_Data_Line.line_Y_Num
                            , snapshotNoteIdParam: selectedNote.id)
                            let movingCellSetHolder = Moving_Cell_Set_Holder(initial_Snapshot_Param: note_Movement_SnapShot, noteParam: selectedNote)
                            moving_Cell_Set_Holder_Array.append(movingCellSetHolder)
                        }
                    }
                    // TODO: set cursor movemode
                    for line in parentCentralState.data_Grid.dataLineArray{
                        for cell in line.dataCellArray{
                            //cell.alterCursorState(thisCellInNote: nil, rewritePermitted: nil, cursorMoveMode: .in_Move)
                            cell.alterCursorState(thisCellInNote: nil, cell_In_Moving_Prohibition: nil, cell_In_Clashing_Prohibition: nil, cursorMoveMode: .in_Move)
                        }
                    }
                    if dont_Copy_Just_Move == true {
                        // TODO: set cursor movemode
                        for line in parentCentralState.data_Grid.dataLineArray{
                            for cell in line.dataCellArray{
                                //cell.alterCursorState(thisCellInNote: nil, rewritePermitted: nil, cursorMoveMode: .in_Move_Copy)
                                cell.alterCursorState(thisCellInNote: nil, cell_In_Moving_Prohibition: nil, cell_In_Clashing_Prohibition: nil, cursorMoveMode: .in_Move_Copy)
                            }
                        }
                        for selectedNote in selectedNotes {
                            if let lclNoteData = selectedNote.modifiable_Note_Data {
                                if lclNoteData.noteParent.moved_Away_From == false{
                                    lclNoteData.noteParent.moved_Away_From = true
                                }
                            }
                        }
                    }
                    
                    
                }
            }
        }
    }
    
    func generateModeDescriptorString() -> String {
        var retVal = "Move Mode"
        if dont_Copy_Just_Move == false {
            retVal = "Copy Mode"
        }
        return retVal
    }
    
    func deactivate_Mode() {
        if mode_Active == true {
            mode_Active=false
            persist_New_Note_Data()
        }
    }
    
    public var dont_Copy_Just_Move : Bool = true
    
    var parentCentralState : Central_State
    var snapshot_Cursor_Min_X : Int?
    var snapshot_Cursor_Y : Int?
    
    var currLeftLimit_Move : Int
    var currRightLimit_Move : Int
    var lineBelowOpen : Bool
    var lineAboveOpen : Bool

    init(parentCentral_State_Param:Central_State,selectableModeIdParam:Int){
        selectableModeId = selectableModeIdParam
        parentCentralState = parentCentral_State_Param
        currLeftLimit_Move = 0
        currRightLimit_Move = dimensions.dataGrid_X_Unit_Count-1
        lineBelowOpen = true
        lineAboveOpen = true
    }
    
    func movement_With_Multi_Note_Selected(){
        
        if parentCentralState.curr_Cursor_Min_Data_Pos_X != snapshot_Cursor_Min_X
            || parentCentralState.curr_Data_Pos_Y != snapshot_Cursor_Y {
            if let collection = parentCentralState.currentNoteCollection {
                collection.deHighlightCollection()
            }
        }
        for m in 0..<moving_Cell_Set_Holder_Array.count {
            var proposedSet = Set<Underlying_Data_Cell>()
            
            if let lclSnapshot_X = snapshot_Cursor_Min_X,let lclSnapshot_Y = snapshot_Cursor_Y {
                let delta_X_Grid_Units = parentCentralState.curr_Cursor_Min_Data_Pos_X - lclSnapshot_X
                let delta_Y_Grid_Units = parentCentralState.curr_Data_Pos_Y - lclSnapshot_Y
                let proposedNewYNumber = moving_Cell_Set_Holder_Array[m].initial_Snapshot.note_Y_Index + delta_Y_Grid_Units
                
                let proposedNewMinIndex = moving_Cell_Set_Holder_Array[m].initial_Snapshot.note_Low_Index + delta_X_Grid_Units
                let proposedNewMaxIndex = moving_Cell_Set_Holder_Array[m].initial_Snapshot.note_High_Index + delta_X_Grid_Units
                
                let newLineSet : Set<Underlying_Data_Cell>
                = Set(parentCentralState.data_Grid.dataLineArray[proposedNewYNumber].dataCellArray)
                

                if proposedNewMinIndex >= currLeftLimit_Move && proposedNewMaxIndex <= currRightLimit_Move {
                    proposedSet = newLineSet
                    .filter{$0.dataCell_X_Number >= proposedNewMinIndex && $0.dataCell_X_Number <= proposedNewMaxIndex}
                }
                else if proposedNewMinIndex < currLeftLimit_Move {
                    proposedSet = parentCentralState.currLineSet
                    .filter{$0.dataCell_X_Number >= currLeftLimit_Move
                    && $0.dataCell_X_Number <= (moving_Cell_Set_Holder_Array[m].initial_Snapshot.note_High_Index - moving_Cell_Set_Holder_Array[m].initial_Snapshot.note_Low_Index)}
                }
                else if proposedNewMaxIndex > currRightLimit_Move {
                    proposedSet = parentCentralState.currLineSet
                    .filter{$0.dataCell_X_Number >=  currRightLimit_Move-(moving_Cell_Set_Holder_Array[m].initial_Snapshot.note_High_Index - moving_Cell_Set_Holder_Array[m].initial_Snapshot.note_Low_Index)
                    && $0.dataCell_X_Number <= currRightLimit_Move
                    }
                }
                if dont_Copy_Just_Move == true {
                    moving_Cell_Set_Holder_Array[m].potential_Moved_Set = proposedSet
                    let clashedSet = proposedSet.filter({$0.note_Im_In != moving_Cell_Set_Holder_Array[m].noteImIn && $0.note_Im_In != nil})
                    moving_Cell_Set_Holder_Array[m].prohibition_Indicator_Set = clashedSet
                }
                else if dont_Copy_Just_Move == false {
                    moving_Cell_Set_Holder_Array[m].potential_Moved_Set = proposedSet
//                    moving_Cell_Set_Holder_Array[m].prohibition_Indicator_Set = moving_Cell_Set_Holder_Array[m]
//                    .potential_Moved_Set.filter({$0.note_Im_In != nil})
                }
            }
        }
    }

    func persist_New_Note_Data(){

            if dont_Copy_Just_Move == true {
                for moving_Cell_Set in moving_Cell_Set_Holder_Array {
                    if moving_Cell_Set.noteImIn.moved_Away_From == true {
                        moving_Cell_Set.noteImIn.moved_Away_From = false
                    }
                    if moving_Cell_Set.movingNoteCurrentlyWriteable == true {
                        if let modNoteData = moving_Cell_Set.noteImIn.modifiable_Note_Data {
                            modNoteData.reWrite_Note_Data(newDataCellSet: moving_Cell_Set.potential_Moved_Set)
                        }
                    }
                    else if moving_Cell_Set.movingNoteCurrentlyWriteable == false {
                        for cell in moving_Cell_Set.potential_Moved_Set {
                            if cell.in_Prohibited_Clashing_Cell_Set == true {
                                cell.handleVisibleStateChange(type: .deActivate_Prohibited_Clashing_Cell)

                            }
                            if cell.in_Prohibited_Moving_Cell_Set == true {
                                cell.handleVisibleStateChange(type: .deActivate_Prohibited_Moving_Cell)

                            }
                            if cell.in_Potential_Set == true {
                                cell.handleVisibleStateChange(type: .deActivate_Potential_Set)

                            }
                        }
                    }
                }
            }
            else if dont_Copy_Just_Move == false {
                for moving_Cell_Set in moving_Cell_Set_Holder_Array {
                    
                    if moving_Cell_Set.noteImIn.moved_Away_From == true {
                        moving_Cell_Set.noteImIn.moved_Away_From = false
                    }
                    
                    if moving_Cell_Set.movingNoteCurrentlyWriteable == true {
                        for cell in moving_Cell_Set.potential_Moved_Set {
                            cell.handleVisibleStateChange(type: .deActivate_Potential_Set)
                        }
                        if let currNoteCollection = parentCentralState.currentNoteCollection {
                            currNoteCollection.write_Note_Data(cellSetParam: moving_Cell_Set.potential_Moved_Set, highlightAfterWrite: true)
                        }
                    }
                    else if moving_Cell_Set.movingNoteCurrentlyWriteable == false {
                        for cell in moving_Cell_Set.potential_Moved_Set {
                            if cell.in_Prohibited_Clashing_Cell_Set == true {
                                cell.handleVisibleStateChange(type: .deActivate_Prohibited_Clashing_Cell)
                            }
                            if cell.in_Prohibited_Moving_Cell_Set == true {
                                cell.handleVisibleStateChange(type: .deActivate_Prohibited_Moving_Cell)
                            }
                            if cell.in_Potential_Set == true {
                                cell.handleVisibleStateChange(type: .deActivate_Potential_Set)
                            }
                        }
                    }
                }
            }
            nil_Cell_Sets()

    }
    
    func nil_Cell_Sets(){
        moving_Cell_Set_Holder_Array.removeAll()
        currLeftLimit_Move = 0
        currRightLimit_Move = dimensions.dataGrid_X_Unit_Count-1
    }
    
}

protocol P_Selectable_Mode {
    var selectableModeId : Int{get set}
    var mode_Active : Bool{get set}
    func activate_Mode(activationCell : Underlying_Data_Cell?)
    func generateModeDescriptorString()->String
    func deactivate_Mode()
}




// ================================================================================================================
// ================================================================================================================
// ================================================================================================================


