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
    
    @Published public var writingIsOn : Bool = false {
        didSet {
            if writingIsOn == true {

                if viableSetHelpers.initial_WriteOnCell == nil {
                    viableSetHelpers.initial_WriteOnCell = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentFourFourDataIndex]
                    viableSetHelpers.establish_Potential_Cells_Set()
                }

            }
            else if writingIsOn == false {
                viableSetHelpers.writeNote(note_Y_Param: curr_Data_Pos_Y)
                viableSetHelpers.inViableCellsLeft.removeAll()
                viableSetHelpers.inViableCellsRight.removeAll()
                viableSetHelpers.in_Swipe_Inviables.removeAll()
                if viableSetHelpers.currentSwipeDirection != nil {
                    viableSetHelpers.currentSwipeDirection = nil
                }
                
                if viableSetHelpers.initial_WriteOnCell != nil {
                    viableSetHelpers.initial_WriteOnCell = nil
                }

                if let lclCursorRef = cursor_Layer_Ref {
                    lclCursorRef.cursorLayerCellColor = colors.cursorNotWriting
                }
                
            }
            
        }
    }
    
    var viableSetHelpers : Viable_Set_Helper_Functions
    
    public init(){
        
        viableSetHelpers = Viable_Set_Helper_Functions()
        
        
        let currLine = data_Grid.dataLineArray[curr_Data_Pos_Y]
        
        for cell in currLine.dataCellArray{
            viableSetHelpers.current_Cell_Line_Set.insert(cell)
        }
        
        viableSetHelpers.establish_Viable_Cells_Set()
        
    }
    
    public func change_Timing_Signature_Central(){

    
//    else if dimensions.patternTimingConfiguration == .sixEight {
//        if viableSetHelpers.helperFuncs_currentData.four_Four_Half_Sub_Index == 1{
//            if let lclH_SliderRef = h_Slider_Ref{
//                lclH_SliderRef.artificially_H_Decrement(numberOfCells: 1)
//                print("set to 4:4, 4:$ sub half index shifted from 1 to : ",viableSetHelpers.helperFuncs_currentData.four_Four_Half_Sub_Index.description)
//            }
//        }
//        else if viableSetHelpers.helperFuncs_currentData.four_Four_Half_Sub_Index == 2 {
//            if let lclH_SliderRef = h_Slider_Ref{
//                lclH_SliderRef.artificially_H_Decrement(numberOfCells: 2)
//                print("set to 4:4, 4:$ sub half index shifted from 2 to : ",viableSetHelpers.helperFuncs_currentData.four_Four_Half_Sub_Index.description)
//            }
//        }
//    }
        
//    if dimensions.patternTimingConfiguration == .fourFour {
//        print("currdata six_Eight_Half_Sub_Index : ",viableSetHelpers.helperFuncs_currentData.six_Eight_Half_Sub_Index.description)
//        if viableSetHelpers.helperFuncs_currentData.six_Eight_Half_Sub_Index == 1 {
//            if let lclH_SliderRef = h_Slider_Ref {
//                lclH_SliderRef.artificially_H_Decrement(numberOfCells: 1)
//                print("set to 6:8, sub half index shifted from1 to : ",viableSetHelpers.helperFuncs_currentData.six_Eight_Half_Sub_Index.description)
//            }
//            else if h_Slider_Ref == nil {
//                print("h_Slider_Ref == nil .........")
//            }
//        }
//    }
        
//    if let lclH_SliderRef = h_Slider_Ref {
//        lclH_SliderRef.jumpToACell(cellNum: 20)
//    }
 

    dimensions.flip_Timing_Signature_Dimensions()

    data_Grid.changeTimingSignature_Data_Level()
        
    

    
    // there is a discrepancy here that both troubles and baffles me
    // print("viable eeX: ",viableSetHelpers.helperFuncs_currentData.dataCell_X_Number.description," hslider currentVal: ",h_Slider_Ref?.computedLineDisplacement.description  )
    // you have to do it here this is AMAZINGLY bad programming
    // because of the line of functions it
    // has to go from setting the hslider pos which triggers calc cursor xpos in the hslider which
    // triggers this classes cursor_Slider_Update which changes viableSetHelpers.helperFuncs_currentData
    // this is really all over the place
    // the trouble is that the cursor x jump gets set in this func
    // then it gets utilised again when you manually alter the position - it has to
    // cursor_Slider_Update(new_X: intDivided, new_Y: nil)
        


        
    }

    public func deleteANote(){
        if let lclNoteCollection = note_Collection_Ref {
            lclNoteCollection.reset_Note_Data_Cells()
            a_Note_Is_Highlighted = false
        }
    }
    
    //var cellNumberMultiplier : Int = 2
    var currentYCursor_Slider_Position : Int = 0
   // var currentXCursor_Slider_Position : Int = 0
    //var computedXCursor_Slider_Position : Int = 0
    // need a position and datanumber pair
    var currentXData_Position : Int = 0
    
    func cursor_Slider_Update(new_X:Int?=nil,new_Y:Int?=nil){
        //if let lcl_NewX = new_X {
            //currentXCursor_Slider_Position = lcl_NewX
            centralState_Data_Evaluation()
            //centralState_Cursor_Position_Evaluation()
            viableSetHelpers.establish_Viable_Cells_Set()
            if writingIsOn == true {
            viableSetHelpers.establish_Potential_Cells_Set()
            }
        //}
        if let lclNew_Y = new_Y {
            currentYCursor_Slider_Position = lclNew_Y
            centralState_Data_Evaluation()
            //centralState_Cursor_Position_Evaluation()
            viableSetHelpers.establish_Viable_Cells_Set()
            if writingIsOn == true {
            viableSetHelpers.establish_Potential_Cells_Set()
            }
        }
    }
    
//    func centralState_Cursor_Position_Evaluation() {
//        if let lclCursorLayer = cursor_Layer_Ref {
//            lclCursorLayer.set_Cursor_Pos(xInt: currentXCursor_Slider_Position, yInt: currentYCursor_Slider_Position)
//        }
//    }
    
    func centralState_Data_Evaluation(){
            
        if let lclCursorLayer = cursor_Layer_Ref {
             
            //lclCursorLayer.currPosX = computedXCursor_Slider_Position
            
            curr_Data_Pos_Y = currentYCursor_Slider_Position + lower_Bracket_Number

            viableSetHelpers.helperFuncs_currentData = data_Grid.dataLineArray[curr_Data_Pos_Y].dataCellArray[dimensions.currentFourFourDataIndex]
            print("Data Y: ",curr_Data_Pos_Y.description,",X: ",dimensions.currentFourFourDataIndex.description)
            lclCursorLayer.currPosY = curr_Data_Pos_Y
            
            if lclCursorLayer.currPosY < data_Grid.dataLineArray.count, lclCursorLayer.currPosX < dimensions.dataGrid_X_Unit_Count {
                
                lclCursorLayer.set_Cursor_Data(dataX: lclCursorLayer.currPosX, dataY: lclCursorLayer.currPosY)
                
                if let lclNote = data_Grid.dataLineArray[lclCursorLayer.currPosY].dataCellArray[lclCursorLayer.currPosX].note_Im_In {
                    if let lclNoteCollection = note_Collection_Ref {
                        lclNoteCollection.note_Collection_Highlight_Handler(noteParam: lclNote)
                    }
                }
                else if data_Grid.dataLineArray[lclCursorLayer.currPosY].dataCellArray[lclCursorLayer.currPosX].note_Im_In == nil {
                    if let lclNoteCollection = note_Collection_Ref {
                        lclNoteCollection.note_Collection_Highlight_Handler(noteParam: nil)
                    }
                }
                
            }

        }
    }
    
    var curr_Data_Pos_Y : Int = 0{
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
    
    public func toggle_Write_Is_On(){
        if a_Note_Is_Highlighted == false {
            writingIsOn.toggle()
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

public enum E_Note_Movement_Type{
    case leftWard
    case rightWard
    case upward
    case downward
}

class Cell_X_Descriptor : Equatable,Hashable{
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


//public static func == (lhs: Underlying_Data_Cell, rhs: Underlying_Data_Cell) -> Bool {
//    lhs.id == rhs.id
//}
//
//public func hash(into hasher: inout Hasher) {
//    hasher.combine(id)
//}
//
//public var id = UUID()
