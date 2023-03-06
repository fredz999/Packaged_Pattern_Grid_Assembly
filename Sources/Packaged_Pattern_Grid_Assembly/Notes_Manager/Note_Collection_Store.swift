//
//  File.swift
//  
//
//  Created by Jon on 19/11/2022.
//

import Foundation
import SwiftUI

public class Note_Collection {
    
    var currentHighlightedNote : Note?{
        willSet{
            if let lclCurr = currentHighlightedNote{
                if let lclNewVal = newValue{
                    if lclNewVal.id != lclCurr.id {
                        lclCurr.highlighted = false
                        centralStateRef.a_Note_Is_Highlighted = false
                    }
                }
                else if newValue == nil{
                    lclCurr.highlighted = false
                    centralStateRef.a_Note_Is_Highlighted = false
                }
            }
        }
        didSet{
            if let lclCurr = currentHighlightedNote {
                lclCurr.highlighted = true
                centralStateRef.a_Note_Is_Highlighted = true
            }
        }
    }
    
    func note_Collection_Highlight_Handler(noteParam:Note?){
        if noteParam == nil {
            currentHighlightedNote = nil
            if centralStateRef.a_Note_Is_Highlighted == true{centralStateRef.a_Note_Is_Highlighted = false}
        }
        else if let lclNoteParam = noteParam {
            currentHighlightedNote = lclNoteParam
            if centralStateRef.a_Note_Is_Highlighted == false{centralStateRef.a_Note_Is_Highlighted = true}
        }
    }
    
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
            if noteArray.count == 0{
                centralStateRef.setPatternMode(patternModeParam: .passive)
                centralStateRef.pattern_Has_A_Note = false
            }
            else if noteArray.count > 0{
                centralStateRef.pattern_Has_A_Note = true
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
    
    func react_To_Mode_Change(){
        if let currHighlightedNote = currentHighlightedNote{
            for dataCell in currHighlightedNote.dataCellArray {
                if let lcl_Data_Vals = dataCell.currentConnectedDataVals {
                    lcl_Data_Vals.check_Highlighted()
                }
            }
        }
    }
    
    func write_Note_Data(cellArrayParam : [Underlying_Data_Cell],note_Y_Num:Int){
        let note = Note(cellArray: cellArrayParam, parentParam: self, yParam: note_Y_Num)
        noteArray.append(note)
        for cell in cellArrayParam {
            cell.note_Im_In = note
        }
    }
    
    // write a note writing func taking a single cell set as an arg
    
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

        if noteArr.count > 0{
            let note = Note(cellArray: noteArr, parentParam: self, yParam: noteArr[0].dataCell_Y_Number)
            noteArray.append(note)
            for cell in noteArr {
                cell.note_Im_In = note
            }
        }
        
    }
    
    public func delete_Current_Highlighted_Note(){
        
        if let lclCurrHighlighted = currentHighlightedNote {
        print("delete_Current_Highlighted_Note() lclCurrHighlighted = currentHighlightedNote")
            
        lclCurrHighlighted.resetCells()
        noteArray.removeAll(where: {$0.id == lclCurrHighlighted.id})
        currentHighlightedNote = nil
        if centralStateRef.a_Note_Is_Highlighted != false{centralStateRef.a_Note_Is_Highlighted = false}
        }
        
    }
    
    public func delete_Current_Highlighted_Note(note_Id_Param:UUID){
        
        print("delete_Current_Highlighted_Note(note_Id_Param:UUID)")
        
        if let note = noteArray.first(where: {$0.id == note_Id_Param}){
            note.resetCells()
            noteArray.removeAll(where: {$0.id == note_Id_Param})
            currentHighlightedNote = nil
            if centralStateRef.a_Note_Is_Highlighted != false{centralStateRef.a_Note_Is_Highlighted = false}
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
