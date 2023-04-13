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
    var dimensions = ComponentDimensions.StaticDimensions
    var centralState : Central_State
    
    // transferred to new object ========================================
    //var containing_Data_Line : Underlying_Data_Line
    //var lowest_X_Index : Int
    //var highest_X_Index : Int
    //var highestFourFourHalfCellIndex : Int
    //var lowestFourFourHalfCellIndex : Int
    //var highestSixEightHalfCellIndex : Int
    //var lowestSixEightHalfCellIndex : Int
    var minimumSet : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    var dataCellArray : [Underlying_Data_Cell] = []
    // transferred to new object ========================================
    
    var note_Modification_Object : Note_Modification_Object
    
    public init(id: UUID = UUID(), cellArray: [Underlying_Data_Cell],parentParam:Note_Collection,yParam:Int,containingLineParam:Underlying_Data_Line) {
        self.parent_Note_Collection = parentParam
        self.id = id
        self.centralState = parentParam.parentCentralState
        
        
        // transferred to new object ========================================
        //self.containing_Data_Line = containingLineParam
        //self.lowest_X_Index = cellArray[0].dataCell_X_Number
        //self.highest_X_Index = cellArray[cellArray.count-1].dataCell_X_Number
        
        //self.highestFourFourHalfCellIndex = cellArray[cellArray.count-1].four_Four_Half_Cell_Index
        //self.lowestFourFourHalfCellIndex = cellArray[0].four_Four_Half_Cell_Index
        
        //self.highestSixEightHalfCellIndex = cellArray[cellArray.count-1].six_Eight_Half_Cell_Index
        //self.lowestSixEightHalfCellIndex = cellArray[0].six_Eight_Half_Cell_Index
        
        
        if cellArray.count == 2{
            self.minimumSet.insert(cellArray[0])
            self.minimumSet.insert(cellArray[1])
        }
        else if cellArray.count > 2 {
            self.minimumSet.insert(cellArray[0])
            self.minimumSet.insert(cellArray[1])
            self.minimumSet.insert(cellArray[2])
        }
        self.dataCellArray = cellArray
        // transferred to new object ========================================
        
        var minSet = Set<Underlying_Data_Cell>()
        if cellArray.count == 2{
            minSet.insert(cellArray[0])
            minSet.insert(cellArray[1])
        }
        else if cellArray.count > 2 {
            minSet.insert(cellArray[0])
            minSet.insert(cellArray[1])
            minSet.insert(cellArray[2])
        }

        self.note_Modification_Object = Note_Modification_Object(dataCellArray: cellArray, lowest_X_Index: cellArray[0].dataCell_X_Number
                                                                 , highest_X_Index: cellArray[cellArray.count-1].dataCell_X_Number, containing_Data_Line: containingLineParam
                                                                 , highestFourFourHalfCellIndex: cellArray[cellArray.count-1].four_Four_Half_Cell_Index
                                                                 , lowestFourFourHalfCellIndex: cellArray[0].four_Four_Half_Cell_Index
                                                                 , highestSixEightHalfCellIndex: cellArray[cellArray.count-1].six_Eight_Half_Cell_Index
                                                                 , lowestSixEightHalfCellIndex: cellArray[0].six_Eight_Half_Cell_Index
                                                                 , minimumSet: minSet)
    }
    
    public func yieldNoteData()->(Int,Int,Int){
        let lastElement = dataCellArray.count-1
        let startCellNum = dataCellArray[0].dataCell_X_Number
        let length = dataCellArray.count
        let endCellNum = dataCellArray[lastElement].dataCell_X_Number
        return (startCellNum,length,endCellNum)
    }
    
    func resetCells(){
        for cell in dataCellArray {
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

class Note_Modification_Object{
    var dataCellArray : [Underlying_Data_Cell] = []
    var lowest_X_Index : Int
    var highest_X_Index : Int
    var containing_Data_Line : Underlying_Data_Line
    var highestFourFourHalfCellIndex : Int
    var lowestFourFourHalfCellIndex : Int
    var highestSixEightHalfCellIndex : Int
    var lowestSixEightHalfCellIndex : Int
    var minimumSet : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    
    init(dataCellArray: [Underlying_Data_Cell], lowest_X_Index: Int, highest_X_Index: Int, containing_Data_Line: Underlying_Data_Line, highestFourFourHalfCellIndex: Int, lowestFourFourHalfCellIndex: Int, highestSixEightHalfCellIndex: Int, lowestSixEightHalfCellIndex: Int, minimumSet: Set<Underlying_Data_Cell>) {
        self.dataCellArray = dataCellArray
        self.lowest_X_Index = lowest_X_Index
        self.highest_X_Index = highest_X_Index
        self.containing_Data_Line = containing_Data_Line
        self.highestFourFourHalfCellIndex = highestFourFourHalfCellIndex
        self.lowestFourFourHalfCellIndex = lowestFourFourHalfCellIndex
        self.highestSixEightHalfCellIndex = highestSixEightHalfCellIndex
        self.lowestSixEightHalfCellIndex = lowestSixEightHalfCellIndex
        self.minimumSet = minimumSet
    }
    
    // do like note rewrites in here instead
}
