//
//  Passive_Helper.swift
//  
//
//  Created by Jon on 28/02/2023.
//

import Foundation

class Passive_Helper: P_Selectable_Mode {
    
    //let dimensions = ComponentDimensions.StaticDimensions
        
    //let note_Collection_Ref = Note_Collection.Static_Note_Collection
    
    var mode_Active: Bool = false

    func test_For_Write_Lock(){
    //        if let cursorZero = passive_Cursor_Set.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
    //
    //            if cursorZero.dataCell_X_Number == 0 {
    //                if Central_State.Static_Central_State.a_Note_Is_Highlighted == true {
    //                    if Central_State.Static_Central_State.note_Write_Locked == false {
    //                        Central_State.Static_Central_State.note_Write_Locked = true
    //                    }
    //                }
    //                else if Central_State.Static_Central_State.a_Note_Is_Highlighted == false {
    //                    if Central_State.Static_Central_State.note_Write_Locked == true {
    //                        Central_State.Static_Central_State.note_Write_Locked = false
    //                    }
    //                }
    //            }
    //            else if cursorZero.dataCell_X_Number == dimensions.dataGrid_X_Unit_Count-1{
    //                if Central_State.Static_Central_State.a_Note_Is_Highlighted == true {
    //                    if Central_State.Static_Central_State.note_Write_Locked == false {
    //                        Central_State.Static_Central_State.note_Write_Locked = true
    //                    }
    //                }
    //                else if Central_State.Static_Central_State.a_Note_Is_Highlighted == false {
    //                    if Central_State.Static_Central_State.note_Write_Locked == true {
    //                        Central_State.Static_Central_State.note_Write_Locked = false
    //                    }
    //                }
    //            }
    //            if cursorZero.dataCell_X_Number > 0 && cursorZero.dataCell_X_Number < dimensions.dataGrid_X_Unit_Count-1{
    //                let write_Block_Set = Central_State.Static_Central_State.currLineSet.filter({$0.dataCell_X_Number == cursorZero.dataCell_X_Number+1
    //                    || $0.dataCell_X_Number == cursorZero.dataCell_X_Number-1})
    //
    //                var write_Getting_Blocked : Bool = true
    //
    //                for cell in write_Block_Set{
    //                    if cell.note_Im_In == nil{
    //                        if write_Getting_Blocked == true{write_Getting_Blocked = false}
    //                    }
    //                }
    //                if write_Getting_Blocked == true{
    //                    if Central_State.Static_Central_State.note_Write_Locked == false{
    //                        Central_State.Static_Central_State.note_Write_Locked = true
    //                    }
    //                }
    //                else if write_Getting_Blocked == false{
    //                    if Central_State.Static_Central_State.note_Write_Locked == true{
    //                        Central_State.Static_Central_State.note_Write_Locked = false
    //                    }
    //                }
    //            }
    //        }
        }
    
    func activate_Mode() {
        if mode_Active == false{mode_Active=true}
    }
    
    func deactivate_Mode() {
        if mode_Active == true{mode_Active=false}
    }


    
//    var passive_Cursor_Set = Set<Underlying_Data_Cell>(){
//        willSet {
//            let delta = passive_Cursor_Set.symmetricDifference(newValue)
//            for cell in delta {
//                cell.handleVisibleStateChange(type: .deActivate_Passive_Cursor_Set)
//            }
//        }
//        didSet {
//            if Central_State.Static_Central_State.currentPatternMode == .passive_Mode {
//                var nillableNote : Note? = nil
//                for cell in passive_Cursor_Set {
//                    cell.handleVisibleStateChange(type: .activate_Passive_Cursor_Set)
//                    if let lclNote = cell.note_Im_In {
//                        nillableNote = lclNote
//                    }
//                }
//
//                test_For_Write_Lock()
//
//                if let lclNoteCollection = Central_State.Static_Central_State.note_Collection_Ref {
//                    if let lclNillableNote = nillableNote {
//                        lclNoteCollection.note_Collection_Highlight_Handler(noteParam: lclNillableNote)
//                    }
//                    else if nillableNote == nil {
//                        lclNoteCollection.note_Collection_Highlight_Handler(noteParam: nil)
//                    }
//                }
//
//            }
//        }
//    }
    
    
    
//    func process_Passive_Cursor_Position() {
//        if dimensions.patternTimingConfiguration == .fourFour {
//        passive_Cursor_Set = Central_State.Static_Central_State.currLineSet.filter({$0.four_Four_Half_Cell_Index == Central_State.Static_Central_State.currentData.four_Four_Half_Cell_Index})
//        }
//        else if dimensions.patternTimingConfiguration == .sixEight {
//        passive_Cursor_Set = Central_State.Static_Central_State.currLineSet.filter({$0.six_Eight_Half_Cell_Index == Central_State.Static_Central_State.currentData.six_Eight_Half_Cell_Index})
//        }
//    }
    
//    func nil_passive_Cursor_Set(){
//        if passive_Cursor_Set.count > 0 {
//            for cell in passive_Cursor_Set {
//                cell.handleVisibleStateChange(type: .deActivate_Passive_Cursor_Set)
//            }
//            passive_Cursor_Set.removeAll()
//        }
//    }
    
}
