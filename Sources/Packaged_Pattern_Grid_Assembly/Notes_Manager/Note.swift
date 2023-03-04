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
    
    var lowest_Index : Int
    var highest_Index : Int
    
  
    
    
    var dimensions = ComponentDimensions.StaticDimensions
    var central_State = Central_State.Static_Central_State
    var note_Y_Number : Int
    
    var highlighted : Bool = false {
        didSet{
            if highlighted == true {
                for dataCell in dataCellArray {
                    dataCell.change_Highlight(highlightStatusParam: true)
                }
            }
            else if highlighted == false {
                for dataCell in dataCellArray {
                    dataCell.change_Highlight(highlightStatusParam: false)
                }
            }
        }
    }

    public init(id: UUID = UUID(), cellArray: [Underlying_Data_Cell],parentParam:Note_Collection,yParam:Int) {
        self.lowest_Index = cellArray[0].dataCell_X_Number
        self.highest_Index = cellArray[cellArray.count-1].dataCell_X_Number
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
        for cell in dataCellArray {
            cell.note_Im_In = nil
            cell.change_Highlight(highlightStatusParam: false)
            cell.reset_To_Original()
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
