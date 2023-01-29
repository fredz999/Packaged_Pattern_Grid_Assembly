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
        helperFuncs_currentData = Underlying_Data_Grid.Static_Underlying_Data_Grid.dataLineArray[0].dataCellArray[0]
        //cellNumberMultiplier = 2 // need this to be a val straight outta dimensions
        
    }
    
    var initial_WriteOnCell : Underlying_Data_Cell?
    {
        willSet {
            if newValue == nil {
                if helperFuncs_PotentialNoteSet.count > 0 {
                    nilPotentialSet()
                }
            }
            else if initial_WriteOnCell == nil {
                establish_Potential_Cells_Set()
            }
        }
        didSet{
            if let lclInitial = initial_WriteOnCell{
                print("how to capture when this is a leftward jumpover?....")
            }
        }
    }
    
    var helperFuncs_currentData : Underlying_Data_Cell
//    {
//        didSet {
//            print("dataX: ",helperFuncs_currentData.dataCell_X_Number.description
//            ,", 4:4 Cell: ",helperFuncs_currentData.four_Four_Cell_Index.description
//            ,", 4:4 Sub: ",helperFuncs_currentData.four_Four_Sub_Index.description
//            ,", 6:8 Cell: ",helperFuncs_currentData.six_Eight_Cell_Index.description
//            ,", 6:8 Sub: ",helperFuncs_currentData.six_Eight_Sub_Index.description
//            )
//        }
//    }
    
    //var cellNumberMultiplier : Int
    
    func writeNote(note_Y_Param:Int){
        
        let combinedPotentialSet = helperFuncs_PotentialNoteSet //.union(helperFuncs_PotentialNoteEdgeSet)
        
        if combinedPotentialSet.count > 2{
            if let min = combinedPotentialSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                ,let max = combinedPotentialSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
            {
                min.change_Type(newType : .start_Note)
                max.change_Type(newType : .end_Note)
                let midz = combinedPotentialSet.filter({$0.dataCell_X_Number != min.dataCell_X_Number})
                for cell in midz{
                    cell.change_Type(newType : .mid_Note)
                }
            }
        }
        else if combinedPotentialSet.count == 2{
            if let min = combinedPotentialSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                ,let max = combinedPotentialSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
            {
                min.change_Type(newType : .start_Note)
                max.change_Type(newType : .end_Note)
            }
        }
        else if combinedPotentialSet.count == 1 {
            if let single = combinedPotentialSet.first {
                single.change_Type(newType : .single_Note)
            }
        }
        
        let noteArray : [Underlying_Data_Cell] = Array(combinedPotentialSet)
        Note_Collection.Static_Note_Collection.write_Note_Data(cellArrayParam: noteArray, note_Y_Num: note_Y_Param)
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
    
    var helperFuncs_PotentialNoteSet = Set<Underlying_Data_Cell>(){
        willSet {
            let delta = helperFuncs_PotentialNoteSet.symmetricDifference(newValue)
            for cell in delta {
                cell.handleVisibleStateChange(type: .deActivate_Potential_Set)
            }
        }
        didSet {
            for cell in helperFuncs_PotentialNoteSet {
                cell.handleVisibleStateChange(type: .activate_Potential_Set)
            }
        }
    }

    func establish_Viable_Cells_Set(){
        
        if helperFuncs_currentData.note_Im_In == nil {
            
            let inViableCellsRight = current_Cell_Line_Set.filter{$0.note_Im_In != nil && $0.dataCell_X_Number > helperFuncs_currentData.dataCell_X_Number}
            let inViableCellsLeft = current_Cell_Line_Set.filter{$0.note_Im_In != nil && $0.dataCell_X_Number < helperFuncs_currentData.dataCell_X_Number}
            
            if inViableCellsRight.count == 0,inViableCellsLeft.count == 0 {
            let emptyCellsRight = current_Cell_Line_Set.filter{$0.dataCell_X_Number > helperFuncs_currentData.dataCell_X_Number}
            let emptyCellsLeft = current_Cell_Line_Set.filter{$0.dataCell_X_Number < helperFuncs_currentData.dataCell_X_Number}
            let currentCellSet = current_Cell_Line_Set.filter{$0.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number}
            viableSet_Combined = emptyCellsRight.union(currentCellSet).union(emptyCellsLeft)
            }
            
            else if inViableCellsRight.count != 0 && inViableCellsLeft.count == 0 {
    
                if let firstNonViableRight = inViableCellsRight.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
    
                    let viablesOnRight = current_Cell_Line_Set.filter {
                    $0.dataCell_X_Number > helperFuncs_currentData.dataCell_X_Number
                    && $0.note_Im_In == nil
                    && $0.dataCell_X_Number < firstNonViableRight.dataCell_X_Number
                    }

                    let viablesOnLeft = current_Cell_Line_Set.filter {
                    $0.dataCell_X_Number < helperFuncs_currentData.dataCell_X_Number
                    && $0.note_Im_In == nil
                    }

                    let currentCellSet = current_Cell_Line_Set.filter({$0.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number})
    
                    viableSet_Combined = viablesOnLeft.union(viablesOnRight).union(currentCellSet)
                }
            }
            
            else if inViableCellsRight.count == 0 && inViableCellsLeft.count != 0 {
                
                if let nearNonViableLeft = inViableCellsLeft.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                    
                    let viablesOnLeft = current_Cell_Line_Set.filter {
                    $0.dataCell_X_Number < helperFuncs_currentData.dataCell_X_Number
                    && $0.note_Im_In == nil
                    && $0.dataCell_X_Number > nearNonViableLeft.dataCell_X_Number
                    }

                    let viablesOnRight = current_Cell_Line_Set.filter {
                    $0.dataCell_X_Number > helperFuncs_currentData.dataCell_X_Number
                    && $0.note_Im_In == nil
                    }
                    
                    let currentCellSet = current_Cell_Line_Set.filter({$0.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number})
                    viableSet_Combined = viablesOnLeft.union(viablesOnRight).union(currentCellSet)
                    
                }
            }
            
            else if inViableCellsRight.count != 0 && inViableCellsLeft.count != 0 {
                if let firstNonViableRight = inViableCellsRight.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                ,let nearNonViableLeft = inViableCellsLeft.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                    
                    let viablesOnLeft = current_Cell_Line_Set.filter{
                    $0.dataCell_X_Number < helperFuncs_currentData.dataCell_X_Number
                    && $0.note_Im_In == nil
                    && $0.dataCell_X_Number > nearNonViableLeft.dataCell_X_Number
                    }
                    
                    let viablesOnRight = current_Cell_Line_Set.filter{
                    $0.dataCell_X_Number > helperFuncs_currentData.dataCell_X_Number
                    && $0.note_Im_In == nil
                    && $0.dataCell_X_Number < firstNonViableRight.dataCell_X_Number
                    }
                    
                    let currentCellSet = current_Cell_Line_Set.filter({$0.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number})
                    
                    viableSet_Combined = viablesOnLeft.union(viablesOnRight).union(currentCellSet)
                    
                }
            }

        }
        else if helperFuncs_currentData.note_Im_In != nil {
            
            if viableSet_Combined.count > 0{
                for cell in viableSet_Combined{
                    cell.handleVisibleStateChange(type: .deActivate_Viable_Set_Combined)
                }
                viableSet_Combined.removeAll()
            }
            
            if helperFuncs_PotentialNoteSet.count > 0{
//                for cell in helperFuncs_PotentialNoteSet {
//                    cell.handleVisibleStateChange(type: .deActivate_Potential_Set )
//                }
//                helperFuncs_PotentialNoteSet.removeAll()
                nilPotentialSet()
            }
            
        }
    }

    func nilPotentialSet(){
        if helperFuncs_PotentialNoteSet.count > 0 {
            for cell in helperFuncs_PotentialNoteSet {
                cell.handleVisibleStateChange(type: .deActivate_Potential_Set)
            }
            helperFuncs_PotentialNoteSet.removeAll()
        }
    }
    
    func establish_Potential_Cells_Set(){
        if let lclInitialCell = initial_WriteOnCell {
            
            if dimensions.patternTimingConfiguration == .fourFour {
                
                
            // --------------------------------- RIGHTWARD ----------------------------------
            if lclInitialCell.dataCell_X_Number < helperFuncs_currentData.dataCell_X_Number {
            let initialHalfCellSet = viableSet_Combined.filter({$0.four_Four_Half_Cell_Index == lclInitialCell.four_Four_Half_Cell_Index})
            let currentHalfCellSet = viableSet_Combined.filter({$0.four_Four_Half_Cell_Index == helperFuncs_currentData.four_Four_Half_Cell_Index})
        
            let combinedSet = initialHalfCellSet.union(currentHalfCellSet)
                if let min_Cell = combinedSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                ,let max_Cell = combinedSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                helperFuncs_PotentialNoteSet = viableSet_Combined.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number && $0.dataCell_X_Number <= max_Cell.dataCell_X_Number})
                }
            }
            // --------------------------------- LEFTWARD ----------------------------------
            else if lclInitialCell.dataCell_X_Number > helperFuncs_currentData.dataCell_X_Number {
                
            let initialHalfCellSet = viableSet_Combined.filter({$0.four_Four_Half_Cell_Index == lclInitialCell.four_Four_Half_Cell_Index-1})
            let currentHalfCellSet = viableSet_Combined.filter({$0.four_Four_Half_Cell_Index == helperFuncs_currentData.four_Four_Half_Cell_Index})
                
            if helperFuncs_currentData.four_Four_Half_Cell_Index == lclInitialCell.four_Four_Half_Cell_Index-1{
                helperFuncs_PotentialNoteSet = currentHalfCellSet
            }
            else if helperFuncs_currentData.four_Four_Half_Cell_Index < lclInitialCell.four_Four_Half_Cell_Index-1{
                let combinedSet = initialHalfCellSet.union(currentHalfCellSet)
                if let min_Cell = combinedSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                ,let max_Cell = combinedSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                helperFuncs_PotentialNoteSet = viableSet_Combined.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number && $0.dataCell_X_Number <= max_Cell.dataCell_X_Number})
                }
            }

            }
            // --------------------------------- STATIONARY ----------------------------------
            else if lclInitialCell.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number {
                helperFuncs_PotentialNoteSet = viableSet_Combined.filter({$0.four_Four_Half_Cell_Index == helperFuncs_currentData.four_Four_Half_Cell_Index})
            }
            }
            
//            else if dimensions.patternTimingConfiguration == .sixEight {
//            let initialHalfCellSet = viableSet_Combined.filter({$0.six_Eight_Half_Cell_Index == lclInitialCell.six_Eight_Half_Cell_Index})
//            let currentHalfCellSet = viableSet_Combined.filter({$0.six_Eight_Half_Cell_Index == helperFuncs_currentData.six_Eight_Half_Cell_Index})
//            let combinedSet = initialHalfCellSet.union(currentHalfCellSet)
//            if let min_Cell = combinedSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
//            ,let max_Cell = combinedSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
//            helperFuncs_PotentialNoteSet = viableSet_Combined.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number && $0.dataCell_X_Number <= max_Cell.dataCell_X_Number})
//            }
//            }
            
        }

//            if helperFuncs_currentData.dataCell_X_Number > lclInitialCell.dataCell_X_Number {
//                helperFuncs_PotentialNoteSet = viableSet_Combined
//                .filter({$0.dataCell_X_Number >= lclInitialCell.dataCell_X_Number
//                && $0.dataCell_X_Number <= helperFuncs_currentData.dataCell_X_Number    })
//            }
//
//            else if helperFuncs_currentData.dataCell_X_Number < lclInitialCell.dataCell_X_Number {
//                helperFuncs_PotentialNoteSet = viableSet_Combined
//                .filter{$0.dataCell_X_Number <= lclInitialCell.dataCell_X_Number
//                && $0.dataCell_X_Number >= helperFuncs_currentData.dataCell_X_Number     }
//            }
//
//            else if helperFuncs_currentData.dataCell_X_Number == lclInitialCell.dataCell_X_Number {
//                helperFuncs_PotentialNoteSet = viableSet_Combined
//                .filter{$0.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number    }
//            }
    
        }
    
    }
