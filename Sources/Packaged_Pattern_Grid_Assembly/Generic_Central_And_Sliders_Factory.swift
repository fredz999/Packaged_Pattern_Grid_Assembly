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
    ,Injected_Cursor_Type:View>{
    
    public var centralState = Central_State.Static_Central_State
    public var visible_Grid_Store : Central_Grid_Store
    public var visible_Line_View_Array : [Visible_Injected_Generic_View_Line<InjectedCentralCellType>] = []
    
    var cursor_Horizontal_Slider_Store : Cursor_Horizontal_Slider_Store
    var h_Slider : Injected_H_SliderType?
    
    var cursor_Vertical_Slider_Store : Cursor_Vertical_Slider_Store
    var v_Slider : Injected_V_SliderType?
    
    var cursor_Layer_Store : Cursor_Layer_Store
    var cursor : Injected_Cursor_Type?
    

    //==============================================================================================================
    public var central_Grid_Manufacturing_Closure : ((Central_Cell_Store)->InjectedCentralCellType)?
    
    public var horizontal_Slider_Manufacturing_Closure : ((Cursor_Horizontal_Slider_Store)->Injected_H_SliderType)?
    
    public var vertical_Slider_Manufacturing_Closure : ((Cursor_Vertical_Slider_Store)->Injected_V_SliderType)?
    
    public var cursor_Manufacturing_Closure : ((Cursor_Layer_Store)->Injected_Cursor_Type)?
    
    //=============================================================================================================
    
    public init(horzUnits:Int,vertUnits:Int){
        
        visible_Grid_Store = Central_Grid_Store(unitsHorizontal: horzUnits, unitsVertical: vertUnits)
        
        cursor_Horizontal_Slider_Store = Cursor_Horizontal_Slider_Store()
        
        cursor_Vertical_Slider_Store = Cursor_Vertical_Slider_Store()
        
        cursor_Layer_Store = Cursor_Layer_Store()
        
        centralState.v_Slider_Ref = cursor_Vertical_Slider_Store
//        centralState.h_Slider_Ref = cursor_Horizontal_Slider_Store
        centralState.cursor_Layer_Ref = cursor_Layer_Store
    }
    
    public func inject_Central_Cell_Factory_Method(unit_Factory_Param: @escaping ((Central_Cell_Store)->InjectedCentralCellType)){
        central_Grid_Manufacturing_Closure = unit_Factory_Param
        create_Visible_Grid_From_Data()
    }
    
    public func inject_HSlider_Factory_Method(horizontal_Slider_Factory_Param: ((Cursor_Horizontal_Slider_Store)->Injected_H_SliderType)){
        //horizontal_Slider_Manufacturing_Closure = horizontal_Slider_Param
        h_Slider = horizontal_Slider_Factory_Param(cursor_Horizontal_Slider_Store)

    }
        
    public func inject_VSlider_Factory_Method(vertical_Slider_Factory_Param: ((Cursor_Vertical_Slider_Store)->Injected_V_SliderType)){
        //vertical_Slider_Manufacturing_Closure = vertical_Slider_Param
        v_Slider = vertical_Slider_Factory_Param(cursor_Vertical_Slider_Store)
    }
    
    public func inject_Cursor_Factory_Method(cursor_Factory_Method: ((Cursor_Layer_Store)->Injected_Cursor_Type)){
        cursor = cursor_Factory_Method(cursor_Layer_Store)
    }
    
    public func returnCentralGridUnit(xParam:Int,yParam:Int)->InjectedCentralCellType{
        return visible_Line_View_Array[yParam].unitArray[xParam]
    }
    
    public func create_Visible_Grid_From_Data(){
        if let lclFactoryMethod = central_Grid_Manufacturing_Closure {
            for y in 0..<visible_Grid_Store.gridUnitsVert {
            let new_Visible_Line : Visible_Injected_Generic_View_Line = Visible_Injected_Generic_View_Line<InjectedCentralCellType>()
                for x in 0..<visible_Grid_Store.gridUnitsHorz {
                    let visibleGridUnit = lclFactoryMethod(visible_Grid_Store.vis_Line_Store_Array[y].visual_Cell_Store_Array[x])
                new_Visible_Line.unitArray.append(visibleGridUnit)
                }
                visible_Line_View_Array.append(new_Visible_Line)
            }
        }
        central_Grid_Manufacturing_Closure = nil
    }

    @ViewBuilder public func returnCentralGrid()->some View {
        if central_Grid_Manufacturing_Closure != nil {
            ForEach(visible_Grid_Store.vis_Line_Store_Array){ visibleLine in
                ForEach(visibleLine.visual_Cell_Store_Array){ visibleUnit in
                    self.returnCentralGridUnit(xParam: visibleUnit.x_Index, yParam: visibleLine.y_Index)
                    .offset(x:visibleUnit.xFloat,y:visibleUnit.yFloat)
                }
            }
        }
        else if central_Grid_Manufacturing_Closure == nil {
            ForEach(visible_Grid_Store.vis_Line_Store_Array){ visibleLine in
                ForEach(visibleLine.visual_Cell_Store_Array){ visibleUnit in
                    Default_Central_Cell_View(visual_Cell_Store: visibleUnit)
                    .offset(x:visibleUnit.xFloat,y:visibleUnit.yFloat)
                }
            }
        }
    }
    
    @ViewBuilder public func returnSliders()->some View {
        if let lclHslider = h_Slider,let lclVslider = v_Slider {
            lclHslider//.offset(x:0,y:110)
            lclVslider//.offset(x:300,y:140)
        }
        else {
            Default_Horizontal_Slider_View(cursor_Horizontal_Slider_Store: cursor_Horizontal_Slider_Store)
                //.offset(x:0,y:110)
            Default_Vertical_Slider_View(cursor_Vertical_Slider_Store: cursor_Vertical_Slider_Store)
             //.offset(x:300,y:140)
        }
//        if let lclHorzSlider_Factory_Method = horizontal_Slider_Manufacturing_Closure,let lclVertSlider_Factory_Method = vertical_Slider_Manufacturing_Closure{
//            lclHorzSlider_Factory_Method(cursor_Horizontal_Slider_Store).offset(x:0,y:110)
//            lclVertSlider_Factory_Method(cursor_Vertical_Slider_Store).offset(x:300,y:140)
//        }
//        else{
//            Default_Horizontal_Slider_View(cursor_Horizontal_Slider_Store: cursor_Horizontal_Slider_Store).offset(x:0,y:110)
//            Default_Vertical_Slider_View(cursor_Vertical_Slider_Store: cursor_Vertical_Slider_Store).offset(x:300,y:140)
//        }
    }
    
    @ViewBuilder public func returnCursorLayer()->some View {
        if let lclCursor = cursor {
            lclCursor//.offset(cursor_Layer_Store.offsetSize)
        }
        else if cursor == nil{
            Default_Cursor_Marker_View(cursor_Layer_Store: cursor_Layer_Store)
        }
        
        
        
        //Cursor_Layer_View(cursor_Layer_Store: cursor_Layer_Store).offset(x:0,y:140)
//        ZStack(alignment: .topLeading){
//            if let lclcursor_Manufacturing_Closure = cursor_Manufacturing_Closure{
//                lclcursor_Manufacturing_Closure(cursor_Layer_Store).offset(cursor_Layer_Store.offsetSize)
//            }
//                Default_Cursor_Marker_View(cursor_Layer_Store: cursor_Layer_Store)
//        }.offset(cursor_Layer_Store.offsetSize)
        
        
        
    }
    //Cursor_Layer_View
    
    deinit {
        if central_Grid_Manufacturing_Closure != nil{central_Grid_Manufacturing_Closure = nil}
    }
    
}

public class Visible_Injected_Generic_View_Line <InjectedViewType:View> : ObservableObject, Identifiable {
    public var id = UUID()
    public var unitArray = [InjectedViewType]()
}
