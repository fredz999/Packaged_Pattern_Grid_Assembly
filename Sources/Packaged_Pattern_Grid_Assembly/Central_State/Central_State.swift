//
//  File.swift
//  
//
//  Created by Jon on 17/11/2022.
//

import Foundation
import SwiftUI

public class Central_State : ObservableObject {

    @Published var write_Note_Button_Visible : Bool = true
    @Published var edit_Layer_Visible : Bool = true
    @Published public var a_Note_Is_Highlighted : Bool = false
    {
        didSet {
            if a_Note_Is_Highlighted == false {
                write_Note_Button_Visible = true
            }
            else if a_Note_Is_Highlighted == true {
                write_Note_Button_Visible = false
            }
        }
    }

    let data_Grid = Underlying_Data_Grid.Static_Underlying_Data_Grid
    var central_Grid_Ref : Central_Grid_Store?
    
    let dimensions = ComponentDimensions.StaticDimensions
    let colors = ComponentColors.StaticColors
    //==================================================
    
    var v_Slider_Ref : Cursor_Vertical_Slider_Store?
    var h_Slider_Ref : Cursor_Horizontal_Slider_Store?
    var cursor_Layer_Ref : Cursor_Layer_Store?
    var potential_Note_Layer_Ref : Potential_Note_Layer_Store?
    public var note_Collection_Ref : Note_Collection?

//    var deleteNote_Btn_Store_Ref : Delete_Button_Store<Delete_Injected_View>?
//    var lengthen_Shorten_Button_Ref : Lengthen_Shorten_Buttons_Store<Lengthen_Shorten_Injected_View>?
//    var leftRightMoveRef : Move_Left_Right_Store<Move_Left_Right_Injected_View>?
//    var down_Up_Button_Ref : Move_Down_Up_Store<Move_Down_Up_Injected_View>?
//    var vertical_Slider_Coordinator_Ref : Vertical_Slider_Coordinator_Store?


    //==================================================
    //==================================================
    private var lower_Bracket_Number : Int = 0
    var higher_Bracket_Number : Int = 0
    //==================================================
    private var currentXCursor_Slider_Position : Int = 0
    private var currentYCursor_Slider_Position : Int = 0

    @Published public var writingIsOn : Bool = false {
        didSet {
            if writingIsOn == true {
                if let lclCursorRef = cursor_Layer_Ref {
                    lclCursorRef.cursorLayerCellColor = colors.cursorWriting
                }
                if let lclPotentialLayer = potential_Note_Layer_Ref{
                    lclPotentialLayer.handlePotentialWrite(gridXParam: currentXCursor_Slider_Position, gridYParam: currentYCursor_Slider_Position)
                    potentialNoteEvaluation()
                }
            }
            else if writingIsOn == false {
                if let lclCursorRef = cursor_Layer_Ref {
                    lclCursorRef.cursorLayerCellColor = colors.cursorNotWriting
                    if let lclPotentialLayer = potential_Note_Layer_Ref {

                        if let lcl_Initial_X = lclPotentialLayer.potential_Initial_Grid_X
                            ,let lcl_Current_X = lclPotentialLayer.potential_Current_Grid_X
                        ,let lcl_Initial_Y = lclPotentialLayer.potential_Initial_Grid_Y{
                            if lcl_Current_X > lcl_Initial_X,let lclNote_Collection = note_Collection_Ref{
                                lclNote_Collection.write_CellArray_Into_Note(lowest_Data_X: (lcl_Initial_X)
                                , highest_Data_X: (lcl_Current_X), data_Y: (lcl_Initial_Y+lower_Bracket_Number))
                            }
                            else if lcl_Current_X < lcl_Initial_X,let lclNote_Collection = note_Collection_Ref{
                                lclNote_Collection.write_CellArray_Into_Note(lowest_Data_X: lcl_Current_X
                                , highest_Data_X: lcl_Initial_X, data_Y: (lcl_Initial_Y+lower_Bracket_Number))
                            }
                            else if lcl_Current_X == lcl_Initial_X,let lclNote_Collection = note_Collection_Ref{
                                lclNote_Collection.write_CellArray_Into_Note(lowest_Data_X: (lcl_Initial_X)
                                , highest_Data_X: (lcl_Current_X), data_Y: (lcl_Initial_Y+lower_Bracket_Number))
                            }
                        }
                        lclPotentialLayer.endPotentialNote()
                    }
                }
            }
        }
    }
    //==================================================

    
    public init(){}
    
    func cursor_Slider_Update(new_X:Int?=nil,new_Y:Int?=nil){
        if let lcl_NewX = new_X {
            if lcl_NewX != currentXCursor_Slider_Position {
                currentXCursor_Slider_Position = lcl_NewX
                centralState_Cursor_Position_Evaluation()
                centralState_Data_Evaluation()
            }
        }
        if let lclNew_Y = new_Y {
            if lclNew_Y != currentYCursor_Slider_Position {
                currentYCursor_Slider_Position = lclNew_Y
                centralState_Cursor_Position_Evaluation()
                centralState_Data_Evaluation()
            }
        }
        if writingIsOn == true {
            potentialNoteEvaluation()
        }
    }

    func data_Slider_LowBracket_Update(newLower:Int){
    lower_Bracket_Number = newLower
    higher_Bracket_Number = Int(dimensions.visualGrid_Y_Unit_Count) + newLower

    if let lcl_Central_Grid_Ref = central_Grid_Ref{
        lcl_Central_Grid_Ref.changeDataBracket(newLower: newLower)
    }

    centralState_Data_Evaluation()
    }

    func centralState_Data_Evaluation(){
        if let lclCursorLayer = cursor_Layer_Ref {
            lclCursorLayer.currPosX = currentXCursor_Slider_Position
            lclCursorLayer.currPosY = currentYCursor_Slider_Position + lower_Bracket_Number

            lclCursorLayer.set_Cursor_Data(dataX: lclCursorLayer.currPosX, dataY: lclCursorLayer.currPosY)

            if let lclNote = data_Grid.dataLineArray[lclCursorLayer.currPosY].dataCellArray[lclCursorLayer.currPosX].note_Im_In {
                if let lclNoteCollection = note_Collection_Ref{
                    lclNoteCollection.note_Collection_Highlight_Handler(noteParam: lclNote)
                }
            }

            else if data_Grid.dataLineArray[lclCursorLayer.currPosY].dataCellArray[lclCursorLayer.currPosX].note_Im_In == nil{
                if let lclNoteCollection = note_Collection_Ref{
                    lclNoteCollection.note_Collection_Highlight_Handler(noteParam: nil)
                }
            }

        }
    }

    func centralState_Cursor_Position_Evaluation() {
        if let lclCursorLayer = cursor_Layer_Ref {
            lclCursorLayer.set_Cursor_Pos(xInt: currentXCursor_Slider_Position, yInt: currentYCursor_Slider_Position)
        }
    }

    func potentialNoteEvaluation(){
        if let lclPotentialLayer = potential_Note_Layer_Ref {
            lclPotentialLayer.handlePotentialWrite(gridXParam: currentXCursor_Slider_Position, gridYParam: currentYCursor_Slider_Position)
        }
    }

    public func changeNoteLength(isIncrement:Bool) {
        if let noteCollection = note_Collection_Ref {
            if let lclCurrNote = noteCollection.currentHighlightedNote {

                if isIncrement == true {
                    lclCurrNote.rightSide_Expansion()
                }
                else if isIncrement == false {
                    lclCurrNote.leftSide_Expansion()
                }

            }
        }
    }

    public func changeNotePosition(movementTyoeParam:E_Note_Movement_Type) {
        
        if let noteCollection = note_Collection_Ref {
       
            if let lclCurrNote = noteCollection.currentHighlightedNote {
                if movementTyoeParam == .rightWard {
                    if let lclHSlider = h_Slider_Ref {
                        if lclCurrNote.cell_Is_Beside_Border_Or_Note(connectionType: .toRight) == false{
                            lclCurrNote.moveRightOne()
                            lclHSlider.artificially_H_Increment()
                        }
                        else {
                            lclHSlider.artificially_H_Increment()
                        }
                    }
                }
                else if movementTyoeParam == .leftWard {
                    if let lclHSlider = h_Slider_Ref {
                        if lclCurrNote.cell_Is_Beside_Border_Or_Note(connectionType: .toLeft) == false {
                            lclCurrNote.moveLeftOne()
                            lclHSlider.artificially_H_Decrement()
                        }
                        else {
                            lclHSlider.artificially_H_Decrement()
                        }
                    }
                }
                else if movementTyoeParam == .downward {
                    if lclCurrNote.cell_Is_Beside_Border_Or_Note(connectionType: .below) == false{
                        if let lclVSlider = v_Slider_Ref{
                            lclCurrNote.moveDownOne()
                            lclVSlider.artificially_V_Increment()
                        }
                    }
                }
                else if movementTyoeParam == .upward {
                    if lclCurrNote.cell_Is_Beside_Border_Or_Note(connectionType: .above) == false{
                        if let lclVSlider = v_Slider_Ref{
                            lclCurrNote.moveUpOne()
                            lclVSlider.artificially_V_Decrement()
                        }
                    }
                }
            }
        }
    }

    public static let Static_Central_State = Central_State()

}

public enum E_Note_Movement_Type{
    case leftWard
    case rightWard
    case upward
    case downward
}




//public class Central_State : ObservableObject {
//
//    var v_Slider_Ref : Cursor_Vertical_Slider_Store?
//    var h_Slider_Ref : Cursor_Horizontal_Slider_Store?
//    var cursor_Layer_Ref : Cursor_Layer_Store?
//    var potential_Note_Layer_Ref : Potential_Note_Layer_Store?
//    var note_Collection_Ref : Note_Collection?
//    var lower_Bracket_Number : Int = 0
//
//    //==================================================
//    private var currentXCursor_Slider_Position : Int = 0
//    private var currentYCursor_Slider_Position : Int = 0
//    let colors = ComponentColors.StaticColors
//    //==================================================
//
//    func cursor_Slider_Update(new_X:Int?=nil,new_Y:Int?=nil){
//
//        if let lcl_NewX = new_X {
//            if lcl_NewX != currentXCursor_Slider_Position {
//                currentXCursor_Slider_Position = lcl_NewX
//                centralState_Cursor_Position_Evaluation()
//                centralState_Data_Evaluation()
//            }
//        }
//        if let lclNew_Y = new_Y {
//            if lclNew_Y != currentYCursor_Slider_Position {
//                currentYCursor_Slider_Position = lclNew_Y
//                centralState_Cursor_Position_Evaluation()
//                centralState_Data_Evaluation()
//            }
//        }
//        if writingIsOn == true {
//            potentialNoteEvaluation()
//        }
//    }
//
//    func potentialNoteEvaluation(){
//        if let lclPotentialLayer = potential_Note_Layer_Ref {
//            lclPotentialLayer.handlePotentialWrite(gridXParam: currentXCursor_Slider_Position, gridYParam: currentYCursor_Slider_Position)
//        }
//    }
//
//    func centralState_Cursor_Position_Evaluation() {
//        if let lclCursorLayer = cursor_Layer_Ref {
//            lclCursorLayer.set_Cursor_Pos(xInt: currentXCursor_Slider_Position, yInt: currentYCursor_Slider_Position)
//        }
//    }
//
//    func centralState_Data_Evaluation(){
//        if let lclCursorLayer = cursor_Layer_Ref {
//            lclCursorLayer.currPosX = currentXCursor_Slider_Position
//            lclCursorLayer.currPosY = currentYCursor_Slider_Position + lower_Bracket_Number
//
//            lclCursorLayer.set_Cursor_Data(dataX: lclCursorLayer.currPosX, dataY: lclCursorLayer.currPosY)
//
//            if let lclNote = data_Grid.dataLineArray[lclCursorLayer.currPosY].dataCellArray[lclCursorLayer.currPosX].note_Im_In {
//                if let lclNoteCollection = note_Collection_Ref{
//                    lclNoteCollection.note_Collection_Highlight_Handler(noteParam: lclNote)
//                }
//            }
//
//            else if data_Grid.dataLineArray[lclCursorLayer.currPosY].dataCellArray[lclCursorLayer.currPosX].note_Im_In == nil{
//                if let lclNoteCollection = note_Collection_Ref{
//                    lclNoteCollection.note_Collection_Highlight_Handler(noteParam: nil)
//                }
//            }
//
//        }
//    }
//
//    let data_Grid = Underlying_Data_Grid.Static_Underlying_Data_Grid
//    @Published var write_Note_Button_Visible : Bool = true
//    @Published var a_Note_Is_Highlighted : Bool = false
//    {
//        didSet {
//            if a_Note_Is_Highlighted == false {
//                write_Note_Button_Visible = true
//            }
//            else if a_Note_Is_Highlighted == true {
//                write_Note_Button_Visible = false
//            }
//        }
//    }
//
//    @Published public var writingIsOn : Bool = false {
//                didSet {
//                    if writingIsOn == true {
//                        if let lclCursorRef = cursor_Layer_Ref {
//                            lclCursorRef.cursorLayerCellColor = colors.cursorWriting
//                        }
//                        if let lclPotentialLayer = potential_Note_Layer_Ref{
//                            lclPotentialLayer.handlePotentialWrite(gridXParam: currentXCursor_Slider_Position, gridYParam: currentYCursor_Slider_Position)
//                            potentialNoteEvaluation()
//                        }
//                    }
//                    else if writingIsOn == false {
//                        if let lclCursorRef = cursor_Layer_Ref {
//                            lclCursorRef.cursorLayerCellColor = colors.cursorNotWriting
//                            if let lclPotentialLayer = potential_Note_Layer_Ref {
//
//                                if let lcl_Initial_X = lclPotentialLayer.potential_Initial_Grid_X
//                                    ,let lcl_Current_X = lclPotentialLayer.potential_Current_Grid_X
//                                ,let lcl_Initial_Y = lclPotentialLayer.potential_Initial_Grid_Y{
//                                    if lcl_Current_X > lcl_Initial_X,let lclNote_Collection = note_Collection_Ref{
//                                        lclNote_Collection.write_CellArray_Into_Note(lowest_Data_X: (lcl_Initial_X)
//                                        , highest_Data_X: (lcl_Current_X), data_Y: (lcl_Initial_Y+lower_Bracket_Number))
//                                    }
//                                    else if lcl_Current_X < lcl_Initial_X,let lclNote_Collection = note_Collection_Ref{
//                                        lclNote_Collection.write_CellArray_Into_Note(lowest_Data_X: lcl_Current_X
//                                        , highest_Data_X: lcl_Initial_X, data_Y: (lcl_Initial_Y+lower_Bracket_Number))
//                                    }
//                                    else if lcl_Current_X == lcl_Initial_X,let lclNote_Collection = note_Collection_Ref{
//                                        lclNote_Collection.write_CellArray_Into_Note(lowest_Data_X: (lcl_Initial_X)
//                                        , highest_Data_X: (lcl_Current_X), data_Y: (lcl_Initial_Y+lower_Bracket_Number))
//                                    }
//                                }
//                                lclPotentialLayer.endPotentialNote()
//                            }
//                        }
//                    }
//
//
//                }
//            }
//
//    var higher_Bracket_Number : Int = 0
//
//    public static let Static_Central_State = Central_State()
//}
