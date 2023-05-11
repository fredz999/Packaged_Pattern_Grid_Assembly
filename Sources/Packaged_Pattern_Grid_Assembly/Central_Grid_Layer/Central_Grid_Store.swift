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
    public init(dataGridParam:Underlying_Data_Grid){
        for y in 0..<dimensions.visualGrid_Y_Unit_Count {
            let newLine = Central_Line_Store(y_Index: y, gridParam: self, dataParam: dataGridParam)
            vis_Line_Store_Array.append(newLine)
        }
    }
    
    public func changeDataBracket(newLower:Int){
        // this has been dun wayyyyyy to simply
        
        for line in vis_Line_Store_Array {
            line.change_Data_Y(lowerBracket_Param: newLower)
        }
    }
    
}





