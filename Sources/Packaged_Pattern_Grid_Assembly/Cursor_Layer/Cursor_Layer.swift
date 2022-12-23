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
    //needs to be changeable
    //@Published public var width : CGFloat
    @Published public var height : CGFloat
    @Published public var cursorLayerCellColor : Color
    @Published public var cursorText = ""
    
    var currDataX : Int
    var currDataY : Int
    
    var currPosX : Int
    var currPosY : Int
    
    public init(){
        //width = dimensions.pattern_Grid_Unit_Width
        height = dimensions.pattern_Grid_Unit_Height
        cursorLayerCellColor = colors.cursorNotWriting
        currDataX = 0
        currDataY = 0
        currPosX = 0
        currPosY = 0
        set_Cursor_Pos(xInt:0,yInt:0)
    }
    
//    @ViewBuilder func currView()->(some View){
//        ZStack(alignment: .topLeading){
//            ZStack(alignment: .center){
//                Default_Cursor_Marker_View(cursor_Layer_Store: self)
//            }.offset(offsetSize)
//        }
//    }
    
    func set_Cursor_Pos(xInt:Int,yInt:Int){
        let floatX = CGFloat(xInt)
        let floatY = CGFloat(yInt)
        let xVal = floatX*dimensions.pattern_Grid_Unit_Width
        let yVal = floatY*dimensions.pattern_Grid_Unit_Height
        offsetSize = CGSize(width: xVal, height: yVal)
    }

    public func set_Cursor_Data(dataX:Int,dataY:Int){
        currDataX = dataX
        currDataY = dataY
        cursorText = dataX.description+","+dataY.description
    }
    
}

//struct Cursor_Layer_View : View {
//    @ObservedObject var cursor_Layer_Store : Cursor_Layer_Store
//    var body: some View {
//        return ZStack(alignment: .topLeading){
//            cursor_Layer_Store.currView()
//        }
//    }
//}

//struct Default_Cursor_Marker_View : View {
//    @ObservedObject var cursor_Layer_Store : Cursor_Layer_Store
//    var body: some View {
//        return ZStack(alignment: .topLeading){
//            ZStack(alignment: .center){
//                Rectangle().frame(width:cursor_Layer_Store.width,height:cursor_Layer_Store.height).foregroundColor(cursor_Layer_Store.cursorLayerCellColor)
//                Text(cursor_Layer_Store.cursorText).foregroundColor(.black)
//            }
//        }
//    }
//}
