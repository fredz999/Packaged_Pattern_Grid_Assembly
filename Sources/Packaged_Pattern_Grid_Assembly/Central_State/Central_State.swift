//
//  File.swift
//  
//
//  Created by Jon on 17/11/2022.
//

import Foundation
import SwiftUI

public class Central_State : ObservableObject {

    
    @Published var edit_Layer_Visible : Bool = true
    
    @Published public var a_Note_Is_Highlighted : Bool = false

    public let data_Grid = Underlying_Data_Grid.Static_Underlying_Data_Grid
    
    let dimensions = ComponentDimensions.StaticDimensions
    let colors = ComponentColors.StaticColors
    //==================================================
    
    var v_Slider_Ref : Cursor_Vertical_Slider_Store?
    public var h_Slider_Ref : Cursor_Horizontal_Slider_Store?
    var cursor_Layer_Ref : Cursor_Layer_Store?
    var potential_Note_Layer_Ref : Potential_Note_Layer_Store?
    public var note_Collection_Ref : Note_Collection?
    
    public var central_Grid_Store : Central_Grid_Store?
    
    public func change_Timing_Signature_Central(){
        dimensions.flip_Timing_Signature()
        data_Grid.changeTimingSignature_Data_Level()
    }
    
    public func deleteANote(){
        if let lclNoteCollection = note_Collection_Ref {
            lclNoteCollection.reset_Note_Data_Cells()
            a_Note_Is_Highlighted = false
        }
        generateCursorInformation()
    }

    //==================================================
    //==================================================
    var lower_Bracket_Number : Int = 0
    var higher_Bracket_Number : Int = 0
    //==================================================
    var currentXCursor_Slider_Position : Int = 0
    var currentYCursor_Slider_Position : Int = 0
    var curr_Data_Pos_Y : Int = 0
    
    public init(){}
    
    @Published public var writingIsOn : Bool = false {
        didSet {
            
            if writingIsOn == true {
                if let lclPotentialLayer = potential_Note_Layer_Ref {
                    potentialNoteEvaluation()
                    lclPotentialLayer.handlePotentialWrite(gridXParam: currentXCursor_Slider_Position, gridYParam: currentYCursor_Slider_Position)
                    generateCursorInformation()
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
                        generateCursorInformation()
                    }
                }
                
            }
            
        }
    }
    
    func cursor_Slider_Update(new_X:Int?=nil,new_Y:Int?=nil){
        if let lcl_NewX = new_X {
            currentXCursor_Slider_Position = lcl_NewX
            centralState_Data_Evaluation()
            centralState_Cursor_Position_Evaluation()
            generateCursorInformation()
            
            if writingIsOn == true {
                potentialNoteEvaluation()
            }
        }
        if let lclNew_Y = new_Y {
            currentYCursor_Slider_Position = lclNew_Y
            centralState_Data_Evaluation()
            generateCursorInformation()
            centralState_Cursor_Position_Evaluation()
            
            if writingIsOn == true {
                potentialNoteEvaluation()
            }
        }
        
    }
    
    func generateCursorInformation(){
    let currLine = data_Grid.dataLineArray[curr_Data_Pos_Y]
    var cell_Line_Set = Set<Underlying_Data_Cell>()
    for cell in currLine.dataCellArray{cell_Line_Set.insert(cell)}
    let currentData = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[currentXCursor_Slider_Position]

    if a_Note_Is_Highlighted == false,writingIsOn == false{
        
        let notesOnRight = cell_Line_Set.filter{$0.note_Im_In != nil && $0.dataCell_X_Number > currentData.dataCell_X_Number}
        let nearestNoteRight = notesOnRight.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
        
        let notesOnLeft = cell_Line_Set.filter{$0.note_Im_In != nil && $0.dataCell_X_Number < currentData.dataCell_X_Number}
        let nearestNoteLeft =   notesOnLeft.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
        
        if let lclRight = nearestNoteRight, let lclLeft = nearestNoteLeft {
            let lowerXfloat = CGFloat(lclLeft.dataCell_X_Number+1) * dimensions.pattern_Grid_Sub_Cell_Width
            let upperXFloat = CGFloat(lclRight.dataCell_X_Number) * dimensions.pattern_Grid_Sub_Cell_Width
            if let lclCursorLayer = cursor_Layer_Ref {
                lclCursorLayer.setViableRegionMarker(lowerXParam: lowerXfloat, upperXParam: upperXFloat)
            }
        }
        else if let lclRight = nearestNoteRight, nearestNoteLeft == nil {
            let upperXFloat = CGFloat(lclRight.dataCell_X_Number) * dimensions.pattern_Grid_Sub_Cell_Width
            if let lclCursorLayer = cursor_Layer_Ref {
                lclCursorLayer.setViableRegionMarker(lowerXParam: 0, upperXParam: upperXFloat)
            }
        }
        else if nearestNoteRight == nil, let lclLeft = nearestNoteLeft {
            let lowerXfloat = CGFloat(lclLeft.dataCell_X_Number+1) * dimensions.pattern_Grid_Sub_Cell_Width
            if let lclCursorLayer = cursor_Layer_Ref {
                lclCursorLayer.setViableRegionMarker(lowerXParam: lowerXfloat, upperXParam: 384)
            }
        }
        else if nearestNoteRight == nil, nearestNoteLeft == nil {
            if let lclCursorLayer = cursor_Layer_Ref {
                lclCursorLayer.setViableRegionMarker(lowerXParam: 0, upperXParam: 384)
            }
        }
        
    }
    else if a_Note_Is_Highlighted == true || writingIsOn == true{
        if let lclCursorLayer = cursor_Layer_Ref {
            lclCursorLayer.setViableRegionMarker(lowerXParam: 0, upperXParam: 0)
        }
    }
    }
    
    func centralState_Cursor_Position_Evaluation() {
        if let lclCursorLayer = cursor_Layer_Ref {
            lclCursorLayer.set_Cursor_Pos(xInt: currentXCursor_Slider_Position, yInt: currentYCursor_Slider_Position)
        }
    }
    
    public func togglewriteIsOn(){
        if a_Note_Is_Highlighted == false{
            writingIsOn.toggle()
        }
    }
    
    func centralState_Data_Evaluation(){
        
        if let lclCursorLayer = cursor_Layer_Ref {
            lclCursorLayer.currPosX = currentXCursor_Slider_Position //*multiplier
            curr_Data_Pos_Y = currentYCursor_Slider_Position + lower_Bracket_Number
            lclCursorLayer.currPosY = curr_Data_Pos_Y
            
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

    var rightBoundaryInt : Int?
    
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


