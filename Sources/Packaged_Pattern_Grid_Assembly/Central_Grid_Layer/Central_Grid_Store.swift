//
//  File.swift
//  
//
//  Created by Jon on 16/11/2022.
//

import Foundation
import SwiftUI

public class Central_Grid_Store : ObservableObject {
    let central_State_Ref = Central_State.Static_Central_State
    let dimensions = ComponentDimensions.StaticDimensions
    
    @Published public var vis_Line_Store_Array : [Central_Line_Store] = []

    public init(){
        populateLineArray()
    }
    
    public func populateLineArray(){
        for y in 0..<dimensions.visualGrid_Y_Unit_Count {
            let newLine = Central_Line_Store(y_Index: y, gridParam: self)
            vis_Line_Store_Array.append(newLine)
        }
    }
    
    public func changeDataBracket(newLower:Int){
        for line in vis_Line_Store_Array {
            line.change_Data_Y(lowerBracket_Param: newLower)
        }
    }
    
}


public class Central_Line_Store : ObservableObject,Identifiable {
    
    public var data = Underlying_Data_Grid.Static_Underlying_Data_Grid
    var dimensions = ComponentDimensions.StaticDimensions
    public var id = UUID()
    public var parentGrid : Central_Grid_Store
    @Published public var y_Index : Int
    @Published public var visual_Cell_Store_Array : [Central_Cell_Store] = []
    
    
    //var cellSet = Set<Central_Cell_Store>()  // this
    //var cells_In_A_Note_Set = Set<Central_Cell_Store>()
    
    //TODO: border check call(if write is on)
//    var nearest_Right_Note : Central_Cell_Store?{
//        didSet {
//            if let lclNearestRightNote = nearest_Right_Note {
//                let lastCellBeforeRightBoundary = lclNearestRightNote.data_Vals_Holder.referenced_dataCell_X_Number-1
//                let boundaryRightStart = Int(lastCellBeforeRightBoundary/dimensions.pattern_Grid_Cell_Sub_Unit_Count)
//                dimensions.set_Current_Rightward_Boundary(newRightBoundary: boundaryRightStart)
//            }
//        }
//    }
    
//    var nearest_Left_Note : Central_Cell_Store?{
//        didSet {
//            if let lclNearestLeftNote = nearest_Left_Note {
//                let lastCellBeforeLeftBoundary = lclNearestLeftNote.data_Vals_Holder.referenced_dataCell_X_Number+1
//                let boundaryLeftStart = Int(lastCellBeforeLeftBoundary/dimensions.pattern_Grid_Cell_Sub_Unit_Count)
//                dimensions.set_Current_Leftward_Boundary(newLeftBoundary: boundaryLeftStart)
//            }
//        }
//    }
    
    public init(y_Index: Int,gridParam:Central_Grid_Store){
        self.y_Index = y_Index
        parentGrid = gridParam
        fillLine()
        //for cell in visual_Cell_Store_Array{cellSet.insert(cell)}
    }
 
    public func fillLine(){
        for x in 0..<dimensions.dataGrid_X_Unit_Count {
            let new_Central_Cell_Store = Central_Cell_Store(x_Index_Param: x, lineParam: self, underlying_Data_Cell_Param: data.dataLineArray[y_Index].dataCellArray[x])
            visual_Cell_Store_Array.append(new_Central_Cell_Store)
        }
    }
    
    public func change_Data_Y(lowerBracket_Param:Int){
        if (lowerBracket_Param + y_Index) < dimensions.DATA_final_Line_Y_Index  {
            let new_Y_Index = lowerBracket_Param + y_Index
            for visualCell in visual_Cell_Store_Array {
                    visualCell.cell_Swap_Underlying_Data(new_Data_Cell: data.dataLineArray[new_Y_Index].dataCellArray[visualCell.x_Index])
            }
        }
    }
    
}

public class Central_Cell_Store : ObservableObject,Identifiable, Equatable, Hashable {
    
    public static func == (lhs: Central_Cell_Store, rhs: Central_Cell_Store) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public var id = UUID()
    public let dimensions = ComponentDimensions.StaticDimensions
    
    @Published public var x_Index : Int
    @Published public var xFloat : CGFloat
    @Published public var yFloat : CGFloat
    
    public var parent_Line_Ref : Central_Line_Store
    @Published public var data_Vals_Holder : Data_Vals_Holder
    
    public init(x_Index_Param:Int,lineParam:Central_Line_Store,underlying_Data_Cell_Param : Underlying_Data_Cell) {
        self.parent_Line_Ref = lineParam
        self.x_Index = x_Index_Param
        self.xFloat = CGFloat(x_Index_Param) * dimensions.pattern_Grid_Sub_Cell_Width
        self.yFloat = CGFloat(lineParam.y_Index) * dimensions.pattern_Grid_Unit_Height
        
        let widthParam : CGFloat = underlying_Data_Cell_Param.currentType == .start_Blank ? dimensions.pattern_Start_Blank_Width : dimensions.pattern_Grid_Sub_Cell_Width
        let xOffsetParam : CGFloat = underlying_Data_Cell_Param.currentType == .start_Blank ? dimensions.pattern_Start_Blank_XOffset : dimensions.pattern_Mid_End_XOffset
        
        data_Vals_Holder = Data_Vals_Holder(xNumParam: underlying_Data_Cell_Param.dataCell_X_Number
        , yNumParam: underlying_Data_Cell_Param.dataCell_Y_Number
        , typeParam: underlying_Data_Cell_Param.currentType
        , cellWidthParam:widthParam, cellHeightParam: dimensions.pattern_Grid_Sub_Cell_Height
        , xOffsetParam:xOffsetParam)
        
        cell_Swap_Underlying_Data(new_Data_Cell: underlying_Data_Cell_Param)
        
    }
    
    
    public func cell_Swap_Underlying_Data(new_Data_Cell : Underlying_Data_Cell){
        new_Data_Cell.currentConnectedDataVals = data_Vals_Holder
        data_Vals_Holder.updateValsFromNewData(
        newXNum: new_Data_Cell.dataCell_X_Number
        , newYNum: new_Data_Cell.dataCell_Y_Number
        , newCellStatus: new_Data_Cell.currentType
        , newNoteImIn: new_Data_Cell.note_Im_In
        , isHighlightedParan: new_Data_Cell.isHighlighted)
    }
    
}
