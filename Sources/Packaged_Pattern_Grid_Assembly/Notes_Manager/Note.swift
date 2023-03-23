//
//  File.swift
//  
//
//  Created by Jon on 19/11/2022.
//

import Foundation
import SwiftUI

public class Note : ObservableObject, Identifiable, Equatable, Hashable {
    
    public static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public var id : UUID
    var parent_Note_Collection : Note_Collection
    var dataCellArray : [Underlying_Data_Cell] = []
    
    var lowest_Index : Int
    var highest_Index : Int
    
    var dimensions = ComponentDimensions.StaticDimensions
    var note_Y_Number : Int
    var centralState : Central_State
    
    public init(id: UUID = UUID(), cellArray: [Underlying_Data_Cell],parentParam:Note_Collection,yParam:Int) {
        self.lowest_Index = cellArray[0].dataCell_X_Number
        self.highest_Index = cellArray[cellArray.count-1].dataCell_X_Number
        self.note_Y_Number = yParam
        self.parent_Note_Collection = parentParam
        self.id = id
        self.dataCellArray = cellArray
        self.centralState = parentParam.parentCentralState
    }
    
    public func yieldNoteData()->(Int,Int,Int){
        let lastElement = dataCellArray.count-1
        let startCellNum = dataCellArray[0].dataCell_X_Number
        let length = dataCellArray.count
        let endCellNum = dataCellArray[lastElement].dataCell_X_Number
        return (startCellNum,length,endCellNum)
    }
    
    
    var new_Note_Cell_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    
    func resizeLength(cellDelta:Int){
        print("resizeLength(cellDelta: ",cellDelta)
        //1 for elongate
        //1: the final cell is no longer an end cell its a mid
        //2: the next two after the final are now midz and the last one is and end
        
        let gridLine = parent_Note_Collection.parentCentralState.data_Grid.dataLineArray[note_Y_Number]
        let currLineSet : Set<Underlying_Data_Cell> = Set(gridLine.dataCellArray)
//        let cell_Addition = cellDelta*3
//        let newEndCellIndex = highest_Index + cell_Addition
        //let originalEndCell = parent_Note_Collection.parentCentralState.data_Grid.dataLineArray[note_Y_Number].dataCellArray[highest_Index]
        
        if cellDelta > 0 {
            // hmm the new note has to be up tp the end of the cursor
            if dimensions.patternTimingConfiguration == .fourFour {
                // the cursor is 3 cells
                //let lowerHalfCellSet = currLineSet.filter({$0.four_Four_Half_Cell_Index == dataCellArray[0].four_Four_Half_Cell_Index})
                let upperHalfCellSet = currLineSet.filter({$0.four_Four_Half_Cell_Index == centralState.currentData.four_Four_Half_Cell_Index-1})
                print("upperHalfCellSet count: ",upperHalfCellSet.count)
//                if let maxUpper = upperHalfCellSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
//                    let proposedNoteSet = currLineSet.filter{$0.dataCell_X_Number > lowest_Index && $0.dataCell_X_Number < maxUpper.dataCell_X_Number}
//                    let rest = currLineSet.subtracting(proposedNoteSet)
//                    for cell in proposedNoteSet{
//                        cell.change_Highlight(highlightStatusParam: true)
//                    }
//                    for cell in rest{
//                        cell.change_Highlight(highlightStatusParam: false)
//                    }
//                }
                
                
            }
        }
//        dataCellArray[lastElement].change_Type(newType: .mid_Note)
//        dataCellArray[lastElement].change_Highlight(highlightStatusParam: true)
//
//        let next_1 = dataCellArray[lastElement].dataCell_X_Number+1
//        let new_Cell_1 = parent_Note_Collection.parentCentralState.data_Grid.dataLineArray[note_Y_Number].dataCellArray[next_1]
//        new_Cell_1.change_Type(newType: .mid_Note)
//        new_Cell_1.note_Im_In = parent_Note_Collection.note_Currently_Under_Cursor
//        new_Cell_1.change_Highlight(highlightStatusParam: true)
//        dataCellArray.append(new_Cell_1)
        

    }
    
    // the visible cells also need to update in data vals holder
    func resetCells(){
        for cell in dataCellArray {
            cell.note_Im_In = nil
            cell.change_Highlight(highlightStatusParam: false)
            cell.reset_To_Original()
        }
    }
    
    var note_Is_Pre_MultiSelected : Bool = false {
        didSet {
            if note_Is_Pre_MultiSelected == false {
                for cell in dataCellArray{
                    cell.handleVisibleStateChange(type: .deActivate_Multiselect_Note_Set)
                }
            }
            else if note_Is_Pre_MultiSelected == true {
                for cell in dataCellArray{
                    cell.handleVisibleStateChange(type: .activate_Multiselect_Note_Set)
                }
            }
        }
    }
    
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
    
}

enum CellConnectionType {
    case below
    case above
    case toRight
    case toLeft
}


//        if cellDelta > 0 {
//            let lastElement = dataCellArray.count-1
//            dataCellArray[lastElement].change_Type(newType: .mid_Note)
//            dataCellArray[lastElement].change_Highlight(highlightStatusParam: true)
//
//            let next_1 = dataCellArray[lastElement].dataCell_X_Number+1
//            let new_Cell_1 = parent_Note_Collection.parentCentralState.data_Grid.dataLineArray[note_Y_Number].dataCellArray[next_1]
//            new_Cell_1.change_Type(newType: .mid_Note)
//            new_Cell_1.note_Im_In = parent_Note_Collection.note_Currently_Under_Cursor
//            new_Cell_1.change_Highlight(highlightStatusParam: true)
//            dataCellArray.append(new_Cell_1)
//
//            let next_2 = dataCellArray[lastElement].dataCell_X_Number+2
//            let new_Cell_2 = parent_Note_Collection.parentCentralState.data_Grid.dataLineArray[note_Y_Number].dataCellArray[next_2]
//            new_Cell_2.change_Type(newType: .mid_Note)
//            new_Cell_2.note_Im_In = parent_Note_Collection.note_Currently_Under_Cursor
//            new_Cell_2.change_Highlight(highlightStatusParam: true)
//            dataCellArray.append(new_Cell_2)
//
//            let next_3 = dataCellArray[lastElement].dataCell_X_Number+3
//            let new_Cell_3 = parent_Note_Collection.parentCentralState.data_Grid.dataLineArray[note_Y_Number].dataCellArray[next_3]
//            new_Cell_3.change_Type(newType: .end_Note)
//            new_Cell_3.note_Im_In = parent_Note_Collection.note_Currently_Under_Cursor
//            new_Cell_3.change_Highlight(highlightStatusParam: true)
//            dataCellArray.append(new_Cell_3)
//
//        }
