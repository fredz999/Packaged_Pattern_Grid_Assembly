//
//  File.swift
//  
//
//  Created by Jon on 19/11/2022.
//

import Foundation
import SwiftUI

public class Note : ObservableObject, Identifiable, Equatable {
    
    public static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.id == rhs.id
    }
    
    public var id : UUID
    var parentRef : Note_Collection
    var dataCellArray : [Underlying_Data_Cell] = []
    var dimensions = ComponentDimensions.StaticDimensions
    var central_State = Central_State.Static_Central_State
    var note_Y_Number : Int
    
    var note_Highlighted : Bool = false {
        didSet {
            if note_Highlighted == true {
                for dataCell in dataCellArray {
                    if dataCell.isHighlighted == false{
                        let vis_Y_Number = note_Y_Number - central_State.lower_Bracket_Number
                                       
                        if let lcl_VisGrid = central_State.central_Grid_Store {
                            if vis_Y_Number < lcl_VisGrid.vis_Line_Store_Array.count,vis_Y_Number >= 0{
                                let visCell = lcl_VisGrid.vis_Line_Store_Array[vis_Y_Number].visual_Cell_Store_Array[dataCell.dataCell_X_Number]
                                visCell.cell_Swap_Underlying_Data(new_Data_Cell: dataCell)
                            }
                        }
                        
                        dataCell.change_Highlight(highlightStatusParam: true)
                    }
                    

                    if central_State.a_Note_Is_Highlighted == false{central_State.a_Note_Is_Highlighted = true}
                    
                }
            }
            else if note_Highlighted == false {
                for dataCell in dataCellArray {
                    
                    if dataCell.isHighlighted == true{
                        dataCell.change_Highlight(highlightStatusParam: false)
                                     
                        let vis_Y_Number = note_Y_Number - central_State.lower_Bracket_Number
     
                        if let lcl_VisGrid = central_State.central_Grid_Store {
                            if vis_Y_Number < lcl_VisGrid.vis_Line_Store_Array.count,vis_Y_Number >= 0 {
                                let visCell = lcl_VisGrid.vis_Line_Store_Array[vis_Y_Number].visual_Cell_Store_Array[dataCell.dataCell_X_Number]
                                visCell.cell_Swap_Underlying_Data(new_Data_Cell: dataCell)
                            }
                        }
                    }
                    
                    if central_State.a_Note_Is_Highlighted == true{central_State.a_Note_Is_Highlighted = true}
                }
            }
        }
    }
    
    public init(id: UUID = UUID(), cellArray: [Underlying_Data_Cell],parentParam:Note_Collection,yParam:Int) {
        self.note_Y_Number = yParam
        self.parentRef = parentParam
        self.id = id
        self.dataCellArray = cellArray
    }
    
    public func yieldNoteData()->(Int,Int,Int){
        let lastElement = dataCellArray.count-1
        let startCellNum = dataCellArray[0].dataCell_X_Number
        let length = dataCellArray.count
        let endCellNum = dataCellArray[lastElement].dataCell_X_Number
        return (startCellNum,length,endCellNum)
    }
    
    // the visible cells also need to update in data vals holder
    func resetCells(){
        for cell in dataCellArray{
            cell.note_Im_In = nil
            cell.change_Highlight(highlightStatusParam: false)
            cell.reset_To_Original()
        }
//        if dimensions.patternTimingConfiguration == .fourFour{
//            var innerX : Int = 0
//            for outerX in 0..<dataCellArray.count{
//                if innerX == 0{
//                    dataCellArray[outerX].reset_Type(newType: dataCellArray[outerX].note_Reset_Status)
//                    innerX = 1
//                }
//                else if innerX == 1{
//                    dataCellArray[outerX].reset_Type(newType: dataCellArray[outerX].note_Reset_Status)
//                    innerX = 2
//                }
//                else if innerX == 2{
//                    dataCellArray[outerX].reset_Type(newType: dataCellArray[outerX].note_Reset_Status)
//                    innerX = 0
//                }
//            }
//        }
//        else if dimensions.patternTimingConfiguration == .sixEight{
//            var innerX : Int = 0
//            for outerX in 0..<dataCellArray.count{
//                if innerX == 0{
//                    dataCellArray[outerX].reset_Type(newType: dataCellArray[outerX].note_Reset_Status)
//                    innerX = 1
//                }
//                else if innerX == 1{
//                    dataCellArray[outerX].reset_Type(newType: dataCellArray[outerX].note_Reset_Status)
//                    innerX = 0
//                }
//            }
//        }
    }
    
    func rightSide_Expansion(){

        if let lastCell = dataCellArray.last {

            let lastIndex = lastCell.dataCell_X_Number

            if lastIndex < (dimensions.dataGrid_X_Unit_Count-1){
                if central_State.data_Grid.dataLineArray[self.note_Y_Number].dataCellArray[lastIndex+1].note_Im_In == nil {
                    dataCellArray.append(parentRef.data.dataLineArray[lastCell.dataCell_Y_Number].dataCellArray[lastIndex+1])
                    redrawCellArray()
                    check_For_Highlight()
                }
            }

            if let c_Layer = central_State.cursor_Layer_Ref {
                if c_Layer.currDataX == lastIndex {
                    if dataCellArray.count > 1 {
                        if let lclHslider = central_State.h_Slider_Ref {
                            lclHslider.artificially_H_Increment()
                        }
                    }
                }
            }

        }
    }
    
    func leftSide_Expansion(){
        if let firstCell = dataCellArray.first,let lastCell = dataCellArray.last {
            
            let firstIndex = firstCell.dataCell_X_Number
            let lastIndex = lastCell.dataCell_X_Number
            
            if let c_Layer = central_State.cursor_Layer_Ref {
                if c_Layer.currDataX == lastIndex {
                    if dataCellArray.count > 1 {
                        if let lclHslider = central_State.h_Slider_Ref {
                            lclHslider.artificially_H_Decrement()
                        }
                    }
                }
            }

            if lastIndex > firstIndex {
                lastCell.note_Im_In = nil
                dataCellArray.removeLast()
                redrawCellArray()
                check_For_Highlight()
            }
        }
    }
    
    func moveRightOne(){
        if let lastCell = dataCellArray.last,let firstCell = dataCellArray.first {
        let lastIndex = lastCell.dataCell_X_Number
            if lastIndex < (dimensions.dataGrid_X_Unit_Count-1){
                if central_State.data_Grid.dataLineArray[self.note_Y_Number].dataCellArray[lastIndex+1].note_Im_In == nil {

                    firstCell.note_Im_In = nil
                    firstCell.change_Highlight(highlightStatusParam: false)
                    dataCellArray.removeFirst()
                    dataCellArray.append(parentRef.data.dataLineArray[lastCell.dataCell_Y_Number].dataCellArray[lastIndex+1])
                    redrawCellArray()
                    check_For_Highlight()
                }
            }
        }
    }
    
    func moveLeftOne(){
        if let lastCell = dataCellArray.last,let firstCell = dataCellArray.first {
        let firstIndex = firstCell.dataCell_X_Number
            if firstIndex > 0{
                if central_State.data_Grid.dataLineArray[self.note_Y_Number].dataCellArray[firstIndex-1].note_Im_In == nil {

                    lastCell.note_Im_In = nil
                    lastCell.change_Highlight(highlightStatusParam: false)

                    dataCellArray.removeLast()
                    
                    let newCell = parentRef.data.dataLineArray[lastCell.dataCell_Y_Number].dataCellArray[firstIndex-1]

                    dataCellArray.insert(newCell, at: 0)
                    
                    redrawCellArray()
                    
                    check_For_Highlight()
                    
                }
            }
        }
    }
    
    func moveDownOne(){

        if self.note_Y_Number+1 < dimensions.DATA_final_Line_Y_Index {

                var newCellArray : [Underlying_Data_Cell] = []
                for cell in dataCellArray {
                    let cellBelow = central_State.data_Grid.dataLineArray[self.note_Y_Number+1].dataCellArray[cell.dataCell_X_Number]
                    newCellArray.append(cellBelow)
                }
            

                
                dataCellArray.removeAll()
                
                for newCell in newCellArray {
                    dataCellArray.append(newCell)
                }
                
                redrawCellArray()
                self.note_Y_Number += 1
                check_For_Highlight()

        }

    }
    
    func moveUpOne(){
        if self.note_Y_Number > 0 {
                
                var newCellArray : [Underlying_Data_Cell] = []
                for cell in dataCellArray {
                    let cellAbove = central_State.data_Grid.dataLineArray[self.note_Y_Number-1].dataCellArray[cell.dataCell_X_Number]
                    newCellArray.append(cellAbove)
                }

                
                dataCellArray.removeAll()
                
                for newCell in newCellArray {
                    dataCellArray.append(newCell)
                }
                redrawCellArray()
                self.note_Y_Number -= 1
                parentRef.currentHighlightedNote = nil
            
        }
    }
    
    // have to trigger the data_vals_Update for each cell.....how....?
    //  swapData
    func redrawCellArray(){
        // this is now never the case
//        if dataCellArray.count == 1{
//            dataCellArray[0].changeType(newType: .single)
//            dataCellArray[0].note_Im_In = self
//        }
//        if dataCellArray.count == 2{
//            dataCellArray[0].changeType(newType: .start)
//            dataCellArray[0].note_Im_In = self
//            
//            dataCellArray[1].changeType(newType: .end)
//            dataCellArray[1].note_Im_In = self
//        }
//        else if dataCellArray.count > 2{
//            dataCellArray[0].changeType(newType: .start)
//            dataCellArray[0].note_Im_In = self
//            for x in 1..<dataCellArray.count-1{
//            dataCellArray[x].changeType(newType: .mid)
//            dataCellArray[x].note_Im_In = self
//            }
//            dataCellArray[dataCellArray.count-1].changeType(newType: .end)
//            dataCellArray[dataCellArray.count-1].note_Im_In = self
//        }
    }
    
    func check_Cursor_Within()->Bool{
        var retval = false
        if let lclCursorLayer = central_State.cursor_Layer_Ref {
            for cell in dataCellArray {
                if cell.dataCell_X_Number == lclCursorLayer.currDataX,cell.dataCell_Y_Number == lclCursorLayer.currDataY {retval = true}
            }
        }
        return retval
    }
    
    func check_For_Highlight(){
        if check_Cursor_Within() == true {
            note_Highlighted = true
        }
        else {
            parentRef.currentHighlightedNote = nil
        }
    }
    
    func cell_Is_Beside_Border_Or_Note(connectionType:CellConnectionType)->Bool{
        var retval = false
        if connectionType == .below {
            if self.note_Y_Number+1 < central_State.higher_Bracket_Number {
                for cell in dataCellArray {
                    let cellBelow = central_State.data_Grid.dataLineArray[self.note_Y_Number+1].dataCellArray[cell.dataCell_X_Number]
                    if cellBelow.note_Im_In != nil {
                        retval = true
                    }
                }
            }
            else if self.note_Y_Number+1 == central_State.higher_Bracket_Number {
                retval = true
            }
        }
        //========================================================================================
        //========================================================================================
        else if connectionType == .above {
            if self.note_Y_Number > 0 {
                for cell in dataCellArray {
                    let cellAbove = central_State.data_Grid.dataLineArray[self.note_Y_Number-1].dataCellArray[cell.dataCell_X_Number]
                    if cellAbove.note_Im_In != nil {
                        retval = true
                    }
                }
            }
            else if self.note_Y_Number == 0 {
                retval = true
            }
        }
        
        
        else if connectionType == .toLeft {
            if dataCellArray[0].dataCell_X_Number > 0 {
                let cell_To_Left = central_State.data_Grid.dataLineArray[self.note_Y_Number].dataCellArray[dataCellArray[0].dataCell_X_Number - 1]
                if cell_To_Left.note_Im_In != nil{
                    retval = true
                }
            }
            else if dataCellArray[0].dataCell_X_Number == 0 {
                if dataCellArray[0].note_Im_In != nil{
                    retval = true
                }
            }
        }
        
        
        else if connectionType == .toRight {
            if dataCellArray[dataCellArray.count-1].dataCell_X_Number < central_State.data_Grid.dataLineArray[self.note_Y_Number].dataCellArray.count-1 {
                let cell_To_Right = central_State.data_Grid.dataLineArray[self.note_Y_Number].dataCellArray[dataCellArray[dataCellArray.count-1].dataCell_X_Number + 1]
                if cell_To_Right.note_Im_In != nil{
                    retval = true
                }
            }
            else if dataCellArray[dataCellArray.count-1].dataCell_X_Number == central_State.data_Grid.dataLineArray[self.note_Y_Number].dataCellArray.count-1 {
                retval = true
            }
        }
        return retval
    }
    
}

enum CellConnectionType {
    case below
    case above
    case toRight
    case toLeft
}
