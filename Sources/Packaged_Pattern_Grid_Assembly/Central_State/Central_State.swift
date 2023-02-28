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
    
    @Published public var a_Note_Is_Highlighted : Bool = false
    
    @Published public var note_Write_Locked : Bool = false
    
    @Published public var write_Needs_Held_Down : Bool = false
    
    @Published public var timing_Sig_Change_Possible : Bool = true
    
    @Published public var currentPatternMode : E_PatternModeType = .passive
    

    public let data_Grid = Underlying_Data_Grid.Static_Underlying_Data_Grid
    let dimensions = ComponentDimensions.StaticDimensions
    let colors = ComponentColors.StaticColors
    //==================================================
    var v_Slider_Ref : Cursor_Vertical_Slider_Store?
    public var h_Slider_Ref : Cursor_Horizontal_Slider_Store?
    public var note_Collection_Ref : Note_Collection?
    public var central_Grid_Store : Central_Grid_Store?
    //==================================================
    var lower_Bracket_Number : Int = 0
    var higher_Bracket_Number : Int = 0
    //==================================================
    var potential_Helper : Potential_Helper
    var delete_Helper : Delete_Helper
    var move_Helper : Move_Helper?

    public init(){
        curr_Data_Pos_X = 0
        curr_Data_Pos_Y = 0
        potential_Helper = Potential_Helper(initialDataParam: currentData)
        delete_Helper = Delete_Helper(initialDataParam: currentData)
        let currLine = data_Grid.dataLineArray[curr_Data_Pos_Y]
        
        for cell in currLine.dataCellArray {
        currLineSet.insert(cell)
        }
        
    }
    
    var currentData : Underlying_Data_Cell = Underlying_Data_Grid.Static_Underlying_Data_Grid.dataLineArray[0].dataCellArray[0]
    
    public func post_init_Setup(){
        potential_Helper.establish_Cursor_Set()
        move_Helper = Move_Helper()
    }
    
    public func accessTestWriteLock(){
        potential_Helper.test_For_Write_Lock()
    }
    
    public func change_Write_Needs_Held_Down(){
        if write_Needs_Held_Down == true {
            write_Needs_Held_Down = false
        }
        else if write_Needs_Held_Down == false {
            write_Needs_Held_Down = true
        }
    }

    public var delete_Note_Tap_Gesture : some Gesture {
        TapGesture(count: 1).onEnded({
            self.deleteANote()
            if self.currentPatternMode == .writing{
                if let lclInitial = self.potential_Helper.initial_WriteOnCell{
                    let variableDelta = (self.potential_Helper.potential_Helper_currentData.dataCell_X_Number - lclInitial.dataCell_X_Number)
                    if variableDelta > self.potential_Helper.helperFuncs_PotentialNote_Set.count
                    || variableDelta < self.potential_Helper.helperFuncs_PotentialNote_Set.count{self.potential_Helper.establish_Potential_Cells_Set()}
                }
            }
        })
    }

    var timing_Change_Compensation_Index : Int? = nil
    
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
        potential_Helper.establish_Cursor_Set()
    }

    public func deleteANote(){
        if let lclNoteCollection = note_Collection_Ref {
            lclNoteCollection.reset_Note_Data_Cells()
            a_Note_Is_Highlighted = false
        }
    }

    var currentYCursor_Slider_Position : Int = 0
    
    public func setPatternMode(patternModeParam : E_PatternModeType){
        
        
        if patternModeParam == .writing {
            if currentPatternMode != .writing {currentPatternMode = .writing}
            delete_Helper.nil_Delete_Square_Set()
            potential_Helper.nil_Cursor_Set()
            if let lclMoveHelper = move_Helper{lclMoveHelper.nil_Move_Note_Cursor_Set()}
            
            if dimensions.patternTimingConfiguration == .fourFour {
                potential_Helper.initial_WriteOnCell = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentFourFourDataIndex]
            }
            else if dimensions.patternTimingConfiguration == .sixEight {
                potential_Helper.initial_WriteOnCell = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentSixEightDataIndex]
            }
            //potential_Helper.establish_Potential_Cells_Set()
        }
        
        
        
        else if patternModeParam == .deleting {
            
            if note_Write_Locked == true{note_Write_Locked = false}
            
            if currentPatternMode != .deleting{currentPatternMode = .deleting}
            
            if let lclMoveHelper = move_Helper{lclMoveHelper.nil_Move_Note_Cursor_Set()}
            
            if potential_Helper.initial_WriteOnCell != nil {
                potential_Helper.initial_WriteOnCell = nil
                potential_Helper.nilPotentialSet()
            }
            
            if currLineSet.count > 0{potential_Helper.nil_Cursor_Set()}
            potential_Helper.test_For_Write_Lock()
            
            if dimensions.patternTimingConfiguration == .fourFour {
                delete_Helper.current_Trail_Corner = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentFourFourDataIndex]
            }
            else if dimensions.patternTimingConfiguration == .sixEight {
                delete_Helper.current_Trail_Corner = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentSixEightDataIndex]
            }
            
            delete_Helper.process_Delete_Cursor_Position()
       
        }
        else if patternModeParam == .passive {

            if potential_Helper.initial_WriteOnCell != nil, potential_Helper.helperFuncs_PotentialNote_Set.count > 0 {
                potential_Helper.writeNote(note_Y_Param: curr_Data_Pos_Y)
                potential_Helper.nilPotentialSet()
                potential_Helper.initial_WriteOnCell = nil
            }
            if delete_Helper.delete_Cursor_Set.count > 0 {delete_Helper.nil_Delete_Square_Set()}
            if let lclMoveHelper = move_Helper{lclMoveHelper.nil_Move_Note_Cursor_Set()}
            
            if currentPatternMode != .passive{currentPatternMode = .passive}
//            if potential_Helper.potential_Helper_Cursor_Set.count == 0{
//                potential_Helper.establish_Cursor_Set()
//            }
            
        }
        else if patternModeParam == .moving {
            if potential_Helper.initial_WriteOnCell != nil, potential_Helper.helperFuncs_PotentialNote_Set.count > 0 {
                potential_Helper.writeNote(note_Y_Param: curr_Data_Pos_Y)
                potential_Helper.nilPotentialSet()
                potential_Helper.initial_WriteOnCell = nil
            }
            if delete_Helper.delete_Cursor_Set.count > 0 {
                delete_Helper.nil_Delete_Square_Set()
            }
            if currentPatternMode != .moving{currentPatternMode = .moving}
            
//            if potential_Helper.potential_Helper_Cursor_Set.count == 0{
//                potential_Helper.establish_Cursor_Set()
//            }
        }
        
        potential_Helper.test_For_Write_Lock()
    }
    
    
    

    func cursor_Slider_Update(){
        curr_Data_Pos_Y = currentYCursor_Slider_Position + lower_Bracket_Number
        centralState_Data_Evaluation()
        
        // redo this, the nil does not need to be called over and over again
        // the helpers themselves should be looking to the central state for info about the current cursor position
        
        if currentPatternMode == .writing {
            potential_Helper.establish_Potential_Cells_Set()
        }
        else if currentPatternMode == .deleting{
            delete_Helper.process_Delete_Cursor_Position()
        }
        else if currentPatternMode == .passive{
            potential_Helper.establish_Cursor_Set()
        }
    }
    
    func centralState_Data_Evaluation(){

        if let currViable = potential_Helper.initial_WriteOnCell {

            if currViable.dataCell_Y_Number != curr_Data_Pos_Y {

                potential_Helper.nilPotentialSet()

                if dimensions.patternTimingConfiguration == .fourFour {
                    potential_Helper.initial_WriteOnCell = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentFourFourDataIndex]
                    potential_Helper.potential_Helper_currentData = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentFourFourDataIndex]
                    curr_Data_Pos_X = dimensions.currentFourFourDataIndex
                }
                else if dimensions.patternTimingConfiguration == .sixEight {
                    potential_Helper.initial_WriteOnCell = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentSixEightDataIndex]
                    potential_Helper.potential_Helper_currentData = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentSixEightDataIndex]
                    curr_Data_Pos_X = dimensions.currentSixEightDataIndex
                }
            }
            else if currViable.dataCell_Y_Number == curr_Data_Pos_Y {
                if dimensions.patternTimingConfiguration == .fourFour {
                    potential_Helper.potential_Helper_currentData = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentFourFourDataIndex]
                    curr_Data_Pos_X = dimensions.currentFourFourDataIndex
                }
                else if dimensions.patternTimingConfiguration == .sixEight {
                    potential_Helper.potential_Helper_currentData = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentSixEightDataIndex]
                    curr_Data_Pos_X = dimensions.currentSixEightDataIndex
                }
            }


        }

        else if  potential_Helper.initial_WriteOnCell == nil{

            if dimensions.patternTimingConfiguration == .fourFour{
                potential_Helper.potential_Helper_currentData = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentFourFourDataIndex]

                    delete_Helper.delete_Cursor_CurrentData = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentFourFourDataIndex]

                curr_Data_Pos_X = dimensions.currentFourFourDataIndex
            }

            else if dimensions.patternTimingConfiguration == .sixEight {
                potential_Helper.potential_Helper_currentData = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentSixEightDataIndex]
                //if currentPatternMode == .deleting {
                    delete_Helper.delete_Cursor_CurrentData = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentSixEightDataIndex]
                //}
                curr_Data_Pos_X = dimensions.currentSixEightDataIndex
            }
        }
    
        if currentPatternMode == .moving,let lclMoveHelper = move_Helper {
            if dimensions.patternTimingConfiguration == .fourFour {
                currentData = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentFourFourDataIndex]
            }
            else if dimensions.patternTimingConfiguration == .sixEight {
                currentData = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentSixEightDataIndex]
            }
            lclMoveHelper.process_Move_Cursor_Position()
        }
        

    }
    
    
    
    var currLineSet = Set<Underlying_Data_Cell>()
    
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

    func data_Slider_LowBracket_Update(newLower:Int){
    
    lower_Bracket_Number = newLower
    higher_Bracket_Number = Int(dimensions.visualGrid_Y_Unit_Count) + newLower

    if let lcl_Central_Grid_Ref = central_Grid_Store {
    lcl_Central_Grid_Ref.changeDataBracket(newLower: newLower)
    }
    centralState_Data_Evaluation()
    }
    
    public func changeNoteLength(isIncrement:Bool) {
        if let noteCollection = note_Collection_Ref {
            if let lclCurrNote = noteCollection.currentHighlightedNote {
                if isIncrement == true {
                    lclCurrNote.rightSide_Expansion()
                }
                else if isIncrement == false {
                    lclCurrNote.leftSide_Expansion()
                }
            }
        }
    }

    

    public static let Static_Central_State = Central_State()

}

public enum E_PatternModeType{
    case writing
    case deleting
    case moving
    case resizing
    case passive
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


//    public var toggleWrite_Gesture_Springy : some Gesture {
//      DragGesture(minimumDistance: 0, coordinateSpace: .local)
//      .onChanged { val in
//          if self.writingIsOn == false{self.writingIsOn=true}
//      }
//      .onEnded { val in
//          if self.writingIsOn == true{self.writingIsOn=false}
//      }
//    }
    
//    public var toggleWrite_Gesture_Sticky : some Gesture {
//        TapGesture(count: 1).onEnded({
//            if self.a_Note_Is_Highlighted == false {
//                self.writingIsOn.toggle()
//            }
//        })
//    }
    
//    public var Deactivate_Write_Tap_Gesture : some Gesture {
//        TapGesture(count: 1).onEnded({
//            self.writingIsOn = false
//        })
//    }
//
//    public var Activate_Write_Tap_Gesture : some Gesture {
//        TapGesture(count: 1).onEnded({
//            self.writingIsOn = true
//        })
//    }
