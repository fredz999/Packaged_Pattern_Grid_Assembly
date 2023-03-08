//
//  File.swift
//  
//
//  Created by Jon on 17/11/2022.
//

import Foundation
import SwiftUI


public class Cursor_Vertical_Slider_Store:ObservableObject{
    
    public let central_State_Ref : Central_State
    
    let dimensions = ComponentDimensions.StaticDimensions
    
    @Published public var computedLineDisplacement: CGFloat = 0
    
    @Published public var accumulatedDrag : CGFloat = 0
    
    @Published public var currentVal : CGFloat = 0 {
        didSet {
            calculateCursorCellYPos()
        }
    }
    
    public init(central_State_Param : Central_State){
        central_State_Ref = central_State_Param
    }
    
    public var slideDragGesture : some Gesture {
      DragGesture(minimumDistance: 0, coordinateSpace: .local)
      .onChanged { val in
          self.handleDrag(inputParam: val.translation.height)
      }
      .onEnded { val in
          self.handleDragEnd(inputParam: self.currentVal)
      }
    }
    
    public func handleDrag(inputParam:CGFloat){
        if (inputParam + accumulatedDrag) <= (dimensions.Vert_Cursor_Slider_Height-dimensions.pattern_Grid_Unit_Height),(inputParam + accumulatedDrag) >= 0 {
            currentVal = inputParam + accumulatedDrag
        }
        else if (inputParam + accumulatedDrag) > (dimensions.Vert_Cursor_Slider_Height-dimensions.pattern_Grid_Unit_Height) {
            currentVal = (dimensions.Vert_Cursor_Slider_Height-dimensions.pattern_Grid_Unit_Height)
        }
        else if (inputParam + accumulatedDrag) < 0 {
            currentVal = 0
        }
    }
    
    public func artificially_V_Increment(){
        accumulatedDrag += dimensions.pattern_Grid_Unit_Height
        if (accumulatedDrag) <= (dimensions.Vert_Cursor_Slider_Height-dimensions.pattern_Grid_Unit_Height),(accumulatedDrag) >= 0 {
            currentVal = accumulatedDrag
        }
        else if (accumulatedDrag) > (dimensions.Vert_Cursor_Slider_Height-dimensions.pattern_Grid_Unit_Height) {
            accumulatedDrag = (dimensions.Vert_Cursor_Slider_Height-dimensions.pattern_Grid_Unit_Height)
            currentVal = (dimensions.Vert_Cursor_Slider_Height-dimensions.pattern_Grid_Unit_Height)
        }
        calculateCursorCellYPos()
    }
    
    public func artificially_V_Decrement(){
        accumulatedDrag -= dimensions.pattern_Grid_Unit_Height
        if (accumulatedDrag) <= (dimensions.Vert_Cursor_Slider_Height-dimensions.pattern_Grid_Unit_Height),(accumulatedDrag) >= 0 {
            currentVal = accumulatedDrag
        }
        else if (accumulatedDrag) < 0 {
            accumulatedDrag = 0
            currentVal = 0
        }
        calculateCursorCellYPos()
    }
        
    public func handleDragEnd(inputParam:CGFloat){
        accumulatedDrag = inputParam
    }
    
//    public func calculateCursorCellYPos(){
//        let divided = currentVal/dimensions.pattern_Grid_Unit_Height
//        let intDivided = Int(divided)
//        if intDivided != centralState.currentYCursor_Slider_Position{
//            centralState.cursor_Slider_Update(new_X: nil, new_Y: intDivided)
//        }
//        computedLineDisplacement = CGFloat(intDivided) * dimensions.pattern_Grid_Unit_Height
//    }
    public func calculateCursorCellYPos(){
        //dimensions.test_Y_Position(currValParam: currentVal, computedLineParam: &computedLineDisplacement)
        //central_State_Ref.cursor_Slider_Update(new_X: nil , new_Y: nil)
        test_Y_Position(currValParam: currentVal, computedLineParam: &computedLineDisplacement)
    }
    
    func test_Y_Position(currValParam:CGFloat,computedLineParam:inout CGFloat){
        let divided = currValParam/dimensions.pattern_Grid_Unit_Height
        let intDivided = Int(divided)
        if intDivided != central_State_Ref.currentYCursor_Slider_Position {
            central_State_Ref.currentYCursor_Slider_Position = intDivided
            central_State_Ref.cursor_Slider_Update()
            computedLineParam = CGFloat(intDivided) * dimensions.pattern_Grid_Unit_Height
        }
    }
    
}
