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
    
    private var fourFourCount : Int = 0
    private var sixEightCount : Int = 0
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
            if currentType == .start_Blank || currentType == .mid_Blank || currentType == .end_Blank{
                change_Type(newType: fourStatus)
            }
            note_Reset_Status = fourStatus
        }
        else if timingParam == .sixEight {
            if currentType == .start_Blank || currentType == .mid_Blank || currentType == .end_Blank{
                change_Type(newType: sixStatus)
            }
            note_Reset_Status = sixStatus
        }
    }
    
    public func change_Type(newType:E_CellStatus){
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
