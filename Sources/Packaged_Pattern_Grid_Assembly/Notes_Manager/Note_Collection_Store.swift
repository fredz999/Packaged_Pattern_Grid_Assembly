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
    
    
    
    
    
    
    // this needs replaced?.... current highlighted notes?
    // use accessor function
//    var currentHighlightedNote : Note?{
//        willSet {
//            if let lclCurr = currentHighlightedNote {
//                if let lclNewVal = newValue {
//                    if lclNewVal.id != lclCurr.id {
//                        lclCurr.highlighted = false
//                    }
//                }
//                else if newValue == nil {
//                    lclCurr.highlighted = false
//                }
//            }
//        }
//        didSet {
//            if let lclCurr = currentHighlightedNote {
//                lclCurr.highlighted = true
//            }
//        }
//    }
    
    //write an accessor function to this array and then limit the bunber of members it can have to one
    var maxSelectedNotes : Int = 1
    //var selected_Notes_Set : Set<Note> = Set<Note>()
    var selected_Notes_Array : [Note] = []
    
    func accessSelected_Notes_Array(currentHighlightedNote : Note?){
        
        if let lclCurrentHighlightedNote = currentHighlightedNote {
            
            lclCurrentHighlightedNote.highlighted = true
            //selected_Notes_Set.insert(lclCurrentHighlightedNote)
            
            if selected_Notes_Array.contains(lclCurrentHighlightedNote) == false{
                if selected_Notes_Array.count < 2{
                    selected_Notes_Array.insert(lclCurrentHighlightedNote, at: 0)
                }
                else if selected_Notes_Array.count == 2{
                    selected_Notes_Array[1].highlighted = false
                    selected_Notes_Array.remove(at: 1)
                    selected_Notes_Array.insert(lclCurrentHighlightedNote, at: 0)
                }
            }
            
//            if selected_Notes_Array.count == 2{
//                selected_Notes_Array.remove(at: 0)
//            }
            //selected_Notes_Array.insert(lclCurrentHighlightedNote, at: 0)
            
            
//            if selected_Notes_Array.count == 1 {
//                selected_Notes_Array[0].highlighted = true
//            }
//            else if selected_Notes_Array.count == 2 {
//                selected_Notes_Array[0].highlighted = true
//                selected_Notes_Array[1].highlighted = false
//                selected_Notes_Array.remove(at: 1)
//            }
        }
        
        
//        if let lclCurrentHighlightedNote = currentHighlightedNote {
//            lclCurrentHighlightedNote.highlighted = true
//            let lastAvailableElement = maxSelectedNotes-1
//
//            if selected_Notes_Array.count == lastAvailableElement {
//                selected_Notes_Array.insert(lclCurrentHighlightedNote, at: 0)
//                selected_Notes_Array[lastAvailableElement].highlighted = false
//                selected_Notes_Array.remove(at: lastAvailableElement)
//            }
//            else if selected_Notes_Array.count < lastAvailableElement {
//                selected_Notes_Array.insert(lclCurrentHighlightedNote, at: 0)
//            }
//
//            selected_Notes_Array.insert(lclCurrentHighlightedNote, at: 0)
//
//        }
//        else if currentHighlightedNote == nil {
//            if selected_Notes_Array.count > 0 {
//                for note in selected_Notes_Array {
//                    note.highlighted = false
//                }
//                selected_Notes_Array.removeAll()
//            }
//        }
        var streeng = ""
        for note in selected_Notes_Array{
            streeng.append(note.id.description + ", ")
        }
        print("streeng........: ",streeng)

    }
    
    func note_Collection_Highlight_Handler(noteParam:Note?){
        if noteParam == nil {
            //currentHighlightedNote = nil
            //selected_Notes_Set.removeAll()
            if parentCentralState.a_Note_Is_Highlighted == true{parentCentralState.a_Note_Is_Highlighted = false}
        }
        else if let lclNoteParam = noteParam {
            //currentHighlightedNote = lclNoteParam
            accessSelected_Notes_Array(currentHighlightedNote: lclNoteParam)
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
        if selected_Notes_Array.count > 0{
            for nute in selected_Notes_Array {
                for dataCell in nute.dataCellArray {
                    if let lcl_Data_Vals = dataCell.currentConnectedDataVals {
                        lcl_Data_Vals.check_Highlighted()
                    }
                }
            }
        }
 
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
//        if let lclCurrHigh = currentHighlightedNote {
//            delete_Note_By_Id(note_Id_Param: lclCurrHigh.id)
//        }
        if selected_Notes_Array.count > 0{
            for nute in selected_Notes_Array{
                delete_Note_By_Id(note_Id_Param: nute.id)
            }
        }
    }
    
    public func delete_Note_By_Id(note_Id_Param:UUID){
        if let note = noteArray.first(where: {$0.id == note_Id_Param}){
            note.resetCells()
            noteArray.removeAll(where: {$0.id == note_Id_Param})
            //currentHighlightedNote = nil
            accessSelected_Notes_Array(currentHighlightedNote: nil)
            if parentCentralState.a_Note_Is_Highlighted != false{parentCentralState.a_Note_Is_Highlighted = false}
        }
    }
    
//    public func reset_Note_Data_Cells(noteParam:Note){
//        noteParam.resetCells()
//        noteArray.removeAll(where: {$0.id == noteParam.id})
//        currentHighlightedNote = nil
//    }

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







//    func write_Note_Data(cellArrayParam : [Underlying_Data_Cell],note_Y_Num:Int){
//        let note = Note(cellArray: cellArrayParam, parentParam: self, yParam: note_Y_Num)
//        noteArray.append(note)
//        for cell in cellArrayParam {
//            cell.note_Im_In = note
//        }
//    }
    
    // write a note writing func taking a single cell set as an arg


//    public func delete_Current_Highlighted_Note(){
//
//        if let lclCurrHighlighted = currentHighlightedNote {
//        lclCurrHighlighted.resetCells()
//        noteArray.removeAll(where: {$0.id == lclCurrHighlighted.id})
//        currentHighlightedNote = nil
//        if centralStateRef.a_Note_Is_Highlighted != false{centralStateRef.a_Note_Is_Highlighted = false}
//        }
//    }
