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
    
    public let centralState = Central_State.Static_Central_State
    
    public let dimensions = ComponentDimensions.StaticDimensions
    
//    public var slider_View : SliderView
//
//    public var slider_Line_View : SliderLineView
    
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
    
    
    //public init(sliderParam:SliderView,sliderLineParam:SliderLineView){
    public init(){
//        slider_View = sliderParam
//        slider_Line_View = sliderLineParam
    }
    
    public func handleDrag(inputParam:CGFloat){
        if (inputParam + accumulatedDrag) <= (dimensions.Horz_Cursor_Slider_Width-dimensions.pattern_Grid_Unit_Width),(inputParam + accumulatedDrag) >= 0 {
            currentVal = inputParam + accumulatedDrag
        }
        else if (inputParam + accumulatedDrag) > (dimensions.Horz_Cursor_Slider_Width-dimensions.pattern_Grid_Unit_Width) {
            currentVal = (dimensions.Horz_Cursor_Slider_Width-dimensions.pattern_Grid_Unit_Width)
        }
        else if (inputParam + accumulatedDrag) < 0 {
            currentVal = 0
        }
    }
        
    public func artificially_H_Increment(){
        
        accumulatedDrag += dimensions.pattern_Grid_Unit_Width

        if (accumulatedDrag) <= (dimensions.Horz_Cursor_Slider_Width-dimensions.pattern_Grid_Unit_Width),accumulatedDrag >= 0{
            currentVal = accumulatedDrag
        }

        else if (accumulatedDrag) > (dimensions.Horz_Cursor_Slider_Width-dimensions.pattern_Grid_Unit_Width) {
            accumulatedDrag = (dimensions.Horz_Cursor_Slider_Width-dimensions.pattern_Grid_Unit_Width)
            currentVal = (dimensions.Horz_Cursor_Slider_Width-dimensions.pattern_Grid_Unit_Width)
        }

    }

    public func artificially_H_Decrement(){
        accumulatedDrag -= dimensions.pattern_Grid_Unit_Width
        
        if (accumulatedDrag) <= (dimensions.Horz_Cursor_Slider_Width-dimensions.pattern_Grid_Unit_Width),(accumulatedDrag) >= 0 {
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
        let divided = currentVal/dimensions.pattern_Grid_Unit_Width
        let intDivided = Int(divided)
        centralState.cursor_Slider_Update(new_X: intDivided, new_Y: nil)
        computedLineDisplacement = CGFloat(intDivided) * dimensions.pattern_Grid_Unit_Width
    }
    
//    func moveCursorAndLineTo48Pos(pos48Param:Int){
//        let newGridPos = pos48Param/dimensions.pattern_Grid_Cell_Sub_Unit_Count
//        computedLineDisplacement = CGFloat(newGridPos) * dimensions.pattern_Grid_Unit_Width
//        centralState.cursor_Slider_Update(new_X: newGridPos, new_Y: nil)
//        
//        
//        //print("instructed to move to: ",newGridPos.description)
//    }
    
}
