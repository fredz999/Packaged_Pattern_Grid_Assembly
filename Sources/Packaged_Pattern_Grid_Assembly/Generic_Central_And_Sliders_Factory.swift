//
//  File.swift
//  
//
//  Created by Jon on 17/11/2022.
//

import Foundation
import SwiftUI

public class Generic_Central_And_Sliders_Factory<InjectedCentralCellType:View
    ,Injected_H_SliderType:View
    ,Injected_V_SliderType:View
    ,Injected_Data_Y_Slider_Cell_Type:View> {
    
    let dimensions = ComponentDimensions.StaticDimensions
    
    public var centralState : Central_State
    
    public var visible_Grid_Store : Central_Grid_Store
    
    public var visible_Line_View_Array : [Visible_Injected_Generic_View_Line<InjectedCentralCellType>] = []
    
    var cursor_Horizontal_Slider_Store : Cursor_Horizontal_Slider_Store
    
    var cursor_Vertical_Slider_Store : Cursor_Vertical_Slider_Store
    
    var injected_h_Slider : Injected_H_SliderType?
    
    var injected_v_Slider : Injected_V_SliderType?
    
    //=============================================================================================================
    public var central_Grid_Manufacturing_Closure : ((Central_Cell_Store)->InjectedCentralCellType)?
    //=============================================================================================================
    
    public var wrapped_Vertical_Slider : Wrapped_Vertical_Slider<Injected_Data_Y_Slider_Cell_Type>
    
    public var generic_Slider_Y_Coord : Generic_Slider_Coordinator<Injected_Data_Y_Slider_Cell_Type>
    
    public init(dataGridParam:Underlying_Data_Grid){
        
        visible_Grid_Store = Central_Grid_Store(dataGridParam: dataGridParam)
        
        centralState = Central_State(dataGridParam: dataGridParam)
        
        generic_Slider_Y_Coord = Generic_Slider_Coordinator<Injected_Data_Y_Slider_Cell_Type>()
        
        wrapped_Vertical_Slider = Wrapped_Vertical_Slider(coordParam: generic_Slider_Y_Coord, centralStateParam: centralState)

        cursor_Horizontal_Slider_Store = Cursor_Horizontal_Slider_Store(central_State_Param: centralState)
        
        cursor_Vertical_Slider_Store = Cursor_Vertical_Slider_Store(central_State_Param: centralState)
        
        centralState.v_Slider_Ref = cursor_Vertical_Slider_Store
        
        centralState.h_Slider_Ref = cursor_Horizontal_Slider_Store
        
        centralState.central_Grid_Store = visible_Grid_Store
        
        centralState.v_Slider_Ref = cursor_Vertical_Slider_Store
        
        centralState.h_Slider_Ref = cursor_Horizontal_Slider_Store
        
        centralState.higher_Bracket_Number = dimensions.visualGrid_Y_Unit_Count
    }
    
    public func inject_Central_Cell_Factory_Method(unit_Factory_Param: @escaping ((Central_Cell_Store)->InjectedCentralCellType)){
        central_Grid_Manufacturing_Closure = unit_Factory_Param 
        create_Central_Grid_From_Data()
    }
    
    public func returnCentralGridUnit(xParam:Int,yParam:Int)->InjectedCentralCellType{
        return visible_Line_View_Array[yParam].unitArray[xParam]
    }
    
    public func inject_HSlider_Factory_Method(horizontal_Slider_Factory_Param: ((Cursor_Horizontal_Slider_Store)->Injected_H_SliderType)){
        injected_h_Slider = horizontal_Slider_Factory_Param(cursor_Horizontal_Slider_Store)
    }
        
    public func inject_VSlider_Factory_Method(vertical_Slider_Factory_Param: ((Cursor_Vertical_Slider_Store)->Injected_V_SliderType)){
        injected_v_Slider = vertical_Slider_Factory_Param(cursor_Vertical_Slider_Store)
    }
    
//    public func inject_Cursor_Factory_Method(cursor_Factory_Method: ((Cursor_Layer_Store)->Injected_Cursor_Type)){
//        injected_cursor = cursor_Factory_Method(cursor_Layer_Store)
//    }

//    public func inject_NoteWriteBtn_Factory_Method(noteWriteBtn_Factory_Method: (()->Injected_Note_Write_Button_Type)){
//        injected_noteWriteBtn = noteWriteBtn_Factory_Method()
//    }
    
//    public func inject_PotentialNote_Factory_Method(potentialNote_Factory_Method: ((Potential_Note_Layer_Store)->Injected_Potential_Note_Type)){
//        injected_potential_Note_View = potentialNote_Factory_Method(potential_Note_Layer_Store)
//    }
    
//    public func inject_InjectedSixEightGrid(){}
    
    public func create_Central_Grid_From_Data(){
        
        if visible_Line_View_Array.count > 0 {
            for line in visible_Line_View_Array {
                line.unitArray.removeAll()
            }
            visible_Line_View_Array.removeAll()
        }
        
        if let lclFactoryMethod = central_Grid_Manufacturing_Closure {
            for y in 0..<dimensions.visualGrid_Y_Unit_Count {
            let new_Visible_Line : Visible_Injected_Generic_View_Line = Visible_Injected_Generic_View_Line<InjectedCentralCellType>()
                for x in 0..<dimensions.dataGrid_X_Unit_Count {
                    let visibleGridUnit = lclFactoryMethod(visible_Grid_Store.vis_Line_Store_Array[y].visual_Cell_Store_Array[x])
                    new_Visible_Line.unitArray.append(visibleGridUnit)
                }
                visible_Line_View_Array.append(new_Visible_Line)
            }
            if centralGridSet == false{centralGridSet = true}
        }
        central_Grid_Manufacturing_Closure = nil
    }
    
    public var centralGridSet : Bool = false
    
    @ViewBuilder public func returnCentralGrid()->some View {
        if centralGridSet == true {
            ForEach(visible_Grid_Store.vis_Line_Store_Array){ visibleLine in
                ForEach(visibleLine.visual_Cell_Store_Array){ visibleUnit in
                    //if let lclXFloat = visibleUnit.xFloat, let lclYFloat = visibleUnit.yFloat{
                        self.returnCentralGridUnit(xParam: visibleUnit.x_Index, yParam: visibleLine.y_Index).offset(x:visibleUnit.xFloat,y:visibleUnit.yFloat)
                    //}
                }
            }
        }
    }
    
    @ViewBuilder public func returnData_Y_Slider() -> some View {
    Generic_Slider_View(generic_Slider_Coordinator_Param: generic_Slider_Y_Coord)
    .frame(width: dimensions.ui_Unit_Width*2,height: dimensions.Vert_Cursor_Slider_Height)
    }
    
    @ViewBuilder public func returnSliders()->some View {
        if let lclHslider = injected_h_Slider,let lclVslider = injected_v_Slider {
            lclHslider
            lclVslider
        }
    }
    
    deinit {
        if central_Grid_Manufacturing_Closure != nil{central_Grid_Manufacturing_Closure = nil}
    }
    
}

public class Visible_Injected_Generic_View_Line <InjectedViewType:View> : ObservableObject, Identifiable {
    public var id = UUID()
    public var unitArray = [InjectedViewType]()
}

public enum E_CentralGridTiming {
    case sixEight
    case fourFour
}


//class InjectedView_Holder<InjectedView:View> {
//
//    var injected_View : InjectedView?
//
//    var type : InjectedViewType
//
//    init(viewParam:InjectedView,typeParam:InjectedViewType){
//        injected_View = viewParam
//        type = typeParam
//    }
//
//    @ViewBuilder public func returnInjectedView()->some View {
//        if let lcl_Injected_View = injected_View {
//            lcl_Injected_View
//        }
//        else if injected_View == nil{
//             //default in here
//        }
//    }
//
//
//}

//enum InjectedViewType {
//    case cursor
//    case data_Y_Slider_Cell
//}


//    @ViewBuilder public func returnCursorLayer()->some View {
//        if let lclCursor = injected_cursor {
//            lclCursor
//        }
//    }
    
//    @ViewBuilder public func returnNoteWriteLayer()->some View {
//        if let lclNoteWritingButton = injected_noteWriteBtn {
//            lclNoteWritingButton
//        }
//        else if injected_noteWriteBtn == nil{
//            Text("NoteWriteBtn")
//        }
//    }
    
    
//    @ViewBuilder public func returnPotentialLayer()->some View {
//        if let lclInjectedPotentialNoteView = injected_potential_Note_View {
//            lclInjectedPotentialNoteView
//        }
//    }
