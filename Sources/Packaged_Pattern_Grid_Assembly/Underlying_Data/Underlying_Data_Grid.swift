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
        set_Data_Grid()
    }
    
    func set_Data_Grid(){
        //TODO: subCells
        let compositeCellCount = dimensions.dataGrid_X_Unit_Count/dimensions.pattern_Grid_Cell_Sub_Unit_Count
        
        for y in 0..<dimensions.DATA_final_Line_Y_Index {
            
            let newLine = Underlying_Data_Line()
            for outerX in 0..<compositeCellCount {
                
                if dimensions.pattern_Grid_Cell_Sub_Unit_Count == 3{
                    // start mid then end
                    for innerX in 0..<3{
                        let computedX = (outerX*3)+innerX
                        
                        if innerX == 0{
                            let newDataCell=Underlying_Data_Cell(xNumParam: computedX, yNumParam: y, statusParam: .start)
                            newLine.dataCellArray.append(newDataCell)
                        }
                        else if innerX == 1{
                            let newDataCell=Underlying_Data_Cell(xNumParam: computedX, yNumParam: y, statusParam: .mid)
                            newLine.dataCellArray.append(newDataCell)
                        }
                        else if innerX == 2{
                            let newDataCell=Underlying_Data_Cell(xNumParam: computedX, yNumParam: y, statusParam: .end)
                            newLine.dataCellArray.append(newDataCell)
                        }
                        
                    }
        
                    
                }
                else if dimensions.pattern_Grid_Cell_Sub_Unit_Count == 2{
                    // start then end
                    for innerX in 0..<2{
                        let computedX = (outerX*2)+innerX
                        if innerX == 0{
                            let newDataCell=Underlying_Data_Cell(xNumParam: computedX, yNumParam: y, statusParam: .start)
                            newLine.dataCellArray.append(newDataCell)
                        }
                        else if innerX == 1{
                            let newDataCell=Underlying_Data_Cell(xNumParam: computedX, yNumParam: y, statusParam: .end)
                            newLine.dataCellArray.append(newDataCell)
                        }
                    }
                    
                }
                else if dimensions.pattern_Grid_Cell_Sub_Unit_Count == 1{
                    // start then end
                    for outerX in 0..<compositeCellCount {
                        let newDataCell=Underlying_Data_Cell(xNumParam: outerX, yNumParam: y, statusParam: .start)
                        newLine.dataCellArray.append(newDataCell)
                    }
                }
                
                
            }
            dataLineArray.append(newLine)
        }
    }
    

    public func changeTimingSignature_Data_Level(){
        print("changeTimingSignature_Data_Level")
        let compositeCellCount = dimensions.dataGrid_X_Unit_Count/dimensions.pattern_Grid_Cell_Sub_Unit_Count
        for dataLine in dataLineArray {
                for outerX in 0..<compositeCellCount {
                    
                    if dimensions.pattern_Grid_Cell_Sub_Unit_Count == 3{
                        for innerX in 0..<3{
                            let computedX = (outerX*3)+innerX
                            if innerX == 0{
                                let dataCell = dataLine.dataCellArray[computedX]
                                if dataCell.currentType != .start{dataCell.currentType = .start}
                            }
                            else if innerX == 1{
                                let dataCell = dataLine.dataCellArray[computedX]
                                if dataCell.currentType != .mid{dataCell.currentType = .mid}
                            }
                            else if innerX == 2{
                                let dataCell = dataLine.dataCellArray[computedX]
                                if dataCell.currentType != .end{dataCell.currentType = .end}
                            }
                        }
                    }
                    else if dimensions.pattern_Grid_Cell_Sub_Unit_Count == 2{
                        for innerX in 0..<2{
                            let computedX = (outerX*2)+innerX
                            if innerX == 0{
                                let dataCell = dataLine.dataCellArray[computedX]
                                if dataCell.currentType != .start{dataCell.currentType = .start}
                            }
                            else if innerX == 1{
                                let dataCell = dataLine.dataCellArray[computedX]
                                if dataCell.currentType != .end{dataCell.currentType = .end}
                            }
                        }
                    }
                }
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

public enum E_CellStatus : String {
    //case unassigned
    case start = "start"
    case mid = "mid"
    case end = "end"
    case single = "single"
}
