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
                    //lcl_Note_At_Cursor.resizeLength(cellDelta: delta_X)
                    
                    
                        let gridLine = parentCentralState.data_Grid.dataLineArray[parentCentralState.curr_Data_Pos_Y]
                        currLineSet = Set(gridLine.dataCellArray)

                        if delta_X > 0 {

                            if dimensions.patternTimingConfiguration == .fourFour {
                                
                                let upperHalfCellSet = currLineSet.filter({$0.four_Four_Half_Cell_Index == parentCentralState.currentData.four_Four_Half_Cell_Index})
                                
                                if let maxUpper = upperHalfCellSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                                
                                    new_Note_Cell_Set = currLineSet.filter{$0.dataCell_X_Number >= lcl_Note_At_Cursor.highest_Index && $0.dataCell_X_Number <= maxUpper.dataCell_X_Number}
                                    the_Rest = currLineSet.subtracting(new_Note_Cell_Set)
                                    
                                    for cell in new_Note_Cell_Set {
                                        if cell.in_Resize_Set == false {
                                            cell.handleVisibleStateChange(type: .activate_Resize_Set)
                                        }
                                    }
                                    for cell in the_Rest {
                                        if cell.in_Resize_Set == true {
                                            cell.handleVisibleStateChange(type: .deActivate_Resize_Set)
                                        }
                                    }
                                    
                                }
                            }
                        }
                //        dataCellArray[lastElement].change_Type(newType: .mid_Note)
                //        dataCellArray[lastElement].change_Highlight(highlightStatusParam: true)
                //
                //        let next_1 = dataCellArray[lastElement].dataCell_X_Number+1
                //        let new_Cell_1 = parent_Note_Collection.parentCentralState.data_Grid.dataLineArray[note_Y_Number].dataCellArray[next_1]
                //        new_Cell_1.change_Type(newType: .mid_Note)
                //        new_Cell_1.note_Im_In = parent_Note_Collection.note_Currently_Under_Cursor
                //        new_Cell_1.change_Highlight(highlightStatusParam: true)
                //        dataCellArray.append(new_Cell_1)
                        

                    
                    
                }
            }
        }
    }
    
    var new_Note_Cell_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    var the_Rest : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    var currLineSet : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()

    func commitOutStandingChanges(){
        
    }
    
    func deactivate_Mode() {
        if mode_Active == true {
            
            if let lclNoteCollection = parentCentralState.currentNoteCollection {
                if let lcl_Note_At_Cursor = lclNoteCollection.note_Currently_Under_Cursor {
                    print("commit all outstanding changes")
                    let cellArray = lcl_Note_At_Cursor.dataCellArray
                    
                    cellArray[cellArray.count-1].change_Type(newType: .mid_Note)
                    
                    //dataCellArray[lastElement].change_Highlight(highlightStatusParam: true)
                    //new_Note_Cell_Set
                    let newMax = new_Note_Cell_Set.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                    let midSet = new_Note_Cell_Set.filter{$0 != newMax}
                    for cell in midSet{
                        cell.change_Type(newType: .mid_Note)
                    }
                    newMax?.change_Type(newType: .end_Note)
                    let combinedAdditionSet = Set<Underlying_Data_Cell>(cellArray).union(new_Note_Cell_Set)
                    let newArray = combinedAdditionSet.sorted(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}) //Array(combinedAdditionSet)
//                    for n in newArray {
//                        print("n: ",n.dataCell_X_Number)
//                    }
                    lcl_Note_At_Cursor.dataCellArray = newArray
                    lcl_Note_At_Cursor.highlighted = true
                }
                else{
                    print("cursor outside of note.....")
                }
            }
            
            //dataCellArray[lastElement].change_Type(newType: .mid_Note)
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






//    func provisional_Note_Cell_Count_Alteration(cellDelta:Int){
//        let gridLine = parentCentralState.data_Grid.dataLineArray[parentCentralState.curr_Data_Pos_Y]
//        let currLineSet : Set<Underlying_Data_Cell> = Set(gridLine.dataCellArray)
//
//        if cellDelta > 0 {
//
//            if dimensions.patternTimingConfiguration == .fourFour {
//
//                let upperHalfCellSet = currLineSet.filter({$0.four_Four_Half_Cell_Index == centralState.currentData.four_Four_Half_Cell_Index})
//
//                if let maxUpper = upperHalfCellSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
//
//                new_Note_Cell_Set = currLineSet.filter{$0.dataCell_X_Number >= highest_Index && $0.dataCell_X_Number <= maxUpper.dataCell_X_Number}
//                the_Rest = currLineSet.subtracting(new_Note_Cell_Set)
//
//                    for cell in new_Note_Cell_Set{
//                        if cell.in_Resize_Set == false{
//                            cell.handleVisibleStateChange(type: .activate_Resize_Set)
//                        }
//                    }
//                    for cell in the_Rest {
//                        if cell.in_Resize_Set == true{
//                            cell.handleVisibleStateChange(type: .deActivate_Resize_Set)
//                        }
//                    }
//
//                }
//            }
//        }
////        dataCellArray[lastElement].change_Type(newType: .mid_Note)
////        dataCellArray[lastElement].change_Highlight(highlightStatusParam: true)
////
////        let next_1 = dataCellArray[lastElement].dataCell_X_Number+1
////        let new_Cell_1 = parent_Note_Collection.parentCentralState.data_Grid.dataLineArray[note_Y_Number].dataCellArray[next_1]
////        new_Cell_1.change_Type(newType: .mid_Note)
////        new_Cell_1.note_Im_In = parent_Note_Collection.note_Currently_Under_Cursor
////        new_Cell_1.change_Highlight(highlightStatusParam: true)
////        dataCellArray.append(new_Cell_1)
//
//
//    }

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
