//
//  File.swift
//  
//
//  Created by Jon on 16/11/2022.
//

import Foundation
import SwiftUI

public class Visual_Grid_Store : ObservableObject {
    
    @Published public var lineArray : [Visual_Line_Store] = []
    
    public var gridUnitsHorz:Int
    public var gridUnitsVert:Int

    public init(unitsHorizontal:Int,unitsVertical:Int){
        gridUnitsHorz = unitsHorizontal
        gridUnitsVert = unitsVertical
        populateLineArray()
    }
    
    public func populateLineArray(){
        for y in 0..<gridUnitsVert {
            let newLine = Visual_Line_Store(y_Index: y, gridParam: self)
            lineArray.append(newLine)
        }
    }
    
    public func changeDataBracket(newLower:Int){
        for line in lineArray {
            line.change_Data_Y(lowerBracket_Param: newLower)
        }
    }
    
}

public class Visual_Line_Store : ObservableObject,Identifiable {
    public var data = Underlying_Data_Grid.Static_Underlying_Data_Grid
    public var id = UUID()
    public var parentGrid : Visual_Grid_Store
    @Published public var y_Index : Int
    @Published public var visualCellArray : [Visual_Cell_Store] = []
    
    public init(y_Index: Int,gridParam:Visual_Grid_Store){
        self.y_Index = y_Index
        parentGrid = gridParam
        fillLine()
    }
 
    public func fillLine(){
        for x in 0..<parentGrid.gridUnitsHorz {
            let new_Visual_Cell = Visual_Cell_Store(x_IndexParam: x, lineParam: self, underlying_Data_Cell_Param: data.dataLineArray[y_Index].dataCellArray[x])
            visualCellArray.append(new_Visual_Cell)
        }
    }
    
    public func change_Data_Y(lowerBracket_Param:Int){
        if (lowerBracket_Param + y_Index) < data.dataLineArray.count {
            let new_Y_Index = lowerBracket_Param + y_Index
            for visualCell in visualCellArray {
                visualCell.underlying_Data_Cell = data.dataLineArray[new_Y_Index].dataCellArray[visualCell.x_Index]
            }
        }
    }
    
}

public class Visual_Cell_Store : ObservableObject,Identifiable {
    public var id = UUID()
    public let dimensions = ComponentDimensions.StaticDimensions
    @Published public var x_Index : Int
    @Published public var xFloat:CGFloat
    @Published public var yFloat:CGFloat
    public var visual_Line_Ref : Visual_Line_Store
    
    @Published public var underlying_Data_Cell : Underlying_Data_Cell
    
    public init(x_IndexParam: Int,lineParam:Visual_Line_Store,underlying_Data_Cell_Param : Underlying_Data_Cell) {
        self.visual_Line_Ref = lineParam
        self.x_Index = x_IndexParam
        self.xFloat = CGFloat(x_IndexParam) * dimensions.pattern_Grid_Unit_Width
        self.yFloat = CGFloat(lineParam.y_Index) * dimensions.pattern_Grid_Unit_Height
        self.underlying_Data_Cell = underlying_Data_Cell_Param
    }

}
