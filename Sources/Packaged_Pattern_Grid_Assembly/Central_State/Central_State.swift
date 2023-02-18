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

    public let data_Grid = Underlying_Data_Grid.Static_Underlying_Data_Grid
    let dimensions = ComponentDimensions.StaticDimensions
    let colors = ComponentColors.StaticColors
    //==================================================
    var v_Slider_Ref : Cursor_Vertical_Slider_Store?
    public var h_Slider_Ref : Cursor_Horizontal_Slider_Store?
    var cursor_Layer_Ref : Cursor_Layer_Store?
    var potential_Note_Layer_Ref : Potential_Note_Layer_Store?
    
    public var note_Collection_Ref : Note_Collection?
    public var central_Grid_Store : Central_Grid_Store?
    //==================================================
    //==================================================
    var lower_Bracket_Number : Int = 0
    var higher_Bracket_Number : Int = 0
    //==================================================
    //==================================================
    //==================================================
    @Published public var writingIsOn : Bool = false {
        didSet {
            if writingIsOn == true {
                viableSetHelpers.nil_Cursor_Set()
                if timing_Sig_Change_Possible == true{timing_Sig_Change_Possible = false}
                if viableSetHelpers.initial_WriteOnCell == nil {
                    if dimensions.patternTimingConfiguration == .fourFour {
                        viableSetHelpers.initial_WriteOnCell = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentFourFourDataIndex]
                    }
                    else if dimensions.patternTimingConfiguration == .sixEight {
                        viableSetHelpers.initial_WriteOnCell = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentSixEightDataIndex]
                    }
                }
            }
            else if writingIsOn == false {
                viableSetHelpers.establish_Cursor_Set()
                if timing_Sig_Change_Possible == false{timing_Sig_Change_Possible = true}
                viableSetHelpers.writeNote(note_Y_Param: curr_Data_Pos_Y)
                if viableSetHelpers.initial_WriteOnCell != nil {
                    viableSetHelpers.initial_WriteOnCell = nil
                }
            }
        }
    }
    
    var viableSetHelpers : Viable_Set_Helper_Functions
    
    public init(){
        curr_Data_Pos_X = 0
        curr_Data_Pos_Y = 0
        viableSetHelpers = Viable_Set_Helper_Functions()
        
        let currLine = data_Grid.dataLineArray[curr_Data_Pos_Y]
        
        for cell in currLine.dataCellArray {
            viableSetHelpers.current_Cell_Line_Set.insert(cell)
        }
        
    }
    
    public func postInitSetup(){
        viableSetHelpers.establish_Cursor_Set()
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

    public var toggleWrite_Gesture_Springy : some Gesture {
      DragGesture(minimumDistance: 0, coordinateSpace: .local)
      .onChanged { val in
          if self.writingIsOn == false{self.writingIsOn=true}
      }
      .onEnded { val in
          if self.writingIsOn == true{self.writingIsOn=false}
      }
    }
    
    public var toggleWrite_Gesture_Sticky : some Gesture {
        TapGesture(count: 1).onEnded({
            if self.a_Note_Is_Highlighted == false {
                self.writingIsOn.toggle()
            }
        })
    }
    
    public var Deactivate_Write_Tap_Gesture : some Gesture {
        TapGesture(count: 1).onEnded({
            self.writingIsOn = false
        })
    }
    
    public var Activate_Write_Tap_Gesture : some Gesture {
        TapGesture(count: 1).onEnded({
            self.writingIsOn = true
        })
    }
    
    public var delete_Note_Tap_Gesture : some Gesture {
        TapGesture(count: 1).onEnded({
            self.deleteANote()
            if self.writingIsOn {
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

    func cursor_Slider_Update(){
        centralState_Data_Evaluation()
        
        if writingIsOn == true {viableSetHelpers.establish_Potential_Cells_Set()}
    }
    
    func centralState_Data_Evaluation(){

        curr_Data_Pos_Y = currentYCursor_Slider_Position + lower_Bracket_Number
        
        if dimensions.patternTimingConfiguration == .fourFour{
            viableSetHelpers.helperFuncs_currentData = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentFourFourDataIndex]
            curr_Data_Pos_X = dimensions.currentFourFourDataIndex
        }
        else if dimensions.patternTimingConfiguration == .sixEight {
            viableSetHelpers.helperFuncs_currentData = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentSixEightDataIndex]
            curr_Data_Pos_X = dimensions.currentSixEightDataIndex
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
