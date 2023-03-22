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
    
    @Published public var there_Is_A_Note_In_The_First_Place : Bool = false
    
    
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
    var multi_Select_Helper : Multi_Select_Helper?

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
        multi_Select_Helper = Multi_Select_Helper(parentCentral_State_Param: self)
        
        centralState_Data_Evaluation()
        
    }
    
    public func move_Delete_Status_Set(moveDeleteOn:Bool){
        if moveDeleteOn == true{
            if let lclDeleteHelper = move_Helper{
                lclDeleteHelper.deleteActive = moveDeleteOn
            }
        }
    }

    public func setCurrentNoteCollection(noteCollectionParam : Note_Collection){
        currentNoteCollection = noteCollectionParam
        currentPatternMode = .passive_Mode
    }
    
    public func setPatternMode(patternModeParam : E_PatternModeType){
        //,let lclMulti_Select_Helper = multi_Select_Helper
        if let lclPassiveHelper = passive_Helper,let lclWriteNote_Helper = writeNote_Helper
            ,let lclDelete_Helper = delete_Helper,let lclMoveHelper = move_Helper,let lclMulti_Select_Helper = multi_Select_Helper {
            
            if patternModeParam == .passive_Mode {
                lclMulti_Select_Helper.deactivate_Mode()
                lclMoveHelper.deactivate_Mode()
                lclDelete_Helper.deactivate_Mode()
                lclWriteNote_Helper.deactivate_Mode()
                lclPassiveHelper.activate_Mode(activationCell: nil)
                currentPatternMode = .passive_Mode
            }
            else if patternModeParam == .write_Mode {
                lclMulti_Select_Helper.deactivate_Mode()
                lclMoveHelper.deactivate_Mode()
                lclDelete_Helper.deactivate_Mode()
                lclPassiveHelper.deactivate_Mode()
                if currentData.note_Im_In == nil {
                    lclWriteNote_Helper.activate_Mode(activationCell: currentData)
                }
                currentPatternMode = .write_Mode
            }
            else if patternModeParam == .delete_Mode {
                
                if currentData.note_Im_In != nil {
                    if let lclNoteCollection = currentNoteCollection {
                        lclNoteCollection.deleteSelectedNotes()
                    }
                }
                
                lclMulti_Select_Helper.deactivate_Mode()
                lclMoveHelper.deactivate_Mode()
                lclPassiveHelper.deactivate_Mode()
                lclWriteNote_Helper.deactivate_Mode()
                lclDelete_Helper.activate_Mode(activationCell: currentData)
                currentPatternMode = .delete_Mode

            }
            else if patternModeParam == .move_Mode {
                lclMulti_Select_Helper.deactivate_Mode()
                lclDelete_Helper.deactivate_Mode()
                lclPassiveHelper.deactivate_Mode()
                lclWriteNote_Helper.deactivate_Mode()
                lclMoveHelper.activate_Mode(activationCell: currentData)
                currentPatternMode = .move_Mode
            }
            else if patternModeParam == .multi_Select_Mode {

                if currentPatternMode == .passive_Mode {
                    // if theres a selected note
                    if let lclCurrNoteCollection = currentNoteCollection {
                        if lclCurrNoteCollection.note_Currently_Under_Cursor != nil {
                            lclCurrNoteCollection.note_Currently_Under_Cursor = nil
                        }
                    }
                }

                lclDelete_Helper.deactivate_Mode()
                lclPassiveHelper.deactivate_Mode()
                lclWriteNote_Helper.deactivate_Mode()
                lclMoveHelper.deactivate_Mode()
                lclMulti_Select_Helper.activate_Mode(activationCell: currentData)
                currentPatternMode = .multi_Select_Mode
            }
        }
        centralState_Data_Evaluation()
    }
    
    func centralState_Data_Evaluation(){

        if dimensions.patternTimingConfiguration == .fourFour {
            
            currentData = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentFourFourDataIndex]
            curr_Data_Pos_X = dimensions.currentFourFourDataIndex
            current_Cursor_Set = currLineSet.filter({$0.four_Four_Half_Cell_Index == currentData.four_Four_Half_Cell_Index})
            
            if currentPatternMode == .passive_Mode {
                if let lclPassiveHelper = passive_Helper {
                    lclPassiveHelper.respond_To_Cursor_Movement(cell_Data_X: curr_Data_Pos_X, cell_Data_Y: curr_Data_Pos_Y)
                }
            }
            else if currentPatternMode == .write_Mode {
                if let lclWriteHelper = writeNote_Helper {
                    if currentData.note_Im_In == nil {
                        lclWriteHelper.establish_Potential_Cells_Set()
                    }
                }
            }
            else if currentPatternMode == .move_Mode {
                // if thers a multi select then go with it
                
                if let lclMoveHelper = move_Helper {
                    lclMoveHelper.movement_With_Multi_Note_Selected()
                        //.movement_With_Single_Note_Selected()
                }
                
            }
            else if currentPatternMode == .multi_Select_Mode {
                if let lclMulti_Select_Helper = multi_Select_Helper {
                    lclMulti_Select_Helper.area_Select_Handler()
                }
            }
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
                if let lclDeleteHelper = delete_Helper {
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
    case multi_Select_Mode = "multi_Select_Mode"
}
// hih?

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
