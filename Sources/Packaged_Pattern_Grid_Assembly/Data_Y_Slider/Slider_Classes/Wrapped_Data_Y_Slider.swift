//
//  File.swift
//  
//
//  Created by Jon on 18/04/2023.
//

import Foundation
import SwiftUI
import UIKit

public class Wrapped_Data_Y_Slider<T:View> {

    let dimensions = ComponentDimensions.StaticDimensions
    var generic_Slider_Responder_Store : Generic_Slider_Responder_Store
    var generic_Slider_coordinator : Data_Y_Slider_Coordinator<T>

    public init(coordParam : Data_Y_Slider_Coordinator<T>,centralStateParam:Central_State) {
        self.generic_Slider_Responder_Store = Generic_Slider_Responder_Store(centralStateParam: centralStateParam)
        self.generic_Slider_coordinator = coordParam
        self.generic_Slider_coordinator.addResponder(responderParam: self.generic_Slider_Responder_Store)
        setupCoordinator()
    }

    func setupCoordinator(){
        self.generic_Slider_coordinator.parentWrapper = self
    }

    @ViewBuilder func yield_A_Cell() -> some View {
        if injectedCellFactoryMethod == nil {
            Default_UICollection_Cell_Overlay()
        }
        else if let lclInjectedMethod = injectedCellFactoryMethod {
            lclInjectedMethod("spell")
        }
    }

    public func inject_Cell_Factory_Method(cell_Factory_Method:@escaping ((String)->T)){
        injectedCellFactoryMethod = cell_Factory_Method
    }

    var injectedCellFactoryMethod : ((String)->T)?

    deinit{
        if injectedCellFactoryMethod != nil{injectedCellFactoryMethod=nil}
    }

}

struct Default_UICollection_Cell_Overlay : View {
    var body: some View {
        return ZStack(alignment: .topLeading){
            Rectangle().frame(width: 30,height: 30).foregroundColor(Color(red: 0, green: 0, blue: 0.6))
            Rectangle().frame(width: 30,height: 1).foregroundColor(Color(red: 0, green: 0, blue: 1))
            Rectangle().frame(width: 1,height: 30).foregroundColor(Color(red: 0, green: 0, blue: 1))
        }
    }
}


class Generic_Slider_Responder_Store : ObservableObject, P_VSlider_Responder {
    let centralState : Central_State
    let dimensions = ComponentDimensions.StaticDimensions

    var trackedInt : Int {
        didSet {
            centralState.data_Slider_LowBracket_Update(newLower: trackedInt)
        }
    }

    init(centralStateParam:Central_State){
        centralState = centralStateParam
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
}

//
//struct Generic_Cell : View{
//    var body: some View{
//        return ZStack(alignment: .topLeading){
//            Rectangle().frame(width: 30,height: 30).foregroundColor(.red)
//            Circle().frame(width: 30,height: 30).foregroundColor(.white)
//        }
//    }
//}
