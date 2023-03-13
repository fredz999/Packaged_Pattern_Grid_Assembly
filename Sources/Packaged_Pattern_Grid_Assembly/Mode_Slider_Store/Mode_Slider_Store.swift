//
//  Mode_Slider_Store.swift
//  
//
//  Created by Jon on 13/03/2023.
//

import Foundation
import SwiftUI
import Combine

// this is intended to house the gesture reader that will be used to make the
// modeslider useable. the mode slider will allow for switching between
// passive, write , delete, move, select
// im thinking this should have a gearing of 2x user input to make the slide really quick
// this should be alot like the
public class Mode_Slider_Store {
    
    public let central_State_Ref : Central_State
    
    public let dimensions = ComponentDimensions.StaticDimensions
    
    @Published public var computedLineDisplacement: CGFloat = 0
    
    @Published public var accumulatedDrag : CGFloat = 0
    
    @Published public var currentVal : CGFloat = 0 {
        didSet {
            calculateCursorCellXPos()
        }
    }
    
    var multy : CGFloat = 2
    
    public var slideDragGesture : some Gesture {
      DragGesture(minimumDistance: 0, coordinateSpace: .local)
      .onChanged { val in
          self.handleDrag(inputParam: (val.translation.width)*self.multy)
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
        accumulatedDrag = CGFloat(cellNum)*dimensions.pattern_Grid_Sub_Cell_Width
        currentVal = accumulatedDrag
    }
    
    public func handleDragEnd(inputParam:CGFloat){
        accumulatedDrag = inputParam
    }
    
    public func calculateCursorCellXPos(){
        
        //dimensions.test_X_Position(currValParam: currentVal, computedLineParam: &computedLineDisplacement)
        //central_State_Ref.cursor_Slider_Update()
            //.cursor_Slider_Update(new_X: nil , new_Y: nil)
    }
    
//    func test_X_Position(currValParam:CGFloat,computedLineParam:inout CGFloat){
//
//        let lesserSetFourFour = dimensions.four_Four_Slider_Positions.filter{$0.x_Position_Float <= currValParam}
//
//        if let lclMaxLesserFour = lesserSetFourFour.max(by:{$0.x_Position_Int < $1.x_Position_Int}) {
//            if lclMaxLesserFour.x_Position_Float !=
//                dimensions.currentFourFourPosition{dimensions.currentFourFourPosition = lclMaxLesserFour.x_Position_Float}
//            if lclMaxLesserFour.x_Position_Int !=
//                dimensions.currentFourFourDataIndex{dimensions.currentFourFourDataIndex = lclMaxLesserFour.x_Position_Int}
//        }
//
//        let lesserSetSixEight = dimensions.six_Eight_Slider_Positions.filter{$0.x_Position_Float <= currValParam}
//
//        if let lclMaxLesserSix = lesserSetSixEight.max(by:{$0.x_Position_Int < $1.x_Position_Int}) {
//            if lclMaxLesserSix.x_Position_Float !=
//                dimensions.currentSixEightPosition{dimensions.currentSixEightPosition = lclMaxLesserSix.x_Position_Float}
//            if lclMaxLesserSix.x_Position_Int !=
//                dimensions.currentSixEightDataIndex{dimensions.currentSixEightDataIndex = lclMaxLesserSix.x_Position_Int}
//        }
//
//        if dimensions.patternTimingConfiguration == .fourFour {
//            if computedLineParam != dimensions.currentFourFourPosition{
//                computedLineParam = dimensions.currentFourFourPosition
//                central_State_Ref.cursor_Slider_Update()
//            }
//        }
//
//        else if dimensions.patternTimingConfiguration == .sixEight {
//            if computedLineParam != dimensions.currentSixEightPosition {
//                computedLineParam = dimensions.currentSixEightPosition
//                central_State_Ref.cursor_Slider_Update()
//            }
//        }
//
//    }
    
    
}
