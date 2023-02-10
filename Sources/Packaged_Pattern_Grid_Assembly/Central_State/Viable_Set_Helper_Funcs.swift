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
//        viableSetHelpers.current_Cell_Line_Set = newSet
        //data_Grid.dataLineArray[current_Cell_Line_Set]
        for cell in Underlying_Data_Grid.Static_Underlying_Data_Grid.dataLineArray[0].dataCellArray{
            //.dataLineArray[0].dataCellArray{
            current_Cell_Line_Set.insert(cell)
        }
        
        establish_Viable_Cells_Set()
        
    }
    
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
            
        }
        else if helperFuncs_currentData.note_Im_In != nil {
            if viableSet_Combined.count > 0{
                for cell in viableSet_Combined{
                    cell.handleVisibleStateChange(type: .deActivate_Viable_Set_Combined)
                }
                viableSet_Combined.removeAll()
            }
            
            if helperFuncs_PotentialNoteSet.count > 0 {
                nilPotentialSet()
            }
            
        }
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
                if lclInitialCell.dataCell_X_Number < helperFuncs_currentData.dataCell_X_Number {
                    print("lclInitialCell.dataCell_X_Number < helperFuncs_currentData.dataCell_X_Number")
                    currentSwipeDirection = .rightward

                    let lowerHalfCellSet = viableSet_Combined.filter({$0.four_Four_Half_Cell_Index == lclInitialCell.four_Four_Half_Cell_Index})

                    let upperHalfCellSet = viableSet_Combined.filter({$0.four_Four_Half_Cell_Index == helperFuncs_currentData.four_Four_Half_Cell_Index-1})

                    var combinedSet = Set<Underlying_Data_Cell>()

                    if lclInitialCell.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number {
                        combinedSet = lowerHalfCellSet
                    }
                    else if helperFuncs_currentData.dataCell_X_Number > lclInitialCell.dataCell_X_Number {
                        combinedSet = lowerHalfCellSet.union(upperHalfCellSet)
                    }

                    // this time just make the inviables everything after the lowest selected

                    let inANoteSet = combinedSet.filter{$0.note_Im_In == nil}

                    if let lowestInANote = inANoteSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                        helperFuncs_PotentialNoteSet = combinedSet.filter{$0.dataCell_X_Number <  lowestInANote.dataCell_X_Number}
                        in_Swipe_Inviables = combinedSet.filter{$0.dataCell_X_Number > lowestInANote.dataCell_X_Number}
                    }
                    else {
                    if let min_Cell = combinedSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                    ,let max_Cell = combinedSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){

                        helperFuncs_PotentialNoteSet = viableSet_Combined.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number
                        && $0.dataCell_X_Number <= max_Cell.dataCell_X_Number})

                    }
                    }





//                    if let min_Cell = combinedSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
//                    ,let max_Cell = combinedSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
//
//                    helperFuncs_PotentialNoteSet = viableSet_Combined.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number && $0.dataCell_X_Number <= max_Cell.dataCell_X_Number})
//
//                    let fullSwipeSet = current_Cell_Line_Set.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number && $0.dataCell_X_Number <= max_Cell.dataCell_X_Number})
//
//                    in_Swipe_Inviables = fullSwipeSet.filter({$0.note_Im_In != nil})
//
//                    }

                }
            }
        }
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

    func writeNote(note_Y_Param:Int){
        let inviableStartCellSet = in_Swipe_Inviables.filter{$0.currentType == .start_Note}
        let inviableEndCellSet = in_Swipe_Inviables.filter{$0.currentType == .end_Note}
    
        var startCellSet = Set<Underlying_Data_Cell>()
        if let minX = helperFuncs_PotentialNoteSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
            startCellSet.insert(minX)
        }
        for cell in inviableEndCellSet{
            if let nextCell = helperFuncs_PotentialNoteSet.first(where: {$0.dataCell_X_Number == (cell.dataCell_X_Number+1)})
            {
                startCellSet.insert(nextCell)
            }
        }
    
        var endCellSet = Set<Underlying_Data_Cell>()
        if let maxX = helperFuncs_PotentialNoteSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
            endCellSet.insert(maxX)
        }
        for cell in inviableStartCellSet{
            if let prevCell = helperFuncs_PotentialNoteSet.first(where: {$0.dataCell_X_Number == (cell.dataCell_X_Number-1)})
            {
                endCellSet.insert(prevCell)
            }
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
