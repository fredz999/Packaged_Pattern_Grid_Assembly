//
//  Move_Helper.swift
//  
//
//  Created by Jon on 27/02/2023.
//

import Foundation
import SwiftUI

class Move_Helper {
    
    let dimensions = ComponentDimensions.StaticDimensions
    
    let note_Collection_Ref = Note_Collection.Static_Note_Collection
    
    var move_Note_Cursor_Set = Set<Underlying_Data_Cell>(){
        willSet {
            let delta = move_Note_Cursor_Set.symmetricDifference(newValue)
            for cell in delta {
                cell.handleVisibleStateChange(type: .deActivate_MoveNote_Cursor_Set)
            }
        }
        didSet {
            for cell in move_Note_Cursor_Set {
                cell.handleVisibleStateChange(type : .activate_MoveNote_Cursor_Set)
            }
        }
    }

    func process_MoveNote_Cursor_Position() {
        if dimensions.patternTimingConfiguration == .fourFour {
        move_Note_Cursor_Set = Central_State.Static_Central_State.currLineSet.filter({$0.four_Four_Half_Cell_Index == Central_State.Static_Central_State.currentData.four_Four_Half_Cell_Index})
        }
        else if dimensions.patternTimingConfiguration == .sixEight {
        move_Note_Cursor_Set = Central_State.Static_Central_State.currLineSet.filter({$0.six_Eight_Half_Cell_Index == Central_State.Static_Central_State.currentData.six_Eight_Half_Cell_Index})
        }
    }
    
    func check_Neighbours(proposedMoveType:E_Note_Movement_Type){
        if let lclCurrNote = note_Collection_Ref.currentHighlightedNote {
            if proposedMoveType == .rightWard{
                if lclCurrNote.cell_Is_Beside_Border_Or_Note(connectionType: .toRight) == false{
                    print("note does not have right bordering note")
                }
                else {
                    print("note HAS right bordering note")
                }
            }
        }
    }
    
    func nil_Move_Note_Cursor_Set(){
        if move_Note_Cursor_Set.count > 0 {
            for cell in move_Note_Cursor_Set {
                cell.handleVisibleStateChange(type: .deActivate_MoveNote_Cursor_Set)
            }
            move_Note_Cursor_Set.removeAll()
        }
    }
    
    
    
}










//public func changeNotePosition(movementTyoeParam:E_Note_Movement_Type) {
//
//
//
//
//        if let lclCurrNote = note_Collection_Ref.currentHighlightedNote {
//            if movementTyoeParam == .rightWard {
//                //if let lclHSlider = Central_State.Static_Central_State.h_Slider_Ref {
//                    if lclCurrNote.cell_Is_Beside_Border_Or_Note(connectionType: .toRight) == false{
//                        print("note does not have right bordering note")
//                        //lclCurrNote.moveRightOne()
//                        //lclHSlider.artificially_H_Increment()
//                    }
//                    else {
//                        //lclHSlider.artificially_H_Increment()
//                        print("note HAS right bordering note")
//                    }
//                //}
//            }
//
//
////                else if movementTyoeParam == .leftWard {
////                    if let lclHSlider = h_Slider_Ref {
////                        if lclCurrNote.cell_Is_Beside_Border_Or_Note(connectionType: .toLeft) == false {
////                            lclCurrNote.moveLeftOne()
////                            lclHSlider.artificially_H_Decrement()
////                        }
////                        else {
////                            lclHSlider.artificially_H_Decrement()
////                        }
////                    }
////                }
////                else if movementTyoeParam == .downward {
////                    if lclCurrNote.cell_Is_Beside_Border_Or_Note(connectionType: .below) == false{
////                        if let lclVSlider = v_Slider_Ref{
////                            lclCurrNote.moveDownOne()
////                            lclVSlider.artificially_V_Increment()
////                        }
////                    }
////                }
////                else if movementTyoeParam == .upward {
////                    if lclCurrNote.cell_Is_Beside_Border_Or_Note(connectionType: .above) == false{
////                        if let lclVSlider = v_Slider_Ref{
////                            lclCurrNote.moveUpOne()
////                            lclVSlider.artificially_V_Decrement()
////                        }
////                    }
////                }
//
//
//        }
//
//}

//if let noteCollection = note_Collection_Ref {
//
//    if let lclCurrNote = noteCollection.currentHighlightedNote {
//        if movementTyoeParam == .rightWard {
//            if let lclHSlider = h_Slider_Ref {
//                if lclCurrNote.cell_Is_Beside_Border_Or_Note(connectionType: .toRight) == false{
//                    lclCurrNote.moveRightOne()
//                    lclHSlider.artificially_H_Increment()
//                }
//                else {
//                    lclHSlider.artificially_H_Increment()
//                }
//            }
//        }
//        else if movementTyoeParam == .leftWard {
//            if let lclHSlider = h_Slider_Ref {
//                if lclCurrNote.cell_Is_Beside_Border_Or_Note(connectionType: .toLeft) == false {
//                    lclCurrNote.moveLeftOne()
//                    lclHSlider.artificially_H_Decrement()
//                }
//                else {
//                    lclHSlider.artificially_H_Decrement()
//                }
//            }
//        }
//        else if movementTyoeParam == .downward {
//            if lclCurrNote.cell_Is_Beside_Border_Or_Note(connectionType: .below) == false{
//                if let lclVSlider = v_Slider_Ref{
//                    lclCurrNote.moveDownOne()
//                    lclVSlider.artificially_V_Increment()
//                }
//            }
//        }
//        else if movementTyoeParam == .upward {
//            if lclCurrNote.cell_Is_Beside_Border_Or_Note(connectionType: .above) == false{
//                if let lclVSlider = v_Slider_Ref{
//                    lclCurrNote.moveUpOne()
//                    lclVSlider.artificially_V_Decrement()
//                }
//            }
//        }
//    }
//}
