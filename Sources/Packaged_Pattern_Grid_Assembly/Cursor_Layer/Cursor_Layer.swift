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
    var dataCell : Underlying_Data_Cell   //= Underlying_Data_Grid.Static_Underlying_Data_Grid
    let dimensions = ComponentDimensions.StaticDimensions
    let colors = ComponentColors.StaticColors
    
    @Published public var offsetSize : CGSize = CGSize(width: 0, height: 0)
    @Published public var height : CGFloat
    @Published public var cursorLayerCellColor : Color
    @Published public var cursorText = ""
    
    @Published public var viableRegionStart : CGFloat = 0
    @Published public var viableRegionWidth : CGFloat = 0
    
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
        dataCell = Underlying_Data_Grid.Static_Underlying_Data_Grid.dataLineArray[0].dataCellArray[0]
        set_Cursor_Pos(xInt:0,yInt:0)
    }
    
    public func setViableRegionMarker(lowerXParam:CGFloat,upperXParam:CGFloat){
        viableRegionStart = lowerXParam
        if upperXParam - lowerXParam >= 0 {
            viableRegionWidth = upperXParam - lowerXParam
        }
    }
    
    func set_Cursor_Pos(xInt:Int,yInt:Int){
        print("xInt: ",xInt.description,", yInt: ",yInt.description)
        let floatX = CGFloat(xInt)
        let floatY = CGFloat(yInt)
        let xVal = floatX*dimensions.cursor_X_Jump
        let yVal = floatY*dimensions.cursor_Y_Jump
        offsetSize = CGSize(width: xVal, height: yVal)
    }

    public func set_Cursor_Data(dataX:Int,dataY:Int){
        currDataX = dataX
        currDataY = dataY
        dataCell = Underlying_Data_Grid.Static_Underlying_Data_Grid.dataLineArray[dataY].dataCellArray[dataX]
//        let fourPos = ",fourPos: " + dataCell.four_Four_Sub_Index.description + ", four4CellIndex: " + dataCell.four_Four_Cell_Index.description
//        let sixPos =  ",sixPos: " + dataCell.six_Eight_Sub_Index.description + ", six8CellIndex: " + dataCell.six_Eight_Cell_Index.description
//        cursorText = dataX.description + ", " + dataY.description + fourPos + sixPos
        //print(cursorText)
    }
    
}
