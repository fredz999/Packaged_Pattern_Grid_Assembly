//
//  Passive_Helper.swift
//  
//
//  Created by Jon on 28/02/2023.
//

import Foundation

class Passive_Helper: P_Selectable_Mode {
    
    var selectableModeId: Int
    
    let dimensions = ComponentDimensions.StaticDimensions
        
    var mode_Active: Bool = false
    
    func activate_Mode(activationCell: Underlying_Data_Cell?) {
        if mode_Active == false{mode_Active=true}
    }
    
    func generateModeDescriptorString()->String{
        return "Passive Mode"
    }
    
    func deactivate_Mode() {
        if mode_Active == true{mode_Active=false}
    }

    var parentCentralState : Central_State
    
    init(parentCentral_State_Param:Central_State,selectableModeIdParam:Int){
        selectableModeId = selectableModeIdParam
        parentCentralState = parentCentral_State_Param
    }
    
    func respond_To_Cursor_Movement(cell_Data_X:Int,cell_Data_Y:Int){

        if let lclNoteImIn = parentCentralState.currentData.note_Im_In {

            if let lclNoteCollection = parentCentralState.currentNoteCollection {
                lclNoteCollection.note_Collection_Highlight_Handler(noteParam: lclNoteImIn)
            }

        }
        else if parentCentralState.currentData.note_Im_In == nil {
            parentCentralState.currentNoteCollection?.note_Collection_Highlight_Handler(noteParam: nil)
        }
        
    }

    func test_For_Write_Lock(){
//            if let cursorZero = passive_Cursor_Set.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
//
//                if cursorZero.dataCell_X_Number == 0 {
//                    if parentCentralState.a_Note_Is_Highlighted == true {
//                        if parentCentralState.note_Write_Locked == false {
//                            parentCentralState.note_Write_Locked = true
//                        }
//                    }
//                    else if parentCentralState.a_Note_Is_Highlighted == false {
//                        if parentCentralState.note_Write_Locked == true {
//                            parentCentralState.note_Write_Locked = false
//                        }
//                    }
//                }
//                else if cursorZero.dataCell_X_Number == dimensions.dataGrid_X_Unit_Count-1{
//                    if parentCentralState.a_Note_Is_Highlighted == true {
//                        if parentCentralState.note_Write_Locked == false {
//                            parentCentralState.note_Write_Locked = true
//                        }
//                    }
//                    else if parentCentralState.a_Note_Is_Highlighted == false {
//                        if parentCentralState.note_Write_Locked == true {
//                            parentCentralState.note_Write_Locked = false
//                        }
//                    }
//                }
//                if cursorZero.dataCell_X_Number > 0 && cursorZero.dataCell_X_Number < dimensions.dataGrid_X_Unit_Count-1{
//                    let write_Block_Set = Central_State.Static_Central_State.currLineSet.filter({$0.dataCell_X_Number == cursorZero.dataCell_X_Number+1
//                        || $0.dataCell_X_Number == cursorZero.dataCell_X_Number-1})
//
//                    var write_Getting_Blocked : Bool = true
//
//                    for cell in write_Block_Set{
//                        if cell.note_Im_In == nil{
//                            if write_Getting_Blocked == true{write_Getting_Blocked = false}
//                        }
//                    }
//                    if write_Getting_Blocked == true{
//                        if parentCentralState.note_Write_Locked == false{
//                             parentCentralState.note_Write_Locked = true
//                        }
//                    }
//                    else if write_Getting_Blocked == false {
//                        if parentCentralState.note_Write_Locked == true {
//                            parentCentralState.note_Write_Locked = false
//                        }
//                    }
//                }
//            }
        }
    
    
}
