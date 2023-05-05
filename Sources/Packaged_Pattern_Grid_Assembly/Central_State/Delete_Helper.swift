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

    var seperatedCellsFinalIndex : Int = 0
    var array_Of_Seperated_Cells = [Underlying_Data_Cell]()
    
    var between_Seperated_Cells_Set = Set<Underlying_Data_Cell>(){
//        willSet {
//            let delta = between_Seperated_Cells_Set.symmetricDifference(newValue)
//            for cell in delta {
//                cell.handleVisibleStateChange(type: .deActivate_Potential_Set )
//            }
//        }
        didSet {
            for cell in between_Seperated_Cells_Set {
                //cell.handleVisibleStateChange(type : .activate_Potential_Set )
                if let lclNote = cell.note_Im_In{
                    if let lclNoteCollection = parentCentralState.currentNoteCollection{
                        lclNoteCollection.delete_Note_By_Id(note_Id_Param: lclNote.id)
                    }
                }
            }
        }
    }
    
    func processCurrCell(cellParam:Underlying_Data_Cell){
        array_Of_Seperated_Cells.append(cellParam)
        seperatedCellsFinalIndex = array_Of_Seperated_Cells.count-1
        processSeperatedCells()
    }
    
    func processSeperatedCells(){
        if seperatedCellsFinalIndex > 0 {
            let secondLastCell = array_Of_Seperated_Cells[seperatedCellsFinalIndex-1]
            let lastCell = array_Of_Seperated_Cells[seperatedCellsFinalIndex]
            
            
            if dimensions.patternTimingConfiguration == .fourFour{
                
                if lastCell.dataCell_X_Number != secondLastCell.dataCell_X_Number {

                    let secondLastCell = array_Of_Seperated_Cells[seperatedCellsFinalIndex-1]
                    let lastCell = array_Of_Seperated_Cells[seperatedCellsFinalIndex]

                    let lastCellSet = lastCell.parentLine.cellSet.filter{$0.four_Four_Half_Cell_Index == lastCell.four_Four_Half_Cell_Index}
                    let secondLastCellSet = secondLastCell.parentLine.cellSet.filter{$0.four_Four_Half_Cell_Index == secondLastCell.four_Four_Half_Cell_Index}
                    
                    
                    if lastCell.dataCell_X_Number > secondLastCell.dataCell_X_Number {
                        if let minX = secondLastCellSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                        ,let maxX = lastCellSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                            let y_Set = parentCentralState.data_Grid.grid_Of_Cells_Set.filter {
                            $0.parentLine.line_Y_Num == lastCell.parentLine.line_Y_Num &&
                            $0.parentLine.line_Y_Num == secondLastCell.parentLine.line_Y_Num &&
                            $0.dataCell_X_Number >= minX.dataCell_X_Number &&
                            $0.dataCell_X_Number <= maxX.dataCell_X_Number
                            }
                            between_Seperated_Cells_Set = between_Seperated_Cells_Set.union(y_Set)
                        }
                    }
                    else if lastCell.dataCell_X_Number < secondLastCell.dataCell_X_Number {
                        if let minX = lastCellSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                        ,let maxX = secondLastCellSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                            let y_Set = parentCentralState.data_Grid.grid_Of_Cells_Set.filter {
                            $0.parentLine.line_Y_Num == lastCell.parentLine.line_Y_Num &&
                            $0.parentLine.line_Y_Num == secondLastCell.parentLine.line_Y_Num &&
                            $0.dataCell_X_Number >= minX.dataCell_X_Number &&
                            $0.dataCell_X_Number <= maxX.dataCell_X_Number
                            }
                            between_Seperated_Cells_Set = between_Seperated_Cells_Set.union(y_Set)
                        }
                    }
                    
                }
                else if lastCell.parentLine.line_Y_Num != secondLastCell.parentLine.line_Y_Num {

                    let x_Four_Four_Set = secondLastCell.parentLine.cellSet.filter{$0.four_Four_Half_Cell_Index == secondLastCell.four_Four_Half_Cell_Index}
                    if let minX = x_Four_Four_Set.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                    ,let maxX = x_Four_Four_Set.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){


                        if lastCell.parentLine.line_Y_Num > secondLastCell.parentLine.line_Y_Num {
                            let y_Set = parentCentralState.data_Grid.grid_Of_Cells_Set.filter {
                            $0.parentLine.line_Y_Num >= secondLastCell.parentLine.line_Y_Num &&
                            $0.parentLine.line_Y_Num <= lastCell.parentLine.line_Y_Num &&
                            $0.dataCell_X_Number >= minX.dataCell_X_Number &&
                            $0.dataCell_X_Number <= maxX.dataCell_X_Number
                            }
                            between_Seperated_Cells_Set = between_Seperated_Cells_Set.union(y_Set)
                        }
                        else if lastCell.parentLine.line_Y_Num < secondLastCell.parentLine.line_Y_Num {
                            let y_Set = parentCentralState.data_Grid.grid_Of_Cells_Set.filter {
                            $0.parentLine.line_Y_Num >= lastCell.parentLine.line_Y_Num &&
                            $0.parentLine.line_Y_Num <= secondLastCell.parentLine.line_Y_Num &&
                            $0.dataCell_X_Number >= minX.dataCell_X_Number &&
                            $0.dataCell_X_Number <= maxX.dataCell_X_Number
                            }
                            between_Seperated_Cells_Set = between_Seperated_Cells_Set.union(y_Set)
                        }
                        
                    }
                }
                
            }
            
            else if dimensions.patternTimingConfiguration == .sixEight{
                
                if lastCell.dataCell_X_Number != secondLastCell.dataCell_X_Number {
                    
                    let secondLastCell = array_Of_Seperated_Cells[seperatedCellsFinalIndex-1]
                    let lastCell = array_Of_Seperated_Cells[seperatedCellsFinalIndex]

                    let lastCellSet = lastCell.parentLine.cellSet.filter{$0.six_Eight_Half_Cell_Index == lastCell.six_Eight_Half_Cell_Index}
                    let secondLastCellSet = secondLastCell.parentLine.cellSet.filter{$0.six_Eight_Half_Cell_Index == secondLastCell.six_Eight_Half_Cell_Index}
                    
                    
                    if lastCell.dataCell_X_Number > secondLastCell.dataCell_X_Number {
                        if let minX = secondLastCellSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                        ,let maxX = lastCellSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                            let y_Set = parentCentralState.data_Grid.grid_Of_Cells_Set.filter {
                            $0.parentLine.line_Y_Num == lastCell.parentLine.line_Y_Num &&
                            $0.parentLine.line_Y_Num == secondLastCell.parentLine.line_Y_Num &&
                            $0.dataCell_X_Number >= minX.dataCell_X_Number &&
                            $0.dataCell_X_Number <= maxX.dataCell_X_Number
                            }
                            between_Seperated_Cells_Set = between_Seperated_Cells_Set.union(y_Set)
                        }
                    }
                    else if lastCell.dataCell_X_Number < secondLastCell.dataCell_X_Number {
                        if let minX = lastCellSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                        ,let maxX = secondLastCellSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                            let y_Set = parentCentralState.data_Grid.grid_Of_Cells_Set.filter {
                            $0.parentLine.line_Y_Num == lastCell.parentLine.line_Y_Num &&
                            $0.parentLine.line_Y_Num == secondLastCell.parentLine.line_Y_Num &&
                            $0.dataCell_X_Number >= minX.dataCell_X_Number &&
                            $0.dataCell_X_Number <= maxX.dataCell_X_Number
                            }
                            between_Seperated_Cells_Set = between_Seperated_Cells_Set.union(y_Set)
                        }
                    }
                    
                }
                else if lastCell.parentLine.line_Y_Num != secondLastCell.parentLine.line_Y_Num {
                    let x_Four_Four_Set = secondLastCell.parentLine.cellSet.filter{$0.six_Eight_Half_Cell_Index == secondLastCell.six_Eight_Half_Cell_Index}
                    if let minX = x_Four_Four_Set.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                    ,let maxX = x_Four_Four_Set.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){


                        if lastCell.parentLine.line_Y_Num > secondLastCell.parentLine.line_Y_Num {
                            let y_Set = parentCentralState.data_Grid.grid_Of_Cells_Set.filter {
                            $0.parentLine.line_Y_Num >= secondLastCell.parentLine.line_Y_Num &&
                            $0.parentLine.line_Y_Num <= lastCell.parentLine.line_Y_Num &&
                            $0.dataCell_X_Number >= minX.dataCell_X_Number &&
                            $0.dataCell_X_Number <= maxX.dataCell_X_Number
                            }
                            between_Seperated_Cells_Set = between_Seperated_Cells_Set.union(y_Set)
                        }
                        else if lastCell.parentLine.line_Y_Num < secondLastCell.parentLine.line_Y_Num {
                            let y_Set = parentCentralState.data_Grid.grid_Of_Cells_Set.filter {
                            $0.parentLine.line_Y_Num >= lastCell.parentLine.line_Y_Num &&
                            $0.parentLine.line_Y_Num <= secondLastCell.parentLine.line_Y_Num &&
                            $0.dataCell_X_Number >= minX.dataCell_X_Number &&
                            $0.dataCell_X_Number <= maxX.dataCell_X_Number
                            }
                            between_Seperated_Cells_Set = between_Seperated_Cells_Set.union(y_Set)
                        }
                        
                    }
                }
                
            }
            
            
        }
    }
    
    func nil_Delete_Square_Set(){
        if delete_Cursor_Set.count > 0 {
            for cell in delete_Cursor_Set {
                cell.handleVisibleStateChange(type: .deActivate_Delete_Square_Set)
            }
            delete_Cursor_Set.removeAll()
        }
        
        if array_Of_Seperated_Cells.count > 0{
            array_Of_Seperated_Cells.removeAll()
        }
        
        if between_Seperated_Cells_Set.count > 0 {
            between_Seperated_Cells_Set.removeAll()
        }
        
        
        seperatedCellsFinalIndex = 0
    }

}

enum E_DeleteLineDirection : String {
    case horizontal = "horizontal"
    case vertical = "vertical"
    case stationary = "stationary"
}
