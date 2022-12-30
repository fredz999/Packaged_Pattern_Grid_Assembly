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
                            let newDataCell=Underlying_Data_Cell(xNumParam: computedX, yNumParam: y, statusParam: .start_Blank)
                            newLine.dataCellArray.append(newDataCell)
                        }
                        else if innerX == 1{
                            let newDataCell=Underlying_Data_Cell(xNumParam: computedX, yNumParam: y, statusParam: .mid_Blank)
                            newLine.dataCellArray.append(newDataCell)
                        }
                        else if innerX == 2{
                            let newDataCell=Underlying_Data_Cell(xNumParam: computedX, yNumParam: y, statusParam: .end_Blank)
                            newLine.dataCellArray.append(newDataCell)
                        }
                        
                    }
        
                    
                }
                else if dimensions.pattern_Grid_Cell_Sub_Unit_Count == 2{
                    // start then end
                    for innerX in 0..<2{
                        let computedX = (outerX*2)+innerX
                        if innerX == 0{
                            let newDataCell=Underlying_Data_Cell(xNumParam: computedX, yNumParam: y, statusParam: .start_Blank)
                            newLine.dataCellArray.append(newDataCell)
                        }
                        else if innerX == 1{
                            let newDataCell=Underlying_Data_Cell(xNumParam: computedX, yNumParam: y, statusParam: .end_Blank)
                            newLine.dataCellArray.append(newDataCell)
                        }
                    }
                    
                }
                
            }
            dataLineArray.append(newLine)
        }
    }
    

    public func changeTimingSignature_Data_Level(){

        let compositeCellCount = dimensions.dataGrid_X_Unit_Count/dimensions.pattern_Grid_Cell_Sub_Unit_Count
        for dataLine in dataLineArray {
                for outerX in 0..<compositeCellCount {
                    
                    
                    
                    if dimensions.pattern_Grid_Cell_Sub_Unit_Count == 3{
                        
                        for innerX in 0..<3{
                            let computedX = (outerX*3)+innerX
                            let dataCell = dataLine.dataCellArray[computedX]
                            if dataCell.note_Im_In == nil{
                                if innerX == 0{
                                    //let dataCell = dataLine.dataCellArray[computedX]
                                    if dataCell.currentType != .start_Blank{dataCell.currentType = .start_Blank}
                                    dataCell.note_Reset_Status = .start_Blank
                                }
                                else if innerX == 1{
                                    //let dataCell = dataLine.dataCellArray[computedX]
                                    if dataCell.currentType != .mid_Blank{dataCell.currentType = .mid_Blank}
                                    dataCell.note_Reset_Status = .mid_Blank
                                }
                                else if innerX == 2{
                                    //let dataCell = dataLine.dataCellArray[computedX]
                                    if dataCell.currentType != .end_Blank{dataCell.currentType = .end_Blank}
                                    dataCell.note_Reset_Status = .end_Blank
                                }
                            }
                        }
                        
                        
                        
                    }
                    else if dimensions.pattern_Grid_Cell_Sub_Unit_Count == 2{
                        for innerX in 0..<2{
                            let computedX = (outerX*2)+innerX
                            let dataCell = dataLine.dataCellArray[computedX]
                            if dataCell.note_Im_In == nil{
                                if innerX == 0{
                                    //let dataCell = dataLine.dataCellArray[computedX]
                                    if dataCell.currentType != .start_Blank{dataCell.currentType = .start_Blank}
                                    dataCell.note_Reset_Status = .start_Blank
                                }
                                else if innerX == 1{
                                    //let dataCell = dataLine.dataCellArray[computedX]
                                    if dataCell.currentType != .end_Blank{dataCell.currentType = .end_Blank}
                                    dataCell.note_Reset_Status = .end_Blank
                                }
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
public class Underlying_Data_Cell:Identifiable {
    
    public var id = UUID()
    public var dataCell_X_Number : Int
    public var dataCell_Y_Number : Int
    private var isHighlighted : Bool = false
    var note_Im_In : Note?
    weak var currentConnectedDataVals : Data_Vals_Holder?
    
    public var currentType : E_CellStatus // = .unassigned
    var note_Reset_Status : E_CellStatus
    
    public init(xNumParam:Int,yNumParam:Int,statusParam:E_CellStatus){
        dataCell_X_Number = xNumParam
        dataCell_Y_Number = yNumParam
        currentType = statusParam
        note_Reset_Status = statusParam
    }
    
    public func reset_Type(newType:E_CellStatus){
        currentType = newType
        if let lcl_Data_Vals = currentConnectedDataVals{
            lcl_Data_Vals.referenced_currentStatus = newType
        }
    }
    
    public func change_Highlight(highlightStatusParam:Bool){
        if isHighlighted != highlightStatusParam{
            isHighlighted = highlightStatusParam
            if let lcl_Data_Vals = currentConnectedDataVals{
                lcl_Data_Vals.referenced_isHighlighted = highlightStatusParam
            }
        }
    }
    
}

public enum E_CellStatus : String {

    case start_Blank = "start_Blank"
    case mid_Blank = "mid_Blank"
    case end_Blank = "end_Blank"
    
    case start_Note = "start_Note"
    case mid_Note = "mid_Note"
    case end_Note = "end_Note"
    case single_Note = "single_Note"
    
}
