//
//  Viable_Set_Helper_Funcs.swift
//  
//
//  Created by Jon on 16/01/2023.
//

import Foundation
import SwiftUI


class WriteNote_Helper: P_Selectable_Mode {
    
    var dimensions = ComponentDimensions.StaticDimensions
    
    var selectableModeId: Int
    
    var mode_Active: Bool

    var parentCentralState : Central_State

    var potential_Note_Set = Set<Underlying_Data_Cell>(){
        willSet {
            let delta = potential_Note_Set.symmetricDifference(newValue)
            for cell in delta {
                cell.handleVisibleStateChange(type: .deActivate_Potential_Set)
            }
        }
        didSet {
            for cell in potential_Note_Set {
                cell.handleVisibleStateChange(type: .activate_Potential_Set)
            }
        }
    }
    
    var initial_WriteOnCell : Underlying_Data_Cell?
    
    init(parentCentral_State_Param:Central_State,selectableModeIdParam:Int){
        selectableModeId = selectableModeIdParam
        mode_Active = false
        parentCentralState = parentCentral_State_Param
    }
    
    func activate_Mode(activationCell: Underlying_Data_Cell?){
        if mode_Active == false {
            mode_Active = true
            if let lclActivationCell = activationCell {
                initial_WriteOnCell = lclActivationCell
                print("timing config: ",dimensions.patternTimingConfiguration.rawValue,",initCell fourFourIndex")
            }
        }
    }
    
    func establish_Potential_Cells_Set(){
        if let lclInitialCell = initial_WriteOnCell {
            if lclInitialCell.dataCell_X_Number < parentCentralState.currentData.dataCell_X_Number {
            if parentCentralState.dimensions.patternTimingConfiguration == .fourFour {
            print("establish_Potential_Cells_Set().........0")
            let lowerHalfCellSet = parentCentralState.currLineSet.filter({$0.four_Four_Half_Cell_Index == lclInitialCell.four_Four_Half_Cell_Index})
            let upperHalfCellSet = parentCentralState.currLineSet.filter({$0.four_Four_Half_Cell_Index == parentCentralState.currentData.four_Four_Half_Cell_Index})
            var combinedSet = Set<Underlying_Data_Cell>()
    
            let rightSideHasNotesSet = parentCentralState.currLineSet.filter({$0.dataCell_X_Number > lclInitialCell.dataCell_X_Number && $0.note_Im_In != nil})
            let lowestRightNoteCell = rightSideHasNotesSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
    
            if lclInitialCell.dataCell_X_Number == parentCentralState.currentData.dataCell_X_Number {
                combinedSet = lowerHalfCellSet
            }
    
            else if parentCentralState.currentData.dataCell_X_Number > lclInitialCell.dataCell_X_Number {
                combinedSet = lowerHalfCellSet.union(upperHalfCellSet)
            }
    
            if let min_Cell = combinedSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
            ,let max_Cell = combinedSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
    
            let swipeSet =
                parentCentralState.currLineSet.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number
                && $0.dataCell_X_Number <= max_Cell.dataCell_X_Number})
            if let lclLowestRightNoteCell = lowestRightNoteCell {
                potential_Note_Set = swipeSet.filter({$0.dataCell_X_Number < lclLowestRightNoteCell.dataCell_X_Number})
            }
            else if lowestRightNoteCell == nil {
                potential_Note_Set = swipeSet
            }
    
            }
            }
            else if parentCentralState.dimensions.patternTimingConfiguration == .sixEight {
                print("establish_Potential_Cells_Set().........1")
                let lowerHalfCellSet = parentCentralState.currLineSet.filter({$0.six_Eight_Half_Cell_Index == lclInitialCell.six_Eight_Half_Cell_Index})
                let upperHalfCellSet = parentCentralState.currLineSet
                    .filter({$0.six_Eight_Half_Cell_Index == parentCentralState.currentData.six_Eight_Half_Cell_Index})
                var combinedSet = Set<Underlying_Data_Cell>()
    
                let rightSideHasNotesSet = parentCentralState.currLineSet.filter({$0.dataCell_X_Number > lclInitialCell.dataCell_X_Number && $0.note_Im_In != nil})
                let lowestRightNoteCell = rightSideHasNotesSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
    
    
                if lclInitialCell.dataCell_X_Number == parentCentralState.currentData.dataCell_X_Number {
                    combinedSet = lowerHalfCellSet
                }
    
                else if parentCentralState.currentData.dataCell_X_Number > lclInitialCell.dataCell_X_Number {
                    combinedSet = lowerHalfCellSet.union(upperHalfCellSet)
                }
    
                if let min_Cell = combinedSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
                ,let max_Cell = combinedSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
    
                    let swipeSet =
                    parentCentralState.currLineSet.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number
                    && $0.dataCell_X_Number <= max_Cell.dataCell_X_Number})
    
                    if let lclLowestRightNoteCell = lowestRightNoteCell {
                        potential_Note_Set = swipeSet.filter({$0.dataCell_X_Number < lclLowestRightNoteCell.dataCell_X_Number})
                    }
                    else if lowestRightNoteCell == nil {
                        potential_Note_Set = swipeSet
                    }
                }
            }
        }
        else if lclInitialCell.dataCell_X_Number > parentCentralState.currentData.dataCell_X_Number {
            if parentCentralState.dimensions.patternTimingConfiguration == .fourFour {
            print("establish_Potential_Cells_Set().........2")
                
            let upperHalfCellSet = parentCentralState.currLineSet.filter({$0.four_Four_Half_Cell_Index == lclInitialCell.four_Four_Half_Cell_Index})
            let lowerHalfCellSet = parentCentralState.currLineSet.filter({$0.four_Four_Half_Cell_Index == parentCentralState.currentData.four_Four_Half_Cell_Index})
            var combinedSet = Set<Underlying_Data_Cell>()

            let leftSideHasNotesSet = parentCentralState.currLineSet.filter({$0.dataCell_X_Number < lclInitialCell.dataCell_X_Number && $0.note_Im_In != nil})
            let highestLeftNoteCell = leftSideHasNotesSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})


            if lclInitialCell.dataCell_X_Number == parentCentralState.currentData.dataCell_X_Number {
                combinedSet = lowerHalfCellSet
            }

            else if parentCentralState.currentData.dataCell_X_Number < lclInitialCell.dataCell_X_Number {
                combinedSet = lowerHalfCellSet.union(upperHalfCellSet)
            }

            if let min_Cell = combinedSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
            ,let max_Cell = combinedSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){

                let swipeSet =
                parentCentralState.currLineSet.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number
                && $0.dataCell_X_Number <= max_Cell.dataCell_X_Number})

                if let lclHighestLeftNoteCell = highestLeftNoteCell {
                    potential_Note_Set = swipeSet.filter({$0.dataCell_X_Number > lclHighestLeftNoteCell.dataCell_X_Number})
                }
                else if highestLeftNoteCell == nil {
                    potential_Note_Set = swipeSet
                }
            }
        }
            else if parentCentralState.dimensions.patternTimingConfiguration == .sixEight {
            print("establish_Potential_Cells_Set().........3")
            let upperHalfCellSet = parentCentralState.currLineSet
            .filter({$0.six_Eight_Half_Cell_Index == lclInitialCell.six_Eight_Half_Cell_Index})
            let lowerHalfCellSet = parentCentralState.currLineSet
            .filter({$0.six_Eight_Half_Cell_Index == parentCentralState.currentData.six_Eight_Half_Cell_Index})
            var combinedSet = Set<Underlying_Data_Cell>()

            let leftSideHasNotesSet = parentCentralState.currLineSet
            .filter({$0.dataCell_X_Number < lclInitialCell.dataCell_X_Number && $0.note_Im_In != nil})
            let highestLeftNoteCell = leftSideHasNotesSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})


            if lclInitialCell.dataCell_X_Number == parentCentralState.currentData.dataCell_X_Number {
                combinedSet = lowerHalfCellSet
            }

            else if parentCentralState.currentData.dataCell_X_Number < lclInitialCell.dataCell_X_Number {
                combinedSet = lowerHalfCellSet.union(upperHalfCellSet)
            }

            if let min_Cell = combinedSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
            ,let max_Cell = combinedSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){

                let swipeSet =
                parentCentralState.currLineSet.filter({$0.dataCell_X_Number >= min_Cell.dataCell_X_Number
                && $0.dataCell_X_Number <= max_Cell.dataCell_X_Number})

                if let lclHighestLeftNoteCell = highestLeftNoteCell {
                    potential_Note_Set = swipeSet.filter({$0.dataCell_X_Number > lclHighestLeftNoteCell.dataCell_X_Number})
                }
                else if highestLeftNoteCell == nil {
                    potential_Note_Set = swipeSet
                }
            }
        }
        }
        }
    }
    
    func generateModeDescriptorString()->String{
        return "Write Mode"
    }
    
    func deactivate_Mode() {
        if mode_Active == true {
            mode_Active = false
            if potential_Note_Set.count > 0 {
                if let currentNoteCollection = parentCentralState.currentNoteCollection{
                    currentNoteCollection.write_Note_Data(cellSetParam: potential_Note_Set, highlightAfterWrite: false)
                }
                potential_Note_Set.removeAll()
            }
            if initial_WriteOnCell != nil{initial_WriteOnCell=nil}
        }
    }
    
}

enum E_SwipeDirections{
    case leftward
    case rightward
    case stationary
}

//func establish_Potential_Cells_Set(){
//    print("establish_Potential_Cells_Set()")
//    if let lclInitialCell = initial_WriteOnCell {
//
//        if lclInitialCell.dataCell_X_Number < parentCentralState.currentData.dataCell_X_Number {
//            if parentCentralState.dimensions.patternTimingConfiguration == .fourFour {
//                print(".fourFour")
//            }
//            else if parentCentralState.dimensions.patternTimingConfiguration == .sixEight {
//                print(".sixEight")
//            }
//            print("nat suuuuure")
//        }
//
//    }
//    else if initial_WriteOnCell == nil{
//        print("initial_WriteOnCell == nil")
//    }
//}


