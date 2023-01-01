//
//  File.swift
//  
//
//  Created by Jon on 18/11/2022.
//

import Foundation
import SwiftUI

public class Cursor_Layer_Store : ObservableObject {
    let centralState = Central_State.Static_Central_State
    let dimensions = ComponentDimensions.StaticDimensions
    let colors = ComponentColors.StaticColors
    
    @Published public var offsetSize : CGSize = CGSize(width: 0, height: 0)
    @Published public var height : CGFloat
    @Published public var cursorLayerCellColor : Color
    @Published public var cursorText = ""
    
    var currDataX : Int
    var currDataY : Int
    
    var currPosX : Int
    var currPosY : Int
    
    public init(){
        height = dimensions.pattern_Grid_Unit_Height
        cursorLayerCellColor = colors.cursorNotWriting
        currDataX = 0
        currDataY = 0
        currPosX = 0
        currPosY = 0
        set_Cursor_Pos(xInt:0,yInt:0)
    }
    
    func set_Cursor_Pos(xInt:Int,yInt:Int){
        let floatX = CGFloat(xInt)
        let floatY = CGFloat(yInt)
        let xVal = floatX*dimensions.cursor_X_Jump
        let yVal = floatY*dimensions.cursor_Y_Jump
        offsetSize = CGSize(width: xVal, height: yVal)
    }

    public func set_Cursor_Data(dataX:Int,dataY:Int){
        currDataX = dataX
        currDataY = dataY
        cursorText = dataX.description+","+dataY.description
    }
    
}
