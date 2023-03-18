//
//  Multi_Select_Helper.swift
//  
//
//  Created by Jon on 14/03/2023.
//

import Foundation
import SwiftUI

//P_Selectable_Mode
class Multi_Select_Helper : P_Selectable_Mode {
    
    var parentCentralState : Central_State
    
    var snapshot_Multi_Select_Cursor_X : Int?
    
    var snapshot_Multi_Select_Cursor_Y : Int?
    
    var mode_Active: Bool = false
    
    func activate_Mode(activationCell: Underlying_Data_Cell?) {
        if mode_Active == false {
            mode_Active = true
            if let lclNoteCollection = parentCentralState.currentNoteCollection {
                lclNoteCollection.access_Additional_Selected_Notes(inputSet: nil)
            }
            if let lclActivationCell = activationCell{
                snapshot_Multi_Select_Cursor_X = lclActivationCell.dataCell_X_Number
                snapshot_Multi_Select_Cursor_Y = lclActivationCell.dataCell_Y_Number
            }
        }
    }

    func deactivate_Mode() {
        if mode_Active == true {
            mode_Active = false

            // no..... its if they arent fully selected
            if multi_Selected_Notes.count > 0 {
                semi_To_Full_Select()
            }
            
            // if the select area contains NO note squares it removes all multi selected
            
            potential_MultiSelect_Background_Set.removeAll()
            snapshot_Multi_Select_Cursor_X = nil
            snapshot_Multi_Select_Cursor_X = nil
        }

    }
    
    func semi_To_Full_Select(){
 
        for note in multi_Selected_Notes {
            if note.note_Is_MultiSelected == true {
                note.note_Is_MultiSelected = false
            }
        }
        if let lclNoteCollection = parentCentralState.currentNoteCollection {
            lclNoteCollection.access_Additional_Selected_Notes(inputSet: multi_Selected_Notes)
        }
        if multi_Selected_Notes.count > 0{multi_Selected_Notes.removeAll()}
    }
    
    var multi_Selected_Notes = Set<Note>()
//    {
//        willSet {
//            // de highlight the notes in the array
//            // empty parentCentralState.currentNoteCollection.additional_Selected_Notes
//            print("multi_Selected_Notes new will be count: ",newValue.count)
//        }
//        didSet {
//            print("multi_Selected_Notes count: ",multi_Selected_Notes.count)
//        }
//    }
    
    init(parentCentral_State_Param:Central_State){
        parentCentralState = parentCentral_State_Param
    }

    var potential_MultiSelect_Background_Set = Set<Underlying_Data_Cell>(){
        willSet {
            let delta = potential_MultiSelect_Background_Set.symmetricDifference(newValue)
            for cell in delta {
                cell.handleVisibleStateChange(type: .deActivate_Multiselect_Background_Set)
            }
        }
        didSet {
            for cell in potential_MultiSelect_Background_Set {
                cell.handleVisibleStateChange(type : .activate_Multiselect_Background_Set)
            }
            analyzeMultiSelectSet()
        }
    }
    
    func analyzeMultiSelectSet(){

        let noteCells = potential_MultiSelect_Background_Set.filter{$0.note_Im_In != nil}
        
        var nuutez = Set<Note>()
        
        for cell in noteCells {
            if let lclNote = cell.note_Im_In {
                nuutez.insert(lclNote)
            }
        }

        if let noteCollection = parentCentralState.currentNoteCollection {
            
            let fullNoteSet = Set(noteCollection.noteArray)
            for note in nuutez {
                if note.note_Is_MultiSelected == false{note.note_Is_MultiSelected = true}
            }

            let notSelectedSet = fullNoteSet.subtracting(nuutez)
            for note in notSelectedSet{
                if note.note_Is_MultiSelected == true{note.note_Is_MultiSelected = false}
            }
            
            multi_Selected_Notes = nuutez
            
        }

    }
    
    func area_Select_Handler(){
        if let lclSnapshot_X = snapshot_Multi_Select_Cursor_X, let lclSnapshot_Y = snapshot_Multi_Select_Cursor_Y
        {
            if lclSnapshot_X <= parentCentralState.curr_Data_Pos_X
            && lclSnapshot_Y <= parentCentralState.curr_Data_Pos_Y {
                
                potential_MultiSelect_Background_Set = parentCentralState.data_Grid.grid_Of_Cells_Set.filter {
                    $0.dataCell_X_Number <= parentCentralState.curr_Data_Pos_X
                    && $0.dataCell_Y_Number <= parentCentralState.curr_Data_Pos_Y
                    && $0.dataCell_X_Number >= lclSnapshot_X
                    && $0.dataCell_Y_Number >= lclSnapshot_Y
                }
                
            }
            
            else if lclSnapshot_X <= parentCentralState.curr_Data_Pos_X
            && lclSnapshot_Y >= parentCentralState.curr_Data_Pos_Y{
                
                potential_MultiSelect_Background_Set = parentCentralState.data_Grid.grid_Of_Cells_Set.filter {
                    $0.dataCell_X_Number <= parentCentralState.curr_Data_Pos_X
                    && $0.dataCell_Y_Number >= parentCentralState.curr_Data_Pos_Y
                    && $0.dataCell_X_Number >= lclSnapshot_X
                    && $0.dataCell_Y_Number <= lclSnapshot_Y
                }
                
            }

            else if lclSnapshot_X >= parentCentralState.curr_Data_Pos_X
            && lclSnapshot_Y <= parentCentralState.curr_Data_Pos_Y{
                
                potential_MultiSelect_Background_Set = parentCentralState.data_Grid.grid_Of_Cells_Set.filter {
                    $0.dataCell_X_Number >= parentCentralState.curr_Data_Pos_X
                    && $0.dataCell_Y_Number <= parentCentralState.curr_Data_Pos_Y
                    && $0.dataCell_X_Number <= lclSnapshot_X
                    && $0.dataCell_Y_Number >= lclSnapshot_Y
                }
                
            }

            else if lclSnapshot_X >= parentCentralState.curr_Data_Pos_X
            && lclSnapshot_Y >= parentCentralState.curr_Data_Pos_Y{
                
                potential_MultiSelect_Background_Set = parentCentralState.data_Grid.grid_Of_Cells_Set.filter {
                    $0.dataCell_X_Number >= parentCentralState.curr_Data_Pos_X
                    && $0.dataCell_Y_Number >= parentCentralState.curr_Data_Pos_Y
                    && $0.dataCell_X_Number <= lclSnapshot_X
                    && $0.dataCell_Y_Number <= lclSnapshot_Y
                }
                
            }
        }
    }
    
}
