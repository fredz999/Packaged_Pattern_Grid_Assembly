//
//  File.swift
//  
//
//  Created by Jon on 17/11/2022.
//

import Foundation
import SwiftUI

public class Central_State : ObservableObject {

    @Published public var write_Needs_Held_Down : Bool = false
    
    @Published public var timing_Sig_Change_Possible : Bool = true
    
    @Published public var currentPatternMode : E_PatternModeType = .no_Note_Collection
    
    @Published public var currentNoteCollection : Note_Collection?
    
    @Published public var a_Note_Is_Highlighted : Bool = false
    
    @Published public var there_Is_A_Note_In_The_First_Place : Bool = false
    
    @Published public var mode_String = ""
    
    @Published public var mode_Id : Int?

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
    
    public var resize_Helper : Resize_Helper?
    
    var helperArray : [P_Selectable_Mode?] = []
    
    var currentData : Underlying_Data_Cell {
        didSet{
            if currentPatternMode == .delete_Mode {
                if let lclDeleteHelper = delete_Helper {
                    lclDeleteHelper.processCurrCell(cellParam: currentData)
                }
            }
        }
    }
    
    var currLineSet = Set<Underlying_Data_Cell>()

    var currLine : Underlying_Data_Line
    
    var timing_Change_Compensation_Index : Int? = nil

    var currentYCursor_Slider_Position : Int = 0
    
    var curr_Cursor_Min_Data_Pos_X : Int
    
    var curr_Data_Pos_Y : Int {
        didSet {
            if curr_Data_Pos_Y < data_Grid.dataLineArray.count {
                currLine = data_Grid.dataLineArray[curr_Data_Pos_Y]
                currLineSet.removeAll()
                currLineSet = Set(currLine.dataCellArray)
            }
        }
    }
    
    var current_Cursor_Set = Set<Underlying_Data_Cell>() {
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
    
    public init(dataGridParam:Underlying_Data_Grid){
        data_Grid = dataGridParam
        currentData = data_Grid.dataLineArray[0].dataCellArray[0]
        curr_Cursor_Min_Data_Pos_X = 0
        curr_Data_Pos_Y = 0
        currLine = data_Grid.dataLineArray[curr_Data_Pos_Y]
        for cell in currLine.dataCellArray {
        currLineSet.insert(cell)
        }
        
        move_Helper = Move_Helper(parentCentral_State_Param: self, selectableModeIdParam: 0)
        helperArray.append(move_Helper)
        
        delete_Helper = Delete_Helper(parentCentral_State_Param: self, selectableModeIdParam: 1)
        helperArray.append(delete_Helper)
        
        passive_Helper = Passive_Helper(parentCentral_State_Param: self, selectableModeIdParam: 2)
        helperArray.append(passive_Helper)
        
        writeNote_Helper = WriteNote_Helper(parentCentral_State_Param: self, selectableModeIdParam: 3)
        helperArray.append(writeNote_Helper)
        
        multi_Select_Helper = Multi_Select_Helper(parentCentral_State_Param: self, selectableModeIdParam: 4)
        helperArray.append(multi_Select_Helper)
        
        resize_Helper = Resize_Helper(parentCentral_State_Param: self, selectableModeIdParam: 5)
        helperArray.append(resize_Helper)
        
        centralState_Data_Evaluation()
        
    }

    deinit {
        if initial_Data_Y_Position_Set != nil{initial_Data_Y_Position_Set=nil}
    }
    
    public func setCurrentNoteCollection(noteCollectionParam : Note_Collection?){
        if let lclNewCollection = noteCollectionParam {
            currentNoteCollection = lclNewCollection
            setPatternMode(patternModeParam: .passive_Mode)
        }
        else if noteCollectionParam == nil{
            if let lclNoteCollection = currentNoteCollection{
                for note in lclNoteCollection.noteArray{
                    if note.note_Is_Pre_MultiSelected == true{note.note_Is_Pre_MultiSelected = false}
                    if note.moved_Away_From == true{note.moved_Away_From = false}
                }
                lclNoteCollection.deHighlightCollection()
                lclNoteCollection.deleteAllNotes()
            }
            //nil the current set
            currentNoteCollection = nil
            // set the mode to pre-passive
            setPatternMode(patternModeParam: .no_Note_Collection)
        }
    }
    
    func modeSpecificActions(){
        if currentPatternMode == .passive_Mode {
            if let lclPassiveHelper = passive_Helper {
                lclPassiveHelper.respond_To_Cursor_Movement(cell_Data_X: curr_Cursor_Min_Data_Pos_X, cell_Data_Y: curr_Data_Pos_Y)
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
            if let lclMoveHelper = move_Helper {
                lclMoveHelper.movement_With_Multi_Note_Selected()
            }
        }
        else if currentPatternMode == .multi_Select_Mode {
            if let lclMulti_Select_Helper = multi_Select_Helper {
                lclMulti_Select_Helper.area_Select_Handler()
            }
        }
        else if currentPatternMode == .resize_Mode {
            if let lclResize_Helper = resize_Helper {
                lclResize_Helper.handleDataEvaluation()
            }
        }
    }
    
    public func setPatternMode(patternModeParam : E_PatternModeType){

        if patternModeParam == .passive_Mode {
            modeActivator(mode_Param: passive_Helper, activationCellParam: nil)
            currentPatternMode = .passive_Mode
        }
        else if patternModeParam == .no_Note_Collection {
            modeActivator(mode_Param: nil, activationCellParam: nil)
            currentPatternMode = .no_Note_Collection
        }
        else if patternModeParam == .resize_Mode {
            modeActivator(mode_Param: resize_Helper, activationCellParam: currentData)
            currentPatternMode = .resize_Mode
        }
        else if patternModeParam == .write_Mode {
            if currentData.note_Im_In == nil {
                modeActivator(mode_Param: writeNote_Helper, activationCellParam: currentData)
                currentPatternMode = .write_Mode
            }
        }
        else if patternModeParam == .delete_Mode {
            if currentData.note_Im_In != nil {
                if let lclNoteCollection = currentNoteCollection {
                    lclNoteCollection.deleteSelectedNotes()
                }
            }
            modeActivator(mode_Param: delete_Helper, activationCellParam: currentData)
            currentPatternMode = .delete_Mode
        }
        else if patternModeParam == .move_Mode {
            modeActivator(mode_Param: move_Helper, activationCellParam: currentData)
            currentPatternMode = .move_Mode
        }
        else if patternModeParam == .multi_Select_Mode {
            if currentPatternMode == .passive_Mode {
                if let lclCurrNoteCollection = currentNoteCollection {
                    if lclCurrNoteCollection.note_Currently_Under_Cursor != nil {
                        lclCurrNoteCollection.note_Currently_Under_Cursor = nil
                    }
                }
            }
            modeActivator(mode_Param: multi_Select_Helper, activationCellParam: currentData)
            currentPatternMode = .multi_Select_Mode
        }
        centralState_Data_Evaluation()
    }
    
    public func change_Timing_Signature_Central() {

        if timing_Sig_Change_Possible == true {
            
        if dimensions.patternTimingConfiguration == .sixEight {
            if data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[curr_Cursor_Min_Data_Pos_X].four_Four_Half_Sub_Index != 0{
                timing_Change_Compensation_Index = curr_Cursor_Min_Data_Pos_X - data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[curr_Cursor_Min_Data_Pos_X].four_Four_Half_Sub_Index
            }
        }
        else if dimensions.patternTimingConfiguration == .fourFour {
            if data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[curr_Cursor_Min_Data_Pos_X].six_Eight_Half_Sub_Index != 0{
                timing_Change_Compensation_Index = curr_Cursor_Min_Data_Pos_X - data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[curr_Cursor_Min_Data_Pos_X].six_Eight_Half_Sub_Index
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
        establishCursorSet()
    }
    
    public func change_Move_Copy_Sub_Mode(isMoveOnly:Bool) {
        
        if let lclMoveHelper = move_Helper {
            
            if isMoveOnly == true {
                if lclMoveHelper.dont_Copy_Just_Move == false {
                    lclMoveHelper.dont_Copy_Just_Move = true
                }
            }
            else if isMoveOnly == false {
                if lclMoveHelper.dont_Copy_Just_Move == true {
                    lclMoveHelper.dont_Copy_Just_Move = false
                }
            }
            
        }
    }

    public func resizeModeActions(action:E_ResizeActions){
        if let lclResizeHelper = resize_Helper {
        if currentPatternMode == .resize_Mode {
                if lclResizeHelper.resizeSubMode == .leftSideSubMode {
                    if action == .subModerightWard {
                        if lclResizeHelper.left_Side_Resizer_Garage_Array.count > 0 {
                            lclResizeHelper.reWriteNotes()
                        }
                        lclResizeHelper.right_Side_Resize_Start()
                        lclResizeHelper.resizeSubMode = .rightSideSubMode
                    }
                    else if action == .writeCurrent{
                        if lclResizeHelper.left_Side_Resizer_Garage_Array.count > 0{
                            lclResizeHelper.reWriteNotes()
                            lclResizeHelper.resizeSubMode = .standBySubMode
                            setPatternMode(patternModeParam: .passive_Mode)
                        }
                    }
                }
                else if lclResizeHelper.resizeSubMode == .rightSideSubMode {
                    if action == .subModeleftWard {
                        if lclResizeHelper.right_Side_Resizer_Garage_Array.count > 0 {
                            lclResizeHelper.reWriteNotes()
                        }
                        lclResizeHelper.left_Side_Resize_Start()
                        lclResizeHelper.resizeSubMode = .leftSideSubMode
                    }
                    else if action == .writeCurrent{
                        if lclResizeHelper.right_Side_Resizer_Garage_Array.count > 0{
                            lclResizeHelper.reWriteNotes()
                            lclResizeHelper.resizeSubMode = .standBySubMode
                            setPatternMode(patternModeParam: .passive_Mode)
                        }
                    }
                }
                else if lclResizeHelper.resizeSubMode == .standBySubMode {
                    if action == .subModeleftWard{
                        lclResizeHelper.left_Side_Resize_Start()
                        lclResizeHelper.resizeSubMode = .leftSideSubMode
                    }
                    else if action == .subModerightWard{
                        lclResizeHelper.right_Side_Resize_Start()
                        lclResizeHelper.resizeSubMode = .rightSideSubMode
                    }
                }
            }
        else if currentPatternMode != .resize_Mode {
            if action == .subModeleftWard {
                setPatternMode(patternModeParam: .resize_Mode)
                lclResizeHelper.left_Side_Resize_Start()
                lclResizeHelper.resizeSubMode = .leftSideSubMode
            }
            else if action == .subModerightWard {
                setPatternMode(patternModeParam: .resize_Mode)
                lclResizeHelper.right_Side_Resize_Start()
                lclResizeHelper.resizeSubMode = .rightSideSubMode
            }
        }
    }
    }
    
    func modeActivator(mode_Param:P_Selectable_Mode?,activationCellParam:Underlying_Data_Cell?){
        if let lclMode_Param = mode_Param {
            for optionalHelper in helperArray {
                if let lclHelper = optionalHelper {
                    if lclHelper.selectableModeId == lclMode_Param.selectableModeId {
                        if lclHelper.mode_Active == false {
                            lclHelper.activate_Mode(activationCell: activationCellParam)
                            mode_String = lclHelper.generateModeDescriptorString()
                            mode_Id = lclHelper.selectableModeId
                        }
                    }
                    else if lclHelper.selectableModeId != lclMode_Param.selectableModeId {
                        if lclHelper.mode_Active == true {
                            lclHelper.deactivate_Mode()
                        }
                    }
                }
            }
        }
        else if mode_Param == nil{
            for optionalHelper in helperArray {
                if let lclHelper = optionalHelper {
                    if lclHelper.mode_Active == true {
                        lclHelper.deactivate_Mode()
                    }
                }
            }
            mode_String = ""
            mode_Id = nil
        }
        
        
    }

    func centralState_Data_Evaluation(){
        if curr_Data_Pos_Y < data_Grid.dataLineArray.count{
            if dimensions.patternTimingConfiguration == .fourFour {
                currentData = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentSingleCellDataIndex]
                curr_Cursor_Min_Data_Pos_X = dimensions.currentFourFourDataIndex
                modeSpecificActions()
            }
            else if dimensions.patternTimingConfiguration == .sixEight {
                currentData = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentSingleCellDataIndex]
                curr_Cursor_Min_Data_Pos_X = dimensions.currentSixEightDataIndex
                modeSpecificActions()
            }
        }
        establishCursorSet()
    }
    
    func establishCursorSet(){
        if dimensions.patternTimingConfiguration == .fourFour {
            let newCursorSet = currLineSet.filter({$0.four_Four_Half_Cell_Index == currentData.four_Four_Half_Cell_Index})
            accessCursorSet(newSet: newCursorSet)
        }
        else if dimensions.patternTimingConfiguration == .sixEight {
            let newCursorSet = currLineSet.filter({$0.six_Eight_Half_Cell_Index == currentData.six_Eight_Half_Cell_Index})
            accessCursorSet(newSet: newCursorSet)
        }
    }
    
    func accessCursorSet(newSet:Set<Underlying_Data_Cell>){
        current_Cursor_Set.removeAll()
        current_Cursor_Set = newSet
    }
    
    func cursor_Visible_Change_Type(isActivation:Bool)->E_VisibleStateChangeType {
        var retVal : E_VisibleStateChangeType = .activate_Passive_Cursor_Set
        if isActivation == false {
            retVal = .deActivate_Passive_Cursor_Set
        }
        return retVal
    }

    func cursor_Slider_Update(){
        if (currentYCursor_Slider_Position + lower_Bracket_Number) < data_Grid.dataLineArray.count {
            curr_Data_Pos_Y = currentYCursor_Slider_Position + lower_Bracket_Number
            centralState_Data_Evaluation()
        }
    }
    
    
    public func jump_To_Y_Position(lowerDataPos:Int,lowerSliderPos:Int){
        if let lclinitial_Data_Y_Position_Set = initial_Data_Y_Position_Set{
            lclinitial_Data_Y_Position_Set(lowerSliderPos)
        }
        data_Slider_LowBracket_Update(newLower:lowerDataPos)
    }
    
    public var initial_Data_Y_Position_Set : ((Int)->())?

    func data_Slider_LowBracket_Update(newLower:Int){
        if (currentYCursor_Slider_Position + newLower) < data_Grid.dataLineArray.count {
            lower_Bracket_Number = newLower
            higher_Bracket_Number = Int(dimensions.visualGrid_Y_Unit_Count) + newLower
            if let lcl_Central_Grid_Ref = central_Grid_Store {
            lcl_Central_Grid_Ref.changeDataBracket(newLower: newLower)
            }
            curr_Data_Pos_Y = currentYCursor_Slider_Position + lower_Bracket_Number
            centralState_Data_Evaluation()
        }
    }
    
}

public enum E_ResizeActions {
    case subModeleftWard
    case subModerightWard
    case writeCurrent
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
