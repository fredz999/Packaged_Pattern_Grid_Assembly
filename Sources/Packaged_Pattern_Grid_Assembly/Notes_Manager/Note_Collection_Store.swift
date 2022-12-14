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
                    lclCurr.highlighted = false
                }
            }
        }
    }
    
    func write_CellArray_Into_Note(lowest_Data_X:Int,highest_Data_X:Int,data_Y:Int) {
    
    var cellArray : [Underlying_Data_Cell] = []
        
    if data_Y < dimensions.DATA_final_Line_Y_Index {
    
    if lowest_Data_X == highest_Data_X {
        
    let singleCell = data.dataLineArray[data_Y].dataCellArray[lowest_Data_X]

    singleCell.changeType(newType: .single)
    
    cellArray.append(singleCell)
        
    }
    else if lowest_Data_X == highest_Data_X-1 {
    let lowestCell = data.dataLineArray[data_Y].dataCellArray[lowest_Data_X]
    let upperCell = data.dataLineArray[data_Y].dataCellArray[highest_Data_X]
    lowestCell.changeType(newType: .start)
    cellArray.append(lowestCell)
    upperCell.changeType(newType: .end)
    cellArray.append(upperCell)
    }
    
    else if lowest_Data_X < highest_Data_X-1 {
        for x in lowest_Data_X...highest_Data_X {
            if x == lowest_Data_X {
                let lowCell = data.dataLineArray[data_Y].dataCellArray[x]
                lowCell.changeType(newType: .start)
                cellArray.append(lowCell)
            }
            else if x > lowest_Data_X,x < highest_Data_X{
                let midCell = data.dataLineArray[data_Y].dataCellArray[x]
                midCell.changeType(newType: .mid)
                cellArray.append(midCell)
            }
            else if x == highest_Data_X{
                let upperCell = data.dataLineArray[data_Y].dataCellArray[x]
                upperCell.changeType(newType: .end)
                cellArray.append(upperCell)
            }
        }
    }
        
    }
    write_Note_Data(cellArrayParam: cellArray)
    }
    
    func note_Collection_Highlight_Handler(noteParam:Note?){
        if noteParam == nil {
            if let lclCurrHighlighted = currentHighlightedNote{
                lclCurrHighlighted.highlighted = false
                currentHighlightedNote = nil
            }
        }
        else if let lclNoteParam = noteParam{
                currentHighlightedNote = lclNoteParam
                lclNoteParam.highlighted = true
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
    
    public func deleteNote(){
        if let lclCurrHighlighted = currentHighlightedNote{
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
