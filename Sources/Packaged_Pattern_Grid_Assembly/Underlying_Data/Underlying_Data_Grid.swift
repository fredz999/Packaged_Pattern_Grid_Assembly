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
    
    private var fourFour_Sub_Count : Int = 0
    private var fourFour_Cell_Count : Int = 0
    private var sixEight_Sub_Count : Int = 0
    private var sixEight_Cell_Count : Int = 0
    
    var initialStatus : E_CellStatus = .start_Blank
    var currFourStatus : E_CellStatus = .start_Blank
    var currSixStatus : E_CellStatus = .start_Blank
    
    func set_Data_Grid(){
        for y in 0..<dimensions.DATA_final_Line_Y_Index {
            let newLine = Underlying_Data_Line()
            for x in 0..<dimensions.dataGrid_X_Unit_Count{
                
                if fourFour_Sub_Count == 0{currFourStatus = .start_Blank}
                else if fourFour_Sub_Count == 1{currFourStatus = .mid_Blank}
                else if fourFour_Sub_Count == 2{currFourStatus = .mid_Blank}
                else if fourFour_Sub_Count == 3{currFourStatus = .end_Blank}
                
                if sixEight_Sub_Count == 0{currSixStatus = .start_Blank}
                else if sixEight_Sub_Count == 1{currSixStatus = .mid_Blank}
                else if sixEight_Sub_Count == 2{currSixStatus = .mid_Blank}
                else if sixEight_Sub_Count == 3{currSixStatus = .mid_Blank}
                else if sixEight_Sub_Count == 4{currSixStatus = .mid_Blank}
                else if sixEight_Sub_Count == 5{currSixStatus = .end_Blank}
                
                if dimensions.patternTimingConfiguration == .fourFour {
                    initialStatus = currFourStatus
                }
                else if dimensions.patternTimingConfiguration == .sixEight {
                    initialStatus = currSixStatus
                }
                
                let newDataCell = Underlying_Data_Cell(xNumParam: x, yNumParam: y, fourStatusParam: currFourStatus
                , sixStatusParam: currSixStatus, initialStatusParam: initialStatus
                , fourFourIndexParam: fourFour_Sub_Count, sixEightIndexParam: sixEight_Sub_Count
                , four_Four_Cell_Index_Param:fourFour_Cell_Count,six_Eight_Cell_Index_Param:sixEight_Cell_Count)
                
                if sixEight_Sub_Count + 1 < 6{sixEight_Sub_Count+=1}
                else if sixEight_Sub_Count + 1 == 6{
                    sixEight_Sub_Count = 0
                    sixEight_Cell_Count += 1
                }
                
                if fourFour_Sub_Count + 1 < 4{fourFour_Sub_Count+=1}
                else if fourFour_Sub_Count + 1 == 4{
                    fourFour_Sub_Count=0
                    fourFour_Cell_Count+=1
                }
                
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
//==================================================================================================================
//==================================================================================================================


public class Underlying_Data_Line:ObservableObject,Identifiable {
    public var id = UUID()
    public var dataCellArray : [Underlying_Data_Cell] = []
}




//==================================================================================================================
//==================================================================================================================





// this things line ref dosent change
public class Underlying_Data_Cell:Identifiable,Equatable,Hashable {
    
    public static func == (lhs: Underlying_Data_Cell, rhs: Underlying_Data_Cell) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public var id = UUID()
    public var dataCell_X_Number : Int
    public var dataCell_Y_Number : Int
    //================================================================================================================
    // hopefully none of these three can be true at the same time or this model is all wrongggggggg
    // like theyre mutually exclusive
    //=================================================== vizzzz -i- bil ==============================================
    var isProhibited : Bool = false
    {
        didSet{
            handleVisibleStateChange(type: .activate_Prohibited)
        }
    }
//    {
//        didSet {
//            handleVisibleStateChange(in_Viable_Set_Left_Param: in_Viable_Set_Left, in_Viable_Set_Right_Param: in_Viable_Set_Right, isHighlightedParam: isHighlighted, isProhibitedParam: isProhibited)
//        }
//    }
    
    var isHighlighted : Bool = false
    {
        didSet{
            handleVisibleStateChange(type: .activate_Highlighted )
        }
    }
//    {
//        didSet {
//            handleVisibleStateChange(in_Viable_Set_Left_Param: in_Viable_Set_Left, in_Viable_Set_Right_Param: in_Viable_Set_Right, isHighlightedParam: isHighlighted, isProhibitedParam: isProhibited)
//        }
//    }
    
    var in_Viable_Set_Right : Bool = false
    {
        didSet{
            handleVisibleStateChange(type: .activate_Viable_Set_Right )
        }
    }
//    {
//        didSet {
//            handleVisibleStateChange(in_Viable_Set_Left_Param: in_Viable_Set_Left, in_Viable_Set_Right_Param: in_Viable_Set_Right, isHighlightedParam: isHighlighted, isProhibitedParam: isProhibited)
//        }
//    }
    
    var in_Viable_Set_Left : Bool = false
    {
        didSet{
            handleVisibleStateChange(type: .activate_Prohibited )
        }
    }
//    {
//        didSet {
//            handleVisibleStateChange(in_Viable_Set_Left_Param: in_Viable_Set_Left, in_Viable_Set_Right_Param: in_Viable_Set_Right, isHighlightedParam: isHighlighted, isProhibitedParam: isProhibited)
//        }
//    }
    
    var in_Potential_Set : Bool = false
    {
        didSet{
            handleVisibleStateChange(type: .activate_Potential_Set )
        }
    }
//    {
//        didSet {
//            handleVisibleStateChange(in_Viable_Set_Left_Param: in_Viable_Set_Left
//                                     , in_Viable_Set_Right_Param: in_Viable_Set_Right
//                                     , isHighlightedParam: isHighlighted
//                                     , isProhibitedParam: isProhibited)
//        }
//    }

    // LOL this is absolute LASH - there should be an enum or something HAHAHAHA so rubbish
    //handleVisibleStateChange(in_Viable_Set_Left_Param:Bool,in_Viable_Set_Right_Param:Bool,isHighlightedParam:Bool,isProhibitedParam:Bool){
    func handleVisibleStateChange(type : E_VisibleStateChangeType){
        
        if type == .activate_Highlighted {
        //if isHighlightedParam == true {
            if in_Viable_Set_Right == true { in_Viable_Set_Right = false }
            if in_Viable_Set_Left == true{ in_Viable_Set_Left = false }
            if isProhibited == true { isProhibited = false }
        }
        else if type == .activate_Viable_Set_Right {
        //else if in_Viable_Set_Right_Param == true {
            if isHighlighted == true { isHighlighted = false }
            if isProhibited == true { isProhibited = false }
            if in_Viable_Set_Left == true{in_Viable_Set_Left = false }
        }
        else if type == .activate_Viable_Set_Left {
        //else if in_Viable_Set_Left_Param == true {
            if isHighlighted == true { isHighlighted = false }
            if isProhibited == true { isProhibited = false }
            if in_Viable_Set_Right == true{ in_Viable_Set_Right = false }
        }
        else if type == .activate_Prohibited {
        //else if isProhibitedParam == true {
            if in_Viable_Set_Right == true { in_Viable_Set_Right = false }
            if in_Viable_Set_Left == true{ in_Viable_Set_Left = false }
            if isHighlighted == true { isHighlighted = false }
        }
        else if type == .activate_Potential_Set {
        //else if isProhibitedParam == true {
            if in_Viable_Set_Right == true { in_Viable_Set_Right = false }
            if in_Viable_Set_Left == true{ in_Viable_Set_Left = false }
            if isHighlighted == true { isHighlighted = false }
        }
        
        if let lclDataVals = currentConnectedDataVals{
            lclDataVals.referenced_in_Viable_Set_Right = in_Viable_Set_Right
            lclDataVals.referenced_in_Viable_Set_Left = in_Viable_Set_Left
            lclDataVals.referenced_isHighlighted = isHighlighted
            lclDataVals.referenced_is_Prohibited_Set = isProhibited
            lclDataVals.updateTempVisualStatus()
        }
    }
    //================================================================================================================
    var note_Im_In : Note?
    weak var currentConnectedDataVals : Data_Vals_Holder?

    var note_Reset_Status : E_CellStatus
    public var currentType : E_CellStatus
    public var fourStatus : E_CellStatus
    public var sixStatus : E_CellStatus
    
    public var four_Four_Sub_Index : Int
    public var four_Four_Cell_Index : Int
    public var six_Eight_Sub_Index : Int
    public var six_Eight_Cell_Index : Int
    
    public init(xNumParam:Int,yNumParam:Int,fourStatusParam:E_CellStatus,sixStatusParam:E_CellStatus
    ,initialStatusParam:E_CellStatus,fourFourIndexParam:Int,sixEightIndexParam:Int
    ,four_Four_Cell_Index_Param:Int,six_Eight_Cell_Index_Param:Int){
        
    four_Four_Sub_Index = fourFourIndexParam
    four_Four_Cell_Index = four_Four_Cell_Index_Param
    six_Eight_Sub_Index = sixEightIndexParam
    six_Eight_Cell_Index = six_Eight_Cell_Index_Param
    
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
    
    public func change_Viable_Set_Status(viableSetMembershipParam:Bool){
        if in_Viable_Set_Right != viableSetMembershipParam {
            in_Viable_Set_Right = viableSetMembershipParam
            if let lcl_Data_Vals = currentConnectedDataVals {
                if lcl_Data_Vals.referenced_in_Viable_Set_Right != viableSetMembershipParam {
                    lcl_Data_Vals.referenced_in_Viable_Set_Right = viableSetMembershipParam
                }
            }
        }
    }
    
    public func change_Prohibition_Status(newProhibitionStatus:Bool){
        if isProhibited != newProhibitionStatus {
            isProhibited = newProhibitionStatus
            if let lcl_Data_Vals = currentConnectedDataVals {
                if lcl_Data_Vals.referenced_is_Prohibited_Set != newProhibitionStatus {
                    lcl_Data_Vals.referenced_is_Prohibited_Set = newProhibitionStatus
                }
            }
        }
    }
    
    public func reset_To_Original(){
        currentType = note_Reset_Status
        if let lcl_Data_Vals = currentConnectedDataVals{
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
    
}

enum E_VisibleStateChangeType {
    case activate_Prohibited
    case activate_Highlighted
    case activate_Viable_Set_Right
    case activate_Viable_Set_Left
    case activate_Potential_Set
}


//var isProhibited : Bool = false
//{
//    didSet {
//        handleVisibleStateChange(in_Viable_Set_Left_Param: in_Viable_Set_Left, in_Viable_Set_Right_Param: in_Viable_Set_Right, isHighlightedParam: isHighlighted, isProhibitedParam: isProhibited)
//    }
//}
//
//var isHighlighted : Bool = false
//{
//    didSet {
//        handleVisibleStateChange(in_Viable_Set_Left_Param: in_Viable_Set_Left, in_Viable_Set_Right_Param: in_Viable_Set_Right, isHighlightedParam: isHighlighted, isProhibitedParam: isProhibited)
//    }
//}
//
//var in_Viable_Set_Right : Bool = false
//{
//    didSet {
//        handleVisibleStateChange(in_Viable_Set_Left_Param: in_Viable_Set_Left, in_Viable_Set_Right_Param: in_Viable_Set_Right, isHighlightedParam: isHighlighted, isProhibitedParam: isProhibited)
//    }
//}
//
//var in_Viable_Set_Left : Bool = false
//{
//    didSet {
//        handleVisibleStateChange(in_Viable_Set_Left_Param: in_Viable_Set_Left, in_Viable_Set_Right_Param: in_Viable_Set_Right, isHighlightedParam: isHighlighted, isProhibitedParam: isProhibited)
//    }
//}
//
//var in_Potential_Set : Bool = false
