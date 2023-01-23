//
//  Viable_Set_Helper_Funcs.swift
//  
//
//  Created by Jon on 16/01/2023.
//

import Foundation
import SwiftUI
class Viable_Set_Helper_Functions{
    
    let dimensions = ComponentDimensions.StaticDimensions
    
    init(){
        currentData = Underlying_Data_Grid.Static_Underlying_Data_Grid.dataLineArray[0].dataCellArray[0]
    }
    
    var currentData : Underlying_Data_Cell
    
    func writeNote(){
        if centralState_PotentialNoteSet.count > 2{
            if let min = centralState_PotentialNoteSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
            ,let max = centralState_PotentialNoteSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
            {
                min.change_Type(newType : .start_Note)
                max.change_Type(newType : .end_Note)
                let midz = centralState_PotentialNoteSet.filter({$0.dataCell_X_Number != min.dataCell_X_Number})
                for cell in midz{
                    cell.change_Type(newType : .mid_Note)
                }
            }
        }
        else if centralState_PotentialNoteSet.count == 2{
            if let min = centralState_PotentialNoteSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
            ,let max = centralState_PotentialNoteSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
            {
                min.change_Type(newType : .start_Note)
                max.change_Type(newType : .end_Note)
            }
        }
        else if centralState_PotentialNoteSet.count == 1 {
            if let single = centralState_PotentialNoteSet.first {
                single.change_Type(newType : .single_Note)
            }
        }

        let noteArray : [Underlying_Data_Cell] = Array(centralState_PotentialNoteSet)
        Note_Collection.Static_Note_Collection.write_Note_Data(cellArrayParam: noteArray)

    }
    
    var initial_WriteOnCell : Underlying_Data_Cell?
    {
        willSet {
            if newValue == nil {
                for cell in centralState_PotentialNoteSet {
                    cell.handleVisibleStateChange(type: .deActivate_Potential_Set)
                }
                centralState_PotentialNoteSet.removeAll()
            }
        }
    }

    var current_Cell_Line_Set = Set<Underlying_Data_Cell>()
    
    var viableSet_Combined = Set<Underlying_Data_Cell>(){
        willSet {
            let delta = viableSet_Combined.symmetricDifference(newValue)
            for cell in delta {
                cell.handleVisibleStateChange(type : .deActivate_Viable_Set_Combined)
            }
        }
        didSet {
            for cell in viableSet_Combined {
                cell.handleVisibleStateChange(type : .activate_Viable_Set_Combined)
            }
        }
    }
    
    var centralState_PotentialNoteSet = Set<Underlying_Data_Cell>()
    {
        willSet {
            let delta = centralState_PotentialNoteSet.symmetricDifference(newValue)
            for cell in delta {
                cell.handleVisibleStateChange(type: .deActivate_Potential_Set)
            }
        }
        didSet {
            for cell in centralState_PotentialNoteSet {
                cell.handleVisibleStateChange(type: .activate_Potential_Set)
            }
        }
    }

    func establish_Viable_Cells_Set(){
        let inViableCellsRight = current_Cell_Line_Set.filter{$0.note_Im_In != nil && $0.dataCell_X_Number > currentData.dataCell_X_Number}
        let inViableCellsLeft = current_Cell_Line_Set.filter{$0.note_Im_In != nil && $0.dataCell_X_Number < currentData.dataCell_X_Number}
        
        if inViableCellsRight.count == 0,inViableCellsLeft.count == 0 {
        let emptyCellsRight = current_Cell_Line_Set.filter{$0.dataCell_X_Number > currentData.dataCell_X_Number}
        let emptyCellsLeft = current_Cell_Line_Set.filter{$0.dataCell_X_Number < currentData.dataCell_X_Number}
        let currentCellSet = current_Cell_Line_Set.filter{$0.dataCell_X_Number == currentData.dataCell_X_Number}
        viableSet_Combined = emptyCellsRight.union(currentCellSet).union(emptyCellsLeft)
        }
        
//        else if inViableCellsRight.count != 0 && inViableCellsLeft.count == 0 {
//    
//            if let firstNonViableRight = inViableCellsRight.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
//    
//                let viablesOnRight = current_Cell_Line_Set.filter{
//                $0.dataCell_X_Number > currentData.dataCell_X_Number
//                && $0.note_Im_In == nil
//                && $0.dataCell_X_Number < firstNonViableRight.dataCell_X_Number
//                }
//                
//                let viablesOnLeft = current_Cell_Line_Set.filter{
//                $0.dataCell_X_Number < currentData.dataCell_X_Number
//                && $0.note_Im_In == nil
//                }
//                
//                let currentCellSet = current_Cell_Line_Set.filter({$0.dataCell_X_Number != currentData.dataCell_X_Number})
//      
//                viableSet_Combined = viablesOnLeft.union(viablesOnRight).union(currentCellSet)
//            }
//        }
        
        else if inViableCellsRight.count == 0 && inViableCellsLeft.count != 0 {
    
            if let nearNonViableLeft = inViableCellsLeft.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                
                let viablesOnLeft = current_Cell_Line_Set.filter {
                $0.dataCell_X_Number < currentData.dataCell_X_Number
                && $0.note_Im_In == nil
                && $0.dataCell_X_Number > nearNonViableLeft.dataCell_X_Number
                }
                // gotta have on right as well
                let viablesOnRight = current_Cell_Line_Set.filter{
                $0.dataCell_X_Number > currentData.dataCell_X_Number
                && $0.note_Im_In == nil
                }
                
                let currentCellSet = current_Cell_Line_Set.filter({$0.dataCell_X_Number != currentData.dataCell_X_Number})
                
                viableSet_Combined = viablesOnLeft.union(viablesOnRight).union(currentCellSet)
            }
        }
        
        else if inViableCellsRight.count != 0 && inViableCellsLeft.count != 0 {
            if let firstNonViableRight = inViableCellsRight.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
            ,let nearNonViableLeft = inViableCellsLeft.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                
                let viablesOnLeft = current_Cell_Line_Set.filter{
                $0.dataCell_X_Number < currentData.dataCell_X_Number
                && $0.note_Im_In == nil
                && $0.dataCell_X_Number > nearNonViableLeft.dataCell_X_Number
                }
                
                let viablesOnRight = current_Cell_Line_Set.filter{
                $0.dataCell_X_Number > currentData.dataCell_X_Number
                && $0.note_Im_In == nil
                && $0.dataCell_X_Number < firstNonViableRight.dataCell_X_Number
                }
                
                let currentCellSet = current_Cell_Line_Set.filter({$0.dataCell_X_Number != currentData.dataCell_X_Number})
                
                viableSet_Combined = viablesOnLeft.union(viablesOnRight).union(currentCellSet)
                
            }
        }
        
        
    }
    
    func establish_Potential_Cells_Set(){
        if let lclInitialCell = initial_WriteOnCell {
    
            if currentData.dataCell_X_Number > lclInitialCell.dataCell_X_Number {
//                centralState_PotentialNoteSet =
//                cell_Line_Set.filter{$0.dataCell_X_Number >= lclInitialCell.dataCell_X_Number && $0.dataCell_X_Number <= currentData.dataCell_X_Number}
                centralState_PotentialNoteSet = viableSet_Combined
                .filter({$0.dataCell_X_Number >= lclInitialCell.dataCell_X_Number && $0.dataCell_X_Number <= currentData.dataCell_X_Number})
            }
    
            else if currentData.dataCell_X_Number < lclInitialCell.dataCell_X_Number {
//                centralState_PotentialNoteSet =
//                cell_Line_Set.filter{$0.dataCell_X_Number <= lclInitialCell.dataCell_X_Number && $0.dataCell_X_Number >= currentData.dataCell_X_Number}
                centralState_PotentialNoteSet =
                viableSet_Combined.filter{$0.dataCell_X_Number <= lclInitialCell.dataCell_X_Number && $0.dataCell_X_Number >= currentData.dataCell_X_Number}
            }
    
            else if currentData.dataCell_X_Number == lclInitialCell.dataCell_X_Number {
//                centralState_PotentialNoteSet = cell_Line_Set
                centralState_PotentialNoteSet = viableSet_Combined.filter{$0.dataCell_X_Number == currentData.dataCell_X_Number}
            }
    
        }
    }
    
    
}


//
//func process_CurrData_Not_In_Note(cell_Line_Set : Set<Underlying_Data_Cell>,currentData : Underlying_Data_Cell){
//
//    let inViableCellsRight = cell_Line_Set.filter{$0.note_Im_In != nil && $0.dataCell_X_Number > currentData.dataCell_X_Number}
//    let inViableCellsLeft = cell_Line_Set.filter{$0.note_Im_In != nil && $0.dataCell_X_Number < currentData.dataCell_X_Number}
//
//    if inViableCellsRight.count == 0,inViableCellsLeft.count == 0 {
//    let emptyCellsRight = cell_Line_Set.filter{$0.dataCell_X_Number > currentData.dataCell_X_Number}
//    let emptyCellsLeft = cell_Line_Set.filter{$0.dataCell_X_Number < currentData.dataCell_X_Number}
//    let currentCellSet = cell_Line_Set.filter{$0.dataCell_X_Number == currentData.dataCell_X_Number}
//    viableSet_Combined = emptyCellsRight.union(currentCellSet).union(emptyCellsLeft)
//    }
//    else if inViableCellsRight.count != 0 && inViableCellsLeft.count == 0 {
//
//        if let firstNonViableRight = inViableCellsRight.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
//
//            let viablesOnRight = cell_Line_Set.filter{
//            $0.dataCell_X_Number >= currentData.dataCell_X_Number
//            && $0.note_Im_In == nil
//            && $0.dataCell_X_Number < firstNonViableRight.dataCell_X_Number
//            }
//            viableSet_Combined = viablesOnRight//.union(viablesOnLeft)
//        }
//    }
//    else if inViableCellsRight.count == 0 && inViableCellsLeft.count != 0 {
//
//        if let nearNonViableLeft = inViableCellsLeft.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
//            let viablesOnLeft = cell_Line_Set.filter{
//            $0.dataCell_X_Number < currentData.dataCell_X_Number
//            && $0.note_Im_In == nil
//            && $0.dataCell_X_Number > nearNonViableLeft.dataCell_X_Number
//            }
//            viableSet_Combined = viablesOnLeft//.union(viablesOnLeft)
//        }
//    }
//    else if inViableCellsRight.count != 0 && inViableCellsLeft.count != 0 {
//        if let firstNonViableRight = inViableCellsRight.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
//        ,let nearNonViableLeft = inViableCellsLeft.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
//            let viablesOnLeft = cell_Line_Set.filter{
//            $0.dataCell_X_Number < currentData.dataCell_X_Number
//            && $0.note_Im_In == nil
//            && $0.dataCell_X_Number > nearNonViableLeft.dataCell_X_Number
//            }
//            let viablesOnRight = cell_Line_Set.filter{
//            $0.dataCell_X_Number >= currentData.dataCell_X_Number
//            && $0.note_Im_In == nil
//            && $0.dataCell_X_Number < firstNonViableRight.dataCell_X_Number
//            }
//            viableSet_Combined = viablesOnLeft.union(viablesOnRight)
//        }
//    }
//
//}
//
//func processPotentialNote(cell_Line_Set : Set<Underlying_Data_Cell>,currentData : Underlying_Data_Cell){
//    if let lclInitialCell = initial_WriteOnCell {
//
//        if currentData.dataCell_X_Number > lclInitialCell.dataCell_X_Number {
//            centralState_PotentialNoteSet =
//            cell_Line_Set.filter{$0.dataCell_X_Number >= lclInitialCell.dataCell_X_Number && $0.dataCell_X_Number <= currentData.dataCell_X_Number}
//        }
//
//        else if currentData.dataCell_X_Number < lclInitialCell.dataCell_X_Number {
//            centralState_PotentialNoteSet =
//            cell_Line_Set.filter{$0.dataCell_X_Number <= lclInitialCell.dataCell_X_Number && $0.dataCell_X_Number >= currentData.dataCell_X_Number}
//        }
//
//        else if currentData.dataCell_X_Number == lclInitialCell.dataCell_X_Number {
//            centralState_PotentialNoteSet = cell_Line_Set
//        }
//
//    }
//}
//
//func endPotentialNote(){
//
//    if centralState_PotentialNoteSet.count > 2{
//        if let min = centralState_PotentialNoteSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
//        ,let max = centralState_PotentialNoteSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
//        {
//            min.change_Type(newType : .start_Note)
//            max.change_Type(newType : .end_Note)
//            let midz = centralState_PotentialNoteSet.filter({$0.dataCell_X_Number != min.dataCell_X_Number})
//            for cell in midz{
//                cell.change_Type(newType : .mid_Note)
//            }
//        }
//    }
//    else if centralState_PotentialNoteSet.count == 2{
//        if let min = centralState_PotentialNoteSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
//        ,let max = centralState_PotentialNoteSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
//        {
//            min.change_Type(newType : .start_Note)
//            max.change_Type(newType : .end_Note)
//        }
//    }
//    else if centralState_PotentialNoteSet.count == 1 {
//        if let single = centralState_PotentialNoteSet.first {
//            single.change_Type(newType : .single_Note)
//        }
//    }
//
//    let noteArray : [Underlying_Data_Cell] = Array(centralState_PotentialNoteSet)
//    Note_Collection.Static_Note_Collection.write_Note_Data(cellArrayParam: noteArray)
//
//    for cell in centralState_PotentialNoteSet {
//        cell.handleVisibleStateChange(type: .deActivate_Potential_Set)
//    }
//
//    centralState_PotentialNoteSet.removeAll()
//
//}
