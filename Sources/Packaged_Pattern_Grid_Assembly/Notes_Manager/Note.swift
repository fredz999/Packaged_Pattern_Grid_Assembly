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
    var modifiable_Note_Data : Modifiable_Note_Data?
    
    public init(id: UUID = UUID(), cellArray: [Underlying_Data_Cell],parentParam:Note_Collection,yParam:Int,containingLineParam:Underlying_Data_Line) {
        self.parent_Note_Collection = parentParam
        self.id = id
        self.centralState = parentParam.parentCentralState
        self.modifiable_Note_Data = Modifiable_Note_Data(dataCellArray: cellArray, lowest_X_Index: cellArray[0].dataCell_X_Number
         , highest_X_Index: cellArray[cellArray.count-1].dataCell_X_Number, containing_Data_Line: containingLineParam
         , highestFourFourHalfCellIndex: cellArray[cellArray.count-1].four_Four_Half_Cell_Index
         , lowestFourFourHalfCellIndex: cellArray[0].four_Four_Half_Cell_Index
         , highestSixEightHalfCellIndex: cellArray[cellArray.count-1].six_Eight_Half_Cell_Index
         , lowestSixEightHalfCellIndex: cellArray[0].six_Eight_Half_Cell_Index, parentParam: self)
    }
    
    public func yieldNoteData()->(Int,Int,Int){
        var lastElement : Int = 0
        var startCellNum : Int = 0
        var length : Int  = 0
        var endCellNum : Int = 0
        if let lclModifiableNoteData = modifiable_Note_Data{
        lastElement = lclModifiableNoteData.dataCellArray.count-1
        startCellNum = lclModifiableNoteData.dataCellArray[0].dataCell_X_Number
        length = lclModifiableNoteData.dataCellArray.count
        endCellNum = lclModifiableNoteData.dataCellArray[lastElement].dataCell_X_Number
        }
        
        return (startCellNum,length,endCellNum)
    }
    
    func resetCells(){
        if let lclModifiableNoteData = modifiable_Note_Data{
            for cell in lclModifiableNoteData.dataCellArray {
                cell.change_Highlight(highlightStatusParam: false)
                cell.reset_To_Original()
            }
        }
    }
    
    var note_Is_Pre_MultiSelected : Bool = false {
        didSet {
            if let lclModifiableNoteData = modifiable_Note_Data{
                
                if note_Is_Pre_MultiSelected == false {
                    for cell in lclModifiableNoteData.dataCellArray{
                        cell.handleVisibleStateChange(type: .deActivate_Multiselect_Note_Set)
                    }
                }
                else if note_Is_Pre_MultiSelected == true {
                    for cell in lclModifiableNoteData.dataCellArray{
                        cell.handleVisibleStateChange(type: .activate_Multiselect_Note_Set)
                    }
                }
                
            }
            
        }
    }
    
    var highlighted : Bool = false {
        didSet {
            if let lclModifiableNoteData = modifiable_Note_Data{
                if highlighted == true {
                    for dataCell in lclModifiableNoteData.dataCellArray {
                        dataCell.change_Highlight(highlightStatusParam: true)
                    }
                }
                else if highlighted == false {
                    for dataCell in lclModifiableNoteData.dataCellArray {
                        dataCell.change_Highlight(highlightStatusParam: false)
                    }
                }
            }
        }
    }
    

    
}


//        if noteWriteable == true {
//            print("hit true")
//            if let lclModifiable = modifiable_Note_Data {
//
//                for cell in lclModifiable.dataCellArray {// potential moved set
//                    // TODO: thing needs 2 b in potential set?
//                    print("thing supposed to switched off?: ",cell.dataCell_X_Number)
//                    if cell.in_Prohibited_Moving_Cell_Set == true {
//                        cell.handleVisibleStateChange(type: .deActivate_Prohibited_Moving_Cell)
//                    }
//                }
//            }
//
//        }
//        else if noteWriteable == false {
//
//            if let lclModifiable = modifiable_Note_Data{
//                for cell in lclModifiable.dataCellArray{
//                    if cell.in_Prohibited_Moving_Cell_Set == false {
//                        cell.handleVisibleStateChange(type: .activate_Prohibited_Moving_Cell)
//                    }
//                }
//            }
//        }
