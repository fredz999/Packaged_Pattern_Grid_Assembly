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
    
    init(){
        helperFuncs_currentData = Underlying_Data_Grid.Static_Underlying_Data_Grid.dataLineArray[0].dataCellArray[0]
        //current_Cell_Line_Set =
//        for cell in currLine.dataCellArray{
//            newSet.insert(cell)
//        }
//      viableSetHelpers.current_Cell_Line_Set = newSet
        //data_Grid.dataLineArray[current_Cell_Line_Set]
        for cell in Underlying_Data_Grid.Static_Underlying_Data_Grid.dataLineArray[0].dataCellArray{
            //.dataLineArray[0].dataCellArray{
            current_Cell_Line_Set.insert(cell)
        }
        //establish_Viable_Cells_Set()
    }
    
    var current_Cell_Line_Set = Set<Underlying_Data_Cell>()
    
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
    
    var currentSwipeDirection : E_SwipeDirections?
    
    var initial_WriteOnCell : Underlying_Data_Cell?{
        willSet {
            if newValue == nil {
                if helperFuncs_PotentialNoteSet.count > 0 {
                    nilPotentialSet()
                }
            }
        }
    }
    
    var helperFuncs_currentData : Underlying_Data_Cell
    
    func establish_Potential_Cells_Set(){
        if let lclInitialCell = initial_WriteOnCell {
            if lclInitialCell.dataCell_X_Number < helperFuncs_currentData.dataCell_X_Number {
                if dimensions.patternTimingConfiguration == .fourFour {
                    let lowerHalfCellSet = current_Cell_Line_Set.filter({$0.four_Four_Half_Cell_Index == lclInitialCell.four_Four_Half_Cell_Index})
                    let upperHalfCellSet = current_Cell_Line_Set.filter({$0.four_Four_Half_Cell_Index == helperFuncs_currentData.four_Four_Half_Cell_Index-1})
                    var combinedSet = Set<Underlying_Data_Cell>()
                    
                    let rightSideHasNotesSet = current_Cell_Line_Set.filter({$0.dataCell_X_Number > lclInitialCell.dataCell_X_Number && $0.note_Im_In != nil})
                    let lowestRightNoteCell = rightSideHasNotesSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                    
                    
                    if lclInitialCell.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number {
                        combinedSet = lowerHalfCellSet
                    }
                    
                    else if helperFuncs_currentData.dataCell_X_Number > lclInitialCell.dataCell_X_Number {
                        combinedSet = lowerHalfCellSet.union(upperHalfCellSet)
                    }

                    if let min_Cell = combinedSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                    ,let max_Cell = combinedSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                        
                        let swipeSet =
                        current_Cell_Line_Set.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number
                        && $0.dataCell_X_Number <= max_Cell.dataCell_X_Number})
                        
                        if let lclLowestRightNoteCell = lowestRightNoteCell {
                            helperFuncs_PotentialNoteSet = swipeSet.filter({$0.dataCell_X_Number < lclLowestRightNoteCell.dataCell_X_Number})
                        }
                        else if lowestRightNoteCell == nil {
                            helperFuncs_PotentialNoteSet = swipeSet
                        }
                    }
                }
                else if dimensions.patternTimingConfiguration == .sixEight {
                    let lowerHalfCellSet = current_Cell_Line_Set.filter({$0.six_Eight_Half_Cell_Index == lclInitialCell.six_Eight_Half_Cell_Index})
                    let upperHalfCellSet = current_Cell_Line_Set.filter({$0.six_Eight_Half_Cell_Index == helperFuncs_currentData.six_Eight_Half_Cell_Index-1})
                    var combinedSet = Set<Underlying_Data_Cell>()
                    
                    let rightSideHasNotesSet = current_Cell_Line_Set.filter({$0.dataCell_X_Number > lclInitialCell.dataCell_X_Number && $0.note_Im_In != nil})
                    let lowestRightNoteCell = rightSideHasNotesSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                    
                    
                    if lclInitialCell.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number {
                        combinedSet = lowerHalfCellSet
                    }
                    
                    else if helperFuncs_currentData.dataCell_X_Number > lclInitialCell.dataCell_X_Number {
                        combinedSet = lowerHalfCellSet.union(upperHalfCellSet)
                    }

                    if let min_Cell = combinedSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                    ,let max_Cell = combinedSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                        
                        let swipeSet =
                        current_Cell_Line_Set.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number
                        && $0.dataCell_X_Number <= max_Cell.dataCell_X_Number})
                        
                        if let lclLowestRightNoteCell = lowestRightNoteCell {
                            helperFuncs_PotentialNoteSet = swipeSet.filter({$0.dataCell_X_Number < lclLowestRightNoteCell.dataCell_X_Number})
                        }
                        else if lowestRightNoteCell == nil {
                            helperFuncs_PotentialNoteSet = swipeSet
                        }
                    }
                }
            }
//            else if lclInitialCell.dataCell_X_Number > helperFuncs_currentData.dataCell_X_Number {
//                if dimensions.patternTimingConfiguration == .fourFour {
//                    let lowerHalfCellSet = current_Cell_Line_Set.filter({$0.four_Four_Half_Cell_Index == lclInitialCell.four_Four_Half_Cell_Index})
//                    let upperHalfCellSet = current_Cell_Line_Set.filter({$0.four_Four_Half_Cell_Index == helperFuncs_currentData.four_Four_Half_Cell_Index-1})
//                    var combinedSet = Set<Underlying_Data_Cell>()
//
//                    let rightSideHasNotesSet = current_Cell_Line_Set.filter({$0.dataCell_X_Number > lclInitialCell.dataCell_X_Number && $0.note_Im_In != nil})
//                    let lowestRightNoteCell = rightSideHasNotesSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
//
//
//                    if lclInitialCell.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number {
//                        combinedSet = lowerHalfCellSet
//                    }
//
//                    else if helperFuncs_currentData.dataCell_X_Number > lclInitialCell.dataCell_X_Number {
//                        combinedSet = lowerHalfCellSet.union(upperHalfCellSet)
//                    }
//
//                    if let min_Cell = combinedSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
//                    ,let max_Cell = combinedSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
//
//                        let swipeSet =
//                        current_Cell_Line_Set.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number
//                        && $0.dataCell_X_Number <= max_Cell.dataCell_X_Number})
//
//                        if let lclLowestRightNoteCell = lowestRightNoteCell {
//                            helperFuncs_PotentialNoteSet = swipeSet.filter({$0.dataCell_X_Number < lclLowestRightNoteCell.dataCell_X_Number})
//                        }
//                        else if lowestRightNoteCell == nil {
//                            helperFuncs_PotentialNoteSet = swipeSet
//                        }
//                    }
//                }
//            }
        }
    }
    
    
//    func establish_Potential_Cells_Set(){
//        if let lclInitialCell = initial_WriteOnCell {
//            if dimensions.patternTimingConfiguration == .fourFour {
//
//                if lclInitialCell.dataCell_X_Number < helperFuncs_currentData.dataCell_X_Number {
//
//                    let lowerHalfCellSet = current_Cell_Line_Set.filter({$0.four_Four_Half_Cell_Index == lclInitialCell.four_Four_Half_Cell_Index})
//                    let upperHalfCellSet = current_Cell_Line_Set.filter({$0.four_Four_Half_Cell_Index == helperFuncs_currentData.four_Four_Half_Cell_Index-1})
//                    var combinedSet = Set<Underlying_Data_Cell>()
//
//                    let rightSideHasNotesSet = current_Cell_Line_Set.filter({$0.dataCell_X_Number > lclInitialCell.dataCell_X_Number && $0.note_Im_In != nil})
//                    let lowestRightNoteCell = rightSideHasNotesSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
//
//
//                    if lclInitialCell.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number {
//                        combinedSet = lowerHalfCellSet
//                    }
//
//                    else if helperFuncs_currentData.dataCell_X_Number > lclInitialCell.dataCell_X_Number {
//                        combinedSet = lowerHalfCellSet.union(upperHalfCellSet)
//                    }
//
//                    if let min_Cell = combinedSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
//                    ,let max_Cell = combinedSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
//
//                        let swipeSet =
//                        current_Cell_Line_Set.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number
//                        && $0.dataCell_X_Number <= max_Cell.dataCell_X_Number})
//
//                        if let lclLowestRightNoteCell = lowestRightNoteCell {
//                            helperFuncs_PotentialNoteSet = swipeSet.filter({$0.dataCell_X_Number < lclLowestRightNoteCell.dataCell_X_Number})
//                        }
//                        else if lowestRightNoteCell == nil {
//                            helperFuncs_PotentialNoteSet = swipeSet
//                        }
//
//                    }
//
//                }
//            }
//            else if dimensions.patternTimingConfiguration == .sixEight {
//
//                if lclInitialCell.dataCell_X_Number < helperFuncs_currentData.dataCell_X_Number {
//
//                    let lowerHalfCellSet = current_Cell_Line_Set.filter({$0.six_Eight_Half_Cell_Index == lclInitialCell.six_Eight_Half_Cell_Index})
//                        //.four_Four_Half_Cell_Index})
//                    let upperHalfCellSet = current_Cell_Line_Set.filter({$0.six_Eight_Half_Cell_Index == helperFuncs_currentData.six_Eight_Half_Cell_Index-1})
//                    var combinedSet = Set<Underlying_Data_Cell>()
//
//                    let rightSideHasNotesSet = current_Cell_Line_Set.filter({$0.dataCell_X_Number > lclInitialCell.dataCell_X_Number && $0.note_Im_In != nil})
//                    let lowestRightNoteCell = rightSideHasNotesSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
//
//
//                    if lclInitialCell.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number {
//                        combinedSet = lowerHalfCellSet
//                    }
//
//                    else if helperFuncs_currentData.dataCell_X_Number > lclInitialCell.dataCell_X_Number {
//                        combinedSet = lowerHalfCellSet.union(upperHalfCellSet)
//                    }
//
//                    if let min_Cell = combinedSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
//                    ,let max_Cell = combinedSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
//
//                        let swipeSet =
//                        current_Cell_Line_Set.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number
//                        && $0.dataCell_X_Number <= max_Cell.dataCell_X_Number})
//
//                        if let lclLowestRightNoteCell = lowestRightNoteCell {
//                            helperFuncs_PotentialNoteSet = swipeSet.filter({$0.dataCell_X_Number < lclLowestRightNoteCell.dataCell_X_Number})
//                        }
//                        else if lowestRightNoteCell == nil {
//                            helperFuncs_PotentialNoteSet = swipeSet
//                        }
//
//                    }
//
//
//
//
//                }
//            }
//
//        }
//    }
    
    
    

    func writeNote(note_Y_Param:Int){

        var startCellSet = Set<Underlying_Data_Cell>()
        if let minX = helperFuncs_PotentialNoteSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
            startCellSet.insert(minX)
        }

        var endCellSet = Set<Underlying_Data_Cell>()
        if let maxX = helperFuncs_PotentialNoteSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
            endCellSet.insert(maxX)
        }

        let midCellSet = helperFuncs_PotentialNoteSet.subtracting(startCellSet.union(endCellSet))
        
        for cell in startCellSet{cell.change_Type(newType: .start_Note)}
        for cell in midCellSet{cell.change_Type(newType: .mid_Note)}
        for cell in endCellSet{cell.change_Type(newType: .end_Note)}
        
        let startCells = startCellSet.sorted(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
        let endCells = endCellSet.sorted(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
        
        for index in 0..<startCellSet.count {
        var noteArr = [Underlying_Data_Cell]()
        let currStartCell = startCells[index]
        let currEndCell = endCells[index]
        noteArr.append(currStartCell)
        let midSet = midCellSet.filter({$0.dataCell_X_Number > currStartCell.dataCell_X_Number && $0.dataCell_X_Number < currEndCell.dataCell_X_Number})
        let midArr = midSet.sorted(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
        for midCell in midArr {
        noteArr.append(midCell)
        }
        noteArr.append(currEndCell)
        Note_Collection.Static_Note_Collection.write_Note_Data(cellArrayParam: noteArr, note_Y_Num: note_Y_Param)
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





//    func establish_Potential_Cells_Set(){
//        if let lclInitialCell = initial_WriteOnCell {
//
//            if dimensions.patternTimingConfiguration == .fourFour {
//            // --------------------------------- RIGHTWARD ----------------------------------
//            if lclInitialCell.dataCell_X_Number < helperFuncs_currentData.dataCell_X_Number {
//
//                currentSwipeDirection = .rightward
//                let lowerHalfCellSet = viableSet_Combined.filter({$0.four_Four_Half_Cell_Index == lclInitialCell.four_Four_Half_Cell_Index})
//                let upperHalfCellSet = viableSet_Combined.filter({$0.four_Four_Half_Cell_Index == helperFuncs_currentData.four_Four_Half_Cell_Index-1})
//                var combinedSet = Set<Underlying_Data_Cell>()
//
//                if lclInitialCell.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number {
//                    combinedSet = lowerHalfCellSet
//                }
//                else if helperFuncs_currentData.dataCell_X_Number > lclInitialCell.dataCell_X_Number {
//                    combinedSet = lowerHalfCellSet.union(upperHalfCellSet)
//                }
//
//                if let min_Cell = combinedSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
//                ,let max_Cell = combinedSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
//
//                    helperFuncs_PotentialNoteSet = viableSet_Combined.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number && $0.dataCell_X_Number <= max_Cell.dataCell_X_Number})
//
//                    let fullSwipeSet = current_Cell_Line_Set.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number && $0.dataCell_X_Number <= max_Cell.dataCell_X_Number})
//
//                    in_Swipe_Inviables = fullSwipeSet.filter({$0.note_Im_In != nil})
//
//                }
//
//            }
//            // --------------------------------- LEFTWARD ----------------------------------
//            else if lclInitialCell.dataCell_X_Number > helperFuncs_currentData.dataCell_X_Number {
//
//                currentSwipeDirection = .leftward
//                let lowerHalfCellSet = viableSet_Combined.filter({$0.four_Four_Half_Cell_Index == helperFuncs_currentData.four_Four_Half_Cell_Index})
//                let upperHalfCellSet = viableSet_Combined.filter({$0.four_Four_Half_Cell_Index == lclInitialCell.four_Four_Half_Cell_Index-1})
//
//                var combinedSet = Set<Underlying_Data_Cell>()
//
//                if lclInitialCell.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number {
//                    combinedSet = lowerHalfCellSet
//                }
//                else if helperFuncs_currentData.dataCell_X_Number < lclInitialCell.dataCell_X_Number{
//                    combinedSet = lowerHalfCellSet.union(upperHalfCellSet)
//                }
//
//                if let min_Cell = combinedSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
//                ,let max_Cell = combinedSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
//                    helperFuncs_PotentialNoteSet = viableSet_Combined.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number && $0.dataCell_X_Number <= max_Cell.dataCell_X_Number})
//                    let fullSwipeSet = current_Cell_Line_Set.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number && $0.dataCell_X_Number <= max_Cell.dataCell_X_Number})
//                    in_Swipe_Inviables = fullSwipeSet.filter({$0.note_Im_In != nil})
//                }
//
//
//            }
//            // --------------------------------- STATIONARY ----------------------------------
//            else if lclInitialCell.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number {
//                currentSwipeDirection = .stationary
//                if helperFuncs_PotentialNoteSet.count > 0{helperFuncs_PotentialNoteSet.removeAll()}
//                if in_Swipe_Inviables.count > 0{in_Swipe_Inviables.removeAll()}
//            }
//            }
//
//            else if dimensions.patternTimingConfiguration == .sixEight {
//            // --------------------------------- RIGHTWARD ----------------------------------
//            if lclInitialCell.dataCell_X_Number < helperFuncs_currentData.dataCell_X_Number {
//
//                currentSwipeDirection = .rightward
//                let lowerHalfCellSet = viableSet_Combined.filter({$0.six_Eight_Half_Cell_Index == lclInitialCell.six_Eight_Half_Cell_Index})
//                let upperHalfCellSet = viableSet_Combined.filter({$0.six_Eight_Half_Cell_Index == helperFuncs_currentData.six_Eight_Half_Cell_Index-1})
//                var combinedSet = Set<Underlying_Data_Cell>()
//                if lclInitialCell.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number{
//                    combinedSet = lowerHalfCellSet
//                }
//                else if helperFuncs_currentData.dataCell_X_Number > lclInitialCell.dataCell_X_Number{
//                    combinedSet = lowerHalfCellSet.union(upperHalfCellSet)
//                }
//
//                if let min_Cell = combinedSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
//                ,let max_Cell = combinedSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
//                    helperFuncs_PotentialNoteSet = viableSet_Combined.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number && $0.dataCell_X_Number <= max_Cell.dataCell_X_Number})
//                    let fullSwipeSet = current_Cell_Line_Set.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number && $0.dataCell_X_Number <= max_Cell.dataCell_X_Number})
//                    in_Swipe_Inviables = fullSwipeSet.filter({$0.note_Im_In != nil})
//                }
//            }
//            // --------------------------------- LEFTWARD ----------------------------------
//            else if lclInitialCell.dataCell_X_Number > helperFuncs_currentData.dataCell_X_Number {
//
//                currentSwipeDirection = .leftward
//                let lowerHalfCellSet = viableSet_Combined.filter({$0.six_Eight_Half_Cell_Index == helperFuncs_currentData.six_Eight_Half_Cell_Index})
//                let upperHalfCellSet = viableSet_Combined.filter({$0.six_Eight_Half_Cell_Index == lclInitialCell.six_Eight_Half_Cell_Index-1})
//
//                var combinedSet = Set<Underlying_Data_Cell>()
//
//                if lclInitialCell.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number {
//                    combinedSet = lowerHalfCellSet
//                }
//                else if helperFuncs_currentData.dataCell_X_Number < lclInitialCell.dataCell_X_Number{
//                    combinedSet = lowerHalfCellSet.union(upperHalfCellSet)
//                }
//
//                if let min_Cell = combinedSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
//                ,let max_Cell = combinedSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
//                    helperFuncs_PotentialNoteSet = viableSet_Combined.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number && $0.dataCell_X_Number <= max_Cell.dataCell_X_Number})
//                    let fullSwipeSet = current_Cell_Line_Set.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number && $0.dataCell_X_Number <= max_Cell.dataCell_X_Number})
//                    in_Swipe_Inviables = fullSwipeSet.filter({$0.note_Im_In != nil})
//                }
//
//            }
//            // --------------------------------- STATIONARY ----------------------------------
//            else if lclInitialCell.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number {
//                currentSwipeDirection = .stationary
//                if helperFuncs_PotentialNoteSet.count > 0{helperFuncs_PotentialNoteSet.removeAll()}
//                if in_Swipe_Inviables.count > 0{in_Swipe_Inviables.removeAll()}
//            }
//            }
//
//        }
//    }
