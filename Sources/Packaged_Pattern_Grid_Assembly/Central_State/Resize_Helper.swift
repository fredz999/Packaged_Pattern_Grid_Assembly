//
//  Resize_Helper.swift
//  
//
//  Created by Jon on 22/03/2023.
//

import Foundation
import SwiftUI

class Resize_Helper: P_Selectable_Mode {
    
    var selectableModeId: Int
    
    let dimensions = ComponentDimensions.StaticDimensions
    
    var mode_Active: Bool = false

    var select_Highlighted_Notes : [Note] = []
    
    func activate_Mode(activationCell: Underlying_Data_Cell?) {
        if mode_Active == false {
            mode_Active = true
            if let lclActivationCell = activationCell{
                snapshot_Cursor_X = lclActivationCell.dataCell_X_Number
                snapshot_Cursor_Y = lclActivationCell.dataCell_Y_Number
                move_Slider_To_Last_Cell_In_Note()
            }
        }
    }
    
    func move_Slider_To_Last_Cell_In_Note(){
        if let lclNoteCollection = parentCentralState.currentNoteCollection {
            if let lcl_Note_At_Cursor = lclNoteCollection.note_Currently_Under_Cursor {
                if let hSliderRef = parentCentralState.h_Slider_Ref {
                    let destinationCellIndex = lcl_Note_At_Cursor.highest_Index - ((dimensions.pattern_Grid_Cell_Sub_Unit_Count/2)-1)
                    hSliderRef.jumpToACell(cellNum: destinationCellIndex)
                }
            }
        }
    }
    
    func resizeReactToHsliderMove(){
        if let lclSnapShotX = snapshot_Cursor_X {
            let delta_X = parentCentralState.currentData.dataCell_X_Number - lclSnapShotX
            if let lclNoteCollection = parentCentralState.currentNoteCollection {
                if let lcl_Note_At_Cursor = lclNoteCollection.note_Currently_Under_Cursor {
                    lcl_Note_At_Cursor.resizeLength(cellDelta: delta_X)
                }
            }
        }
    }
    
    func deactivate_Mode() {
        if mode_Active == true {
            print("commit all outstanding changes")
            mode_Active=false
        }
    }
    
    var parentCentralState : Central_State

    var snapshot_Cursor_X : Int?
    var snapshot_Cursor_Y : Int?
    
    var currLeftLimit : Int
    var currRightLimit : Int

    init(parentCentral_State_Param:Central_State,selectableModeIdParam:Int){
        selectableModeId = selectableModeIdParam
        parentCentralState = parentCentral_State_Param
        currLeftLimit = 0
        currRightLimit = dimensions.dataGrid_X_Unit_Count-1
    }
    
    

    //this happens with x slider
//    func resize(){
//        for note in select_Highlighted_Notes{
//            note.shortenToNearestViableUnit()
//        }
//    }
    
//    func resize(){
//        for m in 0..<moving_Cell_Set_Holder_Array.count{
//            var proposedSet = Set<Underlying_Data_Cell>()
//            if let lclSnapshot_X = snapshot_Cursor_X,let lclSnapshot_Y = snapshot_Cursor_Y {
//                let delta_X_Grid_Units = parentCentralState.curr_Data_Pos_X - lclSnapshot_X
//                let delta_Y_Grid_Units = parentCentralState.curr_Data_Pos_Y - lclSnapshot_Y
//                let proposedNewYNumber = moving_Cell_Set_Holder_Array[m].initial_Snapshot.note_Y_Index + delta_Y_Grid_Units
//
//                let proposedNewMinIndex = moving_Cell_Set_Holder_Array[m].initial_Snapshot.note_Low_Index + delta_X_Grid_Units
//                let proposedNewMaxIndex = moving_Cell_Set_Holder_Array[m].initial_Snapshot.note_High_Index + delta_X_Grid_Units
//
//                let newLineSet : Set<Underlying_Data_Cell>
//                = Set(parentCentralState.data_Grid.dataLineArray[proposedNewYNumber].dataCellArray)
//                if proposedNewMinIndex >= currLeftLimit && proposedNewMaxIndex <= currRightLimit {
//                    proposedSet = newLineSet
//                    .filter{$0.dataCell_X_Number >= proposedNewMinIndex && $0.dataCell_X_Number <= proposedNewMaxIndex}
//                }
//                else if proposedNewMinIndex < currLeftLimit {
//                    proposedSet = parentCentralState.currLineSet
//                    .filter{$0.dataCell_X_Number >= currLeftLimit
//                    && $0.dataCell_X_Number <= (moving_Cell_Set_Holder_Array[m].initial_Snapshot.note_High_Index - moving_Cell_Set_Holder_Array[m].initial_Snapshot.note_Low_Index)}
//                }
//                else if proposedNewMaxIndex > currRightLimit {
//                    proposedSet = parentCentralState.currLineSet
//                    .filter{$0.dataCell_X_Number >=  currRightLimit-(moving_Cell_Set_Holder_Array[m].initial_Snapshot.note_High_Index - moving_Cell_Set_Holder_Array[m].initial_Snapshot.note_Low_Index)
//                    && $0.dataCell_X_Number <= currRightLimit
//                    }
//                }
//                moving_Cell_Set_Holder_Array[m].potential_Moved_Set = proposedSet
//                moving_Cell_Set_Holder_Array[m].prohibition_Indicator_Set = moving_Cell_Set_Holder_Array[m].potential_Moved_Set.filter({$0.note_Im_In != nil})
//            }
//        }
//    }
    
}








//func movement_With_Multi_Note_Selected(){
//    for m in 0..<moving_Cell_Set_Holder_Array.count{
//        var proposedSet = Set<Underlying_Data_Cell>()
//        if let lclSnapshot_X = snapshot_Cursor_X,let lclSnapshot_Y = snapshot_Cursor_Y {
//            let delta_X_Grid_Units = parentCentralState.curr_Data_Pos_X - lclSnapshot_X
//            let delta_Y_Grid_Units = parentCentralState.curr_Data_Pos_Y - lclSnapshot_Y
//            let proposedNewYNumber = moving_Cell_Set_Holder_Array[m].initial_Snapshot.note_Y_Index + delta_Y_Grid_Units
//
//            let proposedNewMinIndex = moving_Cell_Set_Holder_Array[m].initial_Snapshot.note_Low_Index + delta_X_Grid_Units
//            let proposedNewMaxIndex = moving_Cell_Set_Holder_Array[m].initial_Snapshot.note_High_Index + delta_X_Grid_Units
//
//            let newLineSet : Set<Underlying_Data_Cell>
//            = Set(parentCentralState.data_Grid.dataLineArray[proposedNewYNumber].dataCellArray)
//            if proposedNewMinIndex >= currLeftLimit && proposedNewMaxIndex <= currRightLimit {
//                proposedSet = newLineSet
//                .filter{$0.dataCell_X_Number >= proposedNewMinIndex && $0.dataCell_X_Number <= proposedNewMaxIndex}
//            }
//            else if proposedNewMinIndex < currLeftLimit {
//                proposedSet = parentCentralState.currLineSet
//                .filter{$0.dataCell_X_Number >= currLeftLimit
//                && $0.dataCell_X_Number <= (moving_Cell_Set_Holder_Array[m].initial_Snapshot.note_High_Index - moving_Cell_Set_Holder_Array[m].initial_Snapshot.note_Low_Index)}
//            }
//            else if proposedNewMaxIndex > currRightLimit {
//                proposedSet = parentCentralState.currLineSet
//                .filter{$0.dataCell_X_Number >=  currRightLimit-(moving_Cell_Set_Holder_Array[m].initial_Snapshot.note_High_Index - moving_Cell_Set_Holder_Array[m].initial_Snapshot.note_Low_Index)
//                && $0.dataCell_X_Number <= currRightLimit
//                }
//            }
//            moving_Cell_Set_Holder_Array[m].potential_Moved_Set = proposedSet
//            moving_Cell_Set_Holder_Array[m].prohibition_Indicator_Set = moving_Cell_Set_Holder_Array[m].potential_Moved_Set.filter({$0.note_Im_In != nil})
//        }
//    }
//}
