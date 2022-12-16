//
//  File.swift
//  
//
//  Created by Jon on 16/11/2022.
//

import Foundation
import SwiftUI

public class Underlying_Data_Grid:ObservableObject,Identifiable {
    public let dimensions = ComponentDimensions.StaticDimensions
    public var id = UUID()
    public var dataLineArray : [Underlying_Data_Line] = []
    public init(){
        setGrid()
    }
    
    func setGrid(){
        //TODO: subCells
        for y in 0..<dimensions.DATA_final_Line_Y_Index {
            let newLine = Underlying_Data_Line()
            for x in 0..<dimensions.dataGrid_X_Unit_Count {
                if dimensions.pattern_Grid_Cell_Sub_Unit_Count == 3{
                    // start mid then end
                    let newDataCell=Underlying_Data_Cell(xNumParam: x, yNumParam: y, statusParam: .start)
                    newLine.dataCellArray.append(newDataCell)
                }
                else if dimensions.pattern_Grid_Cell_Sub_Unit_Count == 2{
                    // start then end
                    let newDataCell=Underlying_Data_Cell(xNumParam: x, yNumParam: y, statusParam: .start)
                    newLine.dataCellArray.append(newDataCell)
                }
                
                
            }
            dataLineArray.append(newLine)
        }
    }
    
    public static let Static_Underlying_Data_Grid = Underlying_Data_Grid()
}

public class Underlying_Data_Line:ObservableObject,Identifiable {
    public var id = UUID()
    public var dataCellArray : [Underlying_Data_Cell] = []
}

// this things line ref dosent change
public class Underlying_Data_Cell:ObservableObject,Identifiable {
    
    public var id = UUID()
    @Published public var dataCell_X_Number : Int
    @Published public var dataCell_Y_Number : Int
    @Published public var isHighlighted : Bool = false
    var note_Im_In : Note?
    
    @Published public var currentType : E_CellStatus // = .unassigned
    
    public init(xNumParam:Int,yNumParam:Int,statusParam:E_CellStatus){
        dataCell_X_Number = xNumParam
        dataCell_Y_Number = yNumParam
        currentType = statusParam
    }
    
    public func changeType(newType:E_CellStatus){
        currentType = newType
    }
    
}

public enum E_CellStatus {
    //case unassigned
    case start
    case mid
    case end
    //case single
}
