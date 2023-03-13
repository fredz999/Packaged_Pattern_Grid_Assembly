//
//  File.swift
//  
//
//  Created by Jon on 17/11/2022.
//

import Foundation
import SwiftUI

public class Central_State : ObservableObject {

    
    @Published var edit_Layer_Visible : Bool = true
    
    //@Published public var a_Note_Is_Highlighted : Bool = false
    
    // need to have a note is highlighted for the initial grab
    // but i need to be able to see the button to drop the note someplace
    //@Published public var pattern_Has_A_Note : Bool = false
    
    //@Published public var note_Write_Locked : Bool = false
    
    @Published public var write_Needs_Held_Down : Bool = false
    
    @Published public var timing_Sig_Change_Possible : Bool = true
    
    @Published public var currentPatternMode : E_PatternModeType = .no_Note_Collection
    
    @Published public var currentNoteCollection : Note_Collection?
    
    @Published public var a_Note_Is_Highlighted : Bool = false
    
    public let data_Grid : Underlying_Data_Grid
    let dimensions = ComponentDimensions.StaticDimensions
    let colors = ComponentColors.StaticColors
    //==================================================
    var v_Slider_Ref : Cursor_Vertical_Slider_Store?
    public var h_Slider_Ref : Cursor_Horizontal_Slider_Store?
    public var central_Grid_Store : Central_Grid_Store?
    //==================================================
    var lower_Bracket_Number : Int = 0
    var higher_Bracket_Number : Int = 0
    //==================================================
    
    var move_Helper : Move_Helper?
    var delete_Helper : Delete_Helper?
    var passive_Helper : Passive_Helper?
    var writeNote_Helper : WriteNote_Helper?

    public init(dataGridParam:Underlying_Data_Grid){
        data_Grid = dataGridParam
        currentData = data_Grid.dataLineArray[0].dataCellArray[0]
        curr_Data_Pos_X = 0
        curr_Data_Pos_Y = 0
        let currLine = data_Grid.dataLineArray[curr_Data_Pos_Y]
        
        for cell in currLine.dataCellArray {
        currLineSet.insert(cell)
        }
        
        move_Helper = Move_Helper(parentCentral_State_Param: self)
        delete_Helper = Delete_Helper(parentCentral_State_Param: self)
        passive_Helper = Passive_Helper(parentCentral_State_Param: self)
        writeNote_Helper = WriteNote_Helper(parentCentral_State_Param: self)
        
        centralState_Data_Evaluation()
        
    }

    public func setCurrentNoteCollection(noteCollectionParam : Note_Collection){
        currentNoteCollection = noteCollectionParam
        currentPatternMode = .passive_Mode
    }
    
    public func setPatternMode(patternModeParam : E_PatternModeType){
        if let lclPassiveHelper = passive_Helper,let lclWriteNote_Helper = writeNote_Helper
            ,let lclDelete_Helper = delete_Helper,let lclMoveHelper = move_Helper {
            
            if patternModeParam == .passive_Mode {
                lclMoveHelper.deactivate_Mode()
                lclDelete_Helper.deactivate_Mode()
                lclWriteNote_Helper.deactivate_Mode()
                lclPassiveHelper.activate_Mode(activationCell: nil)
                currentPatternMode = .passive_Mode
            }
            else if patternModeParam == .write_Mode {
                lclMoveHelper.deactivate_Mode()
                lclDelete_Helper.deactivate_Mode()
                lclPassiveHelper.deactivate_Mode()
                lclWriteNote_Helper.activate_Mode(activationCell: currentData)
                currentPatternMode = .write_Mode
            }
            else if patternModeParam == .delete_Mode {
                lclMoveHelper.deactivate_Mode()
                lclPassiveHelper.deactivate_Mode()
                lclWriteNote_Helper.deactivate_Mode()
                lclDelete_Helper.activate_Mode(activationCell: currentData)
                currentPatternMode = .delete_Mode
            }
            else if patternModeParam == .move_Mode {
                lclDelete_Helper.deactivate_Mode()
                lclPassiveHelper.deactivate_Mode()
                lclWriteNote_Helper.deactivate_Mode()

                // this has to be a note
                lclMoveHelper.activate_Mode(activationCell: nil)
                
                currentPatternMode = .move_Mode
            }
        }
    }
    
    func centralState_Data_Evaluation(){

        if dimensions.patternTimingConfiguration == .fourFour {
            currentData = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentFourFourDataIndex]
            curr_Data_Pos_X = dimensions.currentFourFourDataIndex
            current_Cursor_Set = currLineSet.filter({$0.four_Four_Half_Cell_Index == currentData.four_Four_Half_Cell_Index})
            
            if currentPatternMode == .passive_Mode {
                if let lclPassiveHelper = passive_Helper{
                    lclPassiveHelper.respond_To_Cursor_Movement(cell_Data_X: curr_Data_Pos_X, cell_Data_Y: curr_Data_Pos_Y)
                }
            }
            else if currentPatternMode == .write_Mode {
                if let lclWriteHelper = writeNote_Helper {
                    lclWriteHelper.establish_Potential_Cells_Set()
                }
            }
            else if currentPatternMode == .move_Mode {
                if let lclMoveHelper = move_Helper {
                    //lclMoveHelper.process_MoveNote_Cursor_Position()
                    lclMoveHelper.movement_With_Note_Selected()
                }
            }
            
            
//            else if currentPatternMode == .delete_Mode {
//                if let lclDeleteHelper = delete_Helper{
//                    //lclDeleteHelper.process_Current_Line(
//                }
//            }
            
        }
        
        else if dimensions.patternTimingConfiguration == .sixEight {
            currentData = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentSixEightDataIndex]
            curr_Data_Pos_X = dimensions.currentSixEightDataIndex
            current_Cursor_Set = currLineSet.filter({$0.six_Eight_Half_Cell_Index == currentData.six_Eight_Half_Cell_Index})
        }
    }
    
    public func change_Write_Needs_Held_Down(){
        if write_Needs_Held_Down == true {
            write_Needs_Held_Down = false
        }
        else if write_Needs_Held_Down == false {
            write_Needs_Held_Down = true
        }
    }

    public func change_Timing_Signature_Central() {
        if timing_Sig_Change_Possible == true {
        if dimensions.patternTimingConfiguration == .sixEight {
            if data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[curr_Data_Pos_X].four_Four_Half_Sub_Index != 0{
                timing_Change_Compensation_Index = curr_Data_Pos_X - data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[curr_Data_Pos_X].four_Four_Half_Sub_Index
            }
        }
        else if dimensions.patternTimingConfiguration == .fourFour {
            if data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[curr_Data_Pos_X].six_Eight_Half_Sub_Index != 0{
                timing_Change_Compensation_Index = curr_Data_Pos_X - data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[curr_Data_Pos_X].six_Eight_Half_Sub_Index
            }
        }
        dimensions.flip_Timing_Signature_Dimensions()
        data_Grid.changeTimingSignature_Data_Level()
        if let lclCompensateIndex = timing_Change_Compensation_Index {
            if let lclHslider = h_Slider_Ref {
                lclHslider.jumpToACell(cellNum: lclCompensateIndex)
            }
            timing_Change_Compensation_Index = nil
        }
        }
//        if let lclPassiveHelper = passive_Helper{
//            lclPassiveHelper.process_Passive_Cursor_Position()
//        }
    }

    var timing_Change_Compensation_Index : Int? = nil

    var currentYCursor_Slider_Position : Int = 0
    
    var curr_Data_Pos_X : Int
    
    var curr_Data_Pos_Y : Int {
        didSet {
            let currLine = data_Grid.dataLineArray[curr_Data_Pos_Y]
            currLineSet.removeAll()
            var newSet = Set<Underlying_Data_Cell>()
            for cell in currLine.dataCellArray{
                newSet.insert(cell)
            }
            currLineSet = newSet
        }
    }
    
    var current_Cursor_Set = Set<Underlying_Data_Cell>(){
        willSet {
            let delta = current_Cursor_Set.symmetricDifference(newValue)
            for cell in delta {
                cell.handleVisibleStateChange(type: cursor_Visible_Change_Type(isActivation: false))
            }
        }
        didSet {
            for cell in current_Cursor_Set {
                cell.handleVisibleStateChange(type: cursor_Visible_Change_Type(isActivation: true))
            }
        }
    }
    
    func cursor_Visible_Change_Type(isActivation:Bool)->E_VisibleStateChangeType {
        var retVal : E_VisibleStateChangeType = .activate_Passive_Cursor_Set
        if isActivation == false {
            retVal = .deActivate_Passive_Cursor_Set
        }
        
        return retVal
    }
    
    func cursor_Slider_Update(){
        curr_Data_Pos_Y = currentYCursor_Slider_Position + lower_Bracket_Number
        centralState_Data_Evaluation()
    }

    var currentData : Underlying_Data_Cell
    {
        willSet {
            if currentPatternMode == .delete_Mode {
                if let lclDeleteHelper = delete_Helper{
                    lclDeleteHelper.process_Current_Line(previousDataCell:currentData,nextDataCell:newValue)
                }
            }
        }
    }
    
    var currLineSet = Set<Underlying_Data_Cell>()
    
    func data_Slider_LowBracket_Update(newLower:Int){
    
    lower_Bracket_Number = newLower
        
    higher_Bracket_Number = Int(dimensions.visualGrid_Y_Unit_Count) + newLower

    if let lcl_Central_Grid_Ref = central_Grid_Store {
    lcl_Central_Grid_Ref.changeDataBracket(newLower: newLower)
    }
    centralState_Data_Evaluation()
    }
    
}

public enum E_PatternModeType : String {
    case write_Mode = "write_Mode"
    case delete_Mode = "delete_Mode"
    case move_Mode = "move_Mode"
    case resize_Mode = "resize_Mode"
    case passive_Mode = "passive_Mode"
    case no_Note_Collection = "no_Note_Collection"
}

public enum E_Note_Movement_Type {
    case leftWard
    case rightWard
    case upward
    case downward
}

class Cell_X_Descriptor : Equatable,Hashable {
    
    static func == (lhs: Cell_X_Descriptor, rhs: Cell_X_Descriptor) -> Bool {
        lhs.x_Position_Int == rhs.x_Position_Int
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x_Position_Int)
    }
    
    var x_Position_Int : Int
    var x_Position_Float : CGFloat
    init(x_Position_Int: Int, x_Position_Float: CGFloat) {
    self.x_Position_Int = x_Position_Int
    self.x_Position_Float = x_Position_Float
    }
}




//        if let currViable = potential_Helper.initial_WriteOnCell {
//            // Y JUMP HANDLER
//            if currViable.dataCell_Y_Number != curr_Data_Pos_Y {
//                potential_Helper.nilPotentialSet()
//                if dimensions.patternTimingConfiguration == .fourFour {
//                    potential_Helper.initial_WriteOnCell = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentFourFourDataIndex]
//                }
//                else if dimensions.patternTimingConfiguration == .sixEight {
//                    potential_Helper.initial_WriteOnCell = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentSixEightDataIndex]
//                }
//            }
//        }
// best place for cursor prolly here

//    public func post_init_Setup(){
//    passive_Helper = Passive_Helper()
//    if let lclPassiveHelper = passive_Helper {
//        lclPassiveHelper.process_Passive_Cursor_Position()
//    }
//    move_Helper = Move_Helper()
//
//        centralState_Data_Evaluation()
//    }



//func cursor_Slider_Update(){
//    curr_Data_Pos_Y = currentYCursor_Slider_Position + lower_Bracket_Number
//
//    centralState_Data_Evaluation()
//
//    //establish current_Cursor_Set
//    // the cursor set has to color it cells accordingly
//
//        if currentPatternMode == .write_Mode {
//            potential_Helper.establish_Potential_Cells_Set()
//        }
//        else if currentPatternMode == .delete_Mode{
//            //delete_Helper.process_Delete_Cursor_Position()
//        }
//        else if currentPatternMode == .move_Mode,let lclMoveHelper = move_Helper{
//            lclMoveHelper.process_MoveNote_Cursor_Position()
//            lclMoveHelper.movement_With_Note_Selected()
//        }
//        else if currentPatternMode == .passive_Mode,let lclPassiveHelper = passive_Helper {
//            lclPassiveHelper.process_Passive_Cursor_Position()
//        }
//
//}

//public func setPatternMode(patternModeParam : E_PatternModeType){
//        if patternModeParam == .delete_Mode {
//            if currentPatternMode != .delete_Mode{currentPatternMode = .delete_Mode}
//        }
//        else if patternModeParam == .move_Mode {
//            if let lcl_Move_Helper = move_Helper{
//                lcl_Move_Helper.activateMoveMode()
//            }
////            if currentPatternMode != .move_Mode{
////                currentPatternMode = .move_Mode
////
////                if let lclNoteCollection = note_Collection_Ref {
////                    if let lclCurrentHighlightedNote = lclNoteCollection.currentHighlightedNote {
////
////                        if let lclMoveHelper = move_Helper {
////                        lclMoveHelper.snapShot_Note_Id_Param = lclCurrentHighlightedNote.id
////                        lclMoveHelper.note_Low_Index = lclCurrentHighlightedNote.lowest_Index
////                        lclMoveHelper.note_High_Index = lclCurrentHighlightedNote.highest_Index
////                        lclMoveHelper.note_Y_Val = lclCurrentHighlightedNote.note_Y_Number
////                        lclMoveHelper.snapshot_Cursor_X = curr_Data_Pos_X
////                        lclMoveHelper.snapshot_Cursor_Y = curr_Data_Pos_Y
////                        //lclMoveHelper.process_MoveNote_Cursor_Position()
////                        }
////
////                    }
////                }
////
////
////
////            }
////            else if currentPatternMode == .move_Mode {
////                if let lclMoveHelper = move_Helper {
////                    lclMoveHelper.writeMovedNote_DeleteOldNote()
////                    lclMoveHelper.note_Low_Index = nil
////                    lclMoveHelper.note_High_Index = nil
////                    lclMoveHelper.note_Y_Val = nil
////                    lclMoveHelper.snapshot_Cursor_X = nil
////                    lclMoveHelper.snapshot_Cursor_Y = nil
////                    lclMoveHelper.nil_Cell_Sets()
////                }
////
////            }
//        }
//        else if patternModeParam == .passive_Mode {
//
//        if currentPatternMode != .passive_Mode{
//            if let lclPassiveHelper = passive_Helper{
//            lclPassiveHelper.nil_passive_Cursor_Set()
//            lclPassiveHelper.process_Passive_Cursor_Position()
//            }
//            Note_Collection.Static_Note_Collection.react_To_Mode_Change()
//            currentPatternMode = .passive_Mode
//        }
//
//        }
//        else if patternModeParam == .write_Mode {
//            if currentPatternMode != .write_Mode {
//            delete_Helper.nil_Delete_Square_Set()
//
//            if let lclMoveHelper = move_Helper {
//            lclMoveHelper.nil_Cell_Sets()
//            lclMoveHelper.note_Low_Index = nil
//            lclMoveHelper.note_High_Index = nil
//            lclMoveHelper.note_Y_Val = nil
//            lclMoveHelper.snapshot_Cursor_X = nil
//            lclMoveHelper.snapshot_Cursor_Y = nil
//            }
//
//            if let lclPassiveHelper = passive_Helper{lclPassiveHelper.nil_passive_Cursor_Set()}
//
//            if dimensions.patternTimingConfiguration == .fourFour {
//                potential_Helper.initial_WriteOnCell = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentFourFourDataIndex]
//            }
//            else if dimensions.patternTimingConfiguration == .sixEight {
//                potential_Helper.initial_WriteOnCell = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentSixEightDataIndex]
//            }
//            potential_Helper.establish_Potential_Cells_Set()
//            currentPatternMode = .write_Mode
//            }
//            else if currentPatternMode == .write_Mode {
//                if potential_Helper.helperFuncs_PotentialNote_Set.count > 0 {
//                    Note_Collection.Static_Note_Collection.write_Note_Data(cellSetParam: potential_Helper.helperFuncs_PotentialNote_Set)
//                }
//                potential_Helper.nilPotentialSet()
//                setPatternMode(patternModeParam: .passive_Mode)
//            }
//        }
//        else if patternModeParam == .resize_Mode {
//            if currentPatternMode != .resize_Mode{currentPatternMode = .resize_Mode}
//        }
//}
//    public func setPatternMode(patternModeParam : E_PatternModeType){
//        if patternModeParam == .deleting {
//
//            if currentPatternMode != .deleting{currentPatternMode = .deleting}
//
//            delete_Helper.process_Delete_Cursor_Position()
//
//            if potential_Helper.initial_WriteOnCell != nil {
//                potential_Helper.initial_WriteOnCell = nil
//                potential_Helper.nilPotentialSet()
//            }
//            if note_Write_Locked == false{note_Write_Locked = true}
//
//            if let lclMoveHelper = move_Helper {
//            lclMoveHelper.nil_Cell_Sets()
//            lclMoveHelper.note_Low_Index = nil
//            lclMoveHelper.note_High_Index = nil
//            lclMoveHelper.note_Y_Val = nil
//            lclMoveHelper.snapshot_Cursor_X = nil
//            lclMoveHelper.snapshot_Cursor_Y = nil
//            }
//
//            if let lclPassiveHelper = passive_Helper{lclPassiveHelper.nil_passive_Cursor_Set()}
//
//            if dimensions.patternTimingConfiguration == .fourFour {
//                delete_Helper.current_Trail_Corner = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentFourFourDataIndex]
//            }
//            else if dimensions.patternTimingConfiguration == .sixEight {
//                delete_Helper.current_Trail_Corner = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentSixEightDataIndex]
//            }
//
//            if let lclNoteCollectionRef = note_Collection_Ref{
//                if let lclCurrHighlighted = lclNoteCollectionRef.currentHighlightedNote{
//                    for cell in lclCurrHighlighted.dataCellArray{
//                        if cell.in_Potential_Set == true{
//                            cell.handleVisibleStateChange(type: .deActivate_Potential_Set)
//                        }
//                    }
//                    print("from 2")
//                    lclNoteCollectionRef.delete_Current_Highlighted_Note(note_Id_Param: lclCurrHighlighted.id)
//                }
//            }
//
//        }
//        else if patternModeParam == .passive {
//            if currentPatternMode != .passive{currentPatternMode = .passive}
//            if potential_Helper.initial_WriteOnCell != nil, potential_Helper.helperFuncs_PotentialNote_Set.count > 0 {
//            potential_Helper.writeNote(note_Y_Param: curr_Data_Pos_Y)
//            potential_Helper.nilPotentialSet()
//            potential_Helper.initial_WriteOnCell = nil
//            }
//
//            if delete_Helper.delete_Cursor_Set.count > 0 {
//            delete_Helper.nil_Delete_Square_Set()
//            }
//
//            if let lclMoveHelper = move_Helper {
//            lclMoveHelper.note_Low_Index = nil
//            lclMoveHelper.note_High_Index = nil
//            lclMoveHelper.note_Y_Val = nil
//            lclMoveHelper.snapshot_Cursor_X = nil
//            lclMoveHelper.snapshot_Cursor_Y = nil
//            print("calling delete note")
//            lclMoveHelper.writeMovedNote_DeleteOldNote()
//            }
//
//            if let lclPassiveHelper = passive_Helper{
//            lclPassiveHelper.nil_passive_Cursor_Set()
//            lclPassiveHelper.process_Passive_Cursor_Position()
//            }
//            Note_Collection.Static_Note_Collection.react_To_Mode_Change()
//        }
//        else if patternModeParam == .moving {
//        if let lclNoteCollection = note_Collection_Ref {
//            if let lclCurrentHighlightedNote = lclNoteCollection.currentHighlightedNote {
//                if currentPatternMode != .moving{currentPatternMode = .moving}
//
//                if potential_Helper.initial_WriteOnCell != nil, potential_Helper.helperFuncs_PotentialNote_Set.count > 0 {
//                potential_Helper.writeNote(note_Y_Param: curr_Data_Pos_Y)
//                potential_Helper.nilPotentialSet()
//                potential_Helper.initial_WriteOnCell = nil
//                }
//
//                if delete_Helper.delete_Cursor_Set.count > 0 {delete_Helper.nil_Delete_Square_Set()}
//                if let lclPassiveHelper = passive_Helper{lclPassiveHelper.nil_passive_Cursor_Set()}
//
//                if let lclMoveHelper = move_Helper {
//                lclMoveHelper.snapShot_Note_Id_Param = lclCurrentHighlightedNote.id
//                lclMoveHelper.note_Low_Index = lclCurrentHighlightedNote.lowest_Index
//                lclMoveHelper.note_High_Index = lclCurrentHighlightedNote.highest_Index
//                lclMoveHelper.note_Y_Val = lclCurrentHighlightedNote.note_Y_Number
//                lclMoveHelper.snapshot_Cursor_X = curr_Data_Pos_X
//                lclMoveHelper.snapshot_Cursor_Y = curr_Data_Pos_Y
//                lclMoveHelper.process_MoveNote_Cursor_Position()
//                }
//
//                lclNoteCollection.react_To_Mode_Change()
//
//            }
//        }
//        }
//        else if patternModeParam == .writing {
//            if currentPatternMode != .writing {currentPatternMode = .writing}
//            delete_Helper.nil_Delete_Square_Set()
//
//            if let lclMoveHelper = move_Helper {
//            lclMoveHelper.nil_Cell_Sets()
//            lclMoveHelper.note_Low_Index = nil
//            lclMoveHelper.note_High_Index = nil
//            lclMoveHelper.note_Y_Val = nil
//            lclMoveHelper.snapshot_Cursor_X = nil
//            lclMoveHelper.snapshot_Cursor_Y = nil
//            }
//
//            if let lclPassiveHelper = passive_Helper{lclPassiveHelper.nil_passive_Cursor_Set()}
//
//            if dimensions.patternTimingConfiguration == .fourFour {
//                potential_Helper.initial_WriteOnCell = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentFourFourDataIndex]
//            }
//            else if dimensions.patternTimingConfiguration == .sixEight {
//                potential_Helper.initial_WriteOnCell = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentSixEightDataIndex]
//            }
//            potential_Helper.establish_Potential_Cells_Set()
//        }
//
//
//    }





//    public var delete_Note_Tap_Gesture : some Gesture {
//        TapGesture(count: 1).onEnded({
//            self.deleteANote()
//            if self.currentPatternMode == .writing{
//                if let lclInitial = self.potential_Helper.initial_WriteOnCell{
//                    let variableDelta = (self.currentData.dataCell_X_Number - lclInitial.dataCell_X_Number)
//                    if variableDelta > self.potential_Helper.helperFuncs_PotentialNote_Set.count
//                    || variableDelta < self.potential_Helper.helperFuncs_PotentialNote_Set.count{self.potential_Helper.establish_Potential_Cells_Set()}
//                }
//            }
//        })
//    }
