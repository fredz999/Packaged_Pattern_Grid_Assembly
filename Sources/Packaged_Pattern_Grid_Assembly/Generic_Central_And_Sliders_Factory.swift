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
    
    public var visible_Line_View_Array : [Visible_Injected_Generic_View_Line<InjectedCentralCellType>] = []
    
    public var unit_Manufacturing_Closure : ((Central_Cell_Store)->InjectedCentralCellType)?
    
    public init(horzUnits:Int,vertUnits:Int){
        visible_Grid_Store = Central_Grid_Store(unitsHorizontal: horzUnits, unitsVertical: vertUnits)
    }
    
    public func inject_Factory_Method(unit_Factory_Param: @escaping ((Central_Cell_Store)->InjectedCentralCellType)){
        unit_Manufacturing_Closure = unit_Factory_Param
        create_Visible_Grid_From_Data()
    }

    public func create_Visible_Grid_From_Data(){
        if let lclFactoryMethod = unit_Manufacturing_Closure {
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

    @ViewBuilder public func returnView()->some View {
        if unit_Manufacturing_Closure != nil {
            ForEach(visible_Grid_Store.vis_Line_Store_Array){ visibleLine in
                ForEach(visibleLine.visual_Cell_Store_Array){ visibleUnit in
                    
                    self.returnInjectedView(xParam: visibleUnit.x_Index, yParam: visibleLine.y_Index)
                    .offset(x:visibleUnit.xFloat,y:visibleUnit.yFloat)
                    
                }
            }
        }
        else if unit_Manufacturing_Closure == nil {
            ForEach(visible_Grid_Store.vis_Line_Store_Array){ visibleLine in
                ForEach(visibleLine.visual_Cell_Store_Array){ visibleUnit in
                    //NOOOOOOO THIS NEEDS TO BE THE THING THAT HOLDS THE FREAKING STOOOOOOOORE
                    Central_Cell_View(visual_Cell_Store: visibleUnit)
                    .offset(x:visibleUnit.xFloat,y:visibleUnit.yFloat)
                }
            }
        }
    }
    
    deinit {
        if unit_Manufacturing_Closure != nil{unit_Manufacturing_Closure = nil}
    }
    
}

public class Visible_Injected_Generic_View_Line <InjectedViewType:View> : ObservableObject, Identifiable {
    public var id = UUID()
    public var unitArray = [InjectedViewType]()
}
