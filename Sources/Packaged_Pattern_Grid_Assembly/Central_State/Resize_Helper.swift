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
        if modeParam == .rightSideSubMode, resizeMode == .leftSideSubMode {
            resizeMode = .rightSideSubMode
            if mode_Active == true {
                write_The_Altered_Note()
                right_Side_Resize_Start()
            }
        }
        else if modeParam == .leftSideSubMode, resizeMode == .rightSideSubMode {
            resizeMode = .leftSideSubMode
            if mode_Active == true {
                if let currNoteCollection = parentCentralState.currentNoteCollection {
                    //if let lclNote = currNoteCollection.note_Currently_Under_Cursor {
                        write_The_Altered_Note()
                        left_Side_Resize_Start()
                    //}
                }
            }
        }
    }
    
    public var mode_Active: Bool = false
    
    func activate_Mode(activationCell: Underlying_Data_Cell?) {
        if mode_Active == false {
            mode_Active = true
            if resizeMode == .leftSideSubMode {
                if let currNoteCollection = parentCentralState.currentNoteCollection {
                    //if let lclNote = currNoteCollection.note_Currently_Under_Cursor{
                        left_Side_Resize_Start()
                    //}
                }
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
            resize_Right_Side_Handler()
        }
        else if resizeMode == .leftSideSubMode {
            let currHalfCell = parentCentralState.currentData.four_Four_Half_Cell_Index
            get_Left_Side_Cursor_Delta(currentHalfCellIndexParam: currHalfCell)
            //resize_Left_Side_Handler()
            //leftSizeResizer.resize_Left_Side_Handler()
        }
    }
    
    func deactivate_Mode() {
        if mode_Active == true {
            

            write_The_Altered_Note()
            
//            if available_Cell_Set.count > 0 {
//                available_Cell_Set.removeAll()
//            }
//
//            if new_Note_Cell_Set.count > 0 {
//                new_Note_Cell_Set.removeAll()
//            }
            
            //if snapshot_Line_Set_Array.count > 0{snapshot_Line_Set_Array.removeAll()}
            if left_Side_Resizer_Garage_Array.count > 0{left_Side_Resizer_Garage_Array.removeAll()}
            
            //if snapshot_Line_Set.count > 0{snapshot_Line_Set.removeAll()}
            //if snapshot_Note_Set.count > 0{snapshot_Note_Set.removeAll()}
            //if snapshot_Cells_Left_Of_Note_Set.count > 0{snapshot_Cells_Left_Of_Note_Set.removeAll()}
            //if snapshot_Note_Cells_Left_Of_Note_Set.count > 0{snapshot_Note_Cells_Left_Of_Note_Set.removeAll()}
            
            if snapshot_Cells_Right_Of_Note_Set.count > 0{snapshot_Cells_Right_Of_Note_Set.removeAll()}
            if snapshot_Note_Cells_Right_Of_Note_Set.count > 0{snapshot_Note_Cells_Right_Of_Note_Set.removeAll()}
            
            
            
            if rightwardBarrierDataX != nil{rightwardBarrierDataX = nil}
            
            
            //if currentHalfCellDelta != nil{currentHalfCellDelta = nil}
            //if leftwardBarrierDataX != nil{leftwardBarrierDataX = nil}
            //if snapshotMinHalfCellIndex != nil{rightwardBarrierDataX = nil}
            //if snapshotMaxHalfCellIndex != nil{rightwardBarrierDataX = nil}
 
            
            
            if snapshot_highest_Note_Half_Cell_Index != nil{snapshot_highest_Note_Half_Cell_Index = nil}
            if snapshot_Lowest_Note_Half_Cell_Index != nil{snapshot_Lowest_Note_Half_Cell_Index = nil}
            if current_Cursor_Set_Max_X != nil{current_Cursor_Set_Max_X = nil}
            if snapshot_Note_Min_X != nil{snapshot_Note_Min_X = nil}
            
            
            mode_Active=false
        }
    }
    
    // Riiiiight.
    // For each note ==============================================================
    
    

    var snapshot_Note_Max_X : Int?
    
    var snapshot_highest_Note_Half_Cell_Index : Int?
    var snapshot_Lowest_Note_Half_Cell_Index : Int?
    var current_Cursor_Set_Max_X : Int?
    var snapshot_Note_Min_X : Int?
    
    
    
    
    //var snapshot_Line_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    //var snapshot_Note_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    //var snapshot_Left_Cursor_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    
    //var snapshot_Cells_Left_Of_Note_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    //var snapshot_Note_Cells_Left_Of_Note_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    
    var snapshot_Cells_Right_Of_Note_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    var snapshot_Note_Cells_Right_Of_Note_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    
    
//    var new_Note_Cell_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
//    var available_Cell_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    
    
    
    //var currentHalfCellDelta : Int?
    var rightwardBarrierDataX : Int?
    
    
    // For each note ==============================================================
    var snapshot_Group_MinHalfCellIndex : Int?
//    var snapshotMaxHalfCellIndex : Int?
    
    var left_Side_Resizer_Garage_Array : [Left_Side_Resizer_Garage] = []
    
    // this is going to have to be the cursornote, somehow have to seperate this from the other notes
    
    func left_Side_Resize_Start(){
        if let lclNoteCollection = parentCentralState.currentNoteCollection{
            
            let highlightSet = Set<Note>(lclNoteCollection.noteArray.filter{$0.highlighted == true})
            

            for noteParam in highlightSet{
                print("trying to resize id: ",noteParam.id.description)
                
                let snapshot_Line_Set = Set<Underlying_Data_Cell>(parentCentralState.currLine.dataCellArray)
                let snapshot_Note_Set = Set<Underlying_Data_Cell>(noteParam.dataCellArray)
                let snapshot_Left_Cursor_Set = snapshot_Note_Set.filter{$0.four_Four_Half_Cell_Index == noteParam.lowestFourFourHalfCellIndex}

                let snapshot_Cells_Left_Of_Note_Set = snapshot_Line_Set.filter{$0.four_Four_Half_Cell_Index < noteParam.lowestFourFourHalfCellIndex}
                let snapshot_Note_Cells_Left_Of_Note_Set = snapshot_Cells_Left_Of_Note_Set.filter{$0.note_Im_In != nil}

                if snapshot_Group_MinHalfCellIndex == nil{
                    if let lclNoteCollection = parentCentralState.currentNoteCollection {
                        if let lclCurrNoteUnderCursor = lclNoteCollection.note_Currently_Under_Cursor {
                            if noteParam.id == lclCurrNoteUnderCursor.id {
                                snapshot_Group_MinHalfCellIndex = noteParam.lowestFourFourHalfCellIndex
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
                    let newResizeGarage = Left_Side_Resizer_Garage(snapshotMinHalfCellIndex: noteParam.lowestFourFourHalfCellIndex
                                                                        , snapshotMaxHalfCellIndex: noteParam.highestFourFourHalfCellIndex
                                                                        , leftwardBarrierDataX: 0
                                                                        , snapshot_Line_Set: snapshot_Line_Set)
                    left_Side_Resizer_Garage_Array.append(newResizeGarage)
                }
                else if let maxNoteCellLeftOfNote = snapshot_Note_Cells_Left_Of_Note_Set.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                    let newResizeGarage  = Left_Side_Resizer_Garage(snapshotMinHalfCellIndex: noteParam.lowestFourFourHalfCellIndex
                                                                        , snapshotMaxHalfCellIndex: noteParam.highestFourFourHalfCellIndex
                                                                        , leftwardBarrierDataX: maxNoteCellLeftOfNote.dataCell_X_Number
                                                                        , snapshot_Line_Set: snapshot_Line_Set)
                    left_Side_Resizer_Garage_Array.append(newResizeGarage)
                }
                
            }
            
            
            
            
                
                
//                let snapshot_Line_Set = Set<Underlying_Data_Cell>(parentCentralState.currLine.dataCellArray)
//                let snapshot_Note_Set = Set<Underlying_Data_Cell>(noteParam.dataCellArray)
//                let snapshot_Left_Cursor_Set = snapshot_Note_Set.filter{$0.four_Four_Half_Cell_Index == noteParam.lowestFourFourHalfCellIndex}
//
//                let snapshot_Cells_Left_Of_Note_Set = snapshot_Line_Set.filter{$0.four_Four_Half_Cell_Index < noteParam.lowestFourFourHalfCellIndex}
//                let snapshot_Note_Cells_Left_Of_Note_Set = snapshot_Cells_Left_Of_Note_Set.filter{$0.note_Im_In != nil}
//
//                if snapshot_Group_MinHalfCellIndex == nil{
//                    if let lclNoteCollection = parentCentralState.currentNoteCollection {
//                        if let lclCurrNoteUnderCursor = lclNoteCollection.note_Currently_Under_Cursor {
//                            if noteParam.id == lclCurrNoteUnderCursor.id {
//                                snapshot_Group_MinHalfCellIndex = noteParam.lowestFourFourHalfCellIndex
//                                if let hSliderRef = parentCentralState.h_Slider_Ref {
//                                    if let minCursorCell = snapshot_Left_Cursor_Set.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
//                                        let destinationCellIndex = minCursorCell.dataCell_X_Number
//                                        hSliderRef.jumpToACell(cellNum: destinationCellIndex)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//
//                if snapshot_Note_Cells_Left_Of_Note_Set.count == 0 {
//                    left_Side_Resizer_Garage = Left_Side_Resizer_Garage(snapshotMinHalfCellIndex: noteParam.lowestFourFourHalfCellIndex
//                                                                        , snapshotMaxHalfCellIndex: noteParam.highestFourFourHalfCellIndex
//                                                                        , leftwardBarrierDataX: 0
//                                                                        , snapshot_Line_Set: snapshot_Line_Set)
//                }
//                else if let maxNoteCellLeftOfNote = snapshot_Note_Cells_Left_Of_Note_Set.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
//                    left_Side_Resizer_Garage = Left_Side_Resizer_Garage(snapshotMinHalfCellIndex: noteParam.lowestFourFourHalfCellIndex
//                                                                        , snapshotMaxHalfCellIndex: noteParam.highestFourFourHalfCellIndex
//                                                                        , leftwardBarrierDataX: maxNoteCellLeftOfNote.dataCell_X_Number
//                                                                        , snapshot_Line_Set: snapshot_Line_Set)
//                }
                
                
             
        }
        //ForEach noteParam in
       
            //}
        //}
    }
    
    
    func get_Left_Side_Cursor_Delta(currentHalfCellIndexParam:Int){
        if let lclSnapshotHalfCellIndex = snapshot_Group_MinHalfCellIndex {
            let currentHalfCellDelta = currentHalfCellIndexParam - lclSnapshotHalfCellIndex
            
            for resizeGarage in left_Side_Resizer_Garage_Array{
                resizeGarage.resize_Left_Side_Handler(halfCellDeltaParam: currentHalfCellDelta)
            }
            
            
//            if let lcl_left_Side_Resizer_Garage = left_Side_Resizer_Garage_Array{
//                lcl_left_Side_Resizer_Garage.resize_Left_Side_Handler(halfCellDeltaParam: currentHalfCellDelta)
//            }
            //resize_Left_Side_Handler(halfCellDeltaParam: currentHalfCellDelta)
        }
    }

    
    
    
    
    
    func right_Side_Resize_Start(){}
    
    func resize_Right_Side_Handler(){}
    
//    func paintCells(){
//        for cell in available_Cell_Set {
//            cell.reset_To_Original()
//            if cell.in_Resize_Set == true {
//                cell.handleVisibleStateChange(type: .deActivate_Resize_Set)
//            }
//        }
//
//        for cell in new_Note_Cell_Set {
//            cell.reset_To_Original()
//            if cell.in_Resize_Set == false {
//                cell.handleVisibleStateChange(type: .activate_Resize_Set)
//            }
//        }
//    }

    public func write_The_Altered_Note(){
//        if let lclLeftSideResizer = left_Side_Resizer_Garage_Array {
//            if lclLeftSideResizer.new_Note_Cell_Set.count > 0 {
                
        for resizer in left_Side_Resizer_Garage_Array{
            if let lclNoteCollection = parentCentralState.currentNoteCollection {
                                        if let lcl_Note_At_Cursor = lclNoteCollection.note_Currently_Under_Cursor {
                                            lcl_Note_At_Cursor.dataCellArray.removeAll()
                                            if resizer.new_Note_Cell_Set.count == 1 {
                                                let newCellArray = Array(resizer.new_Note_Cell_Set)
                                                newCellArray[0].change_Type(newType: .single_Note)
                                                newCellArray[0].note_Im_In = lcl_Note_At_Cursor
                                                lcl_Note_At_Cursor.lowest_Index = newCellArray[0].dataCell_X_Number
                                                lcl_Note_At_Cursor.highest_Index = newCellArray[0].dataCell_X_Number
                                                for cell in newCellArray{
                                                    if cell.in_Resize_Set == true {cell.handleVisibleStateChange(type: .deActivate_Resize_Set)}
                                                    if cell.note_Im_In != lcl_Note_At_Cursor{cell.note_Im_In = lcl_Note_At_Cursor}
                                                }
                                                lcl_Note_At_Cursor.dataCellArray = newCellArray
                                                lcl_Note_At_Cursor.highestFourFourHalfCellIndex = newCellArray[0].four_Four_Half_Cell_Index
                                                lcl_Note_At_Cursor.lowestFourFourHalfCellIndex = newCellArray[0].four_Four_Half_Cell_Index
                                            }
                                            else if resizer.new_Note_Cell_Set.count == 2 {
                                                let newCellArray = resizer.new_Note_Cell_Set.sorted(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                                                newCellArray[0].change_Type(newType: .start_Note)
                                                newCellArray[0].note_Im_In = lcl_Note_At_Cursor
                                                lcl_Note_At_Cursor.lowest_Index = newCellArray[0].dataCell_X_Number
                                                newCellArray[1].change_Type(newType: .end_Note)
                                                newCellArray[1].note_Im_In = lcl_Note_At_Cursor
                                                lcl_Note_At_Cursor.highest_Index = newCellArray[1].dataCell_X_Number
                                                for cell in newCellArray{
                                                    if cell.in_Resize_Set == true {cell.handleVisibleStateChange(type: .deActivate_Resize_Set)}
                                                    if cell.note_Im_In != lcl_Note_At_Cursor{cell.note_Im_In = lcl_Note_At_Cursor}
                                                }
                                                lcl_Note_At_Cursor.dataCellArray = newCellArray
                                                lcl_Note_At_Cursor.highestFourFourHalfCellIndex = newCellArray[1].four_Four_Half_Cell_Index
                                                lcl_Note_At_Cursor.lowestFourFourHalfCellIndex = newCellArray[0].four_Four_Half_Cell_Index
                                            }
                                            else if resizer.new_Note_Cell_Set.count > 2 {
                                                let newCellArray = resizer.new_Note_Cell_Set.sorted(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                                                let firstIndex = 0
                                                let finalIndex = newCellArray.count-1
                                                newCellArray[firstIndex].change_Type(newType: .start_Note)
                                                newCellArray[firstIndex].note_Im_In = lcl_Note_At_Cursor
                                                lcl_Note_At_Cursor.lowest_Index = newCellArray[firstIndex].dataCell_X_Number
                                                for x in 1..<finalIndex{
                                                    newCellArray[x].change_Type(newType: .mid_Note)
                                                    newCellArray[x].note_Im_In = lcl_Note_At_Cursor
                                                }
                                                newCellArray[finalIndex].change_Type(newType: .end_Note)
                                                newCellArray[finalIndex].note_Im_In = lcl_Note_At_Cursor
                                                lcl_Note_At_Cursor.highest_Index = newCellArray[finalIndex].dataCell_X_Number
                                                for cell in newCellArray {
                                                    if cell.in_Resize_Set == true {cell.handleVisibleStateChange(type: .deActivate_Resize_Set)}
                                                    if cell.note_Im_In != lcl_Note_At_Cursor{cell.note_Im_In = lcl_Note_At_Cursor}
                                                }
                                                lcl_Note_At_Cursor.dataCellArray = newCellArray
                                                lcl_Note_At_Cursor.highestFourFourHalfCellIndex = newCellArray[finalIndex].four_Four_Half_Cell_Index
                                                lcl_Note_At_Cursor.lowestFourFourHalfCellIndex = newCellArray[firstIndex].four_Four_Half_Cell_Index
                                            }
                                        }
                                    }

        }
        
                        
                
//            }
//        }
    }

}

// right lets try this again....
// thing is ..... this class has to have an instance per line .......
// I think that the currently highlighted(the one where the cursor is actually at) can supply the delta information
// the ones where the cursor aint can
class Left_Side_Resizer_Garage {
    
    
    var snapshotMinHalfCellIndex : Int?
    var snapshotMaxHalfCellIndex : Int?
    var leftwardBarrierDataX : Int?
    var snapshot_Line_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    var new_Note_Cell_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    var available_Cell_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    
    init(snapshotMinHalfCellIndex: Int, snapshotMaxHalfCellIndex: Int, leftwardBarrierDataX: Int
         , snapshot_Line_Set: Set<Underlying_Data_Cell>){
         //, new_Note_Cell_Set: Set<Underlying_Data_Cell>, available_Cell_Set: Set<Underlying_Data_Cell>) {
        self.snapshotMinHalfCellIndex = snapshotMinHalfCellIndex
        self.snapshotMaxHalfCellIndex = snapshotMaxHalfCellIndex
        self.leftwardBarrierDataX = leftwardBarrierDataX
        self.snapshot_Line_Set = snapshot_Line_Set
//        self.new_Note_Cell_Set = new_Note_Cell_Set
//        self.available_Cell_Set = available_Cell_Set
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



//func left_Side_Resize_Start(){
//
//    snapshot_Line_Set = Set<Underlying_Data_Cell>(parentCentralState.currLine.dataCellArray)
//
//    if let lclCurrentNoteCollection = parentCentralState.currentNoteCollection {
//
//        if let lclCurrentNote = lclCurrentNoteCollection.note_Currently_Under_Cursor {
//
//            snapshot_highest_Note_Half_Cell_Index = lclCurrentNote.highestFourFourHalfCellIndex
//
//            snapshot_Note_Set = Set<Underlying_Data_Cell>(lclCurrentNote.dataCellArray)
//
//            snapshot_Note_Max_X = snapshot_Note_Set.max(by: { $0.dataCell_X_Number < $1.dataCell_X_Number })?.dataCell_X_Number
//
//            if let minNoteCell = snapshot_Note_Set.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
//
//                if let hSliderRef = parentCentralState.h_Slider_Ref {
//                    let destinationCellIndex = minNoteCell.dataCell_X_Number
//                    hSliderRef.jumpToACell(cellNum: destinationCellIndex)
//                }
//
//                snapshot_Cells_Left_Of_Note_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number < minNoteCell.dataCell_X_Number}
//
//                snapshot_Note_Cells_Left_Of_Note_Set = snapshot_Cells_Left_Of_Note_Set.filter{$0.note_Im_In != nil}
//
//                if snapshot_Note_Cells_Left_Of_Note_Set.count == 0 {
//                     leftwardBarrierDataX = 0
//                }
//                else if let maxNoteCellLeftOfNote = snapshot_Note_Cells_Left_Of_Note_Set.max(by: { $0.dataCell_X_Number < $1.dataCell_X_Number }){
//                    leftwardBarrierDataX = maxNoteCellLeftOfNote.dataCell_X_Number
//                }
//            }
//        }
//    }
//}



//    func resize_Left_Side_Handler(){
//
//        if let cursorMinCell = parentCentralState.current_Cursor_Set.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
//
//            let current_Cursor_Set_Min_X = cursorMinCell.dataCell_X_Number
//
//            if let lclNoteHighHalfCell = snapshot_highest_Note_Half_Cell_Index {
//
//                if parentCentralState.currentData.four_Four_Half_Cell_Index >= lclNoteHighHalfCell {
//
//                    new_Note_Cell_Set = snapshot_Line_Set.filter{$0.four_Four_Half_Cell_Index == lclNoteHighHalfCell}
//                    available_Cell_Set = snapshot_Line_Set.filter{$0.four_Four_Half_Cell_Index < lclNoteHighHalfCell}
//                }
//
//                else if parentCentralState.currentData.four_Four_Half_Cell_Index < lclNoteHighHalfCell {
//                    if let lclMinX = leftDataXLimit,let lclNoteNax = snapshot_Note_Max_X {
//                        if lclMinX == 0{
//                            available_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number >= lclMinX &&  $0.dataCell_X_Number < current_Cursor_Set_Min_X}
//                            new_Note_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number >= current_Cursor_Set_Min_X && $0.dataCell_X_Number <= lclNoteNax}
//                        }
//                        else if lclMinX > 0{
//                            available_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number > lclMinX &&  $0.dataCell_X_Number < current_Cursor_Set_Min_X}
//                            new_Note_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number >= current_Cursor_Set_Min_X && $0.dataCell_X_Number <= lclNoteNax}
//                        }
//                    }
//                }
//            }
//        }
//
//        paintCells()
//
//    }

//func right_Side_Resize_Start(){
//
//    snapshot_Line_Set = Set<Underlying_Data_Cell>(parentCentralState.currLine.dataCellArray)
//
//    if let lclCurrentNoteCollection = parentCentralState.currentNoteCollection {
//
//        if let lclCurrentNote = lclCurrentNoteCollection.note_Currently_Under_Cursor {
//
//            snapshot_Lowest_Note_Half_Cell_Index = lclCurrentNote.lowestFourFourHalfCellIndex
//
//            snapshot_Note_Set = Set<Underlying_Data_Cell>(lclCurrentNote.dataCellArray)
//
//            snapshot_Note_Min_X = snapshot_Note_Set.min(by: { $0.dataCell_X_Number < $1.dataCell_X_Number })?.dataCell_X_Number
//
//            if let maxNoteCell = snapshot_Note_Set.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
//
//                if let hSliderRef = parentCentralState.h_Slider_Ref {
//                    let destinationCellIndex = maxNoteCell.dataCell_X_Number
//                    hSliderRef.jumpToACell(cellNum: destinationCellIndex)
//                }
//
//                snapshot_Cells_Right_Of_Note_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number > maxNoteCell.dataCell_X_Number}
//                snapshot_Note_Cells_Right_Of_Note_Set = snapshot_Cells_Right_Of_Note_Set.filter{$0.note_Im_In != nil}
//                if snapshot_Note_Cells_Right_Of_Note_Set.count == 0 {
//                    rightwardBarrierDataX = dimensions.dataGrid_X_Unit_Count-1
//                }
//                else if let minNoteCellRightOfNote = snapshot_Note_Cells_Right_Of_Note_Set.min(by: { $0.dataCell_X_Number < $1.dataCell_X_Number }){
//                    rightwardBarrierDataX = minNoteCellRightOfNote.dataCell_X_Number
//                }
//            }
//
//        }
//    }
//}
//
//func resize_Right_Side_Handler(){
//
//    if let lcl_CursorMaxCell = parentCentralState.current_Cursor_Set.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
//        current_Cursor_Set_Max_X = lcl_CursorMaxCell.dataCell_X_Number
//    }
//
//    if let lclNoteLowhHalfCell = snapshot_Lowest_Note_Half_Cell_Index {
//        if parentCentralState.currentData.four_Four_Half_Cell_Index <= lclNoteLowhHalfCell {
//            new_Note_Cell_Set = snapshot_Line_Set.filter{$0.four_Four_Half_Cell_Index == lclNoteLowhHalfCell}
//            available_Cell_Set = snapshot_Line_Set.filter{$0.four_Four_Half_Cell_Index > lclNoteLowhHalfCell}
//        }
//        else if parentCentralState.currentData.four_Four_Half_Cell_Index > lclNoteLowhHalfCell {
//            if let lclMaxX = rightwardBarrierDataX, let lclCursorMax = current_Cursor_Set_Max_X,let lclNoteNin = snapshot_Note_Min_X {
//                available_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number < lclMaxX &&  $0.dataCell_X_Number > lclCursorMax}
//                new_Note_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number <= lclCursorMax && $0.dataCell_X_Number >= lclNoteNin}
//            }
//        }
//    }
//    paintCells()
//}
