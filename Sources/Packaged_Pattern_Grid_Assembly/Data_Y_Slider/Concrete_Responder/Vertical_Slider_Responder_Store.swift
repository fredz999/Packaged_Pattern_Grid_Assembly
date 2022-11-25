//
//  File.swift
//  
//
//  Created by Jon on 25/11/2022.
//

import Foundation
import SwiftUI
import Combine

class Vertical_Slider_Responder_Store : ObservableObject, P_VSlider_Responder {
    let centralState = Central_State.Static_Central_State
    let dimensions = ComponentDimensions.StaticDimensions
    
    var trackedInt : Int {
        didSet {
            centralState.data_Slider_LowBracket_Update(newLower: trackedInt)
        }
    }
    
    init(){
        trackedInt = 0
    }

    func react_To_Swiper_Y(y_OffsetParam: CGFloat) {
        let bracketFloat = y_OffsetParam/dimensions.ui_Unit_Height
        let bracketInt = Int(bracketFloat)
        if bracketInt != trackedInt, bracketInt >= 0, bracketInt <= dimensions.DATA_final_Line_Y_Index {
            trackedInt = bracketInt
        }
        else if bracketInt < 0,trackedInt != 0{trackedInt = 0}
        else if bracketInt > dimensions.DATA_final_Line_Y_Index
        , trackedInt != dimensions.DATA_final_Line_Y_Index{trackedInt = dimensions.DATA_final_Line_Y_Index}
    }
    
    func return_NewLowerY()->Int{
        return trackedInt
    }

}
