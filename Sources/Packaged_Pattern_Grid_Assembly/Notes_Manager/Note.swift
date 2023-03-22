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
    var parentRef : Note_Collection
    var dataCellArray : [Underlying_Data_Cell] = []
    
    var lowest_Index : Int
    var highest_Index : Int
    
    var dimensions = ComponentDimensions.StaticDimensions
    var note_Y_Number : Int
    
    

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
    
    func resizeLength(cellDelta:Int){
        print("resizeLength(cellDelta: ",cellDelta)
    }
    
    // hit when resize mode active and x slider moved over highlighted cell
//    func shortenToNearestViableUnit(){
//        //1: est minimum length, check if removing cells will go below
//        // ach just start with the subtraction of one current grid unit
//        print("dimensions.pattern_Grid_Cell_Sub_Unit_Count: ",dimensions.pattern_Grid_Cell_Sub_Unit_Count)
//        print("dataCellArray.count: ",dataCellArray.count)
//    }
    
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
