//
//  File.swift
//  
//
//  Created by Jon on 19/11/2022.
//

import Foundation
import SwiftUI

public class Note_Collection {
    
    let dimensions = ComponentDimensions.StaticDimensions
    
    var data = Underlying_Data_Grid.Static_Underlying_Data_Grid
    
    var visual_Grid_Ref : Central_Grid_Store?
    
    // this has to be seen externally and they have to be swappable
    public var noteArray : [Note] = []{
        didSet{
            if p_ExternalNote_Responder_Array.count > 0 {
                for i in 0..<p_ExternalNote_Responder_Array.count {
                    p_ExternalNote_Responder_Array[i].react_To_NoteArrayChange(noteArrayParam: noteArray)
                }
            }
        }
    }
    
    public func swapArray(newNoteArrayParam: [Note]){
        noteArray = newNoteArrayParam
    }
    
    var p_ExternalNote_Responder_Array : [P_ExternalNote_Responder] = []
    
    public func addExternalNoteResponder(newNoteResponder:P_ExternalNote_Responder){
        p_ExternalNote_Responder_Array.append(newNoteResponder)
    }
    
    var currentHighlightedNote : Note?{
        willSet{
            if let lclCurr = currentHighlightedNote,let lclNewVal = newValue{
                if lclNewVal.id != lclCurr.id {
                    lclCurr.note_Highlighted = false
                }
            }
        }
    }
    
    //func write_CellArray_Into_Note(computed_Lowest_Data_X:Int,computed_Highest_Data_X:Int,data_Y:Int) {
    func write_CellArray_Into_Note(lowest_Data_X:Int,highest_Data_X:Int,data_Y:Int) {
    
        // atm its 2x
    let multiplier = Int(dimensions.cursor_X_Jump/dimensions.pattern_Grid_Unit_Width)


    let computed_Lowest_Data_X = multiplier*lowest_Data_X
    let computed_Highest_Data_X = (multiplier*highest_Data_X)+dimensions.cellArray_Write_Addition
        
    var dataCellArray : [Underlying_Data_Cell] = []

    if data_Y < dimensions.DATA_final_Line_Y_Index {

    if computed_Lowest_Data_X == computed_Highest_Data_X {

    let singleCell = data.dataLineArray[data_Y].dataCellArray[computed_Lowest_Data_X]

    //TODO: handle single note now requiring multiple cells
    singleCell.change_Type(newType: .single_Note)

    dataCellArray.append(singleCell)

    }
    else if computed_Lowest_Data_X == computed_Highest_Data_X-1 {
    let lowestCell = data.dataLineArray[data_Y].dataCellArray[computed_Lowest_Data_X]
    let upperCell = data.dataLineArray[data_Y].dataCellArray[computed_Highest_Data_X]
    lowestCell.change_Type(newType: .start_Note)
    dataCellArray.append(lowestCell)
    upperCell.change_Type(newType: .end_Note)
    dataCellArray.append(upperCell)
    }

    else if computed_Lowest_Data_X < computed_Highest_Data_X-1 {
        for x in computed_Lowest_Data_X...computed_Highest_Data_X {
            if x == computed_Lowest_Data_X {
                let lowCell = data.dataLineArray[data_Y].dataCellArray[x]
                lowCell.change_Type(newType: .start_Note)
                dataCellArray.append(lowCell)
            }
            else if x > computed_Lowest_Data_X,x < computed_Highest_Data_X{
                let midCell = data.dataLineArray[data_Y].dataCellArray[x]
                midCell.change_Type(newType: .mid_Note)
                dataCellArray.append(midCell)
            }
            else if x == computed_Highest_Data_X{
                let upperCell = data.dataLineArray[data_Y].dataCellArray[x]
                upperCell.change_Type(newType: .end_Note)
                dataCellArray.append(upperCell)
            }
        }
    }

    }
    write_Note_Data(cellArrayParam: dataCellArray)
    }
    
    func note_Collection_Highlight_Handler(noteParam:Note?){
        
        if noteParam == nil {
            if let lclCurrHighlighted = currentHighlightedNote {
                lclCurrHighlighted.note_Highlighted = false
                currentHighlightedNote = nil
            }
        }
        else if let lclNoteParam = noteParam {
                currentHighlightedNote = lclNoteParam
                lclNoteParam.note_Highlighted = true
        }
    }
    
    func write_Note_Data(cellArrayParam : [Underlying_Data_Cell]){
        let note = Note(cellArray: cellArrayParam, parentParam: self, yParam: cellArrayParam[0].dataCell_Y_Number)
        noteArray.append(note)
        for cell in cellArrayParam {
            cell.note_Im_In = note
        }
        note_Collection_Highlight_Handler(noteParam: note)
    }
    
    // will now be called in central state after which the visual_cells will have their data vals reset
    public func reset_Note_Data_Cells(){
        if let lclCurrHighlighted = currentHighlightedNote {
            lclCurrHighlighted.resetCells()
            noteArray = noteArray.filter{$0.id == lclCurrHighlighted.id}
            currentHighlightedNote = nil
        }
    }
    
    public static let Static_Note_Collection = Note_Collection()
    
}

public protocol P_ExternalNote_Responder {
    func react_To_NoteArrayChange(noteArrayParam: [Note])
}
