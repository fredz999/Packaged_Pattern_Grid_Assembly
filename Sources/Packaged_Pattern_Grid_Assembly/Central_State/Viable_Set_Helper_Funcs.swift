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
        for cell in Underlying_Data_Grid.Static_Underlying_Data_Grid.dataLineArray[0].dataCellArray{
            current_Cell_Line_Set.insert(cell)
        }
    }
    
    var current_Cell_Line_Set = Set<Underlying_Data_Cell>()
    
    var helperFuncs_PotentialNote_Set = Set<Underlying_Data_Cell>(){
        willSet {
            let delta = helperFuncs_PotentialNote_Set.symmetricDifference(newValue)
            for cell in delta {
                cell.handleVisibleStateChange(type: .deActivate_Potential_Set)
            }
        }
        didSet {
            for cell in helperFuncs_PotentialNote_Set {
                cell.handleVisibleStateChange(type: .activate_Potential_Set)
            }
        }
    }
    
    var helperFuncs_Cursor_Set = Set<Underlying_Data_Cell>(){
        willSet {
            let delta = helperFuncs_Cursor_Set.symmetricDifference(newValue)
            for cell in delta {
                cell.handleVisibleStateChange(type: .deActivate_Cursor_Set)
            }
        }
        didSet {
            if Central_State.Static_Central_State.writingIsOn == false {
                var nillableNote : Note? = nil
                for cell in helperFuncs_Cursor_Set {
                    cell.handleVisibleStateChange(type: .activate_Cursor_Set)
                    if let lclNote = cell.note_Im_In {
                        nillableNote = lclNote
                    }
                }

                if let lclNoteCollection = Central_State.Static_Central_State.note_Collection_Ref {
                    if let lclNillableNote = nillableNote {
                        lclNoteCollection.note_Collection_Highlight_Handler(noteParam: lclNillableNote)
                    }
                    else if nillableNote == nil{
                        lclNoteCollection.note_Collection_Highlight_Handler(noteParam: nil)
                    }
                }
                
            }
        }
    }

    var initial_WriteOnCell : Underlying_Data_Cell?{
        willSet {
            if newValue == nil {
                if helperFuncs_PotentialNote_Set.count > 0 {
                    nilPotentialSet()
                }
            }
        }
    }
    
    var helperFuncs_currentData : Underlying_Data_Cell{
        didSet {
            establish_Cursor_Set()
        }
    }
    
    func establish_Cursor_Set(){
        
        if dimensions.patternTimingConfiguration == .fourFour {
            helperFuncs_Cursor_Set = current_Cell_Line_Set.filter({$0.four_Four_Half_Cell_Index == helperFuncs_currentData.four_Four_Half_Cell_Index})
        }
        else if dimensions.patternTimingConfiguration == .sixEight {
            helperFuncs_Cursor_Set = current_Cell_Line_Set.filter({$0.six_Eight_Half_Cell_Index == helperFuncs_currentData.six_Eight_Half_Cell_Index})
        }
        
//        if dimensions.patternTimingConfiguration == .fourFour {
//            helperFuncs_Cursor_Set = current_Cell_Line_Set.filter({$0.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number
//                || $0.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number+1
//            })
//        }
//        else if dimensions.patternTimingConfiguration == .sixEight {
//            helperFuncs_Cursor_Set = current_Cell_Line_Set.filter({$0.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number
//                || $0.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number+1
//            })
//        }
        
//        if dimensions.patternTimingConfiguration == .fourFour {
//            helperFuncs_Cursor_Set = current_Cell_Line_Set.filter({$0.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number
//                || $0.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number
//            })
//        }
//        else if dimensions.patternTimingConfiguration == .sixEight {
//            helperFuncs_Cursor_Set = current_Cell_Line_Set.filter({$0.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number
//                || $0.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number
//            })
//        }
        
        
    }
    
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
                helperFuncs_PotentialNote_Set = swipeSet.filter({$0.dataCell_X_Number < lclLowestRightNoteCell.dataCell_X_Number})
            }
            else if lowestRightNoteCell == nil {
                helperFuncs_PotentialNote_Set = swipeSet
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
                        helperFuncs_PotentialNote_Set = swipeSet.filter({$0.dataCell_X_Number < lclLowestRightNoteCell.dataCell_X_Number})
                    }
                    else if lowestRightNoteCell == nil {
                        helperFuncs_PotentialNote_Set = swipeSet
                    }
                }
            }
            }
            else if lclInitialCell.dataCell_X_Number > helperFuncs_currentData.dataCell_X_Number {
            if dimensions.patternTimingConfiguration == .fourFour {
                let upperHalfCellSet = current_Cell_Line_Set.filter({$0.four_Four_Half_Cell_Index == lclInitialCell.four_Four_Half_Cell_Index-1})
                let lowerHalfCellSet = current_Cell_Line_Set.filter({$0.four_Four_Half_Cell_Index == helperFuncs_currentData.four_Four_Half_Cell_Index})
                var combinedSet = Set<Underlying_Data_Cell>()

                let leftSideHasNotesSet = current_Cell_Line_Set.filter({$0.dataCell_X_Number < lclInitialCell.dataCell_X_Number && $0.note_Im_In != nil})
                let highestLeftNoteCell = leftSideHasNotesSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})


                if lclInitialCell.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number {
                    combinedSet = lowerHalfCellSet
                }

                else if helperFuncs_currentData.dataCell_X_Number < lclInitialCell.dataCell_X_Number {
                    combinedSet = lowerHalfCellSet.union(upperHalfCellSet)
                }

                if let min_Cell = combinedSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                ,let max_Cell = combinedSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){

                    let swipeSet =
                    current_Cell_Line_Set.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number
                    && $0.dataCell_X_Number <= max_Cell.dataCell_X_Number})

                    if let lclHighestLeftNoteCell = highestLeftNoteCell {
                        helperFuncs_PotentialNote_Set = swipeSet.filter({$0.dataCell_X_Number > lclHighestLeftNoteCell.dataCell_X_Number})
                    }
                    else if highestLeftNoteCell == nil {
                        helperFuncs_PotentialNote_Set = swipeSet
                    }
                }
            }
            else if dimensions.patternTimingConfiguration == .sixEight {
                let upperHalfCellSet = current_Cell_Line_Set.filter({$0.six_Eight_Half_Cell_Index == lclInitialCell.six_Eight_Half_Cell_Index-1})
                let lowerHalfCellSet = current_Cell_Line_Set.filter({$0.six_Eight_Half_Cell_Index == helperFuncs_currentData.six_Eight_Half_Cell_Index})
                var combinedSet = Set<Underlying_Data_Cell>()

                let leftSideHasNotesSet = current_Cell_Line_Set.filter({$0.dataCell_X_Number < lclInitialCell.dataCell_X_Number && $0.note_Im_In != nil})
                let highestLeftNoteCell = leftSideHasNotesSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})


                if lclInitialCell.dataCell_X_Number == helperFuncs_currentData.dataCell_X_Number {
                    combinedSet = lowerHalfCellSet
                }

                else if helperFuncs_currentData.dataCell_X_Number < lclInitialCell.dataCell_X_Number {
                    combinedSet = lowerHalfCellSet.union(upperHalfCellSet)
                }

                if let min_Cell = combinedSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                ,let max_Cell = combinedSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){

                    let swipeSet =
                    current_Cell_Line_Set.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number
                    && $0.dataCell_X_Number <= max_Cell.dataCell_X_Number})

                    if let lclHighestLeftNoteCell = highestLeftNoteCell {
                        helperFuncs_PotentialNote_Set = swipeSet.filter({$0.dataCell_X_Number > lclHighestLeftNoteCell.dataCell_X_Number})
                    }
                    else if highestLeftNoteCell == nil {
                        helperFuncs_PotentialNote_Set = swipeSet
                    }
                }
            }
            }

        }
    }
    
    func writeNote(note_Y_Param:Int){

        var startCellSet = Set<Underlying_Data_Cell>()
        if let minX = helperFuncs_PotentialNote_Set.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
            startCellSet.insert(minX)
        }

        var endCellSet = Set<Underlying_Data_Cell>()
        if let maxX = helperFuncs_PotentialNote_Set.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
            endCellSet.insert(maxX)
        }

        let midCellSet = helperFuncs_PotentialNote_Set.subtracting(startCellSet.union(endCellSet))
        
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
        if helperFuncs_PotentialNote_Set.count > 0 {
            for cell in helperFuncs_PotentialNote_Set {
                cell.handleVisibleStateChange(type: .deActivate_Potential_Set)
            }
            helperFuncs_PotentialNote_Set.removeAll()
        }
    }
    
    func nil_Cursor_Set(){
        if helperFuncs_Cursor_Set.count > 0 {
            for cell in helperFuncs_Cursor_Set {
                cell.handleVisibleStateChange(type: .deActivate_Cursor_Set)
            }
            helperFuncs_Cursor_Set.removeAll()
        }
    }
    

    }

enum E_SwipeDirections{
    case leftward
    case rightward
    case stationary
}
