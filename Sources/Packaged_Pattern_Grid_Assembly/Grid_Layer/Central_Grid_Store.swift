//
//  File.swift
//  
//
//  Created by Jon on 16/11/2022.
//

import Foundation
import SwiftUI


//public class Generic_Central_And_Sliders_Factory<InjectedCentralCellType:View>{
//
//    public var visible_Grid_Store : Central_Grid_Store
//
//    public var visible_Line_View_Array : [Visible_Injected_Generic_View_Line<InjectedCentralCellType>] = []
//
//    public var unit_Manufacturing_Closure : ((Central_Cell_Store)->InjectedCentralCellType)?
//
//    public init(horzUnits:Int,vertUnits:Int){
//        visible_Grid_Store = Central_Grid_Store(unitsHorizontal: horzUnits, unitsVertical: vertUnits)
//    }
//
//    public func inject_Factory_Method(unit_Factory_Param: @escaping ((Central_Cell_Store)->InjectedCentralCellType)){
//        unit_Manufacturing_Closure = unit_Factory_Param
//        create_Visible_Grid_From_Data()
//    }
//
//    public func create_Visible_Grid_From_Data(){
//        if let lclFactoryMethod = unit_Manufacturing_Closure {
//            for y in 0..<visible_Grid_Store.gridUnitsVert {
//            let new_Visible_Line : Visible_Injected_Generic_View_Line = Visible_Injected_Generic_View_Line<InjectedCentralCellType>()
//                for x in 0..<visible_Grid_Store.gridUnitsHorz {
//                    let visibleGridUnit = lclFactoryMethod(visible_Grid_Store.vis_Line_Store_Array[y].visual_Cell_Store_Array[x])
//                new_Visible_Line.unitArray.append(visibleGridUnit)
//                }
//                visible_Line_View_Array.append(new_Visible_Line)
//            }
//        }
//    }
//
//
//
//    public func returnInjectedView(xParam:Int,yParam:Int)->InjectedCentralCellType {
//        return visible_Line_View_Array[yParam].unitArray[xParam]
//    }
//
//    @ViewBuilder public func returnView()->some View {
//        if unit_Manufacturing_Closure != nil {
//            ForEach(visible_Grid_Store.vis_Line_Store_Array){ visibleLine in
//                ForEach(visibleLine.visual_Cell_Store_Array){ visibleUnit in
//
//                    self.returnInjectedView(xParam: visibleUnit.x_Index, yParam: visibleLine.y_Index)
//                    .offset(x:visibleUnit.xFloat,y:visibleUnit.yFloat)
//
//                }
//            }
//        }
//        else if unit_Manufacturing_Closure == nil {
//            ForEach(visible_Grid_Store.vis_Line_Store_Array){ visibleLine in
//                ForEach(visibleLine.visual_Cell_Store_Array){ visibleUnit in
//                    //NOOOOOOO THIS NEEDS TO BE THE THING THAT HOLDS THE FREAKING STOOOOOOOORE
//                    Central_Cell_View(visual_Cell_Store: visibleUnit)
//                    .offset(x:visibleUnit.xFloat,y:visibleUnit.yFloat)
//                }
//            }
//        }
//    }
//
//    deinit {
//        if unit_Manufacturing_Closure != nil{unit_Manufacturing_Closure = nil}
//    }
//
//}
//
//public class Visible_Injected_Generic_View_Line <InjectedViewType:View> : ObservableObject, Identifiable {
//    public var id = UUID()
//    public var unitArray = [InjectedViewType]()
//}

public class Central_Grid_Store : ObservableObject {
    
    @Published public var vis_Line_Store_Array : [Central_Line_Store] = []
    
    public var gridUnitsHorz:Int
    public var gridUnitsVert:Int

    public init(unitsHorizontal:Int,unitsVertical:Int){
        gridUnitsHorz = unitsHorizontal
        gridUnitsVert = unitsVertical
        populateLineArray()
    }
    
    public func populateLineArray(){
        for y in 0..<gridUnitsVert {
            let newLine = Central_Line_Store(y_Index: y, gridParam: self)
            vis_Line_Store_Array.append(newLine)
        }
    }
    
    public func changeDataBracket(newLower:Int){
        for line in vis_Line_Store_Array {
            line.change_Data_Y(lowerBracket_Param: newLower)
        }
    }

}

public class Central_Line_Store : ObservableObject,Identifiable {
    public var data = Underlying_Data_Grid.Static_Underlying_Data_Grid
    public var id = UUID()
    public var parentGrid : Central_Grid_Store
    @Published public var y_Index : Int
    @Published public var visual_Cell_Store_Array : [Central_Cell_Store] = []
    
    public init(y_Index: Int,gridParam:Central_Grid_Store){
        self.y_Index = y_Index
        parentGrid = gridParam
        fillLine()
    }
 
    public func fillLine(){
        for x in 0..<parentGrid.gridUnitsHorz {
            let new_Visual_Cell = Central_Cell_Store(x_IndexParam: x, lineParam: self, underlying_Data_Cell_Param: data.dataLineArray[y_Index].dataCellArray[x])
            visual_Cell_Store_Array.append(new_Visual_Cell)
        }
    }
    
    public func change_Data_Y(lowerBracket_Param:Int){
        if (lowerBracket_Param + y_Index) < data.dataLineArray.count {
            let new_Y_Index = lowerBracket_Param + y_Index
            for visualCell in visual_Cell_Store_Array {
                visualCell.underlying_Data_Cell = data.dataLineArray[new_Y_Index].dataCellArray[visualCell.x_Index]
            }
        }
    }
    
}

public class Central_Cell_Store : ObservableObject,Identifiable {
    public var id = UUID()
    public let dimensions = ComponentDimensions.StaticDimensions
    @Published public var x_Index : Int
    @Published public var xFloat:CGFloat
    @Published public var yFloat:CGFloat
    public var visual_Line_Ref : Central_Line_Store
    
    @Published public var underlying_Data_Cell : Underlying_Data_Cell
    
    public init(x_IndexParam: Int,lineParam:Central_Line_Store,underlying_Data_Cell_Param : Underlying_Data_Cell) {
        self.visual_Line_Ref = lineParam
        self.x_Index = x_IndexParam
        self.xFloat = CGFloat(x_IndexParam) * dimensions.pattern_Grid_Unit_Width
        self.yFloat = CGFloat(lineParam.y_Index) * dimensions.pattern_Grid_Unit_Height
        self.underlying_Data_Cell = underlying_Data_Cell_Param
    }

}
