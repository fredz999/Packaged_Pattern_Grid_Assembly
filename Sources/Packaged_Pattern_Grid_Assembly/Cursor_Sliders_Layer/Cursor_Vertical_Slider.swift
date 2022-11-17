//
//  File.swift
//  
//
//  Created by Jon on 17/11/2022.
//

import Foundation
import SwiftUI

public struct Default_Cursor_Vertical_Slider_View : View {
    let dimensions = ComponentDimensions.StaticDimensions
    let colors = ComponentColors.StaticColors
    @ObservedObject var cursor_Vertical_Slider_Store : Cursor_Vertical_Slider_Store<V_Slider_View_External,V_Slider_Line_View_External>
    
    
    public var body: some View {
        return ZStack(alignment: .topLeading) {
            cursor_Vertical_Slider_Store.slider_View
            cursor_Vertical_Slider_Store.slider_Line_View.offset(x:-dimensions.Horz_Cursor_Slider_Width, y:cursor_Vertical_Slider_Store.computedLineDisplacement)
        }.gesture(cursor_Vertical_Slider_Store.slideDragGesture)
    }
}


public struct V_Slider_View_External : View {
    let dimensions = ComponentDimensions.StaticDimensions
    let colors = ComponentColors.StaticColors
    public var body : some View {
        Rectangle().frame(width: dimensions.Vert_Cursor_Slider_Width,height: dimensions.Vert_Cursor_Slider_Height)
        .foregroundColor(colors.cursorSwiperColor)
    }
}

public struct V_Slider_Line_View_External : View {
    let dimensions = ComponentDimensions.StaticDimensions
    let colors = ComponentColors.StaticColors
    public var body : some View {
        Rectangle().frame(width: dimensions.Vert_Cursor_Slider_Line_Width,height: dimensions.Vert_Cursor_Slider_Line_Height)
        .foregroundColor(colors.cursorSliderLineColor)
    }
}


public class Cursor_Vertical_Slider_Store<SliderView:View,SliderLineView:View>:ObservableObject{
    
    let centralState = Central_State.Static_Central_State
    
    let dimensions = ComponentDimensions.StaticDimensions
    
    @Published public var computedLineDisplacement: CGFloat = 0
    
    @Published public var accumulatedDrag : CGFloat = 0
    
    @Published public var currentVal : CGFloat = 0 {
        didSet {
            calculateCursorCellYPos()
        }
    }
    
    public var slider_View : SliderView
    
    public var slider_Line_View : SliderLineView
    
    public init(sliderParam:SliderView,sliderLineParam:SliderLineView){
        slider_View = sliderParam
        slider_Line_View = sliderLineParam
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
    
    public func calculateCursorCellYPos(){
        let divided = currentVal/dimensions.pattern_Grid_Unit_Height
        let intDivided = Int(divided)
        centralState.cursor_Slider_Update(new_X: nil, new_Y: intDivided)
        computedLineDisplacement = CGFloat(intDivided) * dimensions.pattern_Grid_Unit_Height
    }
    
}
