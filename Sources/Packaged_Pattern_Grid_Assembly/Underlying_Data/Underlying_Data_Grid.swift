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
    
    var fourFourCount : Int = 0
    var sixEightCount : Int = 0
    var initialStatus : E_CellStatus = .start_Blank
    var currFourStatus : E_CellStatus = .start_Blank
    var currSixStatus : E_CellStatus = .start_Blank
    
    func set_Data_Grid(){
        for y in 0..<dimensions.DATA_final_Line_Y_Index {
            let newLine = Underlying_Data_Line()
            for x in 0..<dimensions.dataGrid_X_Unit_Count{
                
                if fourFourCount == 0{currFourStatus = .start_Blank}
                else if fourFourCount == 1{currFourStatus = .mid_Blank}
                else if fourFourCount == 2{currFourStatus = .mid_Blank}
                else if fourFourCount == 3{currFourStatus = .end_Blank}
                
                if sixEightCount == 0{currSixStatus = .start_Blank}
                else if sixEightCount == 1{currSixStatus = .mid_Blank}
                else if sixEightCount == 2{currSixStatus = .mid_Blank}
                else if sixEightCount == 3{currSixStatus = .mid_Blank}
                else if sixEightCount == 4{currSixStatus = .mid_Blank}
                else if sixEightCount == 5{currSixStatus = .end_Blank}
                
                if dimensions.patternTimingConfiguration == .fourFour {
                    initialStatus = currFourStatus
                }
                else if dimensions.patternTimingConfiguration == .sixEight {
                    initialStatus = currSixStatus
                }
                
                let newDataCell = Underlying_Data_Cell(xNumParam: x, yNumParam: y, fourStatusParam: currFourStatus
                , sixStatusParam: currSixStatus, initialStatusParam: initialStatus
                , fourFourIndexParam: fourFourCount, sixEightIndexParam: sixEightCount)
                
                if sixEightCount + 1 < 6{sixEightCount+=1}
                else if sixEightCount + 1 == 6{sixEightCount=0}
                
                if fourFourCount + 1 < 4{fourFourCount+=1}
                else if fourFourCount + 1 == 4{fourFourCount=0}
                
                newLine.dataCellArray.append(newDataCell)
            }
            dataLineArray.append(newLine)
        }
    }
    
    public func changeTimingSignature_Data_Level(){
        
        if dimensions.patternTimingConfiguration == .sixEight{
            for line in dataLineArray {
                for cell in line.dataCellArray {
                    cell.react_To_Timing_Change(timingParam: .sixEight)
                }
            }
        }
        else if dimensions.patternTimingConfiguration == .fourFour{
            for line in dataLineArray {
                for cell in line.dataCellArray {
                    cell.react_To_Timing_Change(timingParam: .fourFour)
                }
            }
        }
        
    }
    
//    func set_Data_Grid(){
//
//        let compositeCellCount = dimensions.dataGrid_X_Unit_Count/dimensions.pattern_Grid_Cell_Sub_Unit_Count
//
//        for y in 0..<dimensions.DATA_final_Line_Y_Index {
//
//            let newLine = Underlying_Data_Line()
//            for outerX in 0..<compositeCellCount {
//                if dimensions.pattern_Grid_Cell_Sub_Unit_Count == 6{
//                    // start mid then end
//                    for innerX in 0..<dimensions.pattern_Grid_Cell_Sub_Unit_Count{
//
//                        let computedX = (outerX*dimensions.pattern_Grid_Cell_Sub_Unit_Count)+innerX
//
//                        if innerX == 0{
//                            let newDataCell=Underlying_Data_Cell(xNumParam: computedX, yNumParam: y, statusParam: .start_Blank)
//                            newLine.dataCellArray.append(newDataCell)
//                        }
//                        else if innerX == 1{
//                            let newDataCell=Underlying_Data_Cell(xNumParam: computedX, yNumParam: y, statusParam: .mid_Blank)
//                            newLine.dataCellArray.append(newDataCell)
//                        }
//                        else if innerX == 2{
//                            let newDataCell=Underlying_Data_Cell(xNumParam: computedX, yNumParam: y, statusParam: .mid_Blank)
//                            newLine.dataCellArray.append(newDataCell)
//                        }
//                        else if innerX == 3{
//                            let newDataCell=Underlying_Data_Cell(xNumParam: computedX, yNumParam: y, statusParam: .mid_Blank)
//                            newLine.dataCellArray.append(newDataCell)
//                        }
//                        else if innerX == 4{
//                            let newDataCell=Underlying_Data_Cell(xNumParam: computedX, yNumParam: y, statusParam: .mid_Blank)
//                            newLine.dataCellArray.append(newDataCell)
//                        }
//                        else if innerX == 5{
//                            let newDataCell=Underlying_Data_Cell(xNumParam: computedX, yNumParam: y, statusParam: .end_Blank)
//                            newLine.dataCellArray.append(newDataCell)
//                        }
//                    }
//                }
//                else if dimensions.pattern_Grid_Cell_Sub_Unit_Count == 4{
//                    // start mid then end
//                    for innerX in 0..<dimensions.pattern_Grid_Cell_Sub_Unit_Count{
//                        let computedX = (outerX*dimensions.pattern_Grid_Cell_Sub_Unit_Count)+innerX
//
//                        if innerX == 0{
//                            let newDataCell=Underlying_Data_Cell(xNumParam: computedX, yNumParam: y, statusParam: .start_Blank)
//                            newLine.dataCellArray.append(newDataCell)
//                        }
//                        else if innerX == 1{
//                            let newDataCell=Underlying_Data_Cell(xNumParam: computedX, yNumParam: y, statusParam: .mid_Blank)
//                            newLine.dataCellArray.append(newDataCell)
//                        }
//                        else if innerX == 2{
//                            let newDataCell=Underlying_Data_Cell(xNumParam: computedX, yNumParam: y, statusParam: .mid_Blank)
//                            newLine.dataCellArray.append(newDataCell)
//                        }
//                        else if innerX == 3{
//                            let newDataCell=Underlying_Data_Cell(xNumParam: computedX, yNumParam: y, statusParam: .end_Blank)
//                            newLine.dataCellArray.append(newDataCell)
//                        }
//                    }
//                }
//                else if dimensions.pattern_Grid_Cell_Sub_Unit_Count == 3{
//                    // start mid then end
//                    for innerX in 0..<3{
//                        let computedX = (outerX*3)+innerX
//
//                        if innerX == 0{
//                            let newDataCell=Underlying_Data_Cell(xNumParam: computedX, yNumParam: y, statusParam: .start_Blank)
//                            newLine.dataCellArray.append(newDataCell)
//                        }
//                        else if innerX == 1{
//                            let newDataCell=Underlying_Data_Cell(xNumParam: computedX, yNumParam: y, statusParam: .mid_Blank)
//                            newLine.dataCellArray.append(newDataCell)
//                        }
//                        else if innerX == 2{
//                            let newDataCell=Underlying_Data_Cell(xNumParam: computedX, yNumParam: y, statusParam: .end_Blank)
//                            newLine.dataCellArray.append(newDataCell)
//                        }
//                    }
//                }
//                else if dimensions.pattern_Grid_Cell_Sub_Unit_Count == 2{
//                    // start then end
//                    for innerX in 0..<2{
//                        let computedX = (outerX*2)+innerX
//                        if innerX == 0{
//                            let newDataCell=Underlying_Data_Cell(xNumParam: computedX, yNumParam: y, statusParam: .start_Blank)
//                            newLine.dataCellArray.append(newDataCell)
//                        }
//                        else if innerX == 1{
//                            let newDataCell=Underlying_Data_Cell(xNumParam: computedX, yNumParam: y, statusParam: .end_Blank)
//                            newLine.dataCellArray.append(newDataCell)
//                        }
//                    }
//
//                }
//
//            }
//            dataLineArray.append(newLine)
//        }
//    }
    
    

//    public func changeTimingSignature_Data_Level(){
//
//        let compositeCellCount = dimensions.dataGrid_X_Unit_Count/dimensions.pattern_Grid_Cell_Sub_Unit_Count
//        for dataLine in dataLineArray {
//                for outerX in 0..<compositeCellCount {
//
//                    if dimensions.pattern_Grid_Cell_Sub_Unit_Count == 6{
//                        for innerX in 0..<6{
//                            let computedX = (outerX*6)+innerX
//                            let dataCell = dataLine.dataCellArray[computedX]
//                            if dataCell.note_Im_In == nil{
//                                if innerX == 0{
//                                    if dataCell.currentType != .start_Blank{dataCell.currentType = .start_Blank}
//                                    dataCell.note_Reset_Status = .start_Blank
//                                }
//                                else if innerX == 1{
//                                    if dataCell.currentType != .mid_Blank{dataCell.currentType = .mid_Blank}
//                                    dataCell.note_Reset_Status = .mid_Blank
//                                }
//                                else if innerX == 2{
//                                    if dataCell.currentType != .mid_Blank{dataCell.currentType = .mid_Blank}
//                                    dataCell.note_Reset_Status = .mid_Blank
//                                }
//                                else if innerX == 3{
//                                    if dataCell.currentType != .mid_Blank{dataCell.currentType = .mid_Blank}
//                                    dataCell.note_Reset_Status = .mid_Blank
//                                }
//                                else if innerX == 4{
//                                    if dataCell.currentType != .mid_Blank{dataCell.currentType = .mid_Blank}
//                                    dataCell.note_Reset_Status = .mid_Blank
//                                }
//                                else if innerX == 5{
//                                    if dataCell.currentType != .end_Blank{dataCell.currentType = .end_Blank}
//                                    dataCell.note_Reset_Status = .end_Blank
//                                }
//                            }
//                            else if dataCell.note_Im_In != nil{
//                                if innerX == 0{
//                                    dataCell.note_Reset_Status = .start_Blank
//                                }
//                                else if innerX == 1{
//                                    dataCell.note_Reset_Status = .mid_Blank
//                                }
//                                else if innerX == 2{
//                                    dataCell.note_Reset_Status = .mid_Blank
//                                }
//                                else if innerX == 3{
//                                    dataCell.note_Reset_Status = .mid_Blank
//                                }
//                                else if innerX == 4{
//                                    dataCell.note_Reset_Status = .mid_Blank
//                                }
//                                else if innerX == 5{
//                                    dataCell.note_Reset_Status = .end_Blank
//                                }
//                            }
//                        }
//                    }
//
//                    else if dimensions.pattern_Grid_Cell_Sub_Unit_Count == 4{
//                        for innerX in 0..<4{
//                            let computedX = (outerX*4)+innerX
//                            let dataCell = dataLine.dataCellArray[computedX]
//                            if dataCell.note_Im_In == nil{
//                                if innerX == 0{
//                                    if dataCell.currentType != .start_Blank{dataCell.currentType = .start_Blank}
//                                    dataCell.note_Reset_Status = .start_Blank
//                                }
//                                else if innerX == 1{
//                                    if dataCell.currentType != .mid_Blank{dataCell.currentType = .mid_Blank}
//                                    dataCell.note_Reset_Status = .mid_Blank
//                                }
//                                else if innerX == 2{
//                                    if dataCell.currentType != .mid_Blank{dataCell.currentType = .mid_Blank}
//                                    dataCell.note_Reset_Status = .mid_Blank
//                                }
//                                else if innerX == 3{
//                                    if dataCell.currentType != .end_Blank{dataCell.currentType = .end_Blank}
//                                    dataCell.note_Reset_Status = .end_Blank
//                                }
//                            }
//                            else if dataCell.note_Im_In != nil{
//                                if innerX == 0{
//                                    dataCell.note_Reset_Status = .start_Blank
//                                }
//                                else if innerX == 1{
//                                    dataCell.note_Reset_Status = .mid_Blank
//                                }
//                                else if innerX == 2{
//                                    dataCell.note_Reset_Status = .mid_Blank
//                                }
//                                else if innerX == 3{
//                                    dataCell.note_Reset_Status = .end_Blank
//                                }
//                            }
//                        }
//                    }
//
//                    else if dimensions.pattern_Grid_Cell_Sub_Unit_Count == 3{
//                        for innerX in 0..<3{
//                            let computedX = (outerX*3)+innerX
//                            let dataCell = dataLine.dataCellArray[computedX]
//                            if dataCell.note_Im_In == nil{
//                                if innerX == 0{
//                                    if dataCell.currentType != .start_Blank{dataCell.currentType = .start_Blank}
//                                    dataCell.note_Reset_Status = .start_Blank
//                                }
//                                else if innerX == 1{
//                                    if dataCell.currentType != .mid_Blank{dataCell.currentType = .mid_Blank}
//                                    dataCell.note_Reset_Status = .mid_Blank
//                                }
//                                else if innerX == 2{
//                                    if dataCell.currentType != .end_Blank{dataCell.currentType = .end_Blank}
//                                    dataCell.note_Reset_Status = .end_Blank
//                                }
//                            }
//                            else if dataCell.note_Im_In != nil{
//                                if innerX == 0{
//                                    dataCell.note_Reset_Status = .start_Blank
//                                }
//                                else if innerX == 1{
//                                    dataCell.note_Reset_Status = .mid_Blank
//                                }
//                                else if innerX == 2{
//                                    dataCell.note_Reset_Status = .end_Blank
//                                }
//                            }
//                        }
//                    }
//
//                    else if dimensions.pattern_Grid_Cell_Sub_Unit_Count == 2{
//                        for innerX in 0..<2{
//                            let computedX = (outerX*2)+innerX
//                            let dataCell = dataLine.dataCellArray[computedX]
//                            if dataCell.note_Im_In == nil{
//                                if innerX == 0{
//                                    if dataCell.currentType != .start_Blank{dataCell.currentType = .start_Blank}
//                                    dataCell.note_Reset_Status = .start_Blank
//                                }
//                                else if innerX == 1{
//                                    if dataCell.currentType != .end_Blank{dataCell.currentType = .end_Blank}
//                                    dataCell.note_Reset_Status = .end_Blank
//                                }
//                            }
//                            else if dataCell.note_Im_In != nil{
//                                if innerX == 0{
//                                    dataCell.note_Reset_Status = .start_Blank
//                                }
//                                else if innerX == 1{
//                                    dataCell.note_Reset_Status = .end_Blank
//                                }
//                            }
//                        }
//                    }
//
//            }
//        }
//
//    }
    
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
    var isHighlighted : Bool = false
    var note_Im_In : Note?
    weak var currentConnectedDataVals : Data_Vals_Holder?

    var note_Reset_Status : E_CellStatus
    public var currentType : E_CellStatus
    public var fourStatus : E_CellStatus
    public var sixStatus : E_CellStatus
    
    public var subCellIndex_Four_Four : Int
    public var subCellIndex_Six_Eight : Int
    
    public init(xNumParam:Int,yNumParam:Int,fourStatusParam:E_CellStatus,sixStatusParam:E_CellStatus,initialStatusParam:E_CellStatus,fourFourIndexParam:Int,sixEightIndexParam:Int){
        if yNumParam == 0 {print("xNumParam: ",xNumParam.description)}
        
        subCellIndex_Four_Four = fourFourIndexParam
        subCellIndex_Six_Eight = sixEightIndexParam
        
        dataCell_X_Number = xNumParam
        dataCell_Y_Number = yNumParam
        
        fourStatus = fourStatusParam
        sixStatus = sixStatusParam
        
        currentType = initialStatusParam
        note_Reset_Status = initialStatusParam
    }
    
    public func react_To_Timing_Change(timingParam:E_CentralGridTiming){
        if timingParam == .fourFour {
            change_Type(newType: fourStatus)
        }
        else if timingParam == .sixEight {
            change_Type(newType: sixStatus)
        }
    }
    
    public func change_Type(newType:E_CellStatus){
        print("changing to: ",newType.rawValue)
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
    
    public func reset_To_Original(){
        currentType = note_Reset_Status
        if let lcl_Data_Vals = currentConnectedDataVals{
            lcl_Data_Vals.referenced_isProhibited = false
            lcl_Data_Vals.updateValsFromNewData(newXNum: dataCell_X_Number
            , newYNum: dataCell_Y_Number
            , newCellStatus: note_Reset_Status
            , newNoteImIn: nil, isHighlightedParan: false)
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
    
    case prohibited_Note = "prohibited_Note"
    
}
