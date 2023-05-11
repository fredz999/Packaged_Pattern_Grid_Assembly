//
//  File.swift
//  
//
//  Created by Jon on 16/11/2022.
//

import Foundation
import SwiftUI

public class Central_Grid_Store : ObservableObject {
    //visualGrid_Y_Unit_Count is 12
    let dimensions = ComponentDimensions.StaticDimensions
    @Published public var vis_Line_Store_Array : [Central_Line_Store] = []
    let dataGridRef : Underlying_Data_Grid?
    public init(dataGridParam:Underlying_Data_Grid){
        dataGridRef = dataGridParam
        for y in 0..<dimensions.visualGrid_Y_Unit_Count {
            let newLine = Central_Line_Store(y_Index: y, gridParam: self, dataParam: dataGridParam)
            vis_Line_Store_Array.append(newLine)
        }
    }
    
    public func changeDataBracket(newLower:Int){
        
        let higher = newLower+dimensions.visualGrid_Y_Unit_Count_Final_Index
        
        if let lclDataGridRef = dataGridRef {
            for line in lclDataGridRef.dataLineArray {
                if line.line_Y_Num < newLower || line.line_Y_Num > higher {
                    for cell in line.dataCellArray {
                        cell.currentConnectedDataVals = nil
                    }
                }
            }
        }
        
        for line in vis_Line_Store_Array {
            line.change_Data_Y(lowerBracket_Param: newLower)
        }
    }
    
}





