//
//  File.swift
//  
//
//  Created by Jon on 17/11/2022.
//

import Foundation
import SwiftUI


public class Generic_Central_And_Sliders_Factory<InjectedCentralCellType:View>{
    
    public var visible_Grid_Store : Central_Grid_Store
    
    @ObservedObject var cursor_Horizontal_Slider_Store : Cursor_Horizontal_Slider_Store<H_Slider_View_External,H_Slider_Line_View_External>
    
    @ObservedObject var cursor_Vertical_Slider_Store : Cursor_Vertical_Slider_Store<V_Slider_View_External,V_Slider_Line_View_External>
    
    public var visible_Line_View_Array : [Visible_Injected_Generic_View_Line<InjectedCentralCellType>] = []
    
    public var central_Grid_Manufacturing_Closure : ((Central_Cell_Store)->InjectedCentralCellType)?
    
    public init(horzUnits:Int,vertUnits:Int){
        visible_Grid_Store = Central_Grid_Store(unitsHorizontal: horzUnits, unitsVertical: vertUnits)
        
        cursor_Horizontal_Slider_Store = Cursor_Horizontal_Slider_Store<H_Slider_View_External
        , H_Slider_Line_View_External>(sliderParam: H_Slider_View_External()
        , sliderLineParam: H_Slider_Line_View_External())
        
        cursor_Vertical_Slider_Store = Cursor_Vertical_Slider_Store<V_Slider_View_External
        , V_Slider_Line_View_External>(sliderParam: V_Slider_View_External()
        , sliderLineParam: V_Slider_Line_View_External())
        
    }
    
    public func inject_Factory_Method(unit_Factory_Param: @escaping ((Central_Cell_Store)->InjectedCentralCellType)){
        central_Grid_Manufacturing_Closure = unit_Factory_Param
        create_Visible_Grid_From_Data()
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
    }
    
    

    public func returnInjectedView(xParam:Int,yParam:Int)->InjectedCentralCellType {
        return visible_Line_View_Array[yParam].unitArray[xParam]
    }

    @ViewBuilder public func returnCentralGrid()->some View {
        if central_Grid_Manufacturing_Closure != nil {
            ForEach(visible_Grid_Store.vis_Line_Store_Array){ visibleLine in
                ForEach(visibleLine.visual_Cell_Store_Array){ visibleUnit in
                    self.returnInjectedView(xParam: visibleUnit.x_Index, yParam: visibleLine.y_Index)
                    .offset(x:visibleUnit.xFloat,y:visibleUnit.yFloat)
                }
            }
        }
        else if central_Grid_Manufacturing_Closure == nil {
            ForEach(visible_Grid_Store.vis_Line_Store_Array){ visibleLine in
                ForEach(visibleLine.visual_Cell_Store_Array){ visibleUnit in
                    //NOOOOOOO THIS NEEDS TO BE THE THING THAT HOLDS THE FREAKING STOOOOOOOORE
                    Central_Cell_View(visual_Cell_Store: visibleUnit)
                    .offset(x:visibleUnit.xFloat,y:visibleUnit.yFloat)
                }
            }
        }
    }
    
    @ViewBuilder public func returnSliders()->some View {
        Default_Cursor_Horizontal_Slider_View(cursor_Horizontal_Slider_Store: cursor_Horizontal_Slider_Store).offset(x:0,y:110)
        Default_Cursor_Vertical_Slider_View(cursor_Vertical_Slider_Store: cursor_Vertical_Slider_Store).offset(x:300,y:140)
    }
    

    
    deinit {
        if central_Grid_Manufacturing_Closure != nil{central_Grid_Manufacturing_Closure = nil}
    }
    
}

public class Visible_Injected_Generic_View_Line <InjectedViewType:View> : ObservableObject, Identifiable {
    public var id = UUID()
    public var unitArray = [InjectedViewType]()
}
