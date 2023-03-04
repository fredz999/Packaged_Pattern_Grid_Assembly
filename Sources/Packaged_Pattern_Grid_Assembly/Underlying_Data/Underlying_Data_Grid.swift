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
    public init(){ set_Data_Grid() }
    
    private var fourFour_Sub_Count : Int = 0
    private var fourFour_Cell_Count : Int = 0

    private var sixEight_Sub_Count : Int = 0
    private var sixEight_Cell_Count : Int = 0
    
    private var fourFour_Half_Cell_Count : Int = 0
    private var sixEight_Half_Cell_Count : Int = 0
    
    private var sixEight_Half_Sub_Count : Int = 0
    private var fourFour_Half_Sub_Count : Int = 0
    
    var initialStatus : E_CellStatus = .start_Blank
    var currFourStatus : E_CellStatus = .start_Blank
    var currSixStatus : E_CellStatus = .start_Blank
    
    var grid_Of_Cells_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    //var line_Of_Cells_Set : Set<Set<Underlying_Data_Cell>> = Set<Set<Underlying_Data_Cell>>()
    //var grid_Set : Set<Set<Underlying_Data_Line>> = Set<Set<Underlying_Data_Line>>()
    
    func set_Data_Grid(){
        for line_Y_Number in 0..<dimensions.DATA_final_Line_Y_Index {
            let newLine = Underlying_Data_Line()
            //var new_Line_Set = Set<Underlying_Data_Cell>()
            
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
                
                if line_Y_Number == 0 {

                    if fourFour_Half_Sub_Count == 0  {
                        let insertFloat = CGFloat(x)*dimensions.pattern_Grid_Sub_Cell_Width
                        let cellIndexDescriptor : Cell_X_Descriptor = Cell_X_Descriptor(x_Position_Int: x, x_Position_Float: insertFloat)
                        dimensions.four_Four_Slider_Positions.insert(cellIndexDescriptor)
                    }

                    if sixEight_Half_Sub_Count == 0 {
                        let insertFloat = CGFloat(x)*dimensions.pattern_Grid_Sub_Cell_Width
                        let cellIndexDescriptor : Cell_X_Descriptor = Cell_X_Descriptor(x_Position_Int: x, x_Position_Float: insertFloat)
                        dimensions.six_Eight_Slider_Positions.insert(cellIndexDescriptor)
                    }

                }
                
                let newDataCell = Underlying_Data_Cell(xNumParam: x, yNumParam: line_Y_Number, fourStatusParam: currFourStatus, sixStatusParam: currSixStatus
                , initialStatusParam: initialStatus, fourFourSubIndexParam: fourFour_Sub_Count, sixEightSubIndexParam: sixEight_Sub_Count
                , four_Four_Cell_Index_Param: fourFour_Cell_Count, six_Eight_Cell_Index_Param: sixEight_Cell_Count
                , four_Four_Half_Sub_Index_Param: fourFour_Half_Sub_Count
                , four_Four_Half_Cell_Index_Param: fourFour_Half_Cell_Count
                , six_Eight_Half_Sub_Index_Param: sixEight_Half_Sub_Count
                , six_Eight_Half_Cell_Index_Param: sixEight_Half_Cell_Count)
                
                if fourFour_Sub_Count + 1 < 6{fourFour_Sub_Count+=1}
                else if fourFour_Sub_Count + 1 == 6{
                    fourFour_Sub_Count = 0
                    fourFour_Cell_Count += 1
                }

                if sixEight_Sub_Count + 1 < 4{sixEight_Sub_Count+=1}
                else if sixEight_Sub_Count + 1 == 4{
                    sixEight_Sub_Count=0
                    sixEight_Cell_Count+=1
                }
                
                if fourFour_Half_Sub_Count + 1 < 3{fourFour_Half_Sub_Count+=1}
                else if fourFour_Half_Sub_Count + 1 == 3{
                    fourFour_Half_Sub_Count = 0
                    fourFour_Half_Cell_Count += 1
                }

                if sixEight_Half_Sub_Count + 1 < 2{sixEight_Half_Sub_Count+=1}
                else if sixEight_Half_Sub_Count + 1 == 2{
                    sixEight_Half_Sub_Count=0
                    sixEight_Half_Cell_Count+=1
                }
                //new_Line_Set.insert(newDataCell)
                newLine.dataCellArray.append(newDataCell)
                grid_Of_Cells_Set.insert(newDataCell)
            }
            dataLineArray.append(newLine)
            //grid_Of_Cells_Set.insert(new_Line_Set)
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

public class Underlying_Data_Line:ObservableObject,Identifiable,Equatable,Hashable {
    
    public static func == (lhs: Underlying_Data_Line, rhs: Underlying_Data_Line) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public var id = UUID()
    
    public var dataCellArray : [Underlying_Data_Cell] = []
    
}

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

    var in_Prohibited_Set : Bool = false
    
    var in_Highlighted_Set : Bool = false
    
    var in_Potential_Set : Bool = false
    
    var in_Potential_Edge_Set : Bool = false

    var in_Delete_Square_Set : Bool = false
    
    var in_Delete_Trail_Set : Bool = false
    
    var in_MoveNote_Cursor_Set : Bool = false
    
    var in_Passive_Cursor_Set : Bool = false

    func handleVisibleStateChange(type : E_VisibleStateChangeType){
        
        if type == .activate_Passive_Cursor_Set {
            if in_Passive_Cursor_Set == false {
                in_Passive_Cursor_Set = true
                if let lclDataVals = currentConnectedDataVals {
                    lclDataVals.update_Cell_Set_Membership(status_Update_TypeParam: .passiveCursorSet, value: in_Passive_Cursor_Set)
                }
            }
        }
        else if type == .deActivate_Passive_Cursor_Set{
            if in_Passive_Cursor_Set == true {
                in_Passive_Cursor_Set = false
                if let lclDataVals = currentConnectedDataVals {
                    lclDataVals.update_Cell_Set_Membership(status_Update_TypeParam: .passiveCursorSet, value: in_Passive_Cursor_Set)
                }
            }
        }
        else if type == .activate_MoveNote_Cursor_Set{
            if in_MoveNote_Cursor_Set == false {
                in_MoveNote_Cursor_Set = true
                if let lclDataVals = currentConnectedDataVals {
                    lclDataVals.update_Cell_Set_Membership(status_Update_TypeParam: .moveNote_Cursor_Set, value: in_MoveNote_Cursor_Set)
                }
            }
        }
        else if type == .deActivate_MoveNote_Cursor_Set {
            if in_MoveNote_Cursor_Set == true {
                in_MoveNote_Cursor_Set = false
                if let lclDataVals = currentConnectedDataVals {
                    lclDataVals.update_Cell_Set_Membership(status_Update_TypeParam: .moveNote_Cursor_Set, value: in_MoveNote_Cursor_Set)
                }
            }
        }
        else if type == .activate_Delete_Square_Set {
            if in_Delete_Square_Set == false {
                in_Delete_Square_Set = true
                if let lclDataVals = currentConnectedDataVals {
                    lclDataVals.update_Cell_Set_Membership(status_Update_TypeParam: .deleteSquareSet , value: in_Delete_Square_Set)
                }
            }
        }
        else if type == .deActivate_Delete_Square_Set {
            if in_Delete_Square_Set == true {
                in_Delete_Square_Set = false
                if let lclDataVals = currentConnectedDataVals {
                    lclDataVals.update_Cell_Set_Membership(status_Update_TypeParam: .deleteSquareSet, value: in_Delete_Square_Set)
                }
            }
        }
        else if type == .activate_Cursor_Set {
            if in_Cursor_Set == false {
                in_Cursor_Set = true
                if let lclDataVals = currentConnectedDataVals {
                    lclDataVals.update_Cell_Set_Membership(status_Update_TypeParam: .cursorSet, value: in_Cursor_Set)
                }
            }
        }
        else if type == .deActivate_Cursor_Set {
            if in_Cursor_Set == true {
                in_Cursor_Set = false
                if let lclDataVals = currentConnectedDataVals {
                    lclDataVals.update_Cell_Set_Membership(status_Update_TypeParam: .cursorSet, value: in_Cursor_Set)
                }
            }
        }
        
        else if type == .activate_Potential_Set {
            if in_Potential_Set == false {
                in_Potential_Set = true
                if let lclDataVals = currentConnectedDataVals {
                    lclDataVals.update_Cell_Set_Membership(status_Update_TypeParam: .potentialSet , value: in_Potential_Set)
                }
            }
        }
        else if type == .deActivate_Potential_Set {
            if in_Potential_Set == true {
                in_Potential_Set = false
                if let lclDataVals = currentConnectedDataVals{
                    lclDataVals.update_Cell_Set_Membership(status_Update_TypeParam: .potentialSet , value: in_Potential_Set)
                }
            }
        }
        else if type == .activate_Prohibited {
            if in_Prohibited_Set == false{in_Prohibited_Set=true}
        }
        else if type == .deActivate_Prohibited {
            if in_Prohibited_Set == true{in_Prohibited_Set=false}
        }
        
    }

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
    
    public var four_Four_Half_Sub_Index : Int
    public var four_Four_Half_Cell_Index : Int
    public var six_Eight_Half_Sub_Index : Int
    public var six_Eight_Half_Cell_Index : Int
    
    public init(xNumParam:Int,yNumParam:Int,fourStatusParam:E_CellStatus,sixStatusParam:E_CellStatus,initialStatusParam:E_CellStatus
    ,fourFourSubIndexParam:Int
    ,sixEightSubIndexParam:Int
    ,four_Four_Cell_Index_Param:Int
    ,six_Eight_Cell_Index_Param:Int
    ,four_Four_Half_Sub_Index_Param:Int
    ,four_Four_Half_Cell_Index_Param:Int
    ,six_Eight_Half_Sub_Index_Param:Int
    ,six_Eight_Half_Cell_Index_Param:Int
    ){
    four_Four_Sub_Index = fourFourSubIndexParam
    four_Four_Cell_Index = four_Four_Cell_Index_Param
    six_Eight_Sub_Index = sixEightSubIndexParam
    six_Eight_Cell_Index = six_Eight_Cell_Index_Param
    four_Four_Half_Sub_Index = four_Four_Half_Sub_Index_Param
    four_Four_Half_Cell_Index = four_Four_Half_Cell_Index_Param
    six_Eight_Half_Sub_Index = six_Eight_Half_Sub_Index_Param
    six_Eight_Half_Cell_Index = six_Eight_Half_Cell_Index_Param

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
        if let lcl_Data_Vals = currentConnectedDataVals {
            lcl_Data_Vals.referenced_currentStatus = newType
        }
    }
    
    public func change_Highlight(highlightStatusParam:Bool){
        if in_Highlighted_Set != highlightStatusParam {
            in_Highlighted_Set = highlightStatusParam
            if let lcl_Data_Vals = currentConnectedDataVals {
                lcl_Data_Vals.update_Cell_Set_Membership(status_Update_TypeParam: .highlightedSet, value: highlightStatusParam)
            }
        }
    }
    
//    public func change_Prohibition_Status(newProhibitionStatus:Bool){
//        if in_Prohibited_Set != newProhibitionStatus {
//            in_Prohibited_Set = newProhibitionStatus
//            if let lcl_Data_Vals = currentConnectedDataVals {
//                lcl_Data_Vals.update_Cell_Set_Membership(status_Update_TypeParam: .prohibitedSet, value: newProhibitionStatus)
//            }
//        }
//    }
    
    //activate_Delete_Square_Combined
    //deActivate_Delete_Square_Combined
    
//    public func change_DeleteSquare_Status(newProhibitionStatus:Bool){
//        if in_Prohibited_Set != newProhibitionStatus {
//            in_Prohibited_Set = newProhibitionStatus
//            if let lcl_Data_Vals = currentConnectedDataVals {
//                lcl_Data_Vals.update_Cell_Set_Membership(status_Update_TypeParam: .prohibitedSet, value: newProhibitionStatus)
//            }
//        }
//    }
    
    var in_Cursor_Set : Bool = false
    
    public func reset_To_Original(){
        currentType = note_Reset_Status
        if let lcl_Data_Vals = currentConnectedDataVals {
            lcl_Data_Vals.updateValsFromNewData(
            newXNum: dataCell_X_Number
            , newYNum: dataCell_Y_Number
            , newCellNoteStatus: note_Reset_Status
            , newNoteImIn: nil
            )
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
    case deActivate_Prohibited
    
//    case activate_Highlighted
//    case deActivate_Highlighted
    
//    case activate_UnSelected
//    case activate_Selected
//    case activate_Selected_For_Move
//    case activate_Selected_For_Resize
    
    
    
    case activate_Viable_Set_Combined
    case deActivate_Viable_Set_Combined
    
    case activate_Potential_Set
    case deActivate_Potential_Set
    
    case activate_Cursor_Set
    case deActivate_Cursor_Set
    
    case activate_Delete_Square_Set
    case deActivate_Delete_Square_Set
    
    case activate_MoveNote_Cursor_Set
    case deActivate_MoveNote_Cursor_Set
    
    case activate_Passive_Cursor_Set
    case deActivate_Passive_Cursor_Set
}
