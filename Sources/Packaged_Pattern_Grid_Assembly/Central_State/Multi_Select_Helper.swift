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
    
    var mode_Active: Bool = false
    
    func activate_Mode(activationCell: Underlying_Data_Cell?) {
        if mode_Active == false{mode_Active = true}
    }
    
    
    //currentHighlightedNote in note collection has to be re-worked
    // to support multiple selection
    
    func deactivate_Mode() {
        if mode_Active == true {
            mode_Active = false
            if let lclNoteCollection = parentCentralState.currentNoteCollection{
//                for note in lclNoteCollection.selected_Notes_Array{
//                   note.resetCells()
//                }
//                lclNoteCollection.selected_Notes_Array.removeAll()
            }
            
        }
    }
    
    func multiSelect(note_Id_Param:UUID){
        if let lclNoteCollection = parentCentralState.currentNoteCollection {
            if let note = lclNoteCollection.noteArray.first(where: {$0.id == note_Id_Param}){
//                lclNoteCollection.note_Collection_Highlight_Handler(noteParam: note)
//                lclNoteCollection.selected_Notes_Array.append(note)
            }
        }
    }
    //func multiSelect(note_Id_Param:UUID){
    
    func multiDelete(){
        //collection  delete_Note_By_Id(note_Id_Param:UUID)
    }
    
    
    init(parentCentral_State_Param:Central_State){
        parentCentralState = parentCentral_State_Param
    }
}
