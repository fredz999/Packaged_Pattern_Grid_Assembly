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

    public let data_Grid = Underlying_Data_Grid.Static_Underlying_Data_Grid
    let dimensions = ComponentDimensions.StaticDimensions
    let colors = ComponentColors.StaticColors
    //==================================================
    var v_Slider_Ref : Cursor_Vertical_Slider_Store?
    public var h_Slider_Ref : Cursor_Horizontal_Slider_Store?
    public var note_Collection_Ref : Note_Collection?
    public var central_Grid_Store : Central_Grid_Store?
    //==================================================
    //==================================================
    var lower_Bracket_Number : Int = 0
    var higher_Bracket_Number : Int = 0
    //==================================================
    //==================================================
    //==================================================
    
    
    public init(){
        curr_Data_Pos_X = 0
        curr_Data_Pos_Y = 0
        viableSetHelpers = Viable_Set_Helper_Functions(initialDataParam: initialData)
        delete_Helper = Delete_Helper(initialDataParam: initialData)
        let currLine = data_Grid.dataLineArray[curr_Data_Pos_Y]
        
        for cell in currLine.dataCellArray {
        viableSetHelpers.current_Cell_Line_Set.insert(cell)
        delete_Helper.current_DellCell_Line_Set.insert(cell)
        }
        
    }
    
    var initialData : Underlying_Data_Cell = Underlying_Data_Grid.Static_Underlying_Data_Grid.dataLineArray[0].dataCellArray[0]
    
    public func post_init_Setup(){
        viableSetHelpers.establish_Cursor_Set()
    }
    
    public func accessTestWriteLock(){
        viableSetHelpers.test_For_Write_Lock()
    }
    
    @Published public var write_Needs_Held_Down : Bool = false
    
    public func change_Write_Needs_Held_Down(){
        if write_Needs_Held_Down == true {
            write_Needs_Held_Down = false
        }
        else if write_Needs_Held_Down == false {
            write_Needs_Held_Down = true
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
    
    public var delete_Note_Tap_Gesture : some Gesture {
        TapGesture(count: 1).onEnded({
            self.deleteANote()
            //if self.writingIsOn {
            if self.currentPatternMode == .writing{
                if let lclInitial = self.viableSetHelpers.initial_WriteOnCell{
                    let variableDelta = (self.viableSetHelpers.helperFuncs_currentData.dataCell_X_Number - lclInitial.dataCell_X_Number)
                    if variableDelta > self.viableSetHelpers.helperFuncs_PotentialNote_Set.count
                    || variableDelta < self.viableSetHelpers.helperFuncs_PotentialNote_Set.count{self.viableSetHelpers.establish_Potential_Cells_Set()}
                }

            }

        })
    }

    var timing_Change_Compensation_Index : Int? = nil
    
    @Published public var timing_Sig_Change_Possible : Bool = true
    
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
        viableSetHelpers.establish_Cursor_Set()
    }

    public func deleteANote(){
        if let lclNoteCollection = note_Collection_Ref {
            lclNoteCollection.reset_Note_Data_Cells()
            a_Note_Is_Highlighted = false
        }
    }

    var currentYCursor_Slider_Position : Int = 0
    
//    @Published public var deleteIsOn : Bool = false
//    {
//        didSet {
//            if deleteIsOn == true {
//                if currentPatternMode == .writing{
//                //if writingIsOn == true {
//                    //writingIsOn = false
//                }
//                delete_Helper.establish_Delete_Square_Set()
//            }
//            else if deleteIsOn == false {
//                delete_Helper.nil_Delete_Square_Set()
//                if currentPatternMode == .writing{
//                //if writingIsOn == true {
//                    viableSetHelpers.establish_Potential_Cells_Set()
//                }
//                else if currentPatternMode == .writing{
//                //else if writingIsOn == false {
//                    viableSetHelpers.establish_Cursor_Set()
//                }
//            }
//        }
//    }
    
//    var writingIsOn : Bool = false
//    {
//        didSet {
//            if writingIsOn == true {
//
//                if deleteIsOn == true{deleteIsOn = false}
//
//                if timing_Sig_Change_Possible == true{timing_Sig_Change_Possible = false}
//
//                if viableSetHelpers.initial_WriteOnCell == nil{
//                    if dimensions.patternTimingConfiguration == .fourFour {
//                        viableSetHelpers.initial_WriteOnCell = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentFourFourDataIndex]
//                    }
//                    else if dimensions.patternTimingConfiguration == .sixEight {
//                        viableSetHelpers.initial_WriteOnCell = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentSixEightDataIndex]
//                    }
//                }
//            }
//            else if writingIsOn == false {
//                if deleteIsOn == true{delete_Helper.establish_Delete_Square_Set()}
//                else if deleteIsOn == false{viableSetHelpers.establish_Cursor_Set()}
//
//                if timing_Sig_Change_Possible == false{timing_Sig_Change_Possible = true}
//                viableSetHelpers.writeNote(note_Y_Param: curr_Data_Pos_Y)
//                if viableSetHelpers.initial_WriteOnCell != nil {
//                    viableSetHelpers.initial_WriteOnCell = nil
//                }
//                viableSetHelpers.test_For_Write_Lock()
//            }
//        }
//    }
    
    @Published public var currentPatternMode : E_PatternModeType = .passive
    public func setPatternMode(patternModeParam : E_PatternModeType){
        
        if patternModeParam == .writing {
            currentPatternMode = .writing
            delete_Helper.nil_Delete_Square_Set()
            viableSetHelpers.nil_Cursor_Set()
            
            if dimensions.patternTimingConfiguration == .fourFour {
                viableSetHelpers.initial_WriteOnCell = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentFourFourDataIndex]
            }
            else if dimensions.patternTimingConfiguration == .sixEight {
                viableSetHelpers.initial_WriteOnCell = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentSixEightDataIndex]
            }
            viableSetHelpers.establish_Potential_Cells_Set()
           
        }
        else if patternModeParam == .deleting {
            if currentPatternMode != .deleting{currentPatternMode = .deleting}
            if viableSetHelpers.initial_WriteOnCell != nil {
                viableSetHelpers.initial_WriteOnCell = nil
                viableSetHelpers.nilPotentialSet()
            }
            if viableSetHelpers.current_Cell_Line_Set.count > 0{viableSetHelpers.nil_Cursor_Set()}
            viableSetHelpers.test_For_Write_Lock()
            delete_Helper.establish_Delete_Square_Set()
       
        }
        else if patternModeParam == .passive {

            if viableSetHelpers.initial_WriteOnCell != nil, viableSetHelpers.helperFuncs_PotentialNote_Set.count > 0 {
                viableSetHelpers.writeNote(note_Y_Param: curr_Data_Pos_Y)
                viableSetHelpers.nilPotentialSet()
                viableSetHelpers.initial_WriteOnCell = nil
            }
            if delete_Helper.delete_Square_Set.count > 0{
                delete_Helper.nil_Delete_Square_Set()
            }

            if currentPatternMode != .passive{currentPatternMode = .passive}
            if viableSetHelpers.helperFuncs_Cursor_Set.count == 0{
                viableSetHelpers.establish_Cursor_Set()
            }
            
        }
        viableSetHelpers.test_For_Write_Lock()
    }
    
    
    var viableSetHelpers : Viable_Set_Helper_Functions
    var delete_Helper : Delete_Helper

    func cursor_Slider_Update(){
        curr_Data_Pos_Y = currentYCursor_Slider_Position + lower_Bracket_Number
        centralState_Data_Evaluation()
        
        // redo this, the nil does not need to be called over and over again
        // the helpers themselves should be looking to the central state for info about the current cursor position
        
        if currentPatternMode == .writing {
        //if writingIsOn == true,deleteIsOn == false {
//            viableSetHelpers.nil_Cursor_Set()
//            delete_Helper.nil_Delete_Square_Set()
            viableSetHelpers.establish_Potential_Cells_Set()
        }
        else if currentPatternMode == .deleting{
        //else if deleteIsOn == true,writingIsOn == false {
//            viableSetHelpers.nil_Cursor_Set()
//            viableSetHelpers.nilPotentialSet()
            delete_Helper.establish_Delete_Square_Set()
        }
        else if currentPatternMode == .passive{
        //else if deleteIsOn == false,writingIsOn == false {
//            viableSetHelpers.nilPotentialSet()
//            delete_Helper.nil_Delete_Square_Set()
            viableSetHelpers.establish_Cursor_Set()
        }
    }
    
    func centralState_Data_Evaluation(){
        
        if let currViable = viableSetHelpers.initial_WriteOnCell {

            if currViable.dataCell_Y_Number != curr_Data_Pos_Y {
                
                viableSetHelpers.nilPotentialSet()
                
                if dimensions.patternTimingConfiguration == .fourFour {
                    viableSetHelpers.initial_WriteOnCell = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentFourFourDataIndex]
                    viableSetHelpers.helperFuncs_currentData = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentFourFourDataIndex]
                    curr_Data_Pos_X = dimensions.currentFourFourDataIndex
                }
                else if dimensions.patternTimingConfiguration == .sixEight {
                    viableSetHelpers.initial_WriteOnCell = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentSixEightDataIndex]
                    viableSetHelpers.helperFuncs_currentData = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentSixEightDataIndex]
                    curr_Data_Pos_X = dimensions.currentSixEightDataIndex
                }
            }
            else if currViable.dataCell_Y_Number == curr_Data_Pos_Y {
                if dimensions.patternTimingConfiguration == .fourFour {
                    viableSetHelpers.helperFuncs_currentData = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentFourFourDataIndex]
                    curr_Data_Pos_X = dimensions.currentFourFourDataIndex
                }
                else if dimensions.patternTimingConfiguration == .sixEight {
                    viableSetHelpers.helperFuncs_currentData = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentSixEightDataIndex]
                    curr_Data_Pos_X = dimensions.currentSixEightDataIndex
                }
            }


        }
        
        else if  viableSetHelpers.initial_WriteOnCell == nil{
            
            if dimensions.patternTimingConfiguration == .fourFour{
                viableSetHelpers.helperFuncs_currentData = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentFourFourDataIndex]
                delete_Helper.deleteHelper_currentData = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentFourFourDataIndex]
                curr_Data_Pos_X = dimensions.currentFourFourDataIndex
            }
            
            else if dimensions.patternTimingConfiguration == .sixEight {
                viableSetHelpers.helperFuncs_currentData = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentSixEightDataIndex]
                delete_Helper.deleteHelper_currentData = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentSixEightDataIndex]
                curr_Data_Pos_X = dimensions.currentSixEightDataIndex
            }
        }
    }
    
    var curr_Data_Pos_X : Int
    
    var curr_Data_Pos_Y : Int {
        didSet {
            let currLine = data_Grid.dataLineArray[curr_Data_Pos_Y]
            viableSetHelpers.current_Cell_Line_Set.removeAll()
            var newSet = Set<Underlying_Data_Cell>()
            for cell in currLine.dataCellArray{
                newSet.insert(cell)
            }
            viableSetHelpers.current_Cell_Line_Set = newSet
            delete_Helper.current_DellCell_Line_Set = newSet
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

    public func changeNotePosition(movementTyoeParam:E_Note_Movement_Type) {
        
//        if let noteCollection = note_Collection_Ref {
//
//            if let lclCurrNote = noteCollection.currentHighlightedNote {
//                if movementTyoeParam == .rightWard {
//                    if let lclHSlider = h_Slider_Ref {
//                        if lclCurrNote.cell_Is_Beside_Border_Or_Note(connectionType: .toRight) == false{
//                            lclCurrNote.moveRightOne()
//                            lclHSlider.artificially_H_Increment()
//                        }
//                        else {
//                            lclHSlider.artificially_H_Increment()
//                        }
//                    }
//                }
//                else if movementTyoeParam == .leftWard {
//                    if let lclHSlider = h_Slider_Ref {
//                        if lclCurrNote.cell_Is_Beside_Border_Or_Note(connectionType: .toLeft) == false {
//                            lclCurrNote.moveLeftOne()
//                            lclHSlider.artificially_H_Decrement()
//                        }
//                        else {
//                            lclHSlider.artificially_H_Decrement()
//                        }
//                    }
//                }
//                else if movementTyoeParam == .downward {
//                    if lclCurrNote.cell_Is_Beside_Border_Or_Note(connectionType: .below) == false{
//                        if let lclVSlider = v_Slider_Ref{
//                            lclCurrNote.moveDownOne()
//                            lclVSlider.artificially_V_Increment()
//                        }
//                    }
//                }
//                else if movementTyoeParam == .upward {
//                    if lclCurrNote.cell_Is_Beside_Border_Or_Note(connectionType: .above) == false{
//                        if let lclVSlider = v_Slider_Ref{
//                            lclCurrNote.moveUpOne()
//                            lclVSlider.artificially_V_Decrement()
//                        }
//                    }
//                }
//            }
//        }
    }

    public static let Static_Central_State = Central_State()

}

public enum E_PatternModeType{
    case writing
    case deleting
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
