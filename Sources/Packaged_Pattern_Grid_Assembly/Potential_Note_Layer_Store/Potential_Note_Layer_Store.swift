//
//  File.swift
//  
//
//  Created by Jon on 19/11/2022.
//

import Foundation
import SwiftUI

public class Potential_Note_Layer_Store : ObservableObject {
    
    let dimensions = ComponentDimensions.StaticDimensions
    
    @Published public var x_Offset : CGFloat = 0
    @Published public var weeedth : CGFloat = 0
    @Published public var y_Offset : CGFloat = 0

    var potential_Initial_Grid_X : Int?{didSet{print("potential_Initial_Grid_X")}}
    var potential_Initial_Grid_Y : Int?{didSet{print("potential_Initial_Grid_Y")}}
    var potential_Current_Grid_X : Int?{didSet{print("potential_Current_Grid_X")}}
    
    public init(){}
    
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
        
        if let lclInitialX = potential_Initial_Grid_X,let initialY = potential_Initial_Grid_Y,let currX = potential_Current_Grid_X {
            
            if lclInitialX <= currX {
                x_Offset = dimensions.cursor_X_Jump * CGFloat(lclInitialX)
                weeedth = (dimensions.cursor_X_Jump * CGFloat(currX)) - dimensions.cursor_X_Jump * CGFloat(lclInitialX)
                y_Offset = dimensions.cursor_Y_Jump * CGFloat(initialY)
            }
            else if lclInitialX > currX {
                x_Offset = dimensions.cursor_X_Jump * CGFloat(currX)
                weeedth = (dimensions.cursor_X_Jump * CGFloat(lclInitialX)) - dimensions.cursor_X_Jump * CGFloat(currX)
                y_Offset = dimensions.cursor_Y_Jump * CGFloat(initialY)
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

}

//struct Potential_Note_Layer_View : View {
//    @ObservedObject var potential_Note_Layer_Store : Potential_Note_Layer_Store<VariableWidthRecView>
//    var body: some View {
//        potential_Note_Layer_Store.currView()
//        .offset(x:potential_Note_Layer_Store.x_Offset,y:potential_Note_Layer_Store.y_Offset)
//    }
//}

//struct Default_Potential_Note_View : View {
//    
//    @ObservedObject var potential_Note_Layer_Store : Potential_Note_Layer_Store
//    let dimensions = ComponentDimensions.StaticDimensions
//    let colors = ComponentColors.StaticColors
//    
//    var body: some View {
//        ZStack(alignment: .topLeading){
//            Rectangle()
//                .frame(width: potential_Note_Layer_Store.weeedth ,height: dimensions.pattern_Grid_Unit_Height)
//                .foregroundColor(colors.potentialColor)
//                .offset(x:potential_Note_Layer_Store.x_Offset,y:potential_Note_Layer_Store.y_Offset)
//        }
//    }
//}
