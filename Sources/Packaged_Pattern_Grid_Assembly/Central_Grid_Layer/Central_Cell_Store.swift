//
//  Central_Cell_Store.swift
//  
//
//  Created by Jon on 11/05/2023.
//

import Foundation
import SwiftUI

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
        
        //TODO: cell_Swap_Underlying_Data needs updated to include visual config
        data_Vals_Holder = Data_Vals_Holder(xNumParam: underlying_Data_Cell_Param.dataCell_X_Number
        , yNumParam: underlying_Data_Cell_Param.parentLine.line_Y_Num
        , typeParam: underlying_Data_Cell_Param.currentType
        , cellWidthParam:widthParam, cellHeightParam: dimensions.pattern_Grid_Sub_Cell_Height
        , xOffsetParam:xOffsetParam)
        
        cell_Swap_Underlying_Data(new_Data_Cell: underlying_Data_Cell_Param)
        
    }
    
//    var currentlyHeldDataCell : Underlying_Data_Cell?{
//        willSet{
//            //if there is an existing one it gets its currentConnectedDV nilled
//            if let lclCurrentlyHeldDataCell = currentlyHeldDataCell {
//                if let lclOutgoingDataCellsDataVals = lclCurrentlyHeldDataCell.currentConnectedDataVals{
//                    lclCurrentlyHeldDataCell.currentConnectedDataVals = nil
//                }
//            }
//        }
//    }
    
    public func cell_Swap_Underlying_Data(new_Data_Cell : Underlying_Data_Cell){
        
        if new_Data_Cell.currentConnectedDataVals != nil {
            new_Data_Cell.currentConnectedDataVals = nil
        }

        new_Data_Cell.currentConnectedDataVals = data_Vals_Holder
        //there should be an old data cell here
        //currentlyHeldDataCell = new_Data_Cell
        
        data_Vals_Holder.updateValsFromNewData(
        newXNum: new_Data_Cell.dataCell_X_Number
        , newYNum: new_Data_Cell.parentLine.line_Y_Num
        , newCellNoteStatus: new_Data_Cell.currentType)
        
        // this is getting incorrectly set in data_Y_Slider
        //externallySetCursorState.is_Over_Note_Cell
        //&& data_Vals_Holder.externallySetCursorState.is_Over_Note_Cell == true
        // && the cell hasnt got the state change thats being done here
        
        // rem: data_Vals_Holder stays the SAME
        // data_Cell changes
        // if the new data cell is noteless that needs to be set as well
        
        if new_Data_Cell.note_Im_In != nil {
            new_Data_Cell.alterCursorState(thisCellInNote: true, cell_In_Moving_Prohibition: nil, cell_In_Clashing_Prohibition: nil, cursorMoveMode: nil)
        }
        else if new_Data_Cell.note_Im_In == nil {
            new_Data_Cell.alterCursorState(thisCellInNote: false, cell_In_Moving_Prohibition: nil, cell_In_Clashing_Prohibition: nil, cursorMoveMode: nil)
        }
        
    }
    
}
