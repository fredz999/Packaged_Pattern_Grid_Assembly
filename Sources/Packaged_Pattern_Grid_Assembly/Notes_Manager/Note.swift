//
//  File.swift
//  
//
//  Created by Jon on 19/11/2022.
//

import Foundation
import SwiftUI

public class Note : ObservableObject, Identifiable {
    public var id : UUID
    var parentRef : Note_Collection
    var cellArray : [Underlying_Data_Cell] = []
    var dimensions = ComponentDimensions.StaticDimensions
    var central_State = Central_State.Static_Central_State
    var note_Y_Number : Int
    
    var highlighted : Bool = false {
        didSet {
            if highlighted == true {
                for cell in cellArray {
                    cell.isHighlighted = true
                    central_State.a_Note_Is_Highlighted = true
                }
            }
            else if highlighted == false {
                for cell in cellArray {
                    cell.isHighlighted = false
                    central_State.a_Note_Is_Highlighted = false
                }
            }
        }
    }
    
    public init(id: UUID = UUID(), cellArray: [Underlying_Data_Cell],parentParam:Note_Collection,yParam:Int) {
        self.note_Y_Number = yParam
        self.parentRef = parentParam
        self.id = id
        self.cellArray = cellArray
    }
    
    func resetCells(){
        for cell in cellArray{
            cell.note_Im_In = nil
            cell.currentType = .unassigned
        }
    }
    
    func rightSide_Expansion(){

        if let lastCell = cellArray.last {

            let lastIndex = lastCell.dataCell_X_Number

            if lastIndex < (dimensions.visualGrid_X_Unit_Count-1){
                if central_State.data_Grid.dataLineArray[self.note_Y_Number].dataCellArray[lastIndex+1].note_Im_In == nil {
                    cellArray.append(parentRef.data.dataLineArray[lastCell.dataCell_Y_Number].dataCellArray[lastIndex+1])
                    redrawCellArray()
                    check_For_Highlight()
                }
            }

            if let c_Layer = central_State.cursor_Layer_Ref {
                if c_Layer.currDataX == lastIndex {
                    if cellArray.count > 1 {
                        if let lclHslider = central_State.h_Slider_Ref {
                            lclHslider.artificially_H_Increment()
                        }
                    }
                }
            }

        }
    }
    
    func leftSide_Expansion(){
        if let firstCell = cellArray.first,let lastCell = cellArray.last {
            
            let firstIndex = firstCell.dataCell_X_Number
            let lastIndex = lastCell.dataCell_X_Number
            
            if let c_Layer = central_State.cursor_Layer_Ref {
                if c_Layer.currDataX == lastIndex {
                    if cellArray.count > 1 {
                        if let lclHslider = central_State.h_Slider_Ref {
                            lclHslider.artificially_H_Decrement()
                        }
                    }
                }
            }

            if lastIndex > firstIndex {
                lastCell.changeType(newType: .unassigned)
                lastCell.note_Im_In = nil
                cellArray.removeLast()
                redrawCellArray()
                check_For_Highlight()
            }
        }
    }
    
    func moveRightOne(){
        if let lastCell = cellArray.last,let firstCell = cellArray.first {
        let lastIndex = lastCell.dataCell_X_Number
            if lastIndex < (dimensions.visualGrid_X_Unit_Count-1){
                if central_State.data_Grid.dataLineArray[self.note_Y_Number].dataCellArray[lastIndex+1].note_Im_In == nil {
                    firstCell.changeType(newType: .unassigned)
                    firstCell.note_Im_In = nil
                    firstCell.isHighlighted = false
                    cellArray.removeFirst()
                    cellArray.append(parentRef.data.dataLineArray[lastCell.dataCell_Y_Number].dataCellArray[lastIndex+1])
                    redrawCellArray()
                    check_For_Highlight()
                }
            }
        }
    }
    
    func moveLeftOne(){
        if let lastCell = cellArray.last,let firstCell = cellArray.first {
        let firstIndex = firstCell.dataCell_X_Number
            if firstIndex > 0{
                if central_State.data_Grid.dataLineArray[self.note_Y_Number].dataCellArray[firstIndex-1].note_Im_In == nil {
                    lastCell.changeType(newType: .unassigned)
                    lastCell.note_Im_In = nil
                    lastCell.isHighlighted = false
                    cellArray.removeLast()
                    
                    let newCell = parentRef.data.dataLineArray[lastCell.dataCell_Y_Number].dataCellArray[firstIndex-1]

                    cellArray.insert(newCell, at: 0)
                    
                    redrawCellArray()
                    
                    check_For_Highlight()
                    
                }
            }
        }
    }
    
    func moveDownOne(){

        if self.note_Y_Number+1 < dimensions.DATA_final_Line_Y_Index {

                var newCellArray : [Underlying_Data_Cell] = []
                for cell in cellArray {
                    let cellBelow = central_State.data_Grid.dataLineArray[self.note_Y_Number+1].dataCellArray[cell.dataCell_X_Number]
                    newCellArray.append(cellBelow)
                }
                
                for cell in cellArray {
                    cell.currentType = .unassigned
                    cell.note_Im_In = nil
                    cell.isHighlighted = false
                }
                
                cellArray.removeAll()
                
                for newCell in newCellArray {
                    cellArray.append(newCell)
                }
                
                redrawCellArray()
                self.note_Y_Number += 1
                check_For_Highlight()

        }

    }
    
    func moveUpOne(){
        if self.note_Y_Number > 0 {
                
                var newCellArray : [Underlying_Data_Cell] = []
                for cell in cellArray {
                    let cellAbove = central_State.data_Grid.dataLineArray[self.note_Y_Number-1].dataCellArray[cell.dataCell_X_Number]
                    newCellArray.append(cellAbove)
                }
                
                for cell in cellArray {
                    cell.currentType = .unassigned
                    cell.note_Im_In = nil
                    cell.isHighlighted = false
                }
                
                cellArray.removeAll()
                
                for newCell in newCellArray {
                    cellArray.append(newCell)
                }
                redrawCellArray()
                self.note_Y_Number -= 1
                parentRef.currentHighlightedNote = nil
            
        }
    }
    
    func redrawCellArray(){
        if cellArray.count == 1{
            cellArray[0].changeType(newType: .single)
            cellArray[0].note_Im_In = self
        }
        if cellArray.count == 2{
            cellArray[0].changeType(newType: .start)
            cellArray[0].note_Im_In = self
            
            cellArray[1].changeType(newType: .end)
            cellArray[1].note_Im_In = self
        }
        else if cellArray.count > 2{
            cellArray[0].changeType(newType: .start)
            cellArray[0].note_Im_In = self
            for x in 1..<cellArray.count-1{
            cellArray[x].changeType(newType: .mid)
            cellArray[x].note_Im_In = self
            }
            cellArray[cellArray.count-1].changeType(newType: .end)
            cellArray[cellArray.count-1].note_Im_In = self
        }
    }
    
    func check_Cursor_Within()->Bool{
        var retval = false
        if let lclCursorLayer = central_State.cursor_Layer_Ref {
            for cell in cellArray {
                if cell.dataCell_X_Number == lclCursorLayer.currDataX,cell.dataCell_Y_Number == lclCursorLayer.currDataY {retval = true}
            }
        }
        return retval
    }
    
    func check_For_Highlight(){
        if check_Cursor_Within() == true {
            highlighted = true
        }
        else {
            parentRef.currentHighlightedNote = nil
        }
    }
    
    func cell_Is_Beside_Border_Or_Note(connectionType:CellConnectionType)->Bool{
        var retval = false
        if connectionType == .below {
            if self.note_Y_Number+1 < central_State.higher_Bracket_Number {
                for cell in cellArray {
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
                for cell in cellArray {
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
            if cellArray[0].dataCell_X_Number > 0 {
                let cell_To_Left = central_State.data_Grid.dataLineArray[self.note_Y_Number].dataCellArray[cellArray[0].dataCell_X_Number - 1]
                if cell_To_Left.note_Im_In != nil{
                    retval = true
                }
            }
            else if cellArray[0].dataCell_X_Number == 0 {
                if cellArray[0].note_Im_In != nil{
                    retval = true
                }
            }
        }
        
        
        else if connectionType == .toRight {
            if cellArray[cellArray.count-1].dataCell_X_Number < central_State.data_Grid.dataLineArray[self.note_Y_Number].dataCellArray.count-1 {
                let cell_To_Right = central_State.data_Grid.dataLineArray[self.note_Y_Number].dataCellArray[cellArray[cellArray.count-1].dataCell_X_Number + 1]
                if cell_To_Right.note_Im_In != nil{
                    retval = true
                }
            }
            else if cellArray[cellArray.count-1].dataCell_X_Number == central_State.data_Grid.dataLineArray[self.note_Y_Number].dataCellArray.count-1 {
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
