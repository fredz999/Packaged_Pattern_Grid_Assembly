//
//  File.swift
//  
//
//  Created by Jon on 16/11/2022.
//

import Foundation
import SwiftUI

public class Central_Grid_Store : ObservableObject {
    let dimensions = ComponentDimensions.StaticDimensions
    @Published public var vis_Line_Store_Array : [Central_Line_Store] = []
    
//    public var gridUnitsHorz:Int
//    public var gridUnitsVert:Int

    public init(){
//        gridUnitsHorz = dimensions.dataGrid_X_Unit_Count //unitsHorizontal
//        gridUnitsVert = dimensions.visualGrid_Y_Unit_Count //unitsVertical
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
    
    public init(y_Index: Int,gridParam:Central_Grid_Store){
        self.y_Index = y_Index
        parentGrid = gridParam
        fillLine()
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
    
//    func respond_To_Timing_Signature_Change_Grid_Line_Level(){
//        for cell in visual_Cell_Store_Array {
//            cell.respond_To_Timing_Signature_Change_Cell_Level()
//        }
//    }
    
}

public class Central_Cell_Store : ObservableObject,Identifiable {
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
        data_Vals_Holder = Data_Vals_Holder(xNumParam: underlying_Data_Cell_Param.dataCell_X_Number
        , yNumParam: underlying_Data_Cell_Param.dataCell_Y_Number
        , typeParam: underlying_Data_Cell_Param.currentType)
    }
    
    
    
    public func cell_Swap_Underlying_Data(new_Data_Cell : Underlying_Data_Cell){
        data_Vals_Holder.updateValsFromNewData(
        newXNum: new_Data_Cell.dataCell_X_Number
        , newYNum: new_Data_Cell.dataCell_Y_Number
        , newHighlightedStatus: new_Data_Cell.isHighlighted
        , newCellStatus: new_Data_Cell.currentType
        , newNoteImIn: new_Data_Cell.note_Im_In)
    }
    
    
    
    
    
    // a function here that issues changes to a sequence of optional closures
    

    
//    func respond_To_Timing_Signature_Change_Cell_Level(){
//        let xInt : Int = self.data_Vals_Holder.referenced_dataCell_X_Number
//        let yInt : Int = self.data_Vals_Holder.referenced_dataCell_Y_Number
//        let highlidhtStatus = self.data_Vals_Holder.referenced_isHighlighted
//        let cellStatus = self.data_Vals_Holder.referenced_currentStatus
//        let noteimIn = self.data_Vals_Holder.referenced_note_Im_In
//
//
//        self.data_Vals_Holder.updateValsFromNewData(newXNum: xInt
//                                                    , newYNum: yInt
//                                                    , newHighlightedStatus: highlidhtStatus
//                                                    , newCellStatus: cellStatus, newNoteImIn: noteimIn)
////        self.xFloat = CGFloat(x_Index) * dimensions.pattern_Grid_Unit_Width
////        self.yFloat = CGFloat(parent_Line_Ref.y_Index) * dimensions.pattern_Grid_Unit_Height
//        //redraw the cells
////        if dimensions.patternTimingConfiguration == .fourFour{
////            // the cells are three sub units wide and there are 16
////
////        }
////        else if dimensions.patternTimingConfiguration == .fourFour{
////            // the cells are two sub units wide and there are 24
////
////        }
//        //self.data_Vals_Holder.handle_Timing_Signature_Change()
//
//    }
    
    //func
    
    //@Published var which_Timing_Type :
    
}

// this will be a stateObject
 public class Data_Vals_Holder : ObservableObject {

    // these are prolly going to be closure responders
    @Published public var referenced_dataCell_X_Number : Int
    @Published public var referenced_dataCell_Y_Number : Int
    @Published public var referenced_isHighlighted : Bool = false
    @Published public var referenced_currentStatus : E_CellStatus
    {
        didSet {
            if let lclStatusClosureResponder = statusClosureResponder {
                lclStatusClosureResponder(referenced_currentStatus)
            }
        }
    }
     
     public var referenced_note_Im_In : Note?{
         didSet{
             if let lclNoteClosureResponder = noteClosureResponder{
                 if referenced_note_Im_In != nil{
                     lclNoteClosureResponder(true)
                 }
                 else if referenced_note_Im_In == nil{
                     lclNoteClosureResponder(false)
                 }
             }
         }
     }
     
    // these might have to completely change , I might try to read data from this class directly
    // in fact I think I should, this is very complex
    public var statusClosureResponder : ((E_CellStatus)->())?
    public var isHighlightedClosureResponder : ((Bool)->())?
    public var noteClosureResponder : ((Bool)->())?
    

    public init(xNumParam:Int,yNumParam:Int,typeParam:E_CellStatus){
    referenced_dataCell_X_Number = xNumParam
    referenced_dataCell_Y_Number = yNumParam
    referenced_currentStatus = typeParam
    }
     
    func updateValsFromNewData(newXNum:Int,newYNum:Int,newHighlightedStatus:Bool,newCellStatus:E_CellStatus,newNoteImIn:Note?){
        
     if referenced_dataCell_X_Number != newXNum{referenced_dataCell_X_Number = newXNum}
     if referenced_dataCell_Y_Number != newYNum{referenced_dataCell_Y_Number = newYNum}
     if referenced_isHighlighted != newHighlightedStatus{
         referenced_isHighlighted = newHighlightedStatus
         if let lclHighlighter = isHighlightedClosureResponder{
             lclHighlighter(newHighlightedStatus)
         }
     }
     if referenced_currentStatus != newCellStatus{referenced_currentStatus = newCellStatus}

     if let lclCurrentNote = referenced_note_Im_In {
         if let lclNewNote = newNoteImIn {
             if lclNewNote != lclCurrentNote {
                 referenced_note_Im_In = lclNewNote
                 if let lclNoteClosureResponder = noteClosureResponder{
                     lclNoteClosureResponder(true)
                 }
             }
         }
         else if newNoteImIn == nil{
             referenced_note_Im_In = nil
             if let lclNoteClosureResponder = noteClosureResponder{
                 lclNoteClosureResponder(false)
             }
         }
     }
     else if referenced_note_Im_In == nil {
         if let lclNewNote = newNoteImIn {
             referenced_note_Im_In = lclNewNote
             if let lclNoteClosureResponder = noteClosureResponder{
                 lclNoteClosureResponder(true)
             }
         }
     }
        
        
    }

     


}
