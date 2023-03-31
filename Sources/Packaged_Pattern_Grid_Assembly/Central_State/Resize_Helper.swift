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

    //var select_Highlighted_Notes : [Note] = []
    
    var parentCentralState : Central_State

    
    
    //================= these will need to be arrays
    //var snapshot_Cursor_X : Int?
    //var snapshot_Cursor_X_Array : [Int] = []
    //var snapshot_Cursor_Y : Int?
    
    var rightDataXLimit : Int?
    var currentNextRight : Int?
    
    var leftDataXLimit : Int?
    var currentNextLeft : Int?
    
    var new_Note_Cell_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    var available_Cell_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    //================= /these will need to be arrays
    
    
    
    
    init(parentCentral_State_Param:Central_State,selectableModeIdParam:Int){
        selectableModeId = selectableModeIdParam
        parentCentralState = parentCentral_State_Param
    }
    
    func activate_Mode(activationCell: Underlying_Data_Cell?) {
        if mode_Active == false {
            mode_Active = true
            if let lclActivationCell = activationCell{
                //snapshot_Cursor_X = lclActivationCell.dataCell_X_Number
                //snapshot_Cursor_X_Array.append(lclActivationCell.dataCell_X_Number)
                //snapshot_Cursor_Y = lclActivationCell.dataCell_Y_Number
            }
        }
    }
    
    func generateModeDescriptorString() -> String {
        return parentCentralState.resizeMode.rawValue
    }

    
    
    
    func right_Side_Resize_Start(){
        
        if let lclNoteCollection = parentCentralState.currentNoteCollection {
            if let lcl_Note_At_Cursor = lclNoteCollection.note_Currently_Under_Cursor {
                if let hSliderRef = parentCentralState.h_Slider_Ref {
                    let destinationCellIndex = lcl_Note_At_Cursor.highest_Index - ((dimensions.pattern_Grid_Cell_Sub_Unit_Count/2)-1)
                    hSliderRef.jumpToACell(cellNum: destinationCellIndex)
                }
                let currNoteSet = Set<Underlying_Data_Cell>(lcl_Note_At_Cursor.dataCellArray)
                
                let allCellsOutSideNote = parentCentralState.currLineSet.subtracting(currNoteSet)
                
                if let lclCurrNoteMax = currNoteSet.max(by: {$0.dataCell_X_Number<$1.dataCell_X_Number}){
                    if lclCurrNoteMax.dataCell_X_Number < dimensions.dataGrid_X_Unit_Count-1 {
                        if parentCentralState.currLine.dataCellArray[lclCurrNoteMax.dataCell_X_Number+1].note_Im_In == nil{
                            
                            currentNextRight = lclCurrNoteMax.dataCell_X_Number+1
                            
                            let allCellsToRight = allCellsOutSideNote.filter({$0.dataCell_X_Number > lclCurrNoteMax.dataCell_X_Number})
                            let cells_On_Right_That_Have_Notes = allCellsToRight.filter{$0.note_Im_In != nil}
                            
                            if let firstCell_On_Right_Thats_In_A_Note = cells_On_Right_That_Have_Notes.min(by:{
                                $0.dataCell_X_Number < $1.dataCell_X_Number
                            }){
                                rightDataXLimit = firstCell_On_Right_Thats_In_A_Note.dataCell_X_Number
                            }
                            else if cells_On_Right_That_Have_Notes.count == 0 {
                                rightDataXLimit = dimensions.dataGrid_X_Unit_Count-1
                            }

                        }
                    }
                }
            }
        }

    }

    func resize_Right_Side_Handler(){
        if let lclNoteCollection = parentCentralState.currentNoteCollection {

            if let lcl_Note_At_Cursor = lclNoteCollection.note_Currently_Under_Cursor {

                let delta_X = parentCentralState.currentData.dataCell_X_Number - lcl_Note_At_Cursor.lowest_Index
                
                if dimensions.patternTimingConfiguration == .fourFour,lcl_Note_At_Cursor.dataCellArray.count > 0  {
                    
                    if delta_X >= 0, let lclRightMost = rightDataXLimit {
                        let cursorSet = parentCentralState.currLineSet.filter({
                        $0.four_Four_Half_Cell_Index == parentCentralState.currentData.four_Four_Half_Cell_Index})
                        
                        let lowCellSet = parentCentralState.currLineSet.filter({$0.four_Four_Half_Cell_Index == lcl_Note_At_Cursor.dataCellArray[0].four_Four_Half_Cell_Index})
                        
                        if let cursorMaxCell = cursorSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                        ,let leftMostCell = lowCellSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                            
//                            if lclRightMost == dimensions.dataGrid_X_Unit_Count-1{
//                                available_Cell_Set = parentCentralState.currLineSet.filter{$0.dataCell_X_Number >= leftMostCell.dataCell_X_Number && $0.dataCell_X_Number <= lclRightMost}
//                            }
//                            else if lclRightMost < dimensions.dataGrid_X_Unit_Count-1{
//                                available_Cell_Set = parentCentralState.currLineSet.filter{$0.dataCell_X_Number >= leftMostCell.dataCell_X_Number && $0.dataCell_X_Number < lclRightMost}
//                            }
                            available_Cell_Set = parentCentralState.currLineSet.filter{$0.dataCell_X_Number >= leftMostCell.dataCell_X_Number && $0.dataCell_X_Number <= lclRightMost}
                            
                            let currentSwipeSet = parentCentralState.currLineSet.filter{$0.dataCell_X_Number >= leftMostCell.dataCell_X_Number
                                && $0.dataCell_X_Number <= cursorMaxCell.dataCell_X_Number}
                            new_Note_Cell_Set = currentSwipeSet.intersection(available_Cell_Set)
                     
                            
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
                }
            }
        }
    }
    
    
    
    func left_Side_Resize_Start(){
        if let lclNoteCollection = parentCentralState.currentNoteCollection {
            print("...........0")
            if let lcl_Note_At_Cursor = lclNoteCollection.note_Currently_Under_Cursor {
                print("...........1")
                if let hSliderRef = parentCentralState.h_Slider_Ref {
                    let destinationCellIndex = lcl_Note_At_Cursor.lowest_Index //-
                    hSliderRef.jumpToACell(cellNum: destinationCellIndex)
                }
                let currNoteSet = Set<Underlying_Data_Cell>(lcl_Note_At_Cursor.dataCellArray)

                let allCellsOutSideNote = parentCentralState.currLineSet.subtracting(currNoteSet)

                if let lclCurrNoteMin = currNoteSet.min(by: {$0.dataCell_X_Number<$1.dataCell_X_Number}){
                    print("...........2")
                    if lclCurrNoteMin.dataCell_X_Number > 0 {
                        print("...........3")
                    // this is checking that there is at least one empty cell to the left
                        if parentCentralState.currLine.dataCellArray[lclCurrNoteMin.dataCell_X_Number-1].note_Im_In == nil{
                            print("...........4")
                            currentNextLeft = lclCurrNoteMin.dataCell_X_Number-1

                            let allCellsToLeft = allCellsOutSideNote.filter({$0.dataCell_X_Number < lclCurrNoteMin.dataCell_X_Number})
                            let cells_On_Left_That_Have_Notes = allCellsToLeft.filter{$0.note_Im_In != nil}

                            if let firstCell_On_Left_Thats_In_A_Note = cells_On_Left_That_Have_Notes.max(by:{
                                $0.dataCell_X_Number < $1.dataCell_X_Number
                            }){
                                leftDataXLimit = firstCell_On_Left_Thats_In_A_Note.dataCell_X_Number
                            }
                            else if cells_On_Left_That_Have_Notes.count == 0 {
                                leftDataXLimit = 0
                            }
                            
                            if let lclLeftDataLimit = leftDataXLimit {
                                print("lclLeftDataLimit : ",lclLeftDataLimit.description)
                            }
                            else if leftDataXLimit == nil {
                                print("leftDataXLimit == nil")
                            }
                            
                        }
                    }
                    else if lclCurrNoteMin.dataCell_X_Number == 0 {
                        currentNextLeft = 0
                        leftDataXLimit = 0
                    }
                }
            }
        }
    }
    
    func resize_Left_Side_Handler(){
        //print("resize_Left_Side_Handler().....0")
        if let lclNoteCollection = parentCentralState.currentNoteCollection {
            //print("resize_Left_Side_Handler()   1.5")
            if let lcl_Note_At_Cursor = lclNoteCollection.note_Currently_Under_Cursor {
                //print("resize_Left_Side_Handler()   2")
                let delta_X = lcl_Note_At_Cursor.highest_Index - parentCentralState.currentData.dataCell_X_Number
                
                if dimensions.patternTimingConfiguration == .fourFour,lcl_Note_At_Cursor.dataCellArray.count > 0 {
                    //print("resize_Left_Side_Handler()   2.5,.....leftDataXLimit: ",leftDataXLimit == nil ? "neel" : "not neel")
                    //if let lclleftDataXLimit = leftDataXLimit {print("lclleftDataXLimit: ",lclleftDataXLimit,", delta_X: ",delta_X.description)}
                    if delta_X >= 0, let lclLeftMost = leftDataXLimit {
                        //print("resize_Left_Side_Handler()   3")
                    let cursorSet = parentCentralState.currLineSet.filter({
                    $0.four_Four_Half_Cell_Index == parentCentralState.currentData.four_Four_Half_Cell_Index})
                    let right_Most_CellGroup_In_Note = parentCentralState.currLineSet.filter({$0.four_Four_Half_Cell_Index
                        == lcl_Note_At_Cursor.dataCellArray[lcl_Note_At_Cursor.dataCellArray.count-1].four_Four_Half_Cell_Index})

                        if let cursorMinCell = cursorSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                        ,let rightMostCell = right_Most_CellGroup_In_Note.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                            //("resize_Left_Side_Handler()   4")
                        
                        if lclLeftMost == 0 {
                            available_Cell_Set = parentCentralState.currLineSet.filter{$0.dataCell_X_Number >= lclLeftMost && $0.dataCell_X_Number <= rightMostCell.dataCell_X_Number}
                        }
                        else if lclLeftMost > 0 {
                            available_Cell_Set = parentCentralState.currLineSet.filter{$0.dataCell_X_Number > lclLeftMost && $0.dataCell_X_Number <= rightMostCell.dataCell_X_Number}
                        }
                    
                                                
                    let currentSwipeSet = parentCentralState.currLineSet.filter{$0.dataCell_X_Number >= cursorMinCell.dataCell_X_Number && $0.dataCell_X_Number <= rightMostCell.dataCell_X_Number}
                            
                            new_Note_Cell_Set = currentSwipeSet.intersection(available_Cell_Set)

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
                }
            }
        }
    }
    
    
    
    
    
    func write_The_Altered_Note(){
        if new_Note_Cell_Set.count > 0 {
            if let lclNoteCollection = parentCentralState.currentNoteCollection {
                if let lcl_Note_At_Cursor = lclNoteCollection.note_Currently_Under_Cursor {
                    lcl_Note_At_Cursor.dataCellArray.removeAll()
                    if new_Note_Cell_Set.count == 1 {
                        let newCellArray = Array(new_Note_Cell_Set)
                        newCellArray[0].change_Type(newType: .single_Note)
                        newCellArray[0].note_Im_In = lcl_Note_At_Cursor
                        lcl_Note_At_Cursor.lowest_Index = newCellArray[0].dataCell_X_Number
                        lcl_Note_At_Cursor.highest_Index = newCellArray[0].dataCell_X_Number
                        for cell in newCellArray{
                            if cell.in_Resize_Set == true {cell.handleVisibleStateChange(type: .deActivate_Resize_Set)}
                            if cell.note_Im_In != lcl_Note_At_Cursor{cell.note_Im_In = lcl_Note_At_Cursor}
                        }
                        lcl_Note_At_Cursor.dataCellArray = newCellArray
                    }
                    else if new_Note_Cell_Set.count == 2 {
                        let newCellArray = new_Note_Cell_Set.sorted(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
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
                    }
                    else if new_Note_Cell_Set.count > 2 {
                        let newCellArray = new_Note_Cell_Set.sorted(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
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
                        for cell in newCellArray{
                            if cell.in_Resize_Set == true {cell.handleVisibleStateChange(type: .deActivate_Resize_Set)}
                            if cell.note_Im_In != lcl_Note_At_Cursor{cell.note_Im_In = lcl_Note_At_Cursor}
                        }
                        lcl_Note_At_Cursor.dataCellArray = newCellArray
                    }
                }
            }
        }
    }

    func deactivate_Mode() {
        if mode_Active == true {
            write_The_Altered_Note()
            if available_Cell_Set.count > 0 {
                available_Cell_Set.removeAll()
            }
            if new_Note_Cell_Set.count > 0 {
                new_Note_Cell_Set.removeAll()
            }
            mode_Active=false
        }
        //if snapshot_Cursor_X_Array.count > 0{snapshot_Cursor_X_Array.removeAll()}
    }
}

public enum E_Resize_Mode : String {
    case rightSideSubMode = "Resize Rightward"
    case leftSideSubMode = "Resize Leftward"
}
