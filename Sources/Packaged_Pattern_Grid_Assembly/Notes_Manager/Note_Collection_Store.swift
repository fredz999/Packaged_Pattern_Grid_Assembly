//
//  File.swift
//  
//
//  Created by Jon on 19/11/2022.
//

import Foundation
import SwiftUI

public class Note_Collection {
    
    var p_ExternalNote_Responder_Array : [P_ExternalNote_Responder] = []
    
    public init(parentCentral_State_Param:Central_State){
        parentCentralState = parentCentral_State_Param
    }

    var parentCentralState : Central_State

    var additional_Selected_Notes = Set<Note>()

    
    func access_Additional_Selected_Notes(inputSet:Set<Note>?){
        if inputSet == nil {
            if additional_Selected_Notes.count > 0 {
                for note in additional_Selected_Notes {
                    note.highlighted = false
                }
                additional_Selected_Notes.removeAll()
            }
        }
        else if let lclInputSet = inputSet {
            for note in lclInputSet {note.highlighted = true}
            additional_Selected_Notes = lclInputSet
        }
    }
    
    
    
    // 1: func to add a nil note with an additional arg stating if its single or part of a multi
    // 2: the single selected might have to become note_Currently_Under_Cursor and the multis - additional_Selected_Notes
    // 3: movement only becomes available when there is a note under the cursor
    // 4: movement out of an already multiselected note .....shouuuuuuuldnt deselect it
    // 5: multi select in a blank area should desselect all notes
    


    var currentHighlighted_Single_Note : Note?{
        willSet {
            if let lclCurr = currentHighlighted_Single_Note {
                if let lclNewVal = newValue {
                    if lclNewVal.id != lclCurr.id {
                        lclCurr.highlighted = false
                    }
                }
                else if newValue == nil {
                    lclCurr.highlighted = false
                    access_Additional_Selected_Notes(inputSet: nil)
                }
            }
        }
        didSet {
            if let lclCurr = currentHighlighted_Single_Note {
                lclCurr.highlighted = true
            }
        }
    }
    
    func note_Collection_Highlight_Handler(noteParam:Note?){
        if noteParam == nil {
            currentHighlighted_Single_Note = nil
            if parentCentralState.a_Note_Is_Highlighted == true{parentCentralState.a_Note_Is_Highlighted = false}
        }
        else if let lclNoteParam = noteParam {
            currentHighlighted_Single_Note = lclNoteParam
            if parentCentralState.a_Note_Is_Highlighted == false{parentCentralState.a_Note_Is_Highlighted = true}
        }
    }

    public var noteArray : [Note] = []{
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
    
    public func swapArray(newNoteArrayParam: [Note]){
        noteArray = newNoteArrayParam
    }

    public func addExternalNoteResponder(newNoteResponder:P_ExternalNote_Responder){
        p_ExternalNote_Responder_Array.append(newNoteResponder)
    }
    
    func react_To_Mode_Change(){
        if let lclCurrHighlighted = currentHighlighted_Single_Note {
            for cell in lclCurrHighlighted.dataCellArray {
                if let lcl_Data_Vals = cell.currentConnectedDataVals {
                    lcl_Data_Vals.check_Highlighted()
                }
            }
        }
//        if selected_Notes_Array.count > 0{
//            for nute in selected_Notes_Array {
//                for dataCell in nute.dataCellArray {
//                    if let lcl_Data_Vals = dataCell.currentConnectedDataVals {
//                        lcl_Data_Vals.check_Highlighted()
//                    }
//                }
//            }
//        }
 
    }
    
    func write_Note_Data(cellSetParam : Set<Underlying_Data_Cell>){
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
        
        var noteArr = [Underlying_Data_Cell]()
        for index in 0..<startCellSet.count {
            let currStartCell = startCells[index]
            let currEndCell = endCells[index]
            noteArr.append(currStartCell)
            let midSet = midCellSet.filter({$0.dataCell_X_Number > currStartCell.dataCell_X_Number && $0.dataCell_X_Number < currEndCell.dataCell_X_Number})
            let midArr = midSet.sorted(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
            for midCell in midArr {
                noteArr.append(midCell)
            }
            noteArr.append(currEndCell)
        }

        if noteArr.count > 0 {
            let note = Note(cellArray: noteArr, parentParam: self, yParam: noteArr[0].dataCell_Y_Number)
            noteArray.append(note)
            for cell in noteArr {
                cell.note_Im_In = note
            }
        }
    }
    
    public func delete_CurrentHighlighted(){
        if let lclCurrHigh = currentHighlighted_Single_Note {
            
//            if additional_Selected_Notes.contains(lclCurrHigh){
//                additional_Selected_Notes.remove(lclCurrHigh)
//            }
            if let note = additional_Selected_Notes.first(where: {$0.id == lclCurrHigh.id}){
                note.resetCells()
                additional_Selected_Notes.remove(lclCurrHigh)
                    //.removeAll(where: {$0.id == lclCurrHigh.id})
            }
            print("1: additional_Selected_Notes.count",additional_Selected_Notes.count)
            //delete_Note_By_Id(note_Id_Param: lclCurrHigh.id)
            currentHighlighted_Single_Note = nil
            if parentCentralState.a_Note_Is_Highlighted != false{parentCentralState.a_Note_Is_Highlighted = false}
            print("2: additional_Selected_Notes.count",additional_Selected_Notes.count)
        }
    }
    
    func deleteMultipleNotes(){
        //print("start: additional_Selected_Notes.count",additional_Selected_Notes.count)
        if currentHighlighted_Single_Note != nil {
            delete_CurrentHighlighted()
        }
        //print("3: additional_Selected_Notes.count",additional_Selected_Notes.count)
        if additional_Selected_Notes.count > 0 {
            for note in additional_Selected_Notes {
                delete_Note_By_Id(note_Id_Param: note.id)
            }
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
