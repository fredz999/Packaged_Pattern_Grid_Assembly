//
//  File.swift
//  
//
//  Created by Jon on 19/11/2022.
//

import Foundation
import SwiftUI

class Potential_Note_Layer_Store<InjectedPotentialView:View> : ObservableObject {
    
    let dimensions = ComponentDimensions.StaticDimensions
    
    @Published var x_Offset : CGFloat = 0
    @Published var weeedth : CGFloat = 0
    @Published var y_Offset : CGFloat = 0

    var potential_Initial_Grid_X : Int?
    var potential_Initial_Grid_Y : Int?
    var potential_Current_Grid_X : Int?
    
    func handlePotentialWrite(gridXParam:Int,gridYParam:Int) {
        
        if potential_Initial_Grid_X == nil, potential_Initial_Grid_Y == nil {
            potential_Initial_Grid_X = gridXParam
            potential_Initial_Grid_Y = gridYParam
        }
        else if potential_Initial_Grid_X != nil, potential_Initial_Grid_Y != nil {
            if potential_Initial_Grid_Y == gridYParam,gridXParam != potential_Current_Grid_X {
                potential_Current_Grid_X = gridXParam
                set_Potential_Note_Dimensions()
            }
            else if potential_Initial_Grid_Y != gridYParam {
                potential_Initial_Grid_X = gridXParam
                potential_Current_Grid_X = gridXParam
                potential_Initial_Grid_Y = gridYParam
                set_Potential_Note_Dimensions()
            }
        }
    }
    
    func set_Potential_Note_Dimensions(){
        print("set_Potential_Note_Dimensions()")
        if let lclInitialX = potential_Initial_Grid_X,let initialY = potential_Initial_Grid_Y,let currX = potential_Current_Grid_X {
            
            if lclInitialX <= currX {
                x_Offset = dimensions.pattern_Grid_Unit_Width * CGFloat(lclInitialX)
                weeedth = (dimensions.pattern_Grid_Unit_Width * CGFloat(currX+1)) - dimensions.pattern_Grid_Unit_Width * CGFloat(lclInitialX)
                y_Offset = dimensions.pattern_Grid_Unit_Height * CGFloat(initialY)
            }
            else if lclInitialX > currX {
                x_Offset = dimensions.pattern_Grid_Unit_Width * CGFloat(currX)
                weeedth = (dimensions.pattern_Grid_Unit_Width * CGFloat(lclInitialX+1)) - dimensions.pattern_Grid_Unit_Width * CGFloat(currX)
                y_Offset = dimensions.pattern_Grid_Unit_Height * CGFloat(initialY)
            }
            
        }
    }
    
    @Published var NoteIsValid : Bool = true
    
    func endPotentialNote(){
        
        potential_Initial_Grid_X = nil
        potential_Current_Grid_X = nil
        potential_Initial_Grid_Y = nil
        
        x_Offset = 0
        weeedth = 0
        y_Offset = 0

    }
    
    var injected_Potential_View : InjectedPotentialView?
//    @ViewBuilder func currView()->(some View){
//        injected_Potential_View
//    }

}

//struct Potential_Note_Layer_View : View {
//    @ObservedObject var potential_Note_Layer_Store : Potential_Note_Layer_Store<VariableWidthRecView>
//    var body: some View {
//        potential_Note_Layer_Store.currView()
//        .offset(x:potential_Note_Layer_Store.x_Offset,y:potential_Note_Layer_Store.y_Offset)
//    }
//}

struct VariableWidthRecView : View {
    let dimensions = ComponentDimensions.StaticDimensions
    let colors = ComponentColors.StaticColors
    @ObservedObject var potential_Note_Layer_Store : Potential_Note_Layer_Store<VariableWidthRecView>
    var body: some View {
        Rectangle().frame(width: potential_Note_Layer_Store.weeedth ,height: dimensions.pattern_Grid_Unit_Height).foregroundColor(colors.potentialColor)
    }
}
