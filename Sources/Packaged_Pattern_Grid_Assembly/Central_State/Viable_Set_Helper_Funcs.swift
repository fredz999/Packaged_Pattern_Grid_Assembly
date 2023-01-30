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
    }
    
    var in_Swipe_Inviables = Set<Underlying_Data_Cell>()
    var currentSwipeDirection : E_SwipeDirections?
    var initial_WriteOnCell : Underlying_Data_Cell?{
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
    }
    var helperFuncs_currentData : Underlying_Data_Cell
    
    func establish_Potential_Cells_Set(){
        if let lclInitialCell = initial_WriteOnCell {
            
            if dimensions.patternTimingConfiguration == .fourFour {
            // --------------------------------- RIGHTWARD ----------------------------------
            if lclInitialCell.dataCell_X_Number < helperFuncs_currentData.dataCell_X_Number {
                
            currentSwipeDirection = .rightward
                
            let initialHalfCellSet = viableSet_Combined.filter({$0.four_Four_Half_Cell_Index == lclInitialCell.four_Four_Half_Cell_Index})
            let currentHalfCellSet = viableSet_Combined.filter({$0.four_Four_Half_Cell_Index == helperFuncs_currentData.four_Four_Half_Cell_Index})
        
            let combinedSet = initialHalfCellSet.union(currentHalfCellSet)
                if let min_Cell = combinedSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                    ,let max_Cell = combinedSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                    helperFuncs_PotentialNoteSet = viableSet_Combined.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number && $0.dataCell_X_Number <= max_Cell.dataCell_X_Number})
                    let fullSwipeSet = current_Cell_Line_Set.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number && $0.dataCell_X_Number <= max_Cell.dataCell_X_Number})
                    in_Swipe_Inviables = fullSwipeSet.filter({$0.note_Im_In != nil})
                }
            }
            // --------------------------------- LEFTWARD ----------------------------------
            else if lclInitialCell.dataCell_X_Number > helperFuncs_currentData.dataCell_X_Number {
                
            currentSwipeDirection = .leftward
                
            let initialHalfCellSet = viableSet_Combined.filter({$0.four_Four_Half_Cell_Index == lclInitialCell.four_Four_Half_Cell_Index-1})
            let currentHalfCellSet = viableSet_Combined.filter({$0.four_Four_Half_Cell_Index == helperFuncs_currentData.four_Four_Half_Cell_Index})
                
//            if helperFuncs_currentData.four_Four_Half_Cell_Index == lclInitialCell.four_Four_Half_Cell_Index-1{
//                helperFuncs_PotentialNoteSet = currentHalfCellSet
//                //TODO: check for inviables in this
//                in_Swipe_Inviables = currentHalfCellSet.filter({$0.note_Im_In != nil})
//                // this shouldnt actually exist
//            }
            if helperFuncs_currentData.four_Four_Half_Cell_Index < lclInitialCell.four_Four_Half_Cell_Index-1{
                let combinedSet = initialHalfCellSet.union(currentHalfCellSet)
                if let min_Cell = combinedSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                ,let max_Cell = combinedSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                helperFuncs_PotentialNoteSet = viableSet_Combined.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number && $0.dataCell_X_Number <= max_Cell.dataCell_X_Number})
                    let fullSwipeSet = current_Cell_Line_Set.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number && $0.dataCell_X_Number <= max_Cell.dataCell_X_Number})
                    in_Swipe_Inviables = fullSwipeSet.filter({$0.note_Im_In != nil})
                }
            }

            }
            // --------------------------------- STATIONARY ----------------------------------
            else if lclInitialCell.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number {
                currentSwipeDirection = .stationary
                helperFuncs_PotentialNoteSet = viableSet_Combined.filter({$0.four_Four_Half_Cell_Index == helperFuncs_currentData.four_Four_Half_Cell_Index})
            }
            }
 
        }
    }
    
    func writeNote(note_Y_Param:Int){
        let combinedPotentialSet = helperFuncs_PotentialNoteSet
        let combinedInviables = inViableCellsLeft.union(inViableCellsRight)
        
        //1: figure out how many notes there actually are
        //......hmmm if theres two notes they will be seperated by a gap
        // that gap will be an area where you were expecting a numeric sequence to continue but it dosent
        // ...ORRRRRR I actually make the inviables visible outside of the function
        // get the inviables into distinct notes ... emmm start and end note status
        
        if let lclSwipeDirection = currentSwipeDirection {
            
            if lclSwipeDirection == .leftward{
               // get min max of the potential set
                // get the inviables within this --- well actually those should be available during the swipe - make a class wide var for currentInviables
                // get the start and end inviables within this
            }
            else if lclSwipeDirection == .rightward{
                
            }
            else if lclSwipeDirection == .stationary{
                
            }
            
            
        }

        
        
        
        
//        if combinedPotentialSet.count > 2{
//            if let min = combinedPotentialSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
//                ,let max = combinedPotentialSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
//            {
//                min.change_Type(newType : .start_Note)
//                max.change_Type(newType : .end_Note)
//                let midz = combinedPotentialSet.filter({$0.dataCell_X_Number != min.dataCell_X_Number})
//                for cell in midz{
//                    cell.change_Type(newType : .mid_Note)
//                }
//            }
//        }
//        else if combinedPotentialSet.count == 2{
//            if let min = combinedPotentialSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
//                ,let max = combinedPotentialSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
//            {
//                min.change_Type(newType : .start_Note)
//                max.change_Type(newType : .end_Note)
//            }
//        }
//        else if combinedPotentialSet.count == 1 {
//            if let single = combinedPotentialSet.first {
//                single.change_Type(newType : .single_Note)
//            }
//        }
//
//        let noteArray : [Underlying_Data_Cell] = Array(combinedPotentialSet)
//        Note_Collection.Static_Note_Collection.write_Note_Data(cellArrayParam: noteArray, note_Y_Num: note_Y_Param)
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
    
    var inViableCellsLeft = Set<Underlying_Data_Cell>()
    var inViableCellsRight = Set<Underlying_Data_Cell>()
    
    func establish_Viable_Cells_Set(){
        
        if helperFuncs_currentData.note_Im_In == nil {
            
            inViableCellsRight = current_Cell_Line_Set.filter{$0.note_Im_In != nil && $0.dataCell_X_Number > helperFuncs_currentData.dataCell_X_Number}
            inViableCellsLeft = current_Cell_Line_Set.filter{$0.note_Im_In != nil && $0.dataCell_X_Number < helperFuncs_currentData.dataCell_X_Number}
            
            if inViableCellsRight.count == 0,inViableCellsLeft.count == 0 {
            let emptyCellsRight = current_Cell_Line_Set.filter{$0.dataCell_X_Number > helperFuncs_currentData.dataCell_X_Number}
            let emptyCellsLeft = current_Cell_Line_Set.filter{$0.dataCell_X_Number < helperFuncs_currentData.dataCell_X_Number}
            let currentCellSet = current_Cell_Line_Set.filter{$0.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number}
            viableSet_Combined = emptyCellsRight.union(currentCellSet).union(emptyCellsLeft)
            }
            else if inViableCellsRight.count != 0 || inViableCellsLeft.count != 0 {
                let currentCellSet = current_Cell_Line_Set.filter({
                $0.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number
                && $0.note_Im_In == nil
                })
                
                let viablesOnLeft = current_Cell_Line_Set.filter {
                $0.dataCell_X_Number < helperFuncs_currentData.dataCell_X_Number
                && $0.note_Im_In == nil
                }
                
                let viablesOnRight = current_Cell_Line_Set.filter {
                $0.dataCell_X_Number > helperFuncs_currentData.dataCell_X_Number
                && $0.note_Im_In == nil
                }

                viableSet_Combined = currentCellSet.union(viablesOnLeft).union(viablesOnRight)
            }
            
//            else if inViableCellsRight.count != 0 && inViableCellsLeft.count == 0 {
//                if let firstNonViableRight = inViableCellsRight.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
//
//                    let viablesOnRight = current_Cell_Line_Set.filter {
//                    $0.dataCell_X_Number > helperFuncs_currentData.dataCell_X_Number
//                    && $0.note_Im_In == nil
//                    && $0.dataCell_X_Number < firstNonViableRight.dataCell_X_Number
//                    }
//
//                    let viablesOnLeft = current_Cell_Line_Set.filter {
//                    $0.dataCell_X_Number < helperFuncs_currentData.dataCell_X_Number
//                    && $0.note_Im_In == nil
//                    }
//
//                    let currentCellSet = current_Cell_Line_Set.filter({$0.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number})
//
//                    viableSet_Combined = viablesOnLeft.union(viablesOnRight).union(currentCellSet)
//                }
//            }
//            else if inViableCellsRight.count == 0 && inViableCellsLeft.count != 0 {
//
//                if let nearNonViableLeft = inViableCellsLeft.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
//
//                    let viablesOnLeft = current_Cell_Line_Set.filter {
//                    $0.dataCell_X_Number < helperFuncs_currentData.dataCell_X_Number
//                    && $0.note_Im_In == nil
//                    && $0.dataCell_X_Number > nearNonViableLeft.dataCell_X_Number
//                    }
//
//                    let viablesOnRight = current_Cell_Line_Set.filter {
//                    $0.dataCell_X_Number > helperFuncs_currentData.dataCell_X_Number
//                    && $0.note_Im_In == nil
//                    }
//
//                    let currentCellSet = current_Cell_Line_Set.filter({$0.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number})
//                    viableSet_Combined = viablesOnLeft.union(viablesOnRight).union(currentCellSet)
//
//                }
//            }
//            else if inViableCellsRight.count != 0 && inViableCellsLeft.count != 0 {
//                if let firstNonViableRight = inViableCellsRight.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
//                ,let nearNonViableLeft = inViableCellsLeft.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
//
//                    let viablesOnLeft = current_Cell_Line_Set.filter{
//                    $0.dataCell_X_Number < helperFuncs_currentData.dataCell_X_Number
//                    && $0.note_Im_In == nil
//                    && $0.dataCell_X_Number > nearNonViableLeft.dataCell_X_Number
//                    }
//
//                    let viablesOnRight = current_Cell_Line_Set.filter{
//                    $0.dataCell_X_Number > helperFuncs_currentData.dataCell_X_Number
//                    && $0.note_Im_In == nil
//                    && $0.dataCell_X_Number < firstNonViableRight.dataCell_X_Number
//                    }
//
//                    let currentCellSet = current_Cell_Line_Set.filter({$0.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number})
//
//                    viableSet_Combined = viablesOnLeft.union(viablesOnRight).union(currentCellSet)
//
//                }
//            }

            
        }
        else if helperFuncs_currentData.note_Im_In != nil {
            
            if viableSet_Combined.count > 0{
                for cell in viableSet_Combined{
                    cell.handleVisibleStateChange(type: .deActivate_Viable_Set_Combined)
                }
                viableSet_Combined.removeAll()
            }
            
            if helperFuncs_PotentialNoteSet.count > 0{
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
    
    
    
    }

enum E_SwipeDirections{
    case leftward
    case rightward
    case stationary
}
