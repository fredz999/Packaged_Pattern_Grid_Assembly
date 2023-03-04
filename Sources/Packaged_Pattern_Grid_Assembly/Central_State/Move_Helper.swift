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
    let dataGrid = Underlying_Data_Grid.Static_Underlying_Data_Grid
    let centralStateRef = Central_State.Static_Central_State
    
    var note_Low_Index : Int?
    var note_High_Index : Int?
    var note_Y_Val : Int?
    var snapshot_Cursor_X : Int?
    var snapshot_Cursor_Y : Int?
    
    var potential_Moved_Set = Set<Underlying_Data_Cell>(){
        willSet {
            let delta = potential_Moved_Set.symmetricDifference(newValue)
            for cell in delta {
                cell.handleVisibleStateChange(type: .deActivate_Potential_Set)
            }
        }
        didSet {
            for cell in potential_Moved_Set {
                cell.handleVisibleStateChange(type : .activate_Potential_Set)
            }
        }
    }
    
    func movement_With_Note_Selected(){
        if let lclNote_Low_Index = note_Low_Index, let lclNote_High_Index = note_High_Index, let lclNote_Y_Val = note_Y_Val
        ,let lclSnapshot_X = snapshot_Cursor_X,let lclSnapshot_Y = snapshot_Cursor_Y{
            
            
            let delta_X_Grid_Units = centralStateRef.curr_Data_Pos_X - lclSnapshot_X
            let delta_Y_Grid_Units = centralStateRef.curr_Data_Pos_Y - lclSnapshot_Y
            //print("delta_X_Grid_Units: ",delta_X_Grid_Units,", delta_Y_Grid_Units: ",delta_Y_Grid_Units)
            //ok.... get a proposed set of datacell x and a y out of this
            let proposedNewMinIndex = lclNote_Low_Index + delta_X_Grid_Units
            let proposedNewMaxIndex = lclNote_High_Index + delta_X_Grid_Units
            let proposedNewYIndex = lclNote_Y_Val + delta_Y_Grid_Units
            
            potential_Moved_Set = Central_State.Static_Central_State.currLineSet
            .filter{$0.dataCell_X_Number >= proposedNewMinIndex && $0.dataCell_X_Number <= proposedNewMaxIndex}
            
        }
        else{
            print("else hit")
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

    var move_Note_Cursor_Set = Set<Underlying_Data_Cell>(){
        willSet {
            let delta = move_Note_Cursor_Set.symmetricDifference(newValue)
            for cell in delta {
                cell.handleVisibleStateChange(type: .deActivate_MoveNote_Cursor_Set)
            }
        }
        didSet {
            if Central_State.Static_Central_State.currentPatternMode == .moving {
                var nillableNote : Note? = nil
                for cell in move_Note_Cursor_Set {
                    cell.handleVisibleStateChange(type: .activate_MoveNote_Cursor_Set)
                    if let lclNote = cell.note_Im_In {
                        nillableNote = lclNote
                    }
                }

                if let lclNoteCollection = Central_State.Static_Central_State.note_Collection_Ref {
                    if let lclNillableNote = nillableNote {
                        lclNoteCollection.note_Collection_Highlight_Handler(noteParam: lclNillableNote)
                    }
                    else if nillableNote == nil {
                        lclNoteCollection.note_Collection_Highlight_Handler(noteParam: nil)
                    }
                }
                
            }
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

//        if let lcl_CapturedX = captured_Initial_Data_X
//        ,let lcl_Captured_Cells = captured_Original_Note_Cells {
//
//            let minCell = Central_State.Static_Central_State.currentData
//            let deltaX = minCell.dataCell_X_Number - lcl_CapturedX
//            if lcl_Captured_Cells.count > 0 {
//
//                let newStartX = lcl_Captured_Cells[0].dataCell_X_Number + deltaX
//
//                if newStartX >= 0,(newStartX+lcl_Captured_Cells.count) <= 96 {
//                    potential_Moved_Set = Central_State.Static_Central_State.currLineSet
//                    .filter{$0.dataCell_X_Number >= newStartX && $0.dataCell_X_Number <= (newStartX+lcl_Captured_Cells.count)}
//                }
//                else if newStartX < 0 {
//                    print("newStartX < 0")
//                }
//            }
//        }



//    var move_Note_Cursor_Set = Set<Underlying_Data_Cell>(){
//        willSet {
//            let delta = move_Note_Cursor_Set.symmetricDifference(newValue)
//            for cell in delta {
//                cell.handleVisibleStateChange(type: .deActivate_MoveNote_Cursor_Set)
//            }
//        }
//        didSet {
//            for cell in move_Note_Cursor_Set {
//                cell.handleVisibleStateChange(type : .activate_MoveNote_Cursor_Set)
//            }
//        }
//    }

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
