//
//  Central_Line_Store.swift
//  
//
//  Created by Jon on 11/05/2023.
//

import Foundation
import SwiftUI

public class Central_Line_Store : ObservableObject,Identifiable {
    
    var data : Underlying_Data_Grid
    var dimensions = ComponentDimensions.StaticDimensions
    public var id = UUID()
    public var parentGrid : Central_Grid_Store
    @Published public var y_Index : Int
    @Published public var visual_Cell_Store_Array : [Central_Cell_Store] = []

    public init(y_Index: Int,gridParam:Central_Grid_Store,dataParam:Underlying_Data_Grid){
        data = dataParam
        self.y_Index = y_Index
        parentGrid = gridParam
        for x in 0..<dimensions.dataGrid_X_Unit_Count {
            let new_Central_Cell_Store = Central_Cell_Store(x_Index_Param: x, lineParam: self, underlying_Data_Cell_Param: data.dataLineArray[y_Index].dataCellArray[x])
            visual_Cell_Store_Array.append(new_Central_Cell_Store)
        }
    }
    
    public func change_Data_Y(lowerBracket_Param:Int){
        //outgoing cell has to get its datadisplay nilled
        print("lower: ",lowerBracket_Param,", higher: ",(lowerBracket_Param+12))
        
        if (lowerBracket_Param + y_Index) < dimensions.DATA_final_Line_Y_Index {
            let new_Y_Index = lowerBracket_Param + y_Index
            for visualCell in visual_Cell_Store_Array {
                visualCell.cell_Swap_Underlying_Data(new_Data_Cell: data.dataLineArray[new_Y_Index].dataCellArray[visualCell.x_Index])
            }
        }
    }
    
}
