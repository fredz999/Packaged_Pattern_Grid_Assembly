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
    
    var rightDataXLimit : Int?
    //var currentNextRight : Int?
    
    var leftDataXLimit : Int?
    //var currentNextLeft : Int?
    
    var new_Note_Cell_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
//    {
//        didSet{
//            print("new_Note_Cell_Set count : ",new_Note_Cell_Set.count)
//        }
//    }
    var available_Cell_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
//    {
//        didSet{
//            print("available_Cell_Set count : ",available_Cell_Set.count)
//        }
//    }
    
    //================= /these will need to be arrays
    
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
                resize_Right_Side_Handler()
            }
        }
        else if modeParam == .leftSideSubMode, resizeMode == .rightSideSubMode {
            resizeMode = .leftSideSubMode
            if mode_Active == true {
                write_The_Altered_Note()
                left_Side_Resize_Start()
                resize_Left_Side_Handler()
            }
        }
    }
    
    public var mode_Active: Bool = false
    
    func activate_Mode(activationCell: Underlying_Data_Cell?) {
        if mode_Active == false {
            mode_Active = true
            if resizeMode == .leftSideSubMode{
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
            resize_Right_Side_Handler()
        }
        else if resizeMode == .leftSideSubMode {
            resize_Left_Side_Handler()
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
            
            if snapshot_Line_Set.count > 0{snapshot_Line_Set.removeAll()}
            if snapshot_Note_Set.count > 0{snapshot_Note_Set.removeAll()}
            if snapshot_Cells_Left_Of_Note_Set.count > 0{snapshot_Cells_Left_Of_Note_Set.removeAll()}
            if snapshot_Note_Cells_Left_Of_Note_Set.count > 0{snapshot_Note_Cells_Left_Of_Note_Set.removeAll()}
            if snapshot_highest_Note_Half_Cell_Index != nil{snapshot_highest_Note_Half_Cell_Index = nil}
            
            if snapshot_Cells_Right_Of_Note_Set.count > 0{snapshot_Cells_Right_Of_Note_Set.removeAll()}
            if snapshot_Note_Cells_Right_Of_Note_Set.count > 0{snapshot_Note_Cells_Right_Of_Note_Set.removeAll()}
            if snapshot_Lowest_Note_Half_Cell_Index != nil{snapshot_Lowest_Note_Half_Cell_Index = nil}
            if current_Cursor_Set_Max_X != nil{current_Cursor_Set_Max_X = nil}
            if snapshot_Note_Min_X != nil{snapshot_Note_Min_X = nil}
            
            
            mode_Active=false
        }
    }
    
    var snapshot_Line_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    var snapshot_Note_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    
    
    var snapshot_Cells_Left_Of_Note_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    var snapshot_Note_Cells_Left_Of_Note_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    var snapshot_highest_Note_Half_Cell_Index : Int?
    var current_Cursor_Set_Min_X : Int?
    var snapshot_Note_Max_X : Int?
    
    
    
    var snapshot_Cells_Right_Of_Note_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    var snapshot_Note_Cells_Right_Of_Note_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    var snapshot_Lowest_Note_Half_Cell_Index : Int?
    var current_Cursor_Set_Max_X : Int?
    var snapshot_Note_Min_X : Int?
    
    
    func right_Side_Resize_Start(){
        print("right_Side_Resize_Start 0")
        snapshot_Line_Set = Set<Underlying_Data_Cell>(parentCentralState.currLine.dataCellArray)

        if let lclCurrentNoteCollection = parentCentralState.currentNoteCollection {
            print("right_Side_Resize_Start 1")
            if let lclCurrentNote = lclCurrentNoteCollection.note_Currently_Under_Cursor {
                print("right_Side_Resize_Start 2")
                //snapshot_highest_Note_Half_Cell_Index = lclCurrentNote.highestFourFourHalfCellIndex
                snapshot_Lowest_Note_Half_Cell_Index = lclCurrentNote.lowestFourFourHalfCellIndex

                snapshot_Note_Set = Set<Underlying_Data_Cell>(lclCurrentNote.dataCellArray)

                snapshot_Note_Min_X = snapshot_Note_Set.min(by: { $0.dataCell_X_Number < $1.dataCell_X_Number })?.dataCell_X_Number

                if let maxNoteCell = snapshot_Note_Set.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                    print("right_Side_Resize_Start 3")
                    if let hSliderRef = parentCentralState.h_Slider_Ref {
                        let destinationCellIndex = maxNoteCell.dataCell_X_Number
                        hSliderRef.jumpToACell(cellNum: destinationCellIndex)
                    }

                    snapshot_Cells_Right_Of_Note_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number > maxNoteCell.dataCell_X_Number}

                    snapshot_Note_Cells_Right_Of_Note_Set = snapshot_Cells_Right_Of_Note_Set.filter{$0.note_Im_In != nil}

                    if snapshot_Cells_Right_Of_Note_Set.count == 0 {
                        print("right_Side_Resize_Start 4")
                        rightDataXLimit = dimensions.dataGrid_X_Unit_Count-1
                    }
                    else if let minNoteCellRightOfNote = snapshot_Note_Cells_Right_Of_Note_Set.min(by: { $0.dataCell_X_Number < $1.dataCell_X_Number }){
                        print("right_Side_Resize_Start 5")
                        rightDataXLimit = minNoteCellRightOfNote.dataCell_X_Number
                    }
                }
                
            }
        }
    }
    
    func resize_Right_Side_Handler(){
        //print("resize_Right_Side_Handler() 0")
        if let lcl_CursorMaxCell = parentCentralState.current_Cursor_Set.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
            //print("resize_Right_Side_Handler() 1")
            current_Cursor_Set_Max_X = lcl_CursorMaxCell.dataCell_X_Number
        }
        // parentCentralState.currentData.four_Four_Half_Cell_Index >= lclNoteHighHalfCell
        // parentCentralState.currentData.four_Four_Half_Cell_Index < lclNoteHighHalfCell

//        if let lclNoteHighHalfCell = snapshot_highest_Note_Half_Cell_Index {
//            if parentCentralState.currentData.four_Four_Half_Cell_Index >= lclNoteHighHalfCell {
//                new_Note_Cell_Set = snapshot_Note_Set.filter{$0.four_Four_Half_Cell_Index == lclNoteHighHalfCell}
//                available_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number < lclNoteHighHalfCell}
//            }
//            else if parentCentralState.currentData.four_Four_Half_Cell_Index < lclNoteHighHalfCell {
//                if let lclMinX = leftDataXLimit, let lclCursorMin = current_Cursor_Set_Min_X,let lclNoteNax = snapshot_Note_Max_X {
//                    available_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number > lclMinX &&  $0.dataCell_X_Number < lclCursorMin}
//                    new_Note_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number >= lclCursorMin && $0.dataCell_X_Number <= lclNoteNax}
//                }
//            }
//        }
        
        
        if let lclNoteLowhHalfCell = snapshot_Lowest_Note_Half_Cell_Index {
            //print("resize_Right_Side_Handler() 2")
            if parentCentralState.currentData.four_Four_Half_Cell_Index <= lclNoteLowhHalfCell {
                //print("resize_Right_Side_Handler() 3")
                new_Note_Cell_Set = snapshot_Note_Set.filter{$0.four_Four_Half_Cell_Index == lclNoteLowhHalfCell}
                available_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number > lclNoteLowhHalfCell}
            }
            else if parentCentralState.currentData.four_Four_Half_Cell_Index > lclNoteLowhHalfCell {
                //print("resize_Right_Side_Handler() 0")
                if let lclMaxX = rightDataXLimit, let lclCursorMax = current_Cursor_Set_Max_X,let lclNoteNin = snapshot_Note_Min_X {
                    //print("resize_Right_Side_Handler() 1")
                    available_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number < lclMaxX &&  $0.dataCell_X_Number > lclCursorMax}
                    new_Note_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number <= lclCursorMax && $0.dataCell_X_Number >= lclNoteNin}
                }
                else {
                    var summaryString = ""
                    
                    if rightDataXLimit == nil{summaryString+="rightDataXLimit = nil"}
                    if current_Cursor_Set_Max_X == nil{summaryString+="current_Cursor_Set_Max_X = nil"}
                    if snapshot_Note_Min_X == nil{summaryString+="snapshot_Note_Min_X = nil"}
                    print(summaryString)
                }
            }
        }
 
        for cell in available_Cell_Set {
            //print("resize_Right_Side_Handler() 5")
            cell.reset_To_Original()
            if cell.in_Resize_Set == true {
                cell.handleVisibleStateChange(type: .deActivate_Resize_Set)
            }
        }

        for cell in new_Note_Cell_Set {
            //print("resize_Right_Side_Handler() 6")
            cell.reset_To_Original()
            if cell.in_Resize_Set == false {
                cell.handleVisibleStateChange(type: .activate_Resize_Set)
            }
        }
    }

    
    
    
    
    func left_Side_Resize_Start(){

        snapshot_Line_Set = Set<Underlying_Data_Cell>(parentCentralState.currLine.dataCellArray)

        if let lclCurrentNoteCollection = parentCentralState.currentNoteCollection {
            
            if let lclCurrentNote = lclCurrentNoteCollection.note_Currently_Under_Cursor {
                
                snapshot_highest_Note_Half_Cell_Index = lclCurrentNote.highestFourFourHalfCellIndex
                
                snapshot_Note_Set = Set<Underlying_Data_Cell>(lclCurrentNote.dataCellArray)
                
                snapshot_Note_Max_X = snapshot_Note_Set.max(by: { $0.dataCell_X_Number < $1.dataCell_X_Number })?.dataCell_X_Number
                
                if let minNoteCell = snapshot_Note_Set.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                    
                    if let hSliderRef = parentCentralState.h_Slider_Ref {
                        let destinationCellIndex = minNoteCell.dataCell_X_Number
                        hSliderRef.jumpToACell(cellNum: destinationCellIndex)
                    }
 
                    snapshot_Cells_Left_Of_Note_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number < minNoteCell.dataCell_X_Number}
 
                    snapshot_Note_Cells_Left_Of_Note_Set = snapshot_Cells_Left_Of_Note_Set.filter{$0.note_Im_In != nil}

                    if snapshot_Note_Cells_Left_Of_Note_Set.count == 0 {
                         leftDataXLimit = 0
                    }
                    else if let maxNoteCellLeftOfNote = snapshot_Note_Cells_Left_Of_Note_Set.max(by: { $0.dataCell_X_Number < $1.dataCell_X_Number }){
                        leftDataXLimit = maxNoteCellLeftOfNote.dataCell_X_Number
                    }
                }
            }
        }
    }
    
    func resize_Left_Side_Handler(){

        if let cursorMinCell = parentCentralState.current_Cursor_Set.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
            current_Cursor_Set_Min_X = cursorMinCell.dataCell_X_Number
        }

        if let lclNoteHighHalfCell = snapshot_highest_Note_Half_Cell_Index {
            if parentCentralState.currentData.four_Four_Half_Cell_Index >= lclNoteHighHalfCell {
                new_Note_Cell_Set = snapshot_Note_Set.filter{$0.four_Four_Half_Cell_Index == lclNoteHighHalfCell}
                available_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number < lclNoteHighHalfCell}
            }
            else if parentCentralState.currentData.four_Four_Half_Cell_Index < lclNoteHighHalfCell {
                if let lclMinX = leftDataXLimit, let lclCursorMin = current_Cursor_Set_Min_X,let lclNoteNax = snapshot_Note_Max_X {
                    available_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number > lclMinX &&  $0.dataCell_X_Number < lclCursorMin}
                    new_Note_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number >= lclCursorMin && $0.dataCell_X_Number <= lclNoteNax}
                }
            }
        }
        
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

    public func write_The_Altered_Note(){

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
                        lcl_Note_At_Cursor.highestFourFourHalfCellIndex = newCellArray[0].four_Four_Half_Cell_Index
                        lcl_Note_At_Cursor.lowestFourFourHalfCellIndex = newCellArray[0].four_Four_Half_Cell_Index
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
                        lcl_Note_At_Cursor.highestFourFourHalfCellIndex = newCellArray[1].four_Four_Half_Cell_Index
                        lcl_Note_At_Cursor.lowestFourFourHalfCellIndex = newCellArray[0].four_Four_Half_Cell_Index
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
    }

    
}

public enum E_Resize_Mode : String {
    case rightSideSubMode = "Resize Rightward"
    case leftSideSubMode = "Resize Leftward"
}



//func resize_Right_Side_Handler(){
//    //print("resize_Right_Side_Handler() 0")
//    if let lclNoteCollection = parentCentralState.currentNoteCollection {
//
//        if let lcl_Note_At_Cursor = lclNoteCollection.note_Currently_Under_Cursor {
//            //print("resize_Right_Side_Handler() 1")
//            let delta_X = parentCentralState.currentData.dataCell_X_Number - lcl_Note_At_Cursor.lowest_Index
//
//            if dimensions.patternTimingConfiguration == .fourFour,lcl_Note_At_Cursor.dataCellArray.count > 0  {
//                //print("resize_Right_Side_Handler() 2")
//                if delta_X >= 0, let lclRightMost = rightDataXLimit {
//                    //print("resize_Right_Side_Handler() 3")
//                    let cursorSet = parentCentralState.currLineSet.filter({
//                    $0.four_Four_Half_Cell_Index == parentCentralState.currentData.four_Four_Half_Cell_Index})
//
//                    let lowCellSet = parentCentralState.currLineSet.filter({$0.four_Four_Half_Cell_Index == lcl_Note_At_Cursor.dataCellArray[0].four_Four_Half_Cell_Index})
//
//                    if let cursorMaxCell = cursorSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
//                    ,let leftMostCell = lowCellSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
//
//                        //print("resize_Right_Side_Handler() 4")
//
////                            if lclRightMost == dimensions.dataGrid_X_Unit_Count-1{
////                                available_Cell_Set = parentCentralState.currLineSet.filter{$0.dataCell_X_Number >= leftMostCell.dataCell_X_Number && $0.dataCell_X_Number <= lclRightMost}
////                            }
////                            else if lclRightMost < dimensions.dataGrid_X_Unit_Count-1{
////                                available_Cell_Set = parentCentralState.currLineSet.filter{$0.dataCell_X_Number >= leftMostCell.dataCell_X_Number && $0.dataCell_X_Number < lclRightMost}
////                            }
//
//                        available_Cell_Set = parentCentralState.currLineSet.filter{$0.dataCell_X_Number >= leftMostCell.dataCell_X_Number && $0.dataCell_X_Number < lclRightMost}
//
//                        let currentSwipeSet = parentCentralState.currLineSet.filter{$0.dataCell_X_Number >= leftMostCell.dataCell_X_Number
//                            && $0.dataCell_X_Number <= cursorMaxCell.dataCell_X_Number}
//                        new_Note_Cell_Set = currentSwipeSet.intersection(available_Cell_Set)
//
//
//                        for cell in available_Cell_Set {
//                            cell.reset_To_Original()
//                            if cell.in_Resize_Set == true {
//                                cell.handleVisibleStateChange(type: .deActivate_Resize_Set)
//                            }
//                        }
//
//                        for cell in new_Note_Cell_Set {
//                            cell.reset_To_Original()
//                            if cell.in_Resize_Set == false {
//                                cell.handleVisibleStateChange(type: .activate_Resize_Set)
//                            }
//                        }
//
//                    }
//                }
//            }
//        }
//    }
//}


//func right_Side_Resize_Start(){
//    //print("right_Side_Resize_Start() 0")
//    if let lclNoteCollection = parentCentralState.currentNoteCollection {
//        //print("right_Side_Resize_Start() 1")
//        if let lcl_Note_At_Cursor = lclNoteCollection.note_Currently_Under_Cursor {
//            //print("right_Side_Resize_Start() 2")
//            if let hSliderRef = parentCentralState.h_Slider_Ref {
//                //print("right_Side_Resize_Start() 3")
//                let destinationCellIndex = lcl_Note_At_Cursor.highest_Index - ((dimensions.pattern_Grid_Cell_Sub_Unit_Count/2)-1)
//                hSliderRef.jumpToACell(cellNum: destinationCellIndex)
//            }
//            let currNoteSet = Set<Underlying_Data_Cell>(lcl_Note_At_Cursor.dataCellArray)
//
//            let allCellsOutSideNote = parentCentralState.currLineSet.subtracting(currNoteSet)
//
//            if let lclCurrNoteMax = currNoteSet.max(by: {$0.dataCell_X_Number<$1.dataCell_X_Number}){
//                //print("right_Side_Resize_Start() 4, lclCurrNoteMax.dataCell_X_Number: ",lclCurrNoteMax.dataCell_X_Number)
//                if lclCurrNoteMax.dataCell_X_Number < dimensions.dataGrid_X_Unit_Count-1 {
//                    //print("right_Side_Resize_Start() 5")
//                    if parentCentralState.currLine.dataCellArray[lclCurrNoteMax.dataCell_X_Number+1].note_Im_In == nil{
//                        //print("right_Side_Resize_Start() 6")
//                        currentNextRight = lclCurrNoteMax.dataCell_X_Number+1
//
//                        let allCellsToRight = allCellsOutSideNote.filter({$0.dataCell_X_Number > lclCurrNoteMax.dataCell_X_Number})
//
//                        let cells_On_Right_That_Have_Notes = allCellsToRight.filter{$0.note_Im_In != nil}
//
//                        if let firstCell_On_Right_Thats_In_A_Note = cells_On_Right_That_Have_Notes.min(by:{
//                            $0.dataCell_X_Number < $1.dataCell_X_Number
//                        }){
//                            rightDataXLimit = firstCell_On_Right_Thats_In_A_Note.dataCell_X_Number
//                        }
//                        else if cells_On_Right_That_Have_Notes.count == 0 {
//                            rightDataXLimit = dimensions.dataGrid_X_Unit_Count-1
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//}



//    func left_Side_Resize_Start(){
//
//        if let lclNoteCollection = parentCentralState.currentNoteCollection {
//
//            if let lcl_Note_At_Cursor = lclNoteCollection.note_Currently_Under_Cursor {
//
//                if let hSliderRef = parentCentralState.h_Slider_Ref {
//                    let destinationCellIndex = lcl_Note_At_Cursor.lowest_Index
//                    hSliderRef.jumpToACell(cellNum: destinationCellIndex)
//                }
//                let currNoteSet = Set<Underlying_Data_Cell>(lcl_Note_At_Cursor.dataCellArray)
//
//                let allCellsOutSideNote = parentCentralState.currLineSet.subtracting(currNoteSet)
//
//                if let lclCurrNoteMin = currNoteSet.min(by: {$0.dataCell_X_Number<$1.dataCell_X_Number}){
//
//                    if lclCurrNoteMin.dataCell_X_Number > 0 {
//
//                        if parentCentralState.currLine.dataCellArray[lclCurrNoteMin.dataCell_X_Number-1].note_Im_In == nil{
//
//                            currentNextLeft = lclCurrNoteMin.dataCell_X_Number-1
//
//                            let allCellsToLeft = allCellsOutSideNote.filter({$0.dataCell_X_Number < lclCurrNoteMin.dataCell_X_Number})
//
//                            let cells_On_Left_That_Have_Notes = allCellsToLeft.filter{$0.note_Im_In != nil}
//
//                            if let firstCell_On_Left_Thats_In_A_Note = cells_On_Left_That_Have_Notes.max(by:{
//                                $0.dataCell_X_Number < $1.dataCell_X_Number
//                            }){
//                                leftDataXLimit = firstCell_On_Left_Thats_In_A_Note.dataCell_X_Number
//                            }
//                            else if cells_On_Left_That_Have_Notes.count == 0 {
//                                leftDataXLimit = 0
//                            }
//
//                            if let lclLeftDataLimit = leftDataXLimit {
//                                print("lclLeftDataLimit : ",lclLeftDataLimit.description)
//                            }
//                            else if leftDataXLimit == nil {
//                                print("leftDataXLimit == nil")
//                            }
//
//                        }
//                    }
//                    else if lclCurrNoteMin.dataCell_X_Number == 0 {
//                        currentNextLeft = 0
//                        leftDataXLimit = 0
//                    }
//                }
//            }
//        }
//    }
//
//    func resize_Left_Side_Handler(){
//
//        if let lclNoteCollection = parentCentralState.currentNoteCollection {
//
//            if let lcl_Note_At_Cursor = lclNoteCollection.note_Currently_Under_Cursor {
//
//                let delta_X = lcl_Note_At_Cursor.highest_Index - parentCentralState.currentData.dataCell_X_Number
//
//                if dimensions.patternTimingConfiguration == .fourFour,lcl_Note_At_Cursor.dataCellArray.count > 0 {
//
//                    if delta_X >= 0, let lclLeftMost = leftDataXLimit {
//
//                    let cursorSet = parentCentralState.currLineSet.filter({
//                    $0.four_Four_Half_Cell_Index == parentCentralState.currentData.four_Four_Half_Cell_Index})
//                    let right_Most_CellGroup_In_Note = parentCentralState.currLineSet.filter({$0.four_Four_Half_Cell_Index
//                        == lcl_Note_At_Cursor.dataCellArray[lcl_Note_At_Cursor.dataCellArray.count-1].four_Four_Half_Cell_Index})
//
//                        if let cursorMinCell = cursorSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
//                        ,let rightMostCell = right_Most_CellGroup_In_Note.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
//
//                        if lclLeftMost == 0 {
//                            available_Cell_Set = parentCentralState.currLineSet.filter{$0.dataCell_X_Number >= lclLeftMost && $0.dataCell_X_Number <= rightMostCell.dataCell_X_Number}
//                        }
//                        else if lclLeftMost > 0 {
//                            available_Cell_Set = parentCentralState.currLineSet.filter{$0.dataCell_X_Number > lclLeftMost && $0.dataCell_X_Number <= rightMostCell.dataCell_X_Number}
//                        }
//
//                        let currentSwipeSet = parentCentralState.currLineSet.filter{$0.dataCell_X_Number >= cursorMinCell.dataCell_X_Number && $0.dataCell_X_Number <= rightMostCell.dataCell_X_Number}
//
//                            if let csMax = currentSwipeSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
//                                print("currX: ",parentCentralState.curr_Data_Pos_X,"currentSwipeSet max: ",csMax.dataCell_X_Number)
//                            }
//
//
//
//                            new_Note_Cell_Set = currentSwipeSet.intersection(available_Cell_Set)
//
//                            for cell in available_Cell_Set {
//                                cell.reset_To_Original()
//                                if cell.in_Resize_Set == true {
//                                    cell.handleVisibleStateChange(type: .deActivate_Resize_Set)
//                                }
//                            }
//
//                            for cell in new_Note_Cell_Set {
//                                cell.reset_To_Original()
//                                if cell.in_Resize_Set == false {
//                                    cell.handleVisibleStateChange(type: .activate_Resize_Set)
//                                }
//                            }
//
//                        }
//                    }
//                    else if delta_X < 0{
//                        print("this zone needs to be processed as well")
//                        //todo: rethink getting all sides in process
//                        // start with each side and identify the areas(sets) that you need
//                    }
//                }
//            }
//        }
//    }
