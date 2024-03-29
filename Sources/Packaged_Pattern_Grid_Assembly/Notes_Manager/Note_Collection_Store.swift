//
//  File.swift
//  
//
//  Created by Jon on 19/11/2022.
//

import Foundation
import SwiftUI

public class Note_Collection : ObservableObject {
    
    var p_ExternalNote_Responder_Array : [P_ExternalNote_Responder] = []
    
    public init(parentCentral_State_Param:Central_State){
        parentCentralState = parentCentral_State_Param
    }

    var parentCentralState : Central_State

    var note_Currently_Under_Cursor : Note?{
        willSet{
            if let lclCurrSelecNote = note_Currently_Under_Cursor{
                lclCurrSelecNote.highlighted = false
            }
        }
        didSet{
            if let lclCurrSelecNote = note_Currently_Under_Cursor{
                lclCurrSelecNote.highlighted = true
            }
        }
    }
    
    func note_Collection_Highlight_Handler(noteParam:Note?){
        if noteParam == nil {
            note_Currently_Under_Cursor = nil
            for note in noteArray{
                if note.highlighted == true{note.highlighted = false}
            }
            if parentCentralState.a_Note_Is_Highlighted == true{parentCentralState.a_Note_Is_Highlighted = false}
        }
        else if let lclNoteParam = noteParam {
            note_Currently_Under_Cursor = lclNoteParam
            if parentCentralState.a_Note_Is_Highlighted == false{parentCentralState.a_Note_Is_Highlighted = true}
        }
    }

    @Published public var noteArray : [Note] = []{
        didSet {
            if p_ExternalNote_Responder_Array.count > 0 {
                for i in 0..<p_ExternalNote_Responder_Array.count {
                    p_ExternalNote_Responder_Array[i].react_To_NoteArrayChange(noteArrayParam: noteArray)
                }
            }
            if noteArray.count == 0{
                if parentCentralState.there_Is_A_Note_In_The_First_Place == true{parentCentralState.there_Is_A_Note_In_The_First_Place = false}
            }
            else if noteArray.count > 0{
                if parentCentralState.there_Is_A_Note_In_The_First_Place == false{parentCentralState.there_Is_A_Note_In_The_First_Place = true}
            }
        }
    }
    
    func deHighlightCollection(){
        for note in noteArray{
            if note.highlighted == true {
                note.highlighted = false
            }
        }
    }
    
    public func swapArray(newNoteArrayParam: [Note]){
        noteArray = newNoteArrayParam
    }

    public func addExternalNoteResponder(newNoteResponder:P_ExternalNote_Responder){
        p_ExternalNote_Responder_Array.append(newNoteResponder)
    }
    
    func react_To_Mode_Change(){
        if let lclCurrHighlighted = note_Currently_Under_Cursor {
            //if let lclModifiable_Note_Data = lclCurrHighlighted.modifiable_Note_Data{
            if let lclModifiableNoteData = lclCurrHighlighted.modifiable_Note_Data{
                    for cell in lclModifiableNoteData.dataCellArray {
                        if let lcl_Data_Vals = cell.currentConnectedDataVals {
                            lcl_Data_Vals.check_Highlighted()
                        }
                    }
                }
            //}
        }
    }
    
    func write_Note_Data(cellSetParam : Set<Underlying_Data_Cell>,highlightAfterWrite : Bool){
        
        var startCellSet = Set<Underlying_Data_Cell>()
        if let minX = cellSetParam.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
            startCellSet.insert(minX)
        }
        var endCellSet = Set<Underlying_Data_Cell>()
        if let maxX = cellSetParam.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
            endCellSet.insert(maxX)
        }
        let midCellSet = cellSetParam.subtracting(startCellSet.union(endCellSet))
        for cell in startCellSet{cell.change_Type(newType: .start_Note)}
        for cell in midCellSet{cell.change_Type(newType: .mid_Note)}
        for cell in endCellSet{cell.change_Type(newType: .end_Note)}
        
        let startCells = startCellSet.sorted(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
        let endCells = endCellSet.sorted(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
        
        var local_Cell_Array = [Underlying_Data_Cell]()
        
        for index in 0..<startCellSet.count {
            
            let currStartCell = startCells[index]
            let currEndCell = endCells[index]
            local_Cell_Array.append(currStartCell)
            let midSet = midCellSet.filter({$0.dataCell_X_Number > currStartCell.dataCell_X_Number && $0.dataCell_X_Number < currEndCell.dataCell_X_Number})
            let midArr = midSet.sorted(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
            for midCell in midArr {
                local_Cell_Array.append(midCell)
            }
            local_Cell_Array.append(currEndCell)
        }
        if local_Cell_Array.count > 0 {
            let line = parentCentralState.data_Grid.dataLineArray[local_Cell_Array[0].parentLine.line_Y_Num]
            let note = Note(cellArray: local_Cell_Array, parentParam: self, yParam: local_Cell_Array[0].parentLine.line_Y_Num, containingLineParam: line)
            noteArray.append(note)
            if highlightAfterWrite == true{note.highlighted = true}
            for cell in local_Cell_Array {
                cell.note_Im_In = note
                cell.alterCursorState(thisCellInNote: true, cell_In_Moving_Prohibition: nil, cell_In_Clashing_Prohibition: nil, cursorMoveMode: nil)
            }
        }
    }
    
    func deleteSelectedNotes(){
        for note in noteArray{
            if note.highlighted == true{
                delete_Note_By_Id(note_Id_Param: note.id)
            }
        }
    }
    
    func deleteAllNotes(){
        for note in noteArray{
            delete_Note_By_Id(note_Id_Param: note.id)
        }
    }
    
    public func delete_Note_By_Id(note_Id_Param:UUID){
        if let note = noteArray.first(where: {$0.id == note_Id_Param}){
            note.resetCells()
            noteArray.removeAll(where: {$0.id == note_Id_Param})
        }
    }

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
