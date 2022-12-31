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
    
    // TODO : highlight update for visual cells
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

    public let data_Grid = Underlying_Data_Grid.Static_Underlying_Data_Grid
    //var central_Grid_Ref : Central_Grid_Store?
    
    let dimensions = ComponentDimensions.StaticDimensions
    let colors = ComponentColors.StaticColors
    //==================================================
    
    var v_Slider_Ref : Cursor_Vertical_Slider_Store?
    public var h_Slider_Ref : Cursor_Horizontal_Slider_Store?
    var cursor_Layer_Ref : Cursor_Layer_Store?
    var potential_Note_Layer_Ref : Potential_Note_Layer_Store?
    public var note_Collection_Ref : Note_Collection?
    
    public var central_Grid_Store : Central_Grid_Store?
    
    public func change_Pattern_Data_Length(){
        dimensions.flip_Timing_Signature()
        if let lclHslider = h_Slider_Ref{
            lclHslider.calculateCursorCellXPos()
                // .zeroCursorCellXPos()
                // .calculateCursorCellXPos()
        }
        data_Grid.changeTimingSignature_Data_Level()

        if let lcl_central_Grid_Store = central_Grid_Store {
            for gridLine in lcl_central_Grid_Store.vis_Line_Store_Array {
                for cell in gridLine.visual_Cell_Store_Array {
                    let currY = cell.data_Vals_Holder.referenced_dataCell_Y_Number
                    let daata : Underlying_Data_Cell = data_Grid.dataLineArray[currY].dataCellArray[cell.x_Index]
                    cell.cell_Swap_Underlying_Data(new_Data_Cell: daata)
                }
            }
        }
    }

    //==================================================
    //==================================================
    var lower_Bracket_Number : Int = 0
    var higher_Bracket_Number : Int = 0
    //==================================================
    var currentXCursor_Slider_Position : Int = 0
    var currentYCursor_Slider_Position : Int = 0
    public init(){}
    
    
    @Published public var writingIsOn : Bool = false {
        didSet {
            
            if writingIsOn == true {
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
                            
                            if let lcl_Vis_Grid = central_Grid_Store {

                                if (lcl_Initial_Y+lower_Bracket_Number) < dimensions.DATA_final_Line_Y_Index
                                ,(lcl_Initial_Y+lower_Bracket_Number) >= 0{

                                    if lcl_Current_X > lcl_Initial_X{
                                        for x in lcl_Initial_X...lcl_Current_X{
                                            let redrawCellData = data_Grid.dataLineArray[(lcl_Initial_Y+lower_Bracket_Number)].dataCellArray[x]
                                            lcl_Vis_Grid.vis_Line_Store_Array[lcl_Initial_Y].visual_Cell_Store_Array[x].cell_Swap_Underlying_Data(new_Data_Cell: redrawCellData)
                                        }
                                    }
                                    else if lcl_Current_X < lcl_Initial_X{
                                        for x in lcl_Current_X...lcl_Initial_X{
                                            let redrawCellData = data_Grid.dataLineArray[(lcl_Initial_Y+lower_Bracket_Number)].dataCellArray[x]
                                            lcl_Vis_Grid.vis_Line_Store_Array[lcl_Initial_Y].visual_Cell_Store_Array[x].cell_Swap_Underlying_Data(new_Data_Cell: redrawCellData)
                                        }
                                    }
                                    else if lcl_Current_X == lcl_Initial_X{
                                        let redrawCellData = data_Grid.dataLineArray[(lcl_Initial_Y+lower_Bracket_Number)].dataCellArray[lcl_Current_X]
                                        lcl_Vis_Grid.vis_Line_Store_Array[lcl_Initial_Y].visual_Cell_Store_Array[lcl_Current_X].cell_Swap_Underlying_Data(new_Data_Cell: redrawCellData)
                                    }
                                    
                                }
                            }
                            
                        }
                        lclPotentialLayer.endPotentialNote()
                    }
                }
                
            }
            
        }
    }
    
    
    func cursor_Slider_Update(new_X:Int?=nil,new_Y:Int?=nil){
        if let lcl_NewX = new_X {
            if lcl_NewX != currentXCursor_Slider_Position {
                currentXCursor_Slider_Position = lcl_NewX
                centralState_Cursor_Position_Evaluation()
                centralState_Data_Evaluation()
                if writingIsOn == true {
                    potentialNoteEvaluation()
                }
            }
        }
        if let lclNew_Y = new_Y {
            if lclNew_Y != currentYCursor_Slider_Position {
                currentYCursor_Slider_Position = lclNew_Y
                centralState_Cursor_Position_Evaluation()
                centralState_Data_Evaluation()
                if writingIsOn == true {
                    potentialNoteEvaluation()
                }
            }
        }
        
    }

    func centralState_Cursor_Position_Evaluation() {
        if let lclCursorLayer = cursor_Layer_Ref {
            lclCursorLayer.set_Cursor_Pos(xInt: currentXCursor_Slider_Position, yInt: currentYCursor_Slider_Position)
        }
    }

    func centralState_Data_Evaluation(){
        
        if let lclCursorLayer = cursor_Layer_Ref {
            
            let multiplier = Int(dimensions.cursor_X_Jump/dimensions.pattern_Grid_Unit_Width)
            
            lclCursorLayer.currPosX = currentXCursor_Slider_Position*multiplier
            
            lclCursorLayer.currPosY = currentYCursor_Slider_Position + lower_Bracket_Number
            
            if lclCursorLayer.currPosY < data_Grid.dataLineArray.count, lclCursorLayer.currPosX < dimensions.dataGrid_X_Unit_Count {
                
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
    }
    
    func data_Slider_LowBracket_Update(newLower:Int){
    lower_Bracket_Number = newLower
    higher_Bracket_Number = Int(dimensions.visualGrid_Y_Unit_Count) + newLower

    if let lcl_Central_Grid_Ref = central_Grid_Store{
        lcl_Central_Grid_Ref.changeDataBracket(newLower: newLower)
    }
    centralState_Data_Evaluation()
    }
    
    func potentialNoteEvaluation(){
        if let lclPotentialLayer = potential_Note_Layer_Ref {
            // check it can be write here?
            // TODO: check viability
            
            
            
//            if (currentYCursor_Slider_Position+lower_Bracket_Number) < dimensions.DATA_final_Line_Y_Index
//                ,(currentYCursor_Slider_Position+lower_Bracket_Number) >= 0 {

                if data_Grid.dataLineArray[(currentYCursor_Slider_Position+lower_Bracket_Number)].dataCellArray[currentXCursor_Slider_Position].note_Im_In != nil{
                    print("hit a note ")
                }
                
                lclPotentialLayer.handlePotentialWrite(gridXParam: currentXCursor_Slider_Position, gridYParam: currentYCursor_Slider_Position)

                
            //}
            
            
            
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


