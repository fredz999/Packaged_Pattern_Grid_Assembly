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
    
    @Published public var resizeMode : E_Resize_Mode = .rightSideSubMode
    
    public init(parentCentral_State_Param:Central_State,selectableModeIdParam:Int){
        selectableModeId = selectableModeIdParam
        parentCentralState = parentCentral_State_Param
    }
    
    public func swap_Resize_Sub_Mode(modeParam : E_Resize_Mode){
        
        if left_Side_Resizer_Garage_Array.count == 0 && right_Side_Resizer_Garage_Array.count == 0{
            reWriteNotes()
            
            if modeParam == .rightSideSubMode, resizeMode == .leftSideSubMode {
                resizeMode = .rightSideSubMode
                if mode_Active == true {
                    right_Side_Resize_Start()
                }
            }
            else if modeParam == .leftSideSubMode, resizeMode == .rightSideSubMode {
                resizeMode = .leftSideSubMode
                if mode_Active == true {
                    left_Side_Resize_Start()
                }
            }
        }
        
        
        
    }
    
    public var mode_Active: Bool = false
    
    func activate_Mode(activationCell: Underlying_Data_Cell?) {
        if mode_Active == false {
            mode_Active = true
            if resizeMode == .leftSideSubMode {
                left_Side_Resize_Start()
            }
            else if resizeMode == .rightSideSubMode{
                right_Side_Resize_Start()
            }
        }
    }
    
    func generateModeDescriptorString () -> String {
        return resizeMode.rawValue
    }

    func handleDataEvaluation(){
        if resizeMode == .rightSideSubMode {
            let currHalfCell = parentCentralState.currentData.four_Four_Half_Cell_Index
            get_Right_Side_Cursor_Delta(currentHalfCellIndexParam: currHalfCell)
        }
        else if resizeMode == .leftSideSubMode {
            let currHalfCell = parentCentralState.currentData.four_Four_Half_Cell_Index
            get_Left_Side_Cursor_Delta(currentHalfCellIndexParam: currHalfCell)
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

            for note in highlightSet {
                //print("left_Side_Resize_Start() note length: ",note.dataCellArray.count)
                let snapshot_Line_Set = Set<Underlying_Data_Cell>(note.containing_Line.dataCellArray)
                let snapshot_Note_Set = Set<Underlying_Data_Cell>(note.dataCellArray)
                let snapshot_Left_Cursor_Set = snapshot_Note_Set.filter{$0.four_Four_Half_Cell_Index == note.lowestFourFourHalfCellIndex}

                let snapshot_Cells_Left_Of_Note_Set = snapshot_Line_Set.filter{$0.four_Four_Half_Cell_Index < note.lowestFourFourHalfCellIndex}
                let snapshot_Note_Cells_Left_Of_Note_Set = snapshot_Cells_Left_Of_Note_Set.filter{$0.note_Im_In != nil}

                if snapshot_Group_MinHalfCellIndex == nil{
                    if let lclNoteCollection = parentCentralState.currentNoteCollection {
                        if let lclCurrNoteUnderCursor = lclNoteCollection.note_Currently_Under_Cursor {
                            if note.id == lclCurrNoteUnderCursor.id {
                                snapshot_Group_MinHalfCellIndex = note.lowestFourFourHalfCellIndex
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
                    let newResizeGarage = Left_Side_Resizer_Garage(snapshotMinHalfCellIndex: note.lowestFourFourHalfCellIndex
                                                                    , snapshotMaxHalfCellIndex: note.highestFourFourHalfCellIndex
                                                                    , leftwardBarrierDataX: -1
                                                                    , snapshot_Line_Set: snapshot_Line_Set, noteParam: note, resizeModeParam: resizeMode)
                    left_Side_Resizer_Garage_Array.append(newResizeGarage)
                }
                else if let maxNoteCellLeftOfNote = snapshot_Note_Cells_Left_Of_Note_Set.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                    let newResizeGarage  = Left_Side_Resizer_Garage(snapshotMinHalfCellIndex: note.lowestFourFourHalfCellIndex
                                                                    , snapshotMaxHalfCellIndex: note.highestFourFourHalfCellIndex
                                                                    , leftwardBarrierDataX: maxNoteCellLeftOfNote.dataCell_X_Number
                                                                    , snapshot_Line_Set: snapshot_Line_Set, noteParam: note, resizeModeParam: resizeMode)
                    left_Side_Resizer_Garage_Array.append(newResizeGarage)
                }

            }

        }

    }
    
    func right_Side_Resize_Start(){
        
        print("right_Side_Resize_Start() 0")
        
        if let lclNoteCollection = parentCentralState.currentNoteCollection {
            print("right_Side_Resize_Start() 1")
            let highlightSet = Set<Note>(lclNoteCollection.noteArray.filter{$0.highlighted == true})
            
            for note in highlightSet{
                print("right_Side_Resize_Start() 2")
                let snapshot_Line_Set = Set<Underlying_Data_Cell>(note.containing_Line.dataCellArray)
                
                let snapshot_Note_Set = Set<Underlying_Data_Cell>(note.dataCellArray)
                
                let snapshot_Right_Cursor_Set = snapshot_Note_Set.filter{$0.four_Four_Half_Cell_Index == note.highestFourFourHalfCellIndex}

                let snapshot_Cells_Right_Of_Note_Set = snapshot_Line_Set.filter{$0.four_Four_Half_Cell_Index > note.highestFourFourHalfCellIndex}
                
                let snapshot_Note_Cells_Right_Of_Note_Set = snapshot_Cells_Right_Of_Note_Set.filter{$0.note_Im_In != nil}

                if snapshot_Group_MaxHalfCellIndex == nil {
                    print("right_Side_Resize_Start() 3")
                    if let lclNoteCollection = parentCentralState.currentNoteCollection {
                        print("right_Side_Resize_Start() 4")
                        if let lclCurrNoteUnderCursor = lclNoteCollection.note_Currently_Under_Cursor {
                            print("right_Side_Resize_Start() 5")
                            if note.id == lclCurrNoteUnderCursor.id {
                                snapshot_Group_MaxHalfCellIndex = note.highestFourFourHalfCellIndex
                                if let hSliderRef = parentCentralState.h_Slider_Ref {
                                    if let maxCursorCell = snapshot_Right_Cursor_Set.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                                        print("right_Side_Resize_Start() 6")
                                        let destinationCellIndex = maxCursorCell.dataCell_X_Number
                                        hSliderRef.jumpToACell(cellNum: destinationCellIndex)
                                    }
                                }
                            }
                        }
                    }
                }

                if snapshot_Note_Cells_Right_Of_Note_Set.count == 0 {
                    print("right_Side_Resize_Start() 7")
                    let newResizeGarage = Right_Side_Resizer_Garage(snapshotMinHalfCellIndex: note.lowestFourFourHalfCellIndex
                                                                    , snapshotMaxHalfCellIndex: note.highestFourFourHalfCellIndex
                                                                    , rightwardBarrierDataXParam: dimensions.dataGrid_X_Unit_Count
                                                                   , snapshot_Line_Set: snapshot_Line_Set, noteParam: note, resizeModeParam: resizeMode)
                    right_Side_Resizer_Garage_Array.append(newResizeGarage)
                }
                else if let minNoteCellRightOfNote = snapshot_Note_Cells_Right_Of_Note_Set.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                    print("right_Side_Resize_Start() 8")
                    let newResizeGarage  = Right_Side_Resizer_Garage(snapshotMinHalfCellIndex: note.lowestFourFourHalfCellIndex
                                                                        , snapshotMaxHalfCellIndex: note.highestFourFourHalfCellIndex
                                                                     , rightwardBarrierDataXParam: minNoteCellRightOfNote.dataCell_X_Number
                                                                    , snapshot_Line_Set: snapshot_Line_Set, noteParam: note, resizeModeParam: resizeMode)
                    right_Side_Resizer_Garage_Array.append(newResizeGarage)
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
        if resizeMode == .leftSideSubMode{
            print("reWriteNotes() resizeMode == .leftSideSubMode{")
            for resizer in left_Side_Resizer_Garage_Array {
                if let lclNoteRef = resizer.noteReference {
                    lclNoteRef.dataCellArray.removeAll()
                    if resizer.new_Note_Cell_Set.count == 1 {
                        let newCellArray = Array(resizer.new_Note_Cell_Set)
                        newCellArray[0].change_Type(newType: .single_Note)
                        newCellArray[0].note_Im_In = resizer.noteReference
                        lclNoteRef.lowest_Index = newCellArray[0].dataCell_X_Number
                        lclNoteRef.highest_Index = newCellArray[0].dataCell_X_Number
                        for cell in newCellArray{
                            if cell.in_Resize_Set == true {cell.handleVisibleStateChange(type: .deActivate_Resize_Set)}
                            if cell.note_Im_In != resizer.noteReference{cell.note_Im_In = lclNoteRef}
                        }
                        lclNoteRef.dataCellArray = newCellArray
                        lclNoteRef.highestFourFourHalfCellIndex = newCellArray[0].four_Four_Half_Cell_Index
                        lclNoteRef.lowestFourFourHalfCellIndex = newCellArray[0].four_Four_Half_Cell_Index
                    }
                    else if resizer.new_Note_Cell_Set.count == 2 {
                        let newCellArray = resizer.new_Note_Cell_Set.sorted(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                        newCellArray[0].change_Type(newType: .start_Note)
                        newCellArray[0].note_Im_In = resizer.noteReference
                        lclNoteRef.lowest_Index = newCellArray[0].dataCell_X_Number
                        newCellArray[1].change_Type(newType: .end_Note)
                        newCellArray[1].note_Im_In = resizer.noteReference
                        lclNoteRef.highest_Index = newCellArray[1].dataCell_X_Number
                        for cell in newCellArray{
                            if cell.in_Resize_Set == true {cell.handleVisibleStateChange(type: .deActivate_Resize_Set)}
                            if cell.note_Im_In != resizer.noteReference{cell.note_Im_In = lclNoteRef}
                        }
                        lclNoteRef.dataCellArray = newCellArray
                        lclNoteRef.highestFourFourHalfCellIndex = newCellArray[1].four_Four_Half_Cell_Index
                        lclNoteRef.lowestFourFourHalfCellIndex = newCellArray[0].four_Four_Half_Cell_Index
                    }
                    else if resizer.new_Note_Cell_Set.count > 2 {
                        
                        let newCellArray = resizer.new_Note_Cell_Set.sorted(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                        let firstIndex = 0
                        let finalIndex = newCellArray.count-1
                        newCellArray[firstIndex].change_Type(newType: .start_Note)
                        newCellArray[firstIndex].note_Im_In = resizer.noteReference
                        lclNoteRef.lowest_Index = newCellArray[firstIndex].dataCell_X_Number
                        for x in 1..<finalIndex{
                            newCellArray[x].change_Type(newType: .mid_Note)
                            newCellArray[x].note_Im_In = resizer.noteReference
                        }
                        newCellArray[finalIndex].change_Type(newType: .end_Note)
                        newCellArray[finalIndex].note_Im_In = resizer.noteReference
                        lclNoteRef.highest_Index = newCellArray[finalIndex].dataCell_X_Number
                        for cell in newCellArray {
                            if cell.in_Resize_Set == true {cell.handleVisibleStateChange(type: .deActivate_Resize_Set)}
                            if cell.note_Im_In != resizer.noteReference{cell.note_Im_In = lclNoteRef}
                        }
                        lclNoteRef.dataCellArray = newCellArray
                        lclNoteRef.highestFourFourHalfCellIndex = newCellArray[finalIndex].four_Four_Half_Cell_Index
                        lclNoteRef.lowestFourFourHalfCellIndex = newCellArray[firstIndex].four_Four_Half_Cell_Index
                    }
                    
                }
     
            }
        }
        else if resizeMode == .rightSideSubMode{
            print("reWriteNotes() resizeMode == .rightSideSubMode")
            for resizer in right_Side_Resizer_Garage_Array {
                if let lclNoteRef = resizer.noteReference {
                    
                    lclNoteRef.dataCellArray.removeAll()
                    if resizer.new_Note_Cell_Set.count == 1 {
                        let newCellArray = Array(resizer.new_Note_Cell_Set)
                        newCellArray[0].change_Type(newType: .single_Note)
                        newCellArray[0].note_Im_In = resizer.noteReference
                        lclNoteRef.lowest_Index = newCellArray[0].dataCell_X_Number
                        lclNoteRef.highest_Index = newCellArray[0].dataCell_X_Number
                        for cell in newCellArray{
                            if cell.in_Resize_Set == true {cell.handleVisibleStateChange(type: .deActivate_Resize_Set)}
                            if cell.note_Im_In != resizer.noteReference{cell.note_Im_In = lclNoteRef}
                        }
                        lclNoteRef.dataCellArray = newCellArray
                        lclNoteRef.highestFourFourHalfCellIndex = newCellArray[0].four_Four_Half_Cell_Index
                        lclNoteRef.lowestFourFourHalfCellIndex = newCellArray[0].four_Four_Half_Cell_Index
                    }
                    else if resizer.new_Note_Cell_Set.count == 2 {
                        let newCellArray = resizer.new_Note_Cell_Set.sorted(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                        newCellArray[0].change_Type(newType: .start_Note)
                        newCellArray[0].note_Im_In = resizer.noteReference
                        lclNoteRef.lowest_Index = newCellArray[0].dataCell_X_Number
                        newCellArray[1].change_Type(newType: .end_Note)
                        newCellArray[1].note_Im_In = resizer.noteReference
                        lclNoteRef.highest_Index = newCellArray[1].dataCell_X_Number
                        for cell in newCellArray{
                            if cell.in_Resize_Set == true {cell.handleVisibleStateChange(type: .deActivate_Resize_Set)}
                            if cell.note_Im_In != resizer.noteReference{cell.note_Im_In = lclNoteRef}
                        }
                        lclNoteRef.dataCellArray = newCellArray
                        lclNoteRef.highestFourFourHalfCellIndex = newCellArray[1].four_Four_Half_Cell_Index
                        lclNoteRef.lowestFourFourHalfCellIndex = newCellArray[0].four_Four_Half_Cell_Index
                    }
                    else if resizer.new_Note_Cell_Set.count > 2 {
                        
                        let newCellArray = resizer.new_Note_Cell_Set.sorted(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                        let firstIndex = 0
                        let finalIndex = newCellArray.count-1
                        newCellArray[firstIndex].change_Type(newType: .start_Note)
                        newCellArray[firstIndex].note_Im_In = resizer.noteReference
                        lclNoteRef.lowest_Index = newCellArray[firstIndex].dataCell_X_Number
                        for x in 1..<finalIndex{
                            newCellArray[x].change_Type(newType: .mid_Note)
                            newCellArray[x].note_Im_In = resizer.noteReference
                        }
                        newCellArray[finalIndex].change_Type(newType: .end_Note)
                        newCellArray[finalIndex].note_Im_In = resizer.noteReference
                        lclNoteRef.highest_Index = newCellArray[finalIndex].dataCell_X_Number
                        for cell in newCellArray {
                            if cell.in_Resize_Set == true {cell.handleVisibleStateChange(type: .deActivate_Resize_Set)}
                            if cell.note_Im_In != resizer.noteReference{cell.note_Im_In = lclNoteRef}
                        }
                        lclNoteRef.dataCellArray = newCellArray
                        lclNoteRef.highestFourFourHalfCellIndex = newCellArray[finalIndex].four_Four_Half_Cell_Index
                        lclNoteRef.lowestFourFourHalfCellIndex = newCellArray[firstIndex].four_Four_Half_Cell_Index
                    }
                    
                }
     
            }
        }
        clear_Variables()
    }
}


class Right_Side_Resizer_Garage {
    
    var snapshotMinHalfCellIndex : Int?
    var snapshotMaxHalfCellIndex : Int?
    var rightwardBarrierDataX : Int?
    
    var snapshot_Line_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    var new_Note_Cell_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    var available_Cell_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    
    var noteReference : Note?
    
    init(snapshotMinHalfCellIndex: Int, snapshotMaxHalfCellIndex: Int, rightwardBarrierDataXParam: Int
         , snapshot_Line_Set: Set<Underlying_Data_Cell>,noteParam:Note, resizeModeParam : E_Resize_Mode){
    self.noteReference = noteParam
    self.snapshotMinHalfCellIndex = snapshotMinHalfCellIndex
    self.snapshotMaxHalfCellIndex = snapshotMaxHalfCellIndex
    self.rightwardBarrierDataX = rightwardBarrierDataXParam
    self.snapshot_Line_Set = snapshot_Line_Set
    }
    
    func resize_Right_Side_Handler(halfCellDeltaParam:Int) {

        if let lclSnapshotMaxHalfCellIndex = snapshotMaxHalfCellIndex
            , let lcl_minHalfCellIndex = snapshotMinHalfCellIndex
            , let lcl_RightwardBarrierDataX = rightwardBarrierDataX {
            
            let currentHalfCellIndexParam = lclSnapshotMaxHalfCellIndex + halfCellDeltaParam
            
            if currentHalfCellIndexParam < lcl_minHalfCellIndex{
                new_Note_Cell_Set = snapshot_Line_Set.filter{$0.four_Four_Half_Cell_Index == lcl_minHalfCellIndex}
                available_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number < lcl_RightwardBarrierDataX &&  $0.four_Four_Half_Cell_Index >= lcl_minHalfCellIndex}
            }
            if currentHalfCellIndexParam >= lcl_minHalfCellIndex {
                available_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number < lcl_RightwardBarrierDataX &&  $0.four_Four_Half_Cell_Index >= lcl_minHalfCellIndex}
                new_Note_Cell_Set = available_Cell_Set.filter{$0.four_Four_Half_Cell_Index <= currentHalfCellIndexParam && $0.four_Four_Half_Cell_Index >= lcl_minHalfCellIndex}
            }
        }
        paintCells()
    }
    
    deinit{
    if snapshotMinHalfCellIndex != nil{snapshotMinHalfCellIndex = nil}
    if snapshotMaxHalfCellIndex != nil{snapshotMaxHalfCellIndex = nil}
    if rightwardBarrierDataX != nil{rightwardBarrierDataX = nil}
    if snapshot_Line_Set.count > 0{snapshot_Line_Set.removeAll()}
    if new_Note_Cell_Set.count > 0{new_Note_Cell_Set.removeAll()}
    if available_Cell_Set.count > 0{available_Cell_Set.removeAll()}
    if noteReference != nil{noteReference = nil}
    }
    
    func paintCells(){
        for cell in available_Cell_Set {
            cell.reset_To_Original()
            if cell.in_Resize_Set == true {
                cell.handleVisibleStateChange(type: .deActivate_Resize_Set)
            }
        }

        for cell in new_Note_Cell_Set {
            cell.reset_To_Original()
            if cell.in_Resize_Set == false {
                cell.handleVisibleStateChange(type: .activate_Resize_Set)
            }
        }
    }
    
    
}


class Left_Side_Resizer_Garage {

    var snapshotMinHalfCellIndex : Int?
    var snapshotMaxHalfCellIndex : Int?
    var leftwardBarrierDataX : Int?
    var snapshot_Line_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    var new_Note_Cell_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    var available_Cell_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    var noteReference : Note?

    init(snapshotMinHalfCellIndex: Int, snapshotMaxHalfCellIndex: Int, leftwardBarrierDataX: Int
         , snapshot_Line_Set: Set<Underlying_Data_Cell>,noteParam:Note,resizeModeParam : E_Resize_Mode){
    self.noteReference = noteParam
    self.snapshotMinHalfCellIndex = snapshotMinHalfCellIndex
    self.snapshotMaxHalfCellIndex = snapshotMaxHalfCellIndex
    self.leftwardBarrierDataX = leftwardBarrierDataX
    self.snapshot_Line_Set = snapshot_Line_Set
    }

    func resize_Left_Side_Handler(halfCellDeltaParam:Int) {
        if let lclSnapshotMinHalfCellIndex = snapshotMinHalfCellIndex
            , let lcl_maxHalfCellIndex = snapshotMaxHalfCellIndex
            , let lcl_LeftwardBarrierDataX = leftwardBarrierDataX {

            let currentHalfCellIndexParam = lclSnapshotMinHalfCellIndex + halfCellDeltaParam

            if currentHalfCellIndexParam >= lcl_maxHalfCellIndex{
                new_Note_Cell_Set = snapshot_Line_Set.filter{$0.four_Four_Half_Cell_Index == lcl_maxHalfCellIndex}
                available_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number > lcl_LeftwardBarrierDataX &&  $0.four_Four_Half_Cell_Index <= lcl_maxHalfCellIndex}
            }
            else if currentHalfCellIndexParam < lcl_maxHalfCellIndex {
                available_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number > lcl_LeftwardBarrierDataX &&  $0.four_Four_Half_Cell_Index <= lcl_maxHalfCellIndex}
                new_Note_Cell_Set = available_Cell_Set.filter{$0.four_Four_Half_Cell_Index >= currentHalfCellIndexParam && $0.four_Four_Half_Cell_Index <= lcl_maxHalfCellIndex}
            }
        }
        paintCells()
    }

    deinit{
    if snapshotMinHalfCellIndex != nil{snapshotMinHalfCellIndex = nil}
    if snapshotMaxHalfCellIndex != nil{snapshotMaxHalfCellIndex = nil}
    if leftwardBarrierDataX != nil{leftwardBarrierDataX = nil}
    if snapshot_Line_Set.count > 0{snapshot_Line_Set.removeAll()}
    if new_Note_Cell_Set.count > 0{new_Note_Cell_Set.removeAll()}
    if available_Cell_Set.count > 0{available_Cell_Set.removeAll()}
    if noteReference != nil{noteReference = nil}
    }

    func paintCells(){
        for cell in available_Cell_Set {
            cell.reset_To_Original()
            if cell.in_Resize_Set == true {
                cell.handleVisibleStateChange(type: .deActivate_Resize_Set)
            }
        }

        for cell in new_Note_Cell_Set {
            cell.reset_To_Original()
            if cell.in_Resize_Set == false {
                cell.handleVisibleStateChange(type: .activate_Resize_Set)
            }
        }
    }


}

public enum E_Resize_Mode : String {
    case rightSideSubMode = "Resize Rightward"
    case leftSideSubMode = "Resize Leftward"
}
