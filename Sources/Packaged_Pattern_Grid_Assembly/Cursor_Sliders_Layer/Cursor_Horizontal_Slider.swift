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
    
    public let central_State_Ref = Central_State.Static_Central_State
    
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
    
    public init(){}
    
    public func handleDrag(inputParam:CGFloat){
        print("handleDrag(....")
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
        
    public func artificially_H_Increment(){

        accumulatedDrag += dimensions.cursor_X_Jump

        if (accumulatedDrag) <= (dimensions.initial_Right_Boundary),accumulatedDrag >= dimensions.initial_Left_Boundary{
            currentVal = accumulatedDrag
        }

        else if (accumulatedDrag) > (dimensions.potential_Note_Rightward_Boundary) {
            accumulatedDrag = (dimensions.potential_Note_Rightward_Boundary)
            currentVal = (dimensions.potential_Note_Rightward_Boundary)
        }

    }

    public func artificially_H_Decrement(){
        accumulatedDrag -= dimensions.cursor_X_Jump
        
        if (accumulatedDrag) <= (dimensions.initial_Right_Boundary),accumulatedDrag >= dimensions.initial_Left_Boundary {
            currentVal = accumulatedDrag
        }

        else if (accumulatedDrag) < 0 {
            accumulatedDrag = 0
            currentVal = 0
        }

    }
    
    public func handleDragEnd(inputParam:CGFloat){
        accumulatedDrag = inputParam
    }
    
    public func calculateCursorCellXPos(){
        let divided = currentVal/dimensions.cursor_X_Jump
        let intDivided = Int(divided)
        if intDivided != central_State_Ref.currentXCursor_Slider_Position {
            central_State_Ref.cursor_Slider_Update(new_X: intDivided, new_Y: nil)
        }
        computedLineDisplacement = CGFloat(intDivided) * dimensions.cursor_X_Jump
    }
    
}
