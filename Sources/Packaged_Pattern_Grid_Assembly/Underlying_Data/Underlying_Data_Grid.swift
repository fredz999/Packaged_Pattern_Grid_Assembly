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
    
    private var fourFour_Half_Cell_Count : Int = 0
    private var sixEight_Half_Cell_Count : Int = 0
    
    private var sixEight_Half_Sub_Count : Int = 0
    private var fourFour_Half_Sub_Count : Int = 0
    private var singleCell_Half_Sub_Count : Int = 0
    
    var initialStatus : E_CellStatus = .start_Blank
    var currFourStatus : E_CellStatus = .start_Blank
    var currSixStatus : E_CellStatus = .start_Blank
    
    var grid_Of_Cells_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    
    func set_Data_Grid(){
        for line_Y_Number in 0..<dimensions.DATA_final_Line_Y_Index {
            let newLine = Underlying_Data_Line(yNumParam: line_Y_Number)

            for x in 0..<dimensions.dataGrid_X_Unit_Count{
                
//                if fourFour_Sub_Count == 0{currFourStatus = .start_Blank}
//                else if fourFour_Sub_Count == 1{currFourStatus = .mid_Blank}
//                else if fourFour_Sub_Count == 2{currFourStatus = .mid_Blank}
//                else if fourFour_Sub_Count == 3{currFourStatus = .end_Blank
//                    print("four four actually reached 3")
//                }
//
//                if sixEight_Sub_Count == 0{currSixStatus = .start_Blank}
//                else if sixEight_Sub_Count == 1{currSixStatus = .mid_Blank}
//                else if sixEight_Sub_Count == 2{currSixStatus = .mid_Blank}
//                else if sixEight_Sub_Count == 3{currSixStatus = .mid_Blank}
//                else if sixEight_Sub_Count == 4{currSixStatus = .mid_Blank}
//                else if sixEight_Sub_Count == 5{
//                    currSixStatus = .end_Blank
//                    print("six eight actually reached 5")
//                }
                
                
                if sixEight_Sub_Count == 0{currSixStatus = .start_Blank}
                else if sixEight_Sub_Count == 1{currSixStatus = .mid_Blank}
                else if sixEight_Sub_Count == 2{currSixStatus = .mid_Blank}
                else if sixEight_Sub_Count == 3{ currSixStatus = .end_Blank}

                if fourFour_Sub_Count == 0{currFourStatus = .start_Blank}
                else if fourFour_Sub_Count == 1{currFourStatus = .mid_Blank}
                else if fourFour_Sub_Count == 2{currFourStatus = .mid_Blank}
                else if fourFour_Sub_Count == 3{currFourStatus = .mid_Blank}
                else if fourFour_Sub_Count == 4{currFourStatus = .mid_Blank}
                else if fourFour_Sub_Count == 5{ currFourStatus = .end_Blank}
                
                
                
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
                    
                    if singleCell_Half_Sub_Count == 0{
                        let insertFloat = CGFloat(x)*dimensions.pattern_Grid_Sub_Cell_Width
                        let cellIndexDescriptor : Cell_X_Descriptor = Cell_X_Descriptor(x_Position_Int: x, x_Position_Float: insertFloat)
                        dimensions.single_Cell_Slider_Positions.insert(cellIndexDescriptor)
                    }

                }
                
                let newDataCell = Underlying_Data_Cell(xNumParam: x, yNumParam: line_Y_Number, parentLineParam: newLine, fourStatusParam: currFourStatus, sixStatusParam: currSixStatus
                , initialStatusParam: initialStatus
                , fourFourSubIndexParam: fourFour_Sub_Count
                , sixEightSubIndexParam: sixEight_Sub_Count
                , four_Four_Cell_Index_Param: fourFour_Cell_Count
                , six_Eight_Cell_Index_Param: sixEight_Cell_Count
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
                newLine.dataCellArray.append(newDataCell)
                newLine.cellSet.insert(newDataCell)
                grid_Of_Cells_Set.insert(newDataCell)
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
    
}

public class Underlying_Data_Line:ObservableObject,Identifiable,Equatable,Hashable {
    
    public static func == (lhs: Underlying_Data_Line, rhs: Underlying_Data_Line) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(yNumParam:Int){
        line_Y_Num = yNumParam
    }
    var line_Y_Num : Int
    public var id = UUID()
    
    public var dataCellArray : [Underlying_Data_Cell] = []
    var cellSet = Set<Underlying_Data_Cell>()
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

enum E_VisibleStateChangeType: String {
    
    case activate_Move_Away_From_Cell = "activate_Move_Away_From_Cell"
    case deActivate_Move_Away_From_Cell = "deActivate_Move_Away_From_Cell"
    
    case activate_Prohibited_Clashing_Cell = "activate_Prohibited_Clashing_Cell"
    case deActivate_Prohibited_Clashing_Cell = "deActivate_Prohibited_Clashing_Cell"
    
    case activate_Prohibited_Moving_Cell = "activate_Prohibited_Moving_Cell"
    case deActivate_Prohibited_Moving_Cell = "deActivate_Prohibited_Moving_Cell"

    case activate_Viable_Set_Combined = "activate_Viable_Set_Combined"
    case deActivate_Viable_Set_Combined = "deActivate_Viable_Set_Combined"
    
    case activate_Potential_Set = "activate_Potential_Set"
    case deActivate_Potential_Set = "deActivate_Potential_Set"
    
    case activate_Resize_Set = "activate_Resize_Set"
    case deActivate_Resize_Set = "deActivate_Resize_Set"
    
    case activate_Multiselect_Background_Set = "activate_Multiselect_Background_Set"
    case deActivate_Multiselect_Background_Set = "deActivate_Multiselect_Background_Set"
    
    case activate_Multiselect_Note_Set = "activate_Multiselect_Note_Set"
    case deActivate_Multiselect_Note_Set = "deActivate_Multiselect_Note_Set"
    
    case activate_Delete_Square_Set = "activate_Delete_Square_Set"
    case deActivate_Delete_Square_Set = "deActivate_Delete_Square_Set"
    
    case activate_MoveNote_Cursor_Set = "activate_MoveNote_Cursor_Set"
    case deActivate_MoveNote_Cursor_Set = "deActivate_MoveNote_Cursor_Set"
    
    case activate_Passive_Cursor_Set = "activate_Passive_Cursor_Set"
    case deActivate_Passive_Cursor_Set = "deActivate_Passive_Cursor_Set"
}
