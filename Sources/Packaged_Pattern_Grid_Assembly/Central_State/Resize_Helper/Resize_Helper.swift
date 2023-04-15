//
//  Resize_Helper.swift
//  
//
//  Created by Jon on 22/03/2023.
//

import Foundation
import SwiftUI

public class Resize_Helper: ObservableObject, P_Selectable_Mode {
    
    var selectableModeId: Int
    
    let dimensions = ComponentDimensions.StaticDimensions
    
    var parentCentralState : Central_State
    
    public init(parentCentral_State_Param:Central_State,selectableModeIdParam:Int){
        selectableModeId = selectableModeIdParam
        parentCentralState = parentCentral_State_Param
    }
    
    public var resizeSubMode : E_Resize_Mode = .rightSideSubMode {
        didSet {
            parentCentralState.mode_String = resizeSubMode.rawValue
        }
    }
    
    public var mode_Active: Bool = false
    func activate_Mode(activationCell: Underlying_Data_Cell?) {
        if mode_Active == false {
            mode_Active = true
        }
    }
    
    func generateModeDescriptorString () -> String {
        return resizeSubMode.rawValue
    }

    func handleDataEvaluation(){
        if resizeSubMode == .rightSideSubMode {
            if dimensions.patternTimingConfiguration == .fourFour{
                let currHalfCell = parentCentralState.currentData.four_Four_Half_Cell_Index
                get_Right_Side_Cursor_Delta(currentHalfCellIndexParam: currHalfCell)
            }
            else if dimensions.patternTimingConfiguration == .sixEight{
                let currHalfCell = parentCentralState.currentData.six_Eight_Half_Cell_Index
                get_Right_Side_Cursor_Delta(currentHalfCellIndexParam: currHalfCell)
            }
        }
        else if resizeSubMode == .leftSideSubMode {
            if dimensions.patternTimingConfiguration == .fourFour {
                let currHalfCell = parentCentralState.currentData.four_Four_Half_Cell_Index
                get_Left_Side_Cursor_Delta(currentHalfCellIndexParam: currHalfCell)
            }
            else if dimensions.patternTimingConfiguration == .sixEight{
                let currHalfCell = parentCentralState.currentData.six_Eight_Half_Cell_Index
                get_Left_Side_Cursor_Delta(currentHalfCellIndexParam: currHalfCell)
            }
        }
    }
    
    func deactivate_Mode() {
        if mode_Active == true {
            
            reWriteNotes()

            clear_Variables()
            
            mode_Active=false
        }
    }
    
    func clear_Variables(){
        
        for garage in left_Side_Resizer_Garage_Array{
            if let lclNoteRef = garage.noteReference{
                lclNoteRef.highlighted = true
                garage.noteReference = nil
            }
        }
        for garage in right_Side_Resizer_Garage_Array {
            if let lclNoteRef = garage.noteReference {
                lclNoteRef.highlighted = true
                garage.noteReference = nil
            }
        }
        
        left_Side_Resizer_Garage_Array.removeAll()
        right_Side_Resizer_Garage_Array.removeAll()
        
        if snapshot_Cells_Right_Of_Note_Set.count > 0{snapshot_Cells_Right_Of_Note_Set.removeAll()}
        if snapshot_Note_Cells_Right_Of_Note_Set.count > 0{snapshot_Note_Cells_Right_Of_Note_Set.removeAll()}
        
        if rightwardBarrierDataX != nil{rightwardBarrierDataX = nil}

        if snapshot_highest_Note_Half_Cell_Index != nil{snapshot_highest_Note_Half_Cell_Index = nil}
        if snapshot_Lowest_Note_Half_Cell_Index != nil{snapshot_Lowest_Note_Half_Cell_Index = nil}
        if current_Cursor_Set_Max_X != nil{current_Cursor_Set_Max_X = nil}
        if snapshot_Note_Min_X != nil{snapshot_Note_Min_X = nil}
        
        if snapshot_Group_MinHalfCellIndex != nil{snapshot_Group_MinHalfCellIndex = nil}
        if snapshot_Group_MaxHalfCellIndex != nil{snapshot_Group_MaxHalfCellIndex = nil}
        
    }
    
    var snapshot_Note_Max_X : Int?
    var snapshot_highest_Note_Half_Cell_Index : Int?
    var snapshot_Lowest_Note_Half_Cell_Index : Int?
    var current_Cursor_Set_Max_X : Int?
    var snapshot_Note_Min_X : Int?
    var snapshot_Cells_Right_Of_Note_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    var snapshot_Note_Cells_Right_Of_Note_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    var rightwardBarrierDataX : Int?
    
    // For each note ==============================================================
    var snapshot_Group_MinHalfCellIndex : Int?
    
    var snapshot_Group_MaxHalfCellIndex : Int?
    
    var left_Side_Resizer_Garage_Array : [Left_Side_Resizer_Garage] = []
    
    var right_Side_Resizer_Garage_Array : [Right_Side_Resizer_Garage] = []
    
    func left_Side_Resize_Start(){
        
        if let lclNoteCollection = parentCentralState.currentNoteCollection {

            let highlightSet = Set<Note>(lclNoteCollection.noteArray.filter{$0.highlighted == true})

            if dimensions.patternTimingConfiguration == .fourFour {
                for note in highlightSet {
                    if let lclModifiableNoteData = note.modifiable_Note_Data{
                        
                        
                        //let snapshot_Line_Set = Set<Underlying_Data_Cell>(note.containing_Data_Line.dataCellArray)
                        let snapshot_Line_Set = Set<Underlying_Data_Cell>(lclModifiableNoteData.containing_Data_Line.dataCellArray)
                        let snapshot_Note_Set = Set<Underlying_Data_Cell>(lclModifiableNoteData.dataCellArray)
                        let snapshot_Left_Cursor_Set = snapshot_Note_Set.filter{$0.four_Four_Half_Cell_Index == lclModifiableNoteData.lowestFourFourHalfCellIndex}
                        let snapshot_Cells_Left_Of_Note_Set = snapshot_Line_Set.filter{$0.four_Four_Half_Cell_Index < lclModifiableNoteData.lowestFourFourHalfCellIndex}
                        let snapshot_Note_Cells_Left_Of_Note_Set = snapshot_Cells_Left_Of_Note_Set.filter{$0.note_Im_In != nil}
                        if snapshot_Group_MinHalfCellIndex == nil{
                            if let lclNoteCollection = parentCentralState.currentNoteCollection {
                                if let lclCurrNoteUnderCursor = lclNoteCollection.note_Currently_Under_Cursor {
                                    if note.id == lclCurrNoteUnderCursor.id {
                                        snapshot_Group_MinHalfCellIndex = lclModifiableNoteData.lowestFourFourHalfCellIndex
                                        if let hSliderRef = parentCentralState.h_Slider_Ref {
                                            if let minCursorCell = snapshot_Left_Cursor_Set.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                                                let destinationCellIndex = minCursorCell.dataCell_X_Number
                                                hSliderRef.jumpToACell(cellNum: destinationCellIndex)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if snapshot_Note_Cells_Left_Of_Note_Set.count == 0 {
                            let newResizeGarage = Left_Side_Resizer_Garage(snapshotMinHalfCellIndex: lclModifiableNoteData.lowestFourFourHalfCellIndex
                            , snapshotMaxHalfCellIndex: lclModifiableNoteData.highestFourFourHalfCellIndex
                            , leftwardBarrierDataX: -1
                            , snapshot_Line_Set: snapshot_Line_Set, noteParam: note, resizeModeParam: resizeSubMode)
                            newResizeGarage.new_Note_Cell_Set = Set(lclModifiableNoteData.dataCellArray)
                            newResizeGarage.available_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number > -1 && $0.dataCell_X_Number < lclModifiableNoteData.highest_X_Index}
                            left_Side_Resizer_Garage_Array.append(newResizeGarage)
                        }
                        else if let maxNoteCellLeftOfNote = snapshot_Note_Cells_Left_Of_Note_Set.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                            let newResizeGarage  = Left_Side_Resizer_Garage(snapshotMinHalfCellIndex: lclModifiableNoteData.lowestFourFourHalfCellIndex
                            , snapshotMaxHalfCellIndex: lclModifiableNoteData.highestFourFourHalfCellIndex
                            , leftwardBarrierDataX: maxNoteCellLeftOfNote.dataCell_X_Number
                            , snapshot_Line_Set: snapshot_Line_Set, noteParam: note, resizeModeParam: resizeSubMode)
                            newResizeGarage.new_Note_Cell_Set = Set(lclModifiableNoteData.dataCellArray)
                            newResizeGarage.available_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number > maxNoteCellLeftOfNote.dataCell_X_Number && $0.dataCell_X_Number < lclModifiableNoteData.highest_X_Index}
                            left_Side_Resizer_Garage_Array.append(newResizeGarage)
                        }
                        
                        
                    }
                    
                    
                }
                
                for garage in left_Side_Resizer_Garage_Array {
                    garage.paintCells()
                }
            }
            
            else if dimensions.patternTimingConfiguration == .sixEight {
                for note in highlightSet {
                    if let lclModifiableNoteData = note.modifiable_Note_Data{
                        
                        let snapshot_Line_Set = Set<Underlying_Data_Cell>(lclModifiableNoteData.containing_Data_Line.dataCellArray)
                        let snapshot_Note_Set = Set<Underlying_Data_Cell>(lclModifiableNoteData.dataCellArray)
                        let snapshot_Left_Cursor_Set = snapshot_Note_Set.filter{$0.six_Eight_Half_Cell_Index == lclModifiableNoteData.lowestSixEightHalfCellIndex}
                        
                        let snapshot_Cells_Left_Of_Note_Set = snapshot_Line_Set.filter{$0.six_Eight_Half_Cell_Index < lclModifiableNoteData.lowestSixEightHalfCellIndex}
                        let snapshot_Note_Cells_Left_Of_Note_Set = snapshot_Cells_Left_Of_Note_Set.filter{$0.note_Im_In != nil}
                        
                        if snapshot_Group_MinHalfCellIndex == nil{
                            if let lclNoteCollection = parentCentralState.currentNoteCollection {
                                if let lclCurrNoteUnderCursor = lclNoteCollection.note_Currently_Under_Cursor {
                                    if note.id == lclCurrNoteUnderCursor.id {
                                        snapshot_Group_MinHalfCellIndex = lclModifiableNoteData.lowestSixEightHalfCellIndex
                                        if let hSliderRef = parentCentralState.h_Slider_Ref {
                                            if let minCursorCell = snapshot_Left_Cursor_Set.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                                                let destinationCellIndex = minCursorCell.dataCell_X_Number
                                                hSliderRef.jumpToACell(cellNum: destinationCellIndex)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        if snapshot_Note_Cells_Left_Of_Note_Set.count == 0 {
                            let newResizeGarage = Left_Side_Resizer_Garage(snapshotMinHalfCellIndex: lclModifiableNoteData.lowestSixEightHalfCellIndex
                                                                           , snapshotMaxHalfCellIndex: lclModifiableNoteData.highestSixEightHalfCellIndex
                                                                           , leftwardBarrierDataX: -1
                                                                           , snapshot_Line_Set: snapshot_Line_Set, noteParam: note, resizeModeParam: resizeSubMode)
                            newResizeGarage.new_Note_Cell_Set = Set(lclModifiableNoteData.dataCellArray)
                            newResizeGarage.available_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number > -1 && $0.dataCell_X_Number < lclModifiableNoteData.highest_X_Index}
                            left_Side_Resizer_Garage_Array.append(newResizeGarage)
                        }
                        else if let maxNoteCellLeftOfNote = snapshot_Note_Cells_Left_Of_Note_Set.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                            let newResizeGarage  = Left_Side_Resizer_Garage(snapshotMinHalfCellIndex: lclModifiableNoteData.lowestSixEightHalfCellIndex
                                                                            , snapshotMaxHalfCellIndex: lclModifiableNoteData.highestSixEightHalfCellIndex
                                                                            , leftwardBarrierDataX: maxNoteCellLeftOfNote.dataCell_X_Number
                                                                            , snapshot_Line_Set: snapshot_Line_Set, noteParam: note, resizeModeParam: resizeSubMode)
                            newResizeGarage.new_Note_Cell_Set = Set(lclModifiableNoteData.dataCellArray)
                            newResizeGarage.available_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number > maxNoteCellLeftOfNote.dataCell_X_Number && $0.dataCell_X_Number < lclModifiableNoteData.highest_X_Index}
                            left_Side_Resizer_Garage_Array.append(newResizeGarage)
                        }
                        
                    }

                    
                }
                for garage in left_Side_Resizer_Garage_Array {
                    garage.paintCells()
                }
            }
        }
    }

    func right_Side_Resize_Start(){
        if let lclNoteCollection = parentCentralState.currentNoteCollection {
            let highlightSet = Set<Note>(lclNoteCollection.noteArray.filter{$0.highlighted == true})
            if dimensions.patternTimingConfiguration == .fourFour {
                for note in highlightSet {
                    if let lclModifiableNoteData = note.modifiable_Note_Data{
                        
                        
                        let snapshot_Line_Set = Set<Underlying_Data_Cell>(lclModifiableNoteData.containing_Data_Line.dataCellArray)
                        
                        let snapshot_Note_Set = Set<Underlying_Data_Cell>(lclModifiableNoteData.dataCellArray)
                        
                        let snapshot_Right_Cursor_Set = snapshot_Note_Set.filter{$0.four_Four_Half_Cell_Index == lclModifiableNoteData.highestFourFourHalfCellIndex}

                        let snapshot_Cells_Right_Of_Note_Set = snapshot_Line_Set.filter{$0.four_Four_Half_Cell_Index > lclModifiableNoteData.highestFourFourHalfCellIndex}
                        
                        let snapshot_Note_Cells_Right_Of_Note_Set = snapshot_Cells_Right_Of_Note_Set.filter{$0.note_Im_In != nil}

                        if snapshot_Group_MaxHalfCellIndex == nil {
                            if let lclNoteCollection = parentCentralState.currentNoteCollection {
                                if let lclCurrNoteUnderCursor = lclNoteCollection.note_Currently_Under_Cursor {
                                    if note.id == lclCurrNoteUnderCursor.id {
                                        snapshot_Group_MaxHalfCellIndex = lclModifiableNoteData.highestFourFourHalfCellIndex
                                        if let hSliderRef = parentCentralState.h_Slider_Ref {
                                            if let maxCursorCell = snapshot_Right_Cursor_Set.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                                                let destinationCellIndex = maxCursorCell.dataCell_X_Number
                                                hSliderRef.jumpToACell(cellNum: destinationCellIndex)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if snapshot_Note_Cells_Right_Of_Note_Set.count == 0 {
                        let newResizeGarage = Right_Side_Resizer_Garage(snapshotMinHalfCellIndex: lclModifiableNoteData.lowestFourFourHalfCellIndex
                                                                        , snapshotMaxHalfCellIndex: lclModifiableNoteData.highestFourFourHalfCellIndex
                                                                        , rightwardBarrierDataXParam: dimensions.dataGrid_X_Unit_Count
                                                                        , leftwardBarrierDataXParam: lclModifiableNoteData.lowest_X_Index
                                                                       , snapshot_Line_Set: snapshot_Line_Set, noteParam: note, resizeModeParam: resizeSubMode)
                        
                        newResizeGarage.new_Note_Cell_Set = Set(lclModifiableNoteData.dataCellArray)
                        newResizeGarage.available_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number > lclModifiableNoteData.highest_X_Index && $0.dataCell_X_Number < dimensions.dataGrid_X_Unit_Count}
                        right_Side_Resizer_Garage_Array.append(newResizeGarage)
                        }
                        else if let minNoteCellRightOfNote = snapshot_Note_Cells_Right_Of_Note_Set.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                        let newResizeGarage  = Right_Side_Resizer_Garage(snapshotMinHalfCellIndex: lclModifiableNoteData.lowestFourFourHalfCellIndex
                                                                            , snapshotMaxHalfCellIndex: lclModifiableNoteData.highestFourFourHalfCellIndex
                                                                         , rightwardBarrierDataXParam: minNoteCellRightOfNote.dataCell_X_Number, leftwardBarrierDataXParam: lclModifiableNoteData.lowest_X_Index
                                                                        , snapshot_Line_Set: snapshot_Line_Set, noteParam: note, resizeModeParam: resizeSubMode)
                        newResizeGarage.new_Note_Cell_Set = Set(lclModifiableNoteData.dataCellArray)
                        newResizeGarage.available_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number > lclModifiableNoteData.highest_X_Index && $0.dataCell_X_Number < minNoteCellRightOfNote.dataCell_X_Number}
                        right_Side_Resizer_Garage_Array.append(newResizeGarage)
                        }
                        
                    }

                
            
            }
                for garage in right_Side_Resizer_Garage_Array {
                    garage.paintCells()
                }
            }
            else if dimensions.patternTimingConfiguration == .sixEight {
                for note in highlightSet {
                    if let lclModifiableNoteData = note.modifiable_Note_Data{
                        
                        let snapshot_Line_Set = Set<Underlying_Data_Cell>(lclModifiableNoteData.containing_Data_Line.dataCellArray)
                        
                        let snapshot_Note_Set = Set<Underlying_Data_Cell>(lclModifiableNoteData.dataCellArray)
                        
                        let snapshot_Right_Cursor_Set = snapshot_Note_Set.filter{$0.six_Eight_Half_Cell_Index == lclModifiableNoteData.highestSixEightHalfCellIndex}

                        let snapshot_Cells_Right_Of_Note_Set = snapshot_Line_Set.filter{$0.six_Eight_Half_Cell_Index > lclModifiableNoteData.highestSixEightHalfCellIndex}
                        
                        let snapshot_Note_Cells_Right_Of_Note_Set = snapshot_Cells_Right_Of_Note_Set.filter{$0.note_Im_In != nil}

                        if snapshot_Group_MaxHalfCellIndex == nil {
                            if let lclNoteCollection = parentCentralState.currentNoteCollection {
                                if let lclCurrNoteUnderCursor = lclNoteCollection.note_Currently_Under_Cursor {
                                    if note.id == lclCurrNoteUnderCursor.id {
                                        snapshot_Group_MaxHalfCellIndex = lclModifiableNoteData.highestSixEightHalfCellIndex
                                        if let hSliderRef = parentCentralState.h_Slider_Ref {
                                            if let maxCursorCell = snapshot_Right_Cursor_Set.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                                                let destinationCellIndex = maxCursorCell.dataCell_X_Number
                                                hSliderRef.jumpToACell(cellNum: destinationCellIndex)
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        if snapshot_Note_Cells_Right_Of_Note_Set.count == 0 {
                            let newResizeGarage = Right_Side_Resizer_Garage(snapshotMinHalfCellIndex: lclModifiableNoteData.lowestSixEightHalfCellIndex
                                                                            , snapshotMaxHalfCellIndex: lclModifiableNoteData.highestSixEightHalfCellIndex
                                                                            , rightwardBarrierDataXParam: dimensions.dataGrid_X_Unit_Count, leftwardBarrierDataXParam: lclModifiableNoteData.lowest_X_Index
                                                                           , snapshot_Line_Set: snapshot_Line_Set, noteParam: note, resizeModeParam: resizeSubMode)
                            
                            newResizeGarage.new_Note_Cell_Set = Set(lclModifiableNoteData.dataCellArray)
                            newResizeGarage.available_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number > lclModifiableNoteData.highest_X_Index && $0.dataCell_X_Number < dimensions.dataGrid_X_Unit_Count}
                            right_Side_Resizer_Garage_Array.append(newResizeGarage)
                        }
                        else if let minNoteCellRightOfNote = snapshot_Note_Cells_Right_Of_Note_Set.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                            let newResizeGarage  = Right_Side_Resizer_Garage(snapshotMinHalfCellIndex: lclModifiableNoteData.lowestSixEightHalfCellIndex
                                                                                , snapshotMaxHalfCellIndex: lclModifiableNoteData.highestSixEightHalfCellIndex
                                                                             , rightwardBarrierDataXParam: minNoteCellRightOfNote.dataCell_X_Number, leftwardBarrierDataXParam: lclModifiableNoteData.lowest_X_Index
                                                                            , snapshot_Line_Set: snapshot_Line_Set, noteParam: note, resizeModeParam: resizeSubMode)
                            newResizeGarage.new_Note_Cell_Set = Set(lclModifiableNoteData.dataCellArray)
                            newResizeGarage.available_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number > lclModifiableNoteData.highest_X_Index && $0.dataCell_X_Number < minNoteCellRightOfNote.dataCell_X_Number}
                            right_Side_Resizer_Garage_Array.append(newResizeGarage)
                        }
                        
                    }

                
            
            }
                for garage in right_Side_Resizer_Garage_Array {
                    garage.paintCells()
                }
            }
        }
    }
    
    func get_Left_Side_Cursor_Delta(currentHalfCellIndexParam:Int){
        if let lclSnapshotHalfCellIndex = snapshot_Group_MinHalfCellIndex {
            let currentHalfCellDelta = currentHalfCellIndexParam - lclSnapshotHalfCellIndex
            for resizeGarage in left_Side_Resizer_Garage_Array {
                resizeGarage.resize_Left_Side_Handler(halfCellDeltaParam: currentHalfCellDelta)
            }
        }
    }
    
    func get_Right_Side_Cursor_Delta(currentHalfCellIndexParam:Int){
        if let lclSnapshotHalfCellIndex = snapshot_Group_MaxHalfCellIndex {
            let currentHalfCellDelta = currentHalfCellIndexParam - lclSnapshotHalfCellIndex
            for resizeGarage in right_Side_Resizer_Garage_Array {
                resizeGarage.resize_Right_Side_Handler(halfCellDeltaParam: currentHalfCellDelta)
            }
        }
    }

    public func reWriteNotes(){
        if left_Side_Resizer_Garage_Array.count > 0 {
            for resizer in left_Side_Resizer_Garage_Array {
                if let lclNoteRef = resizer.noteReference {
                    if let lclModifiableNoteData = lclNoteRef.modifiable_Note_Data {
                        if resizer.new_Note_Cell_Set.count == 1 {
                            lclModifiableNoteData.reWrite_Note_Data(newDataCellSet: resizer.new_Note_Cell_Set)
                        }
                        else if resizer.new_Note_Cell_Set.count == 2 {
                            lclModifiableNoteData.reWrite_Note_Data(newDataCellSet: resizer.new_Note_Cell_Set)
                        }
                        else if resizer.new_Note_Cell_Set.count > 2 {
                            lclModifiableNoteData.reWrite_Note_Data(newDataCellSet: resizer.new_Note_Cell_Set)
                        }
                    }
                }
            }
        }
        if right_Side_Resizer_Garage_Array.count > 0{
            for resizer in right_Side_Resizer_Garage_Array {
            if let lclNoteRef = resizer.noteReference {
                if let lclModifiableNoteData = lclNoteRef.modifiable_Note_Data {
                    if resizer.new_Note_Cell_Set.count == 1 {
                        lclModifiableNoteData.reWrite_Note_Data(newDataCellSet: resizer.new_Note_Cell_Set)
                    }
                    else if resizer.new_Note_Cell_Set.count == 2 {
                        lclModifiableNoteData.reWrite_Note_Data(newDataCellSet: resizer.new_Note_Cell_Set)
                    }
                    else if resizer.new_Note_Cell_Set.count > 2 {
                        lclModifiableNoteData.reWrite_Note_Data(newDataCellSet: resizer.new_Note_Cell_Set)
                    }
                }
            }
        }
    }
    clear_Variables()
    }
}




public enum E_Resize_Mode : String {
    case rightSideSubMode = "Resize Rightward"
    case leftSideSubMode = "Resize Leftward"
    case standBySubMode = "Resize Standby"
}


//public func reWriteNotes(){
//
////        if left_Side_Resizer_Garage_Array.count > 0 {
////            for resizer in left_Side_Resizer_Garage_Array {
////                if let lclNoteRef = resizer.noteReference {
////                    lclNoteRef.note_Modification_Object.dataCellArray.removeAll()
////                    if resizer.new_Note_Cell_Set.count == 1 {
////                        let newCellArray = Array(resizer.new_Note_Cell_Set)
////                        newCellArray[0].change_Type(newType: .single_Note)
////                        newCellArray[0].note_Im_In = resizer.noteReference
////                        lclNoteRef.note_Modification_Object.lowest_X_Index = newCellArray[0].dataCell_X_Number
////                        lclNoteRef.note_Modification_Object.highest_X_Index = newCellArray[0].dataCell_X_Number
////                        for cell in newCellArray{
////                            if cell.in_Resize_Set == true {cell.handleVisibleStateChange(type: .deActivate_Resize_Set)}
////                            if cell.note_Im_In != resizer.noteReference{cell.note_Im_In = lclNoteRef}
////                        }
////                        lclNoteRef.note_Modification_Object.dataCellArray = newCellArray
////                        lclNoteRef.note_Modification_Object.highestFourFourHalfCellIndex = newCellArray[0].four_Four_Half_Cell_Index
////                        lclNoteRef.note_Modification_Object.lowestFourFourHalfCellIndex = newCellArray[0].four_Four_Half_Cell_Index
////                        lclNoteRef.note_Modification_Object.highestSixEightHalfCellIndex = newCellArray[0].six_Eight_Half_Cell_Index
////                        lclNoteRef.note_Modification_Object.lowestSixEightHalfCellIndex = newCellArray[0].six_Eight_Half_Cell_Index
////                    }
////                    else if resizer.new_Note_Cell_Set.count == 2 {
////                        let newCellArray = resizer.new_Note_Cell_Set.sorted(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
////                        newCellArray[0].change_Type(newType: .start_Note)
////                        newCellArray[0].note_Im_In = resizer.noteReference
////                        lclNoteRef.note_Modification_Object.lowest_X_Index = newCellArray[0].dataCell_X_Number
////                        newCellArray[1].change_Type(newType: .end_Note)
////                        newCellArray[1].note_Im_In = resizer.noteReference
////                        lclNoteRef.note_Modification_Object.highest_X_Index = newCellArray[1].dataCell_X_Number
////                        for cell in newCellArray{
////                            if cell.in_Resize_Set == true {cell.handleVisibleStateChange(type: .deActivate_Resize_Set)}
////                            if cell.note_Im_In != resizer.noteReference{cell.note_Im_In = lclNoteRef}
////                        }
////                        lclNoteRef.note_Modification_Object.dataCellArray = newCellArray
////                        lclNoteRef.note_Modification_Object.highestFourFourHalfCellIndex = newCellArray[1].four_Four_Half_Cell_Index
////                        lclNoteRef.note_Modification_Object.lowestFourFourHalfCellIndex = newCellArray[0].four_Four_Half_Cell_Index
////                        lclNoteRef.note_Modification_Object.highestSixEightHalfCellIndex = newCellArray[1].six_Eight_Half_Cell_Index
////                        lclNoteRef.note_Modification_Object.lowestSixEightHalfCellIndex = newCellArray[0].six_Eight_Half_Cell_Index
////                    }
////                    else if resizer.new_Note_Cell_Set.count > 2 {
////
////                        let newCellArray = resizer.new_Note_Cell_Set.sorted(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
////                        let firstIndex = 0
////                        let finalIndex = newCellArray.count-1
////                        newCellArray[firstIndex].change_Type(newType: .start_Note)
////                        newCellArray[firstIndex].note_Im_In = resizer.noteReference
////                        lclNoteRef.note_Modification_Object.lowest_X_Index = newCellArray[firstIndex].dataCell_X_Number
////
////                        for x in 1..<finalIndex{
////                            newCellArray[x].change_Type(newType: .mid_Note)
////                            newCellArray[x].note_Im_In = resizer.noteReference
////                        }
////
////                        newCellArray[finalIndex].change_Type(newType: .end_Note)
////                        newCellArray[finalIndex].note_Im_In = resizer.noteReference
////                        lclNoteRef.note_Modification_Object.highest_X_Index = newCellArray[finalIndex].dataCell_X_Number
////                        for cell in newCellArray {
////                            if cell.in_Resize_Set == true {cell.handleVisibleStateChange(type: .deActivate_Resize_Set)}
////                            if cell.note_Im_In != resizer.noteReference{cell.note_Im_In = lclNoteRef}
////                        }
////                        lclNoteRef.note_Modification_Object.dataCellArray = newCellArray
////                        lclNoteRef.note_Modification_Object.highestFourFourHalfCellIndex = newCellArray[finalIndex].four_Four_Half_Cell_Index
////                        lclNoteRef.note_Modification_Object.lowestFourFourHalfCellIndex = newCellArray[firstIndex].four_Four_Half_Cell_Index
////                        lclNoteRef.note_Modification_Object.highestSixEightHalfCellIndex = newCellArray[finalIndex].six_Eight_Half_Cell_Index
////                        lclNoteRef.note_Modification_Object.lowestSixEightHalfCellIndex = newCellArray[firstIndex].six_Eight_Half_Cell_Index
////                    }
////
////                }
////            }
////        }
//
//
//
//        if right_Side_Resizer_Garage_Array.count > 0{
//
//            for resizer in right_Side_Resizer_Garage_Array {
//                    if let lclNoteRef = resizer.noteReference {
//                        if let lclModifiableNoteData = lclNoteRef.modifiable_Note_Data{
//                        //lclModifiableNoteData.dataCellArray.removeAll()
//
//                        if resizer.new_Note_Cell_Set.count == 1 {
////                                let newCellArray = Array(resizer.new_Note_Cell_Set)
////                                newCellArray[0].change_Type(newType: .single_Note)
////                                newCellArray[0].note_Im_In = resizer.noteReference
////                                lclModifiableNoteData.lowest_X_Index = newCellArray[0].dataCell_X_Number
////                                lclModifiableNoteData.highest_X_Index = newCellArray[0].dataCell_X_Number
////                                for cell in newCellArray{
////                                    if cell.in_Resize_Set == true {cell.handleVisibleStateChange(type: .deActivate_Resize_Set)}
////                                    if cell.note_Im_In != resizer.noteReference{cell.note_Im_In = lclNoteRef}
////                                }
////                                lclModifiableNoteData.dataCellArray = newCellArray
////                                lclModifiableNoteData.highestFourFourHalfCellIndex = newCellArray[0].four_Four_Half_Cell_Index
////                                lclModifiableNoteData.lowestFourFourHalfCellIndex = newCellArray[0].four_Four_Half_Cell_Index
////                                lclModifiableNoteData.highestSixEightHalfCellIndex = newCellArray[0].six_Eight_Half_Cell_Index
////                                lclModifiableNoteData.lowestSixEightHalfCellIndex = newCellArray[0].six_Eight_Half_Cell_Index
//                            lclModifiableNoteData.reWrite_Note_Data(newDataCellSet: resizer.new_Note_Cell_Set)
//                        }
//                        else if resizer.new_Note_Cell_Set.count == 2 {
////                                let newCellArray = resizer.new_Note_Cell_Set.sorted(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
////                                newCellArray[0].change_Type(newType: .start_Note)
////                                newCellArray[0].note_Im_In = resizer.noteReference
////                                lclModifiableNoteData.lowest_X_Index = newCellArray[0].dataCell_X_Number
////                                newCellArray[1].change_Type(newType: .end_Note)
////                                newCellArray[1].note_Im_In = resizer.noteReference
////                                lclModifiableNoteData.highest_X_Index = newCellArray[1].dataCell_X_Number
////                                for cell in newCellArray{
////                                    if cell.in_Resize_Set == true {cell.handleVisibleStateChange(type: .deActivate_Resize_Set)}
////                                    if cell.note_Im_In != resizer.noteReference{cell.note_Im_In = lclNoteRef}
////                                }
////                                lclModifiableNoteData.dataCellArray = newCellArray
////                                lclModifiableNoteData.highestFourFourHalfCellIndex = newCellArray[1].four_Four_Half_Cell_Index
////                                lclModifiableNoteData.lowestFourFourHalfCellIndex = newCellArray[0].four_Four_Half_Cell_Index
////                                lclModifiableNoteData.highestSixEightHalfCellIndex = newCellArray[1].six_Eight_Half_Cell_Index
////                                lclModifiableNoteData.lowestSixEightHalfCellIndex = newCellArray[0].six_Eight_Half_Cell_Index
//                            lclModifiableNoteData.reWrite_Note_Data(newDataCellSet: resizer.new_Note_Cell_Set)
//                        }
//                        else if resizer.new_Note_Cell_Set.count > 2 {
//                            // try for the lclModifiableNoteData rewrite here
//
//                            lclModifiableNoteData.reWrite_Note_Data(newDataCellSet: resizer.new_Note_Cell_Set)
//
////                                let newCellArray = resizer.new_Note_Cell_Set.sorted(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
////                                lclModifiableNoteData.applyModification(newDataCellArray: newCellArray)
//
////                                let newCellArray = resizer.new_Note_Cell_Set.sorted(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
////                                let firstIndex = 0
////                                let finalIndex = newCellArray.count-1
////                                newCellArray[firstIndex].change_Type(newType: .start_Note)
////                                newCellArray[firstIndex].note_Im_In = resizer.noteReference
////                                lclModifiableNoteData.lowest_X_Index = newCellArray[firstIndex].dataCell_X_Number
////                                for x in 1..<finalIndex{
////                                    newCellArray[x].change_Type(newType: .mid_Note)
////                                    newCellArray[x].note_Im_In = resizer.noteReference
////                                }
////                                newCellArray[finalIndex].change_Type(newType: .end_Note)
////                                newCellArray[finalIndex].note_Im_In = resizer.noteReference
////                                lclModifiableNoteData.highest_X_Index = newCellArray[finalIndex].dataCell_X_Number
////                                for cell in newCellArray {
////                                    if cell.in_Resize_Set == true {cell.handleVisibleStateChange(type: .deActivate_Resize_Set)}
////                                    if cell.note_Im_In != resizer.noteReference{cell.note_Im_In = lclNoteRef}
////                                }
////                                lclModifiableNoteData.dataCellArray = newCellArray
////                                lclModifiableNoteData.highestFourFourHalfCellIndex = newCellArray[finalIndex].four_Four_Half_Cell_Index
////                                lclModifiableNoteData.lowestFourFourHalfCellIndex = newCellArray[firstIndex].four_Four_Half_Cell_Index
////                                lclModifiableNoteData.highestSixEightHalfCellIndex = newCellArray[finalIndex].six_Eight_Half_Cell_Index
////                                lclModifiableNoteData.lowestSixEightHalfCellIndex = newCellArray[firstIndex].six_Eight_Half_Cell_Index
//                        }
//
//                    }
//            }
//        }
//
//    }
//
//
//
//    clear_Variables()
//}
