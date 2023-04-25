//
//  File.swift
//  
//
//  Created by Jon on 21/02/2023.
//

import Foundation
import SwiftUI

class Delete_Helper : P_Selectable_Mode{
    
    var selectableModeId : Int
    var mode_Active: Bool = false
    
    func activate_Mode(activationCell: Underlying_Data_Cell?) {
        if mode_Active == false{
            mode_Active=true
            //if current_Trail_Corner == nil {current_Trail_Corner = activationCell}
        }
    }
    
    func generateModeDescriptorString()->String{
        return "Delete Mode"
    }
    
    func deactivate_Mode() {
        if mode_Active == true {
            mode_Active=false
            nil_Delete_Square_Set()
        }
    }
    
    var parentCentralState : Central_State

    let dimensions = ComponentDimensions.StaticDimensions

    var min_X : Int?
    var max_X : Int?
    var min_Y : Int?
    var max_Y : Int?

    var curr_Max_X_Right : Int?
    var curr_Max_X_Left : Int?
    var curr_Max_Y_Up : Int?
    var curr_Max_Y_Down : Int?

    var delete_Cursor_Set = Set<Underlying_Data_Cell>(){
        willSet {
            let delta = delete_Cursor_Set.symmetricDifference(newValue)
            for cell in delta {
                cell.handleVisibleStateChange(type: .deActivate_Delete_Square_Set)
            }
        }
        didSet {
            for cell in delete_Cursor_Set {
                cell.handleVisibleStateChange(type : .activate_Delete_Square_Set)
            }
        }
    }

    //var multiple_Line_Corners_Set = Set<Underlying_Data_Cell>()

    //var current_Direction : E_DeleteLineDirection = .stationary

//    var current_Trail_Corner : Underlying_Data_Cell?{
//        didSet {
//            if let lclDelete_Cursor_StartData = current_Trail_Corner {
//                let new_Corner_Set = parentCentralState.data_Grid.grid_Of_Cells_Set
//                .filter{$0.parentLine.line_Y_Num == lclDelete_Cursor_StartData.parentLine.line_Y_Num
//                    && $0.four_Four_Half_Cell_Index == lclDelete_Cursor_StartData.four_Four_Half_Cell_Index
//                }
//                for cell in new_Corner_Set{
//                    multiple_Line_Corners_Set.insert(cell)
//                }
//            }
//        }
//    }
    
    init(parentCentral_State_Param:Central_State,selectableModeIdParam:Int){
        selectableModeId = selectableModeIdParam
        parentCentralState = parentCentral_State_Param
    }

    func process_Delete_Cursor_Position() {
        if dimensions.patternTimingConfiguration == .fourFour {
            delete_Cursor_Set = parentCentralState.currLineSet.filter({$0.four_Four_Half_Cell_Index == parentCentralState.currentData.four_Four_Half_Cell_Index})
        }
        else if dimensions.patternTimingConfiguration == .sixEight {
            delete_Cursor_Set = parentCentralState.currLineSet.filter({$0.four_Four_Half_Cell_Index == parentCentralState.currentData.six_Eight_Half_Cell_Index})
        }
    }

    
//    func process_Current_Line(previousDataCell:Underlying_Data_Cell,nextDataCell:Underlying_Data_Cell) {
//
//        let deltaY = nextDataCell.parentLine.line_Y_Num - previousDataCell.parentLine.line_Y_Num
//        let deltaX = nextDataCell.dataCell_X_Number - previousDataCell.dataCell_X_Number
//
//
//    }
    
    var seperatedCellsFinalIndex : Int = 0
    var array_Of_Seperated_Cells = [Underlying_Data_Cell]()
    
    var between_Seperated = Set<Underlying_Data_Cell>(){
        willSet {
            let delta = delete_Cursor_Set.symmetricDifference(newValue)
            for cell in delta {
                cell.handleVisibleStateChange(type: .deActivate_Potential_Set )
            }
        }
        didSet {
            print("between_Sep count: ",between_Seperated.count)
            for cell in delete_Cursor_Set {
                cell.handleVisibleStateChange(type : .activate_Potential_Set )
            }
        }
    }
    
    
    func processCurrCell(cellParam:Underlying_Data_Cell){
        array_Of_Seperated_Cells.append(cellParam) // paint lines between these(because theyre ordered) using the sets which are faster
        seperatedCellsFinalIndex = array_Of_Seperated_Cells.count-1
        //print("seperatedCellsFinalIndex: ",seperatedCellsFinalIndex)
        processSeperatedCells()
    }
    
    func processSeperatedCells(){
        //print("processSeperatedCells()")
        if seperatedCellsFinalIndex > 0 {
            
            let secondLastCell = array_Of_Seperated_Cells[seperatedCellsFinalIndex-1]
            let lastCell = array_Of_Seperated_Cells[seperatedCellsFinalIndex]
 
            if lastCell.dataCell_X_Number > secondLastCell.dataCell_X_Number+1 {
                    let addedSet = parentCentralState.currLineSet.filter {
                        $0.dataCell_X_Number >= secondLastCell.dataCell_X_Number &&
                        $0.dataCell_X_Number <= lastCell.dataCell_X_Number
                    }
                between_Seperated = between_Seperated.union(addedSet)
            }
            else if lastCell.dataCell_X_Number == secondLastCell.dataCell_X_Number+1 {
                between_Seperated.insert(secondLastCell)
                between_Seperated.insert(lastCell)
            }
            else if lastCell.dataCell_X_Number == secondLastCell.dataCell_X_Number {
                between_Seperated.insert(lastCell)
            }
            
            
//            else if lastCell.dataCell_X_Number < secondLastCell.dataCell_X_Number-1 {
//                // add line between going from lastCell ... secondLastCell
//            }
//            else if lastCell.dataCell_X_Number == secondLastCell.dataCell_X_Number-1 {
//                // add line between going from lastCell ... secondLastCell
//            }
//            else if lastCell.dataCell_X_Number == secondLastCell.dataCell_X_Number {
//                // add line between going from lastCell ... secondLastCell
//            }
//
//
//            else if lastCell.parentLine.line_Y_Num > secondLastCell.parentLine.line_Y_Num+1 {
//                // add line between going from lastCell ... secondLastCell
//            }
//            else if lastCell.parentLine.line_Y_Num == secondLastCell.parentLine.line_Y_Num+1 {
//                // add line between going from lastCell ... secondLastCell
//            }
//            else if lastCell.parentLine.line_Y_Num == secondLastCell.parentLine.line_Y_Num  {
//                // add line between going from lastCell ... secondLastCell
//            }
//
//            else if lastCell.parentLine.line_Y_Num < secondLastCell.parentLine.line_Y_Num-1 {
//                // add line between going from lastCell ... secondLastCell
//            }
//            else if lastCell.parentLine.line_Y_Num == secondLastCell.parentLine.line_Y_Num-1 {
//                // add line between going from lastCell ... secondLastCell
//            }
//            else if lastCell.parentLine.line_Y_Num == secondLastCell.parentLine.line_Y_Num {
//                // add line between going from lastCell ... secondLastCell
//            }
            
        }
    }

    func nil_Delete_Square_Set(){
        if delete_Cursor_Set.count > 0 {
            for cell in delete_Cursor_Set {
                cell.handleVisibleStateChange(type: .deActivate_Delete_Square_Set)
            }
            delete_Cursor_Set.removeAll()
        }
    }

}

enum E_DeleteLineDirection : String {
    case horizontal = "horizontal"
    case vertical = "vertical"
    case stationary = "stationary"
}

//
//class Delete_Helper : P_Selectable_Mode{
//    var selectableModeId : Int
//    var mode_Active: Bool = false
//
//    func activate_Mode(activationCell: Underlying_Data_Cell?) {
//        if mode_Active == false{
//            mode_Active=true
//            if current_Trail_Corner == nil {current_Trail_Corner = activationCell}
//        }
//    }
//
//    func generateModeDescriptorString()->String{
//        return "Delete Mode"
//    }
//
//    func deactivate_Mode() {
//        if mode_Active == true {
//            mode_Active=false
//            nil_Delete_Square_Set()
//        }
//    }
//
//    var parentCentralState : Central_State
//
//    let dimensions = ComponentDimensions.StaticDimensions
//
//    var min_X : Int?
//    var max_X : Int?
//    var min_Y : Int?
//    var max_Y : Int?
//
//    var curr_Max_X_Right : Int?
//    var curr_Max_X_Left : Int?
//    var curr_Max_Y_Up : Int?
//    var curr_Max_Y_Down : Int?
//
//    var delete_Cursor_Set = Set<Underlying_Data_Cell>(){
//        willSet {
//            let delta = delete_Cursor_Set.symmetricDifference(newValue)
//            for cell in delta {
//                cell.handleVisibleStateChange(type: .deActivate_Delete_Square_Set)
//            }
//        }
//        didSet {
//            for cell in delete_Cursor_Set {
//                cell.handleVisibleStateChange(type : .activate_Delete_Square_Set)
//            }
//        }
//    }
//
//    var multiple_Line_Corners_Set = Set<Underlying_Data_Cell>()
//
//    var current_Direction : E_DeleteLineDirection = .stationary
//
//    var current_Trail_Corner : Underlying_Data_Cell?{
//        didSet {
//            if let lclDelete_Cursor_StartData = current_Trail_Corner {
//                let new_Corner_Set = parentCentralState.data_Grid.grid_Of_Cells_Set
//                    .filter{$0.parentLine.line_Y_Num == lclDelete_Cursor_StartData.parentLine.line_Y_Num
//                        && $0.four_Four_Half_Cell_Index == lclDelete_Cursor_StartData.four_Four_Half_Cell_Index
//                    }
////                .filter{$0.dataCell_Y_Number == lclDelete_Cursor_StartData.dataCell_Y_Number
////                    && $0.four_Four_Half_Cell_Index == lclDelete_Cursor_StartData.four_Four_Half_Cell_Index
////                }
//                for cell in new_Corner_Set{
//                    multiple_Line_Corners_Set.insert(cell)
//                }
//            }
//        }
//    }
//
//    init(parentCentral_State_Param:Central_State,selectableModeIdParam:Int){
//        selectableModeId = selectableModeIdParam
//        parentCentralState = parentCentral_State_Param
//    }
//
//    func process_Delete_Cursor_Position() {
//        if dimensions.patternTimingConfiguration == .fourFour {
//            delete_Cursor_Set = parentCentralState.currLineSet.filter({$0.four_Four_Half_Cell_Index == parentCentralState.currentData.four_Four_Half_Cell_Index})
//        }
//        else if dimensions.patternTimingConfiguration == .sixEight {
//            delete_Cursor_Set = parentCentralState.currLineSet.filter({$0.four_Four_Half_Cell_Index == parentCentralState.currentData.six_Eight_Half_Cell_Index})
//        }
//    }
//
//    func process_Current_Line(previousDataCell:Underlying_Data_Cell,nextDataCell:Underlying_Data_Cell) {
//
//        if let lclCurrent_Initial_Cell = current_Trail_Corner {
//
//            let initialX = lclCurrent_Initial_Cell.dataCell_X_Number
//            let initialY = lclCurrent_Initial_Cell.parentLine.line_Y_Num
//                //.dataCell_Y_Number
//            let prevX = previousDataCell.dataCell_X_Number
//            let prevY = previousDataCell.parentLine.line_Y_Num
//                //.dataCell_Y_Number
//            let nextX = nextDataCell.dataCell_X_Number
//            let nextY = nextDataCell.parentLine.line_Y_Num
//                //.dataCell_Y_Number
//            if current_Direction == .stationary {
//                if nextX != initialX{current_Direction = .horizontal}
//                else if nextY != initialY{current_Direction = .vertical}
//            }
//            else if current_Direction == .horizontal {
//                if prevY != nextY{
//                    current_Trail_Corner = previousDataCell
//                    current_Direction = .vertical
//                }
//                else if prevY == nextY {
//                    incorporate_Row_Into_DeleteSet(curr_Y: nextY, initialX: initialX, finalX: nextX)
//                }
//            }
//            else if current_Direction == .vertical {
//                if prevX != nextX{
//                    current_Trail_Corner = previousDataCell
//                    current_Direction = .horizontal
//                }
//                else if prevX == nextX{
//                    incorporate_Column_Into_DeleteSet(curr_X:nextX,initialY:initialY,finalY:nextY)
//                }
//            }
//
//        }
//
//    }
//
//    private func incorporate_Row_Into_DeleteSet(curr_Y:Int,initialX:Int,finalX:Int){
//
//        if finalX > initialX {
//            let new_Horz_Set =
//            parentCentralState.data_Grid.grid_Of_Cells_Set
//            .filter{$0.parentLine.line_Y_Num ==  curr_Y
//                && $0.dataCell_X_Number > initialX
//                && $0.dataCell_X_Number < finalX
//            }
//            for cell in new_Horz_Set{
//                if cell.in_Delete_Trail_Set == false{
//                    multiple_Line_Corners_Set.insert(cell)
//                    if let lclNoteCollectionRef = parentCentralState.currentNoteCollection{
//                        if let cellNote = cell.note_Im_In{lclNoteCollectionRef.delete_Note_By_Id(note_Id_Param: cellNote.id)}
//                    }
//                }
//            }
//        }
//        else if finalX < initialX {
//            let new_Horz_Set =
//            parentCentralState.data_Grid.grid_Of_Cells_Set
//            .filter{$0.parentLine.line_Y_Num ==  curr_Y
//                && $0.dataCell_X_Number < initialX
//                && $0.dataCell_X_Number > finalX
//            }
//            for cell in new_Horz_Set{
//                if cell.in_Delete_Trail_Set == false {
//                    multiple_Line_Corners_Set.insert(cell)
//                    if let lclNoteCollectionRef = parentCentralState.currentNoteCollection{
//                        if let cellNote = cell.note_Im_In{lclNoteCollectionRef.delete_Note_By_Id(note_Id_Param: cellNote.id)}
//                    }
//                }
//            }
//        }
//    }
//
//    private func incorporate_Column_Into_DeleteSet(curr_X:Int,initialY:Int,finalY:Int){
//
//        if finalY > initialY {
//            let new_Vert_Set =
//            parentCentralState.data_Grid.grid_Of_Cells_Set
//            .filter{$0.dataCell_X_Number == curr_X && $0.parentLine.line_Y_Num >= initialY && $0.parentLine.line_Y_Num <= finalY}
//
//            for cell in new_Vert_Set{
//                let cell_Set = parentCentralState.data_Grid.grid_Of_Cells_Set.filter{$0.four_Four_Half_Cell_Index == cell.four_Four_Half_Cell_Index}
//                for subCell in cell_Set{
//                    multiple_Line_Corners_Set.insert(subCell)
//                    if let lclNoteCollectionRef = parentCentralState.currentNoteCollection{
//                        if let cellNote = subCell.note_Im_In{lclNoteCollectionRef.delete_Note_By_Id(note_Id_Param: cellNote.id)}
//                    }
//                }
//            }
//
//        }
//        else if finalY < initialY {
//            let new_Vert_Set =
//            parentCentralState.data_Grid.grid_Of_Cells_Set
//            .filter{$0.dataCell_X_Number == curr_X && $0.parentLine.line_Y_Num >= finalY && $0.parentLine.line_Y_Num <= initialY}
//            for cell in new_Vert_Set{
//                let cell_Set = parentCentralState.data_Grid.grid_Of_Cells_Set.filter{$0.four_Four_Half_Cell_Index == cell.four_Four_Half_Cell_Index}
//                for subCell in cell_Set{
//                    multiple_Line_Corners_Set.insert(subCell)
//                    if let lclNoteCollectionRef = parentCentralState.currentNoteCollection{
//                        if let cellNote = subCell.note_Im_In{lclNoteCollectionRef.delete_Note_By_Id(note_Id_Param: cellNote.id)}
//                    }
//                }
//            }
//        }
//    }
//
//    func nil_Delete_Square_Set(){
//
//        if current_Direction != .stationary{current_Direction = .stationary}
//        if current_Trail_Corner != nil{current_Trail_Corner = nil}
//
//        if min_X != nil{min_X=nil}
//        if max_X != nil{max_X=nil}
//        if min_Y != nil{min_Y=nil}
//        if max_Y != nil{max_Y=nil}
//
//        if delete_Cursor_Set.count > 0 {
//            for cell in delete_Cursor_Set {
//                cell.handleVisibleStateChange(type: .deActivate_Delete_Square_Set)
//            }
//            delete_Cursor_Set.removeAll()
//        }
//
//        if multiple_Line_Corners_Set.count > 0 {
//            multiple_Line_Corners_Set.removeAll()
//        }
//
////        if delete_Area_Set.count > 0 {
////            for cell in delete_Area_Set {
////                cell.handleVisibleStateChange(type: .deActivate_Delete_Square_Set)
////            }
////            delete_Area_Set.removeAll()
////        }
//    }
//
//}
