//
//  File.swift
//  
//
//  Created by Jon on 16/11/2022.
//

import Foundation
import SwiftUI

public class Central_Grid_Store : ObservableObject {
    
    @Published public var vis_Line_Store_Array : [Central_Line_Store] = []
    
    public var gridUnitsHorz:Int
    public var gridUnitsVert:Int

    public init(unitsHorizontal:Int,unitsVertical:Int){
        gridUnitsHorz = unitsHorizontal
        gridUnitsVert = unitsVertical
        populateLineArray()
    }
    
    public func populateLineArray(){
        for y in 0..<gridUnitsVert {
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
        for x in 0..<parentGrid.gridUnitsHorz {
            // let new_Visual_Cell = Central_Cell_Store(x_IndexParam: x, lineParam: self, underlying_Data_Cell_Param: data.dataLineArray[y_Index].dataCellArray[x])

            
            let new_Central_Cell_Store = Central_Cell_Store(x_Index_Param: x, lineParam: self, underlying_Data_Cell_Param: data.dataLineArray[y_Index].dataCellArray[x])
            // TODO: cell_View manufactured
            //new_Central_Cell_Store//.set_Central_Cell_Props(x_IndexParam: x, lineParam: self, underlying_Data_Cell_Param: data.dataLineArray[y_Index].dataCellArray[x])
            visual_Cell_Store_Array.append(new_Central_Cell_Store)
        }
    }
    
    public func change_Data_Y(lowerBracket_Param:Int){
        if (lowerBracket_Param + y_Index) < data.dataLineArray.count {
            let new_Y_Index = lowerBracket_Param + y_Index
            for visualCell in visual_Cell_Store_Array {
                // visualCell.underlying_Data_Cell = data.dataLineArray[new_Y_Index].dataCellArray[visualCell.x_Index]
                // TODO: change cell data
                //if let lcl_Cell_X = visualCell.x_Index {
                    //visualCell.underlying_Data_Cell = data.dataLineArray[new_Y_Index].dataCellArray[visualCell.x_Index]
                
                    visualCell.swapData(new_Data_Cell: data.dataLineArray[new_Y_Index].dataCellArray[visualCell.x_Index])
                //}
                
            }
        }
    }
    
}

public class Central_Cell_Store : ObservableObject,Identifiable {
    public var id = UUID()
    public let dimensions = ComponentDimensions.StaticDimensions
    
    @Published public var x_Index : Int
    @Published public var xFloat : CGFloat
    @Published public var yFloat : CGFloat
    
    public var parent_Line_Ref : Central_Line_Store
    
    // right.... I think this has to be a permanent object within this class
    // because it has to be a state object in its view ......
    // im thinking that instead of swapping in and out a data object, that the
    // composed in object itself has to remain the same and that the values it contains actually have to be read from
    // the data objects and the in_Cell_Data_Values has to mutate instead
    // this is necessary because otherwise the changing of a class will make a new view(which is a struct) init each time causing a data leak
    // OR find out how to make the view dismiss itself and prevent the menory leak that way ...
    // seriously I think im going for the first one tho
    // its also going to make transferring new data to underlying data more complex ...
    //@Published public var underlying_Data_Cell : Underlying_Data_Cell
    @Published public var data_Vals_Holder : Data_Vals_Holder
    

    
    public init(x_Index_Param:Int,lineParam:Central_Line_Store,underlying_Data_Cell_Param : Underlying_Data_Cell) {
        self.parent_Line_Ref = lineParam
        self.x_Index = x_Index_Param
        self.xFloat = CGFloat(x_Index_Param) * dimensions.pattern_Grid_Unit_Width
        self.yFloat = CGFloat(lineParam.y_Index) * dimensions.pattern_Grid_Unit_Height
        //self.underlying_Data_Cell = underlying_Data_Cell_Param
        data_Vals_Holder = Data_Vals_Holder(xNumParam: underlying_Data_Cell_Param.dataCell_X_Number
        , yNumParam: underlying_Data_Cell_Param.dataCell_Y_Number
        , typeParam: underlying_Data_Cell_Param.currentType)
    }
    
    // this will eventually be used to simply read the internal variables of the data and update
    // an in store object with matching variables
    func swapData(new_Data_Cell : Underlying_Data_Cell){
        //underlying_Data_Cell = new_Data_Cell
        
        print("swapData triggered")
        
        data_Vals_Holder.updateValsFromNewData(newXNum: new_Data_Cell.dataCell_X_Number
                                               , newYNum: new_Data_Cell.dataCell_Y_Number
                                               , newHighlightedStatus: new_Data_Cell.isHighlighted
                                               , newCellStatus: new_Data_Cell.currentType
                                               , newNoteImIn: new_Data_Cell.note_Im_In)
    }
    
    //func update_Referenced_Data(){
        // there needs to be numeric references to the currently referenced data object
        // but the old method of directly updating the underlying data might not work
        //...but then again it might....maybe in the new update method whatever operation
        // gets carried out it simply does a downstream swapData (above) afterwards ....
    //}
    
//    public func set_Central_Cell_Props(x_IndexParam: Int,lineParam:Central_Line_Store,underlying_Data_Cell_Param : Underlying_Data_Cell){
//        self.parent_Line_Ref = lineParam
//        self.x_Index = x_IndexParam
//        self.xFloat = CGFloat(x_IndexParam) * dimensions.pattern_Grid_Unit_Width
//        self.yFloat = CGFloat(lineParam.y_Index) * dimensions.pattern_Grid_Unit_Height
//        self.underlying_Data_Cell = underlying_Data_Cell_Param
//    }

}

// this will be a stateObject
 public class Data_Vals_Holder : ObservableObject {

    @Published public var referenced_dataCell_X_Number : Int
    @Published public var referenced_dataCell_Y_Number : Int
    @Published public var referenced_isHighlighted : Bool = false
    @Published public var referenced_currentStatus : E_CellStatus = .unassigned
    var referenced_note_Im_In : Note?

    public init(xNumParam:Int,yNumParam:Int,typeParam:E_CellStatus){
    referenced_dataCell_X_Number = xNumParam
    referenced_dataCell_Y_Number = yNumParam
    referenced_currentStatus = typeParam
    }
     
    func updateValsFromNewData(newXNum:Int,newYNum:Int,newHighlightedStatus:Bool,newCellStatus:E_CellStatus,newNoteImIn:Note?){
     if referenced_dataCell_X_Number != newXNum{referenced_dataCell_X_Number = newXNum}
     if referenced_dataCell_Y_Number != newYNum{referenced_dataCell_Y_Number = newYNum}
     if referenced_isHighlighted != newHighlightedStatus{referenced_isHighlighted = newHighlightedStatus}
     if referenced_currentStatus != newCellStatus{referenced_currentStatus = newCellStatus}

     if let lclCurrentNote = referenced_note_Im_In {
         if let lclNewNote = newNoteImIn {
             if lclNewNote != lclCurrentNote {
                 referenced_note_Im_In = lclNewNote
             }
         }
         else if newNoteImIn == nil{
             referenced_note_Im_In = nil
         }
     }
     else if referenced_note_Im_In == nil {
         if let lclNewNote = newNoteImIn {
             referenced_note_Im_In = lclNewNote
         }
     }
    }


}
