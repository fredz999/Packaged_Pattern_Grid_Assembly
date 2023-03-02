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
    
    let centralStateRef = Central_State.Static_Central_State
    
    var currentHighlightedNote : Note?{
        willSet{
            if let lclCurr = currentHighlightedNote,let lclNewVal = newValue{
                if lclNewVal.id != lclCurr.id {
                    lclCurr.note_Highlight_Type = .UnSelected
                }
            }
        }
    }
    
    func note_Collection_Highlight_Handler(noteParam:Note?,highlightType:E_HighlightType){
        
        //print("highlightType: ",highlightType.rawValue)
        
        if noteParam == nil {
            if let lclCurrHighlighted = currentHighlightedNote {
                lclCurrHighlighted.note_Highlight_Type = highlightType
                currentHighlightedNote = nil
                if centralStateRef.a_Note_Is_Highlighted == true{centralStateRef.a_Note_Is_Highlighted = false}
            }
        }
        
        else if let lclNoteParam = noteParam {
            currentHighlightedNote = lclNoteParam
            lclNoteParam.note_Highlight_Type = highlightType
            if centralStateRef.a_Note_Is_Highlighted == false{centralStateRef.a_Note_Is_Highlighted = true}
        }
        
    }
    
    func write_Note_Data(cellArrayParam : [Underlying_Data_Cell],note_Y_Num:Int){
        let note = Note(cellArray: cellArrayParam, parentParam: self, yParam: note_Y_Num)
        noteArray.append(note)
        for cell in cellArrayParam {
            cell.note_Im_In = note
        }
    }
    
    public func reset_Note_Data_Cells(){
        if let lclCurrHighlighted = currentHighlightedNote {
        lclCurrHighlighted.resetCells()
        noteArray.removeAll(where: {$0.id == lclCurrHighlighted.id})
        currentHighlightedNote = nil
        }
    }
    
    public func reset_Note_Data_Cells(noteParam:Note){
        noteParam.resetCells()
        noteArray.removeAll(where: {$0.id == noteParam.id})
        currentHighlightedNote = nil
    }
    
    public static let Static_Note_Collection = Note_Collection()
    
}

public enum E_HighlightType : String {
    case UnSelected = "UnSelected"
    case Selected_Highlight = "Selected_Highlight"
    case Selected_For_Moving_Highlight = "Selected_For_Moving_Highlight"
    case Selected_For_Resizing_Highlight = "Selected_For_Resizing_Highlight"
}

public protocol P_ExternalNote_Responder {
    func react_To_NoteArrayChange(noteArrayParam: [Note])
}
