//
//  Viable_Set_Helper_Funcs.swift
//  
//
//  Created by Jon on 16/01/2023.
//

import Foundation
import SwiftUI
class Viable_Set_Helper_Functions{
    
    let central_State_Ref : Central_State
    let dimensions = ComponentDimensions.StaticDimensions
    
    init(central_State_Param:Central_State){
        central_State_Ref = central_State_Param
    }
    
    var initial_WriteOnCell : Underlying_Data_Cell?{
        willSet {
            if initial_WriteOnCell == nil, let lclFirstPotential = newValue {
                var initialSet = Set<Underlying_Data_Cell>()
                initialSet.insert(lclFirstPotential)
                processPotentialNote(cell_Line_Set: initialSet, currentData: lclFirstPotential)
            }
        }
    }
    
    func process_CurrData_Not_In_Note(cell_Line_Set : Set<Underlying_Data_Cell>,currentData : Underlying_Data_Cell){

        let inViableCellsRight = cell_Line_Set.filter{$0.note_Im_In != nil && $0.dataCell_X_Number > currentData.dataCell_X_Number}
        let inViableCellsLeft = cell_Line_Set.filter{$0.note_Im_In != nil && $0.dataCell_X_Number < currentData.dataCell_X_Number}

        if inViableCellsRight.count == 0,inViableCellsLeft.count == 0 {
        let emptyCellsRight = cell_Line_Set.filter{$0.dataCell_X_Number > currentData.dataCell_X_Number}
        let emptyCellsLeft = cell_Line_Set.filter{$0.dataCell_X_Number < currentData.dataCell_X_Number}
        let currentCellSet = cell_Line_Set.filter{$0.dataCell_X_Number == currentData.dataCell_X_Number}
        central_State_Ref.viableSet_Combined = emptyCellsRight.union(currentCellSet).union(emptyCellsLeft)
        }
        else if inViableCellsRight.count != 0 && inViableCellsLeft.count == 0 {
            
            if let firstNonViableRight = inViableCellsRight.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                
                let viablesOnRight = cell_Line_Set.filter{
                $0.dataCell_X_Number >= currentData.dataCell_X_Number
                && $0.note_Im_In == nil
                && $0.dataCell_X_Number < firstNonViableRight.dataCell_X_Number
                }
                central_State_Ref.viableSet_Combined = viablesOnRight//.union(viablesOnLeft)
            }
        }
        else if inViableCellsRight.count == 0 && inViableCellsLeft.count != 0 {
            
            if let nearNonViableLeft = inViableCellsLeft.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                let viablesOnLeft = cell_Line_Set.filter{
                $0.dataCell_X_Number < currentData.dataCell_X_Number
                && $0.note_Im_In == nil
                && $0.dataCell_X_Number > nearNonViableLeft.dataCell_X_Number
                }
                central_State_Ref.viableSet_Combined = viablesOnLeft//.union(viablesOnLeft)
            }
        }
        else if inViableCellsRight.count != 0 && inViableCellsLeft.count != 0 {
            if let firstNonViableRight = inViableCellsRight.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
            ,let nearNonViableLeft = inViableCellsLeft.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                let viablesOnLeft = cell_Line_Set.filter{
                $0.dataCell_X_Number < currentData.dataCell_X_Number
                && $0.note_Im_In == nil
                && $0.dataCell_X_Number > nearNonViableLeft.dataCell_X_Number
                }
                let viablesOnRight = cell_Line_Set.filter{
                $0.dataCell_X_Number >= currentData.dataCell_X_Number
                && $0.note_Im_In == nil
                && $0.dataCell_X_Number < firstNonViableRight.dataCell_X_Number
                }
                central_State_Ref.viableSet_Combined = viablesOnLeft.union(viablesOnRight)
            }
        }
        
    }

    
    
    func processPotentialNote(cell_Line_Set : Set<Underlying_Data_Cell>,currentData : Underlying_Data_Cell){
        if let lclInitialCell = initial_WriteOnCell {
            
            if currentData.dataCell_X_Number > lclInitialCell.dataCell_X_Number {
                central_State_Ref.centralState_PotentialNoteSet =
                cell_Line_Set.filter{$0.dataCell_X_Number >= lclInitialCell.dataCell_X_Number && $0.dataCell_X_Number <= currentData.dataCell_X_Number}
            }
            
            else if currentData.dataCell_X_Number < lclInitialCell.dataCell_X_Number {
                central_State_Ref.centralState_PotentialNoteSet =
                cell_Line_Set.filter{$0.dataCell_X_Number <= lclInitialCell.dataCell_X_Number && $0.dataCell_X_Number >= currentData.dataCell_X_Number}
            }
            
            else if currentData.dataCell_X_Number == lclInitialCell.dataCell_X_Number {
                central_State_Ref.centralState_PotentialNoteSet = cell_Line_Set
            }
            
        }
    }
    
    func endPotentialNote(){
        
        if central_State_Ref.centralState_PotentialNoteSet.count > 2{
            if let min = central_State_Ref.centralState_PotentialNoteSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
            ,let max = central_State_Ref.centralState_PotentialNoteSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
            {
                min.change_Type(newType : .start_Note)
                max.change_Type(newType : .end_Note)
                let midz = central_State_Ref.centralState_PotentialNoteSet.filter({$0.dataCell_X_Number != min.dataCell_X_Number})
                for cell in midz{
                    cell.change_Type(newType : .mid_Note)
                }
            }
        }
        else if central_State_Ref.centralState_PotentialNoteSet.count == 2{
            if let min = central_State_Ref.centralState_PotentialNoteSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
            ,let max = central_State_Ref.centralState_PotentialNoteSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
            {
                min.change_Type(newType : .start_Note)
                max.change_Type(newType : .end_Note)
            }
        }
        else if central_State_Ref.centralState_PotentialNoteSet.count == 1 {
            if let single = central_State_Ref.centralState_PotentialNoteSet.first {
                single.change_Type(newType : .single_Note)
            }
        }
        
        if let lcl_Note_Collection_Ref = central_State_Ref.note_Collection_Ref{
            let noteArray : [Underlying_Data_Cell] = Array(central_State_Ref.centralState_PotentialNoteSet)
            lcl_Note_Collection_Ref.write_Note_Data(cellArrayParam: noteArray)
        }
        
        for cell in central_State_Ref.centralState_PotentialNoteSet {
            cell.handleVisibleStateChange(type: .deActivate_Potential_Set)
        }
        
        central_State_Ref.centralState_PotentialNoteSet.removeAll()
        
    }
    
    // cells right with note
    //            let inViableCellsRight = cell_Line_Set.filter{$0.note_Im_In != nil && $0.dataCell_X_Number > currentData.dataCell_X_Number}
    //            let nearestInviableRight = inViableCellsRight.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
    //            if let lclNearestRight = nearestInviableRight {
    //                let viable_Cells_Right = cell_Line_Set.filter{$0.dataCell_X_Number >= currentData.dataCell_X_Number && $0.dataCell_X_Number < lclNearestRight.dataCell_X_Number}
    //                viableSet = viable_Cells_Right
    //            }
    // cells left with note
    //            let inViableCellsLeft = cell_Line_Set.filter{$0.note_Im_In != nil && $0.dataCell_X_Number < currentData.dataCell_X_Number}
    //            let nearestInviableLeft = inViableCellsLeft.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
    //            if let lclNearestLeft = nearestInviableLeft {
    //                let viable_Cells_Left = cell_Line_Set.filter{$0.dataCell_X_Number <= currentData.dataCell_X_Number && $0.dataCell_X_Number > lclNearestLeft.dataCell_X_Number}
    //                viableSet = viable_Cells_Left
    //            }
    //
    
    
    
}
