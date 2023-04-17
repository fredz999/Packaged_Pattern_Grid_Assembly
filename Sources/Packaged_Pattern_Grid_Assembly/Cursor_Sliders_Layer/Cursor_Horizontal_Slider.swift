//
//  File.swift
//  
//
//  Created by Jon on 17/11/2022.
//

import Foundation
import SwiftUI

// I think I can take these generics oot and use the default ones
// then in the generic assembly decide at runtime whether or not to use the injected factory methods
public class Cursor_Horizontal_Slider_Store : ObservableObject {

    public let central_State_Ref : Central_State
    
    public let dimensions = ComponentDimensions.StaticDimensions
    
    @Published public var computedLineDisplacement: CGFloat = 0
    
    @Published public var accumulatedDrag : CGFloat = 0
    
    @Published public var currentVal : CGFloat = 0 {
        didSet {
            calculateCursorCellXPos()
        }
    }
    
    public var slideDragGesture : some Gesture {
      DragGesture(minimumDistance: 0, coordinateSpace: .local)
      .onChanged { val in
          self.handleDrag(inputParam: val.translation.width)
      }
      .onEnded { val in
          self.handleDragEnd(inputParam: self.currentVal)
      }
    }
    
    public init(central_State_Param: Central_State){
        central_State_Ref = central_State_Param
    }
    
    public func handleDrag(inputParam:CGFloat){
        
        if (inputParam + accumulatedDrag) <= (dimensions.potential_Note_Rightward_Boundary),(inputParam + accumulatedDrag) >= dimensions.potential_Note_Leftward_Boundary {
            currentVal = inputParam + accumulatedDrag
        }
        else if (inputParam + accumulatedDrag) > (dimensions.potential_Note_Rightward_Boundary) {
            currentVal = (dimensions.potential_Note_Rightward_Boundary)
        }
        else if (inputParam + accumulatedDrag) < dimensions.potential_Note_Leftward_Boundary {
            currentVal = dimensions.potential_Note_Leftward_Boundary
        }
    }
    
    public func jumpToACell(cellNum:Int){
        let proposedNewVal = CGFloat(cellNum)*dimensions.pattern_Grid_Sub_Cell_Width
        if accumulatedDrag != proposedNewVal{
            accumulatedDrag = proposedNewVal
            currentVal = accumulatedDrag
        }
        
    }
    
    public func handleDragEnd(inputParam:CGFloat){
        accumulatedDrag = inputParam
    }
    
    public func calculateCursorCellXPos(){
        test_X_Position(currValParam: currentVal, computedLineParam: &computedLineDisplacement)
    }
    
    func test_X_Position(currValParam:CGFloat,computedLineParam:inout CGFloat){

        let lesserSetFourFour = dimensions.four_Four_Slider_Positions.filter{$0.x_Position_Float <= currValParam}
        let lesserSetSixEight = dimensions.six_Eight_Slider_Positions.filter{$0.x_Position_Float <= currValParam}
        let lesserSetSingleCell = dimensions.single_Cell_Slider_Positions.filter{$0.x_Position_Float <= currValParam}

        if let lclMaxLesserFour = lesserSetFourFour.max(by:{$0.x_Position_Int < $1.x_Position_Int}) {
            
            if lclMaxLesserFour.x_Position_Float != dimensions.currentFourFourPosition{
                dimensions.currentFourFourPosition = lclMaxLesserFour.x_Position_Float
            }
            if lclMaxLesserFour.x_Position_Int != dimensions.currentFourFourDataIndex {
                dimensions.currentFourFourDataIndex = lclMaxLesserFour.x_Position_Int
            }
            
        }
        if let lclMaxLesserSix = lesserSetSixEight.max(by:{$0.x_Position_Int < $1.x_Position_Int}) {
            if lclMaxLesserSix.x_Position_Float != dimensions.currentSixEightPosition{dimensions.currentSixEightPosition = lclMaxLesserSix.x_Position_Float}
            if lclMaxLesserSix.x_Position_Int != dimensions.currentSixEightDataIndex{dimensions.currentSixEightDataIndex = lclMaxLesserSix.x_Position_Int}
        }
        if let lclMaxLesserSingleCell = lesserSetSingleCell.max(by:{$0.x_Position_Int < $1.x_Position_Int}) {
            if lclMaxLesserSingleCell.x_Position_Float != dimensions.currentSingleCellPosition{dimensions.currentSingleCellPosition = lclMaxLesserSingleCell.x_Position_Float}
            if lclMaxLesserSingleCell.x_Position_Int != dimensions.currentSingleCellDataIndex{dimensions.currentSingleCellDataIndex = lclMaxLesserSingleCell.x_Position_Int}
        }
        //do the single cell position in here then figure out how this relates to the setting of the currentData in central
        // see then how to have simultaneous 1: cursor positions and 2: current single cell to ensure selection of all notes is possible
        // because the basic mechanism of this is that the line pos and cursor pos are set in the same func
        // and the selected data is the cursors minimum
        // cant explain the count diff in thingy....actually its cyclical depending on the four four and six eight
        // raising the question how come six eight has 96?
        

        
        
        if dimensions.patternTimingConfiguration == .fourFour {
//            if computedLineParam != dimensions.currentFourFourPosition{
//                computedLineParam = dimensions.currentFourFourPosition
//                central_State_Ref.cursor_Slider_Update()
//            }
            //computedLineParam = currValParam
            computedLineParam = dimensions.currentSingleCellPosition
            central_State_Ref.cursor_Slider_Update()
        }
        else if dimensions.patternTimingConfiguration == .sixEight {
//            if computedLineParam != dimensions.currentSixEightPosition {
//                computedLineParam = dimensions.currentSixEightPosition
//                central_State_Ref.cursor_Slider_Update()
//            }
            //computedLineParam = currValParam
            computedLineParam = dimensions.currentSingleCellPosition
            central_State_Ref.cursor_Slider_Update()
        }
        
    }
    
}
