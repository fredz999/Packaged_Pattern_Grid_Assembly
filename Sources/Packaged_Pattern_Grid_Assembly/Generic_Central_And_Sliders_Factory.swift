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
    ,Injected_Cursor_Type:View
    ,Injected_Note_Write_Button_Type:View
    ,Injected_Potential_Note_Type:View
    ,Injected_Data_Y_Slider_Cell_Type:View>{
    
    let dimensions = ComponentDimensions.StaticDimensions
    
    public var centralState = Central_State.Static_Central_State
    public var visible_Grid_Store : Central_Grid_Store
    public var visible_Line_View_Array : [Visible_Injected_Generic_View_Line<InjectedCentralCellType>] = []
    
    var cursor_Horizontal_Slider_Store : Cursor_Horizontal_Slider_Store
    var cursor_Vertical_Slider_Store : Cursor_Vertical_Slider_Store
    var cursor_Layer_Store : Cursor_Layer_Store
    
    var injected_h_Slider : Injected_H_SliderType?
    var injected_v_Slider : Injected_V_SliderType?
    var injected_cursor : Injected_Cursor_Type?
    var injected_noteWriteBtn : Injected_Note_Write_Button_Type?
    var injected_potential_Note_View : Injected_Potential_Note_Type?
    
    var potential_Note_Layer_Store : Potential_Note_Layer_Store
    
    //=============================================================================================================
    public var central_Grid_Manufacturing_Closure : ((Central_Cell_Store)->InjectedCentralCellType)?
    //=============================================================================================================
    
    var noteCollection = Note_Collection.Static_Note_Collection
    
    public var wrapped_Vertical_Slider : Wrapped_Vertical_Slider<Injected_Data_Y_Slider_Cell_Type>
    public var generic_Slider_Y_Coord : Generic_Slider_Coordinator<Injected_Data_Y_Slider_Cell_Type>
    //var injected_cursor : Injected_Cursor_Type?
    
    @ViewBuilder public func returnData_Y_Slider() -> some View {
    Generic_Slider_View(generic_Slider_Coordinator_Param: generic_Slider_Y_Coord)
    .frame(width: dimensions.ui_Unit_Width,height: dimensions.Vert_Cursor_Slider_Height)
    }
    
    
    public init(){
        
        generic_Slider_Y_Coord = Generic_Slider_Coordinator<Injected_Data_Y_Slider_Cell_Type>()
        
        wrapped_Vertical_Slider = Wrapped_Vertical_Slider(coordParam: generic_Slider_Y_Coord)
        
        visible_Grid_Store = Central_Grid_Store()
        
        cursor_Horizontal_Slider_Store = Cursor_Horizontal_Slider_Store()
        
        cursor_Vertical_Slider_Store = Cursor_Vertical_Slider_Store()
        
        cursor_Layer_Store = Cursor_Layer_Store()
        
        potential_Note_Layer_Store = Potential_Note_Layer_Store()
        
        centralState.v_Slider_Ref = cursor_Vertical_Slider_Store
        
        centralState.h_Slider_Ref = cursor_Horizontal_Slider_Store

        centralState.cursor_Layer_Ref = cursor_Layer_Store
        
        centralState.potential_Note_Layer_Ref = potential_Note_Layer_Store
        
        centralState.note_Collection_Ref = Note_Collection.Static_Note_Collection
        
        centralState.potential_Note_Layer_Ref = potential_Note_Layer_Store
        centralState.note_Collection_Ref = noteCollection
        centralState.central_Grid_Store = visible_Grid_Store
        centralState.v_Slider_Ref = cursor_Vertical_Slider_Store
        centralState.h_Slider_Ref = cursor_Horizontal_Slider_Store
        centralState.higher_Bracket_Number = dimensions.visualGrid_Y_Unit_Count
    }
    
    public func inject_Central_Cell_Factory_Method(unit_Factory_Param: @escaping ((Central_Cell_Store)->InjectedCentralCellType)){
        central_Grid_Manufacturing_Closure = unit_Factory_Param 
        create_Central_Grid_From_Data()
    }
    
    public func inject_HSlider_Factory_Method(horizontal_Slider_Factory_Param: ((Cursor_Horizontal_Slider_Store)->Injected_H_SliderType)){
        injected_h_Slider = horizontal_Slider_Factory_Param(cursor_Horizontal_Slider_Store)
    }
        
    public func inject_VSlider_Factory_Method(vertical_Slider_Factory_Param: ((Cursor_Vertical_Slider_Store)->Injected_V_SliderType)){
        injected_v_Slider = vertical_Slider_Factory_Param(cursor_Vertical_Slider_Store)
    }
    
    public func inject_Cursor_Factory_Method(cursor_Factory_Method: ((Cursor_Layer_Store)->Injected_Cursor_Type)){
        injected_cursor = cursor_Factory_Method(cursor_Layer_Store)
    }

    public func inject_NoteWriteBtn_Factory_Method(noteWriteBtn_Factory_Method: (()->Injected_Note_Write_Button_Type)){
        injected_noteWriteBtn = noteWriteBtn_Factory_Method()
    }
    
    public func inject_PotentialNote_Factory_Method(potentialNote_Factory_Method: ((Potential_Note_Layer_Store)->Injected_Potential_Note_Type)){
        injected_potential_Note_View = potentialNote_Factory_Method(potential_Note_Layer_Store)
    }
    
    public func returnCentralGridUnit(xParam:Int,yParam:Int)->InjectedCentralCellType{
        return visible_Line_View_Array[yParam].unitArray[xParam]
    }
    
    public func create_Central_Grid_From_Data(){
        if let lclFactoryMethod = central_Grid_Manufacturing_Closure {
            for y in 0..<visible_Grid_Store.gridUnitsVert {
            let new_Visible_Line : Visible_Injected_Generic_View_Line = Visible_Injected_Generic_View_Line<InjectedCentralCellType>()
                for x in 0..<visible_Grid_Store.gridUnitsHorz {
                    let visibleGridUnit = lclFactoryMethod(visible_Grid_Store.vis_Line_Store_Array[y].visual_Cell_Store_Array[x])
                    new_Visible_Line.unitArray.append(visibleGridUnit)
                    if centralGridSet == false{centralGridSet = true}
                }
                visible_Line_View_Array.append(new_Visible_Line)
            }
        }
        central_Grid_Manufacturing_Closure = nil
    }
    
    var centralGridSet : Bool = false
    
    
    @ViewBuilder public func returnCentralGrid()->some View {
        if centralGridSet == true {
            ForEach(visible_Grid_Store.vis_Line_Store_Array){ visibleLine in
                ForEach(visibleLine.visual_Cell_Store_Array){ visibleUnit in

                    

     
                    //if let lclX_Index = visibleUnit.x_Index, let lclXFloat = visibleUnit.xFloat, let lclYFloat = visibleUnit.yFloat{
                    if let lclXFloat = visibleUnit.xFloat, let lclYFloat = visibleUnit.yFloat{

                        self.returnCentralGridUnit(xParam: visibleUnit.x_Index, yParam: visibleLine.y_Index)
                            .offset(x:lclXFloat,y:lclYFloat)


                    }
//                    else if visibleUnit.x_Index == nil{
//                        //print("=============================== nil at for each")
//                        Circle().frame(width: 30,height: 30).foregroundColor( Color(red: 0.5, green: 1.0, blue: 0)  )
//                    }
                    
                    
                    
//                    else if visibleUnit.x_Index == nil || visibleUnit.xFloat == nil || visibleUnit.yFloat == nil{
//                        print("=============================== nil at for each")
//                    }
//                    self.returnCentralGridUnit(xParam: visibleUnit.x_Index, yParam: visibleLine.y_Index)
//                    .offset(x:visibleUnit.xFloat,y:visibleUnit.yFloat)
                    
                }
            }
        }
        else if centralGridSet == false {
            ForEach(visible_Grid_Store.vis_Line_Store_Array){ visibleLine in
                ForEach(visibleLine.visual_Cell_Store_Array){ visibleUnit in
                    
                    if let lclXFloat = visibleUnit.xFloat, let lclYFloat = visibleUnit.yFloat{
                        //Default_Central_Cell_View(visual_Cell_Store: visibleUnit).offset(x:lclXFloat,y:lclYFloat)
                        Default_Central_Cell_View(central_Cell_Store: visibleUnit).offset(x:lclXFloat,y:lclYFloat)
                    }
//                    Default_Central_Cell_View(visual_Cell_Store: visibleUnit)
//                    .offset(x:visibleUnit.xFloat,y:visibleUnit.yFloat)
                    
                }
            }
        }
    }
    
    @ViewBuilder public func returnSliders()->some View {
        if let lclHslider = injected_h_Slider,let lclVslider = injected_v_Slider {
            lclHslider
            lclVslider
        }
        else {
            Default_Horizontal_Slider_View(cursor_Horizontal_Slider_Store: cursor_Horizontal_Slider_Store)
            Default_Vertical_Slider_View(cursor_Vertical_Slider_Store: cursor_Vertical_Slider_Store)
        }
    }
    
    @ViewBuilder public func returnCursorLayer()->some View {
        if let lclCursor = injected_cursor {
            lclCursor
        }
        else if injected_cursor == nil{
            Default_Cursor_Marker_View(cursor_Layer_Store: cursor_Layer_Store)
        }
    }
    
    @ViewBuilder public func returnNoteWriteLayer()->some View {
        if let lclNoteWritingButton = injected_noteWriteBtn {
            lclNoteWritingButton
        }
        else if injected_noteWriteBtn == nil{
            Default_Note_Write_Button_View()
        }
    }
    
    
    @ViewBuilder public func returnPotentialLayer()->some View {
        if let lclInjectedPotentialNoteView = injected_potential_Note_View {
            lclInjectedPotentialNoteView
        }
        else if injected_potential_Note_View == nil {
            Default_Potential_Note_View(potential_Note_Layer_Store: potential_Note_Layer_Store)
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

class InjectedView_Holder<InjectedView:View> {
    
    var injected_View : InjectedView?
    
    var type : InjectedViewType
    
//    public func inject_View(viewParam:InjectedView){
//        injected_View = viewParam
//    }
    
    init(viewParam:InjectedView,typeParam:InjectedViewType){
        injected_View = viewParam
        type = typeParam
    }
    
    @ViewBuilder public func returnInjectedView()->some View {
        if let lcl_Injected_View = injected_View {
            lcl_Injected_View
        }
        else if injected_View == nil{
             //default in here
        }
    }
    
    //static let Static_Return_Data_Y_Cell_View = Return_Data_Y_Cell_View()
}

enum InjectedViewType {
    case cursor
    case data_Y_Slider_Cell
    //.... e.t.c
}
