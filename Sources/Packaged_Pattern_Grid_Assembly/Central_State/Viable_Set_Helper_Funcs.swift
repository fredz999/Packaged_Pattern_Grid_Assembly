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
    
    func process_CurrData_Not_In_Note(cell_Line_Set : Set<Underlying_Data_Cell>,currentData : Underlying_Data_Cell){
        
        let inViableCellsRight = cell_Line_Set.filter{$0.note_Im_In != nil && $0.dataCell_X_Number > currentData.dataCell_X_Number}
        let inViableCellsLeft = cell_Line_Set.filter{$0.note_Im_In != nil && $0.dataCell_X_Number < currentData.dataCell_X_Number}
        
        if inViableCellsRight.count == 0 {
            let emptyCellsRight = cell_Line_Set.filter{$0.dataCell_X_Number > currentData.dataCell_X_Number}
            central_State_Ref.viableSet_Right = emptyCellsRight
        }

        if inViableCellsLeft.count == 0 {
            let emptyCellsLeft = cell_Line_Set.filter{$0.dataCell_X_Number < currentData.dataCell_X_Number}
            central_State_Ref.viableSet_Left = emptyCellsLeft
        }
        
    }
    
    var initial_WriteOnCell : Underlying_Data_Cell?
    
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
                central_State_Ref.centralState_PotentialNoteSet =
                cell_Line_Set.filter{$0.dataCell_X_Number == lclInitialCell.dataCell_X_Number}
            }
            
            
        }
    }
    
    func endPotentialNote(){
        for cell in central_State_Ref.centralState_PotentialNoteSet{
            if cell.in_Potential_Set == true {
                cell.in_Potential_Set = false
            }
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
