//
//  Viable_Set_Helper_Funcs.swift
//  
//
//  Created by Jon on 16/01/2023.
//

import Foundation
import SwiftUI

class WriteNote_Helper: P_Selectable_Mode {
    
    var mode_Active: Bool = false
    
    func activate_Mode() {
        if mode_Active == false{mode_Active=true}
    }
    
    func deactivate_Mode() {
        if mode_Active == true{mode_Active=false}
    }
    
    let dimensions = ComponentDimensions.StaticDimensions

    var potential_Helper_Cursor_Set = Set<Underlying_Data_Cell>(){
        willSet {
            let delta = potential_Helper_Cursor_Set.symmetricDifference(newValue)
            for cell in delta {
                cell.handleVisibleStateChange(type: .deActivate_Cursor_Set)
            }
        }
        didSet {
            if Central_State.Static_Central_State.currentPatternMode != .write_Mode{
                var nillableNote : Note? = nil
                for cell in potential_Helper_Cursor_Set {
                    cell.handleVisibleStateChange(type: .activate_Cursor_Set)
                    if let lclNote = cell.note_Im_In {
                        nillableNote = lclNote
                    }
                }
                
                //test_For_Write_Lock()
                
                if let lclNoteCollection = Central_State.Static_Central_State.note_Collection_Ref {
                    if let lclNillableNote = nillableNote {
                        lclNoteCollection.note_Collection_Highlight_Handler(noteParam: lclNillableNote)
                                                                            //, highlightType: .Selected_Highlight)
                    }
                    else if nillableNote == nil {
                        lclNoteCollection.note_Collection_Highlight_Handler(noteParam: nil)
                                                                            //, highlightType: .UnSelected)
                    }
                }
                
            }
        }
    }

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
    
    var initial_WriteOnCell : Underlying_Data_Cell?

    func establish_Cursor_Set(){
        if dimensions.patternTimingConfiguration == .fourFour {
            potential_Helper_Cursor_Set = Central_State.Static_Central_State.currLineSet
                .filter({$0.four_Four_Half_Cell_Index == Central_State.Static_Central_State.currentData.four_Four_Half_Cell_Index})
        }
        else if dimensions.patternTimingConfiguration == .sixEight {
            potential_Helper_Cursor_Set = Central_State.Static_Central_State.currLineSet
                .filter({$0.four_Four_Half_Cell_Index == Central_State.Static_Central_State.currentData.six_Eight_Half_Cell_Index})
        }
    }
    
    func establish_Potential_Cells_Set(){
        if let lclInitialCell = initial_WriteOnCell {

            if lclInitialCell.dataCell_X_Number < Central_State.Static_Central_State.currentData.dataCell_X_Number {
            if dimensions.patternTimingConfiguration == .fourFour {
            let lowerHalfCellSet = Central_State.Static_Central_State.currLineSet.filter({$0.four_Four_Half_Cell_Index == lclInitialCell.four_Four_Half_Cell_Index})
            let upperHalfCellSet = Central_State.Static_Central_State.currLineSet.filter({$0.four_Four_Half_Cell_Index == Central_State.Static_Central_State.currentData.four_Four_Half_Cell_Index-1})
            var combinedSet = Set<Underlying_Data_Cell>()

            let rightSideHasNotesSet = Central_State.Static_Central_State.currLineSet.filter({$0.dataCell_X_Number > lclInitialCell.dataCell_X_Number && $0.note_Im_In != nil})
            let lowestRightNoteCell = rightSideHasNotesSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})

            if lclInitialCell.dataCell_X_Number == Central_State.Static_Central_State.currentData.dataCell_X_Number {
                combinedSet = lowerHalfCellSet
            }

            else if Central_State.Static_Central_State.currentData.dataCell_X_Number > lclInitialCell.dataCell_X_Number {
                combinedSet = lowerHalfCellSet.union(upperHalfCellSet)
            }

            if let min_Cell = combinedSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
            ,let max_Cell = combinedSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){

            let swipeSet =
                Central_State.Static_Central_State.currLineSet.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number
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
                let lowerHalfCellSet = Central_State.Static_Central_State.currLineSet.filter({$0.six_Eight_Half_Cell_Index == lclInitialCell.six_Eight_Half_Cell_Index})
                let upperHalfCellSet = Central_State.Static_Central_State.currLineSet
                    .filter({$0.six_Eight_Half_Cell_Index == Central_State.Static_Central_State.currentData.six_Eight_Half_Cell_Index-1})
                var combinedSet = Set<Underlying_Data_Cell>()

                let rightSideHasNotesSet = Central_State.Static_Central_State.currLineSet.filter({$0.dataCell_X_Number > lclInitialCell.dataCell_X_Number && $0.note_Im_In != nil})
                let lowestRightNoteCell = rightSideHasNotesSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})


                if lclInitialCell.dataCell_X_Number == Central_State.Static_Central_State.currentData.dataCell_X_Number {
                    combinedSet = lowerHalfCellSet
                }

                else if Central_State.Static_Central_State.currentData.dataCell_X_Number > lclInitialCell.dataCell_X_Number {
                    combinedSet = lowerHalfCellSet.union(upperHalfCellSet)
                }

                if let min_Cell = combinedSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                ,let max_Cell = combinedSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){

                    let swipeSet =
                    Central_State.Static_Central_State.currLineSet.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number
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
            else if lclInitialCell.dataCell_X_Number > Central_State.Static_Central_State.currentData.dataCell_X_Number {
            if dimensions.patternTimingConfiguration == .fourFour {
                let upperHalfCellSet = Central_State.Static_Central_State.currLineSet.filter({$0.four_Four_Half_Cell_Index == lclInitialCell.four_Four_Half_Cell_Index-1})
                let lowerHalfCellSet = Central_State.Static_Central_State.currLineSet.filter({$0.four_Four_Half_Cell_Index == Central_State.Static_Central_State.currentData.four_Four_Half_Cell_Index})
                var combinedSet = Set<Underlying_Data_Cell>()

                let leftSideHasNotesSet = Central_State.Static_Central_State.currLineSet.filter({$0.dataCell_X_Number < lclInitialCell.dataCell_X_Number && $0.note_Im_In != nil})
                let highestLeftNoteCell = leftSideHasNotesSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})


                if lclInitialCell.dataCell_X_Number == Central_State.Static_Central_State.currentData.dataCell_X_Number {
                    combinedSet = lowerHalfCellSet
                }

                else if Central_State.Static_Central_State.currentData.dataCell_X_Number < lclInitialCell.dataCell_X_Number {
                    combinedSet = lowerHalfCellSet.union(upperHalfCellSet)
                }

                if let min_Cell = combinedSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                ,let max_Cell = combinedSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){

                    let swipeSet =
                    Central_State.Static_Central_State.currLineSet.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number
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
                let upperHalfCellSet = Central_State.Static_Central_State.currLineSet
                .filter({$0.six_Eight_Half_Cell_Index == lclInitialCell.six_Eight_Half_Cell_Index-1})
                let lowerHalfCellSet = Central_State.Static_Central_State.currLineSet
                .filter({$0.six_Eight_Half_Cell_Index == Central_State.Static_Central_State.currentData.six_Eight_Half_Cell_Index})
                var combinedSet = Set<Underlying_Data_Cell>()

                let leftSideHasNotesSet = Central_State.Static_Central_State.currLineSet
                .filter({$0.dataCell_X_Number < lclInitialCell.dataCell_X_Number && $0.note_Im_In != nil})
                let highestLeftNoteCell = leftSideHasNotesSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})


                if lclInitialCell.dataCell_X_Number == Central_State.Static_Central_State.currentData.dataCell_X_Number {
                    combinedSet = lowerHalfCellSet
                }

                else if Central_State.Static_Central_State.currentData.dataCell_X_Number < lclInitialCell.dataCell_X_Number {
                    combinedSet = lowerHalfCellSet.union(upperHalfCellSet)
                }

                if let min_Cell = combinedSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                ,let max_Cell = combinedSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){

                    let swipeSet =
                    Central_State.Static_Central_State.currLineSet.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number
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
    
    func nilPotentialSet(){
        if helperFuncs_PotentialNote_Set.count > 0 {
            for cell in helperFuncs_PotentialNote_Set {
                cell.handleVisibleStateChange(type: .deActivate_Potential_Set)
            }
            helperFuncs_PotentialNote_Set.removeAll()
        }
        if potential_Helper_Cursor_Set.count > 0 {
            for cell in potential_Helper_Cursor_Set {
                cell.handleVisibleStateChange(type: .deActivate_Potential_Set)
            }
            potential_Helper_Cursor_Set.removeAll()
        }
        initial_WriteOnCell = nil
    }
    
//    func writeNote(note_Y_Param:Int){
//        var startCellSet = Set<Underlying_Data_Cell>()
//        if let minX = helperFuncs_PotentialNote_Set.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
//            startCellSet.insert(minX)
//        }
//
//        var endCellSet = Set<Underlying_Data_Cell>()
//        if let maxX = helperFuncs_PotentialNote_Set.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
//            endCellSet.insert(maxX)
//        }
//
//        let midCellSet = helperFuncs_PotentialNote_Set.subtracting(startCellSet.union(endCellSet))
//
//        for cell in startCellSet{cell.change_Type(newType: .start_Note)}
//        for cell in midCellSet{cell.change_Type(newType: .mid_Note)}
//        for cell in endCellSet{cell.change_Type(newType: .end_Note)}
//
//        let startCells = startCellSet.sorted(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
//        let endCells = endCellSet.sorted(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
//
//        for index in 0..<startCellSet.count {
//        var noteArr = [Underlying_Data_Cell]()
//        let currStartCell = startCells[index]
//        let currEndCell = endCells[index]
//        noteArr.append(currStartCell)
//        let midSet = midCellSet.filter({$0.dataCell_X_Number > currStartCell.dataCell_X_Number && $0.dataCell_X_Number < currEndCell.dataCell_X_Number})
//        let midArr = midSet.sorted(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
//        for midCell in midArr {
//        noteArr.append(midCell)
//        }
//        noteArr.append(currEndCell)
//        Note_Collection.Static_Note_Collection.write_Note_Data(cellArrayParam: noteArr, note_Y_Num: note_Y_Param)
//        }
//
//    }
    
    
    
//    func nil_Potential_Cursor_Set(){
//        if potential_Helper_Cursor_Set.count > 0 {
//            for cell in potential_Helper_Cursor_Set {
//                cell.handleVisibleStateChange(type: .deActivate_Cursor_Set)
//            }
//            potential_Helper_Cursor_Set.removeAll()
//        }
//    }

}

enum E_SwipeDirections{
    case leftward
    case rightward
    case stationary
}