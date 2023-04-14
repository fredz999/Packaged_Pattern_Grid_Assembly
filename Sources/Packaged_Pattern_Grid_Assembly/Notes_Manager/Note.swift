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
    //var minimumSet : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    //var dataCellArray : [Underlying_Data_Cell] = []
    // transferred to new object ========================================
    
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
        var lastElement : Int = 0 // = note_Modification_Object.dataCellArray.count-1
        var startCellNum : Int = 0 // = note_Modification_Object.dataCellArray[0].dataCell_X_Number
        var length : Int  = 0// = note_Modification_Object.dataCellArray.count
        var endCellNum : Int = 0 // = note_Modification_Object.dataCellArray[lastElement].dataCell_X_Number
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

public class Modifiable_Note_Data{
    var noteParent : Note
    var dataCellArray : [Underlying_Data_Cell] = []
    var lowest_X_Index : Int
    var highest_X_Index : Int
    var containing_Data_Line : Underlying_Data_Line
    var highestFourFourHalfCellIndex : Int
    var lowestFourFourHalfCellIndex : Int
    var highestSixEightHalfCellIndex : Int
    var lowestSixEightHalfCellIndex : Int
    var minimumSet : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    
    init(dataCellArray: [Underlying_Data_Cell], lowest_X_Index: Int, highest_X_Index: Int, containing_Data_Line: Underlying_Data_Line, highestFourFourHalfCellIndex: Int, lowestFourFourHalfCellIndex: Int, highestSixEightHalfCellIndex: Int, lowestSixEightHalfCellIndex: Int,parentParam:Note) {
        self.dataCellArray = dataCellArray
        self.lowest_X_Index = lowest_X_Index
        self.highest_X_Index = highest_X_Index
        self.containing_Data_Line = containing_Data_Line
        self.highestFourFourHalfCellIndex = highestFourFourHalfCellIndex
        self.lowestFourFourHalfCellIndex = lowestFourFourHalfCellIndex
        self.highestSixEightHalfCellIndex = highestSixEightHalfCellIndex
        self.lowestSixEightHalfCellIndex = lowestSixEightHalfCellIndex
        
        var minSet = Set<Underlying_Data_Cell>()
        
        if self.dataCellArray.count == 2 {
            minSet.insert(self.dataCellArray[0])
            minSet.insert(self.dataCellArray[1])
        }
        else if self.dataCellArray.count > 2 {
            minSet.insert(self.dataCellArray[0])
            minSet.insert(self.dataCellArray[1])
            minSet.insert(self.dataCellArray[2])
        }
        self.minimumSet = minSet
        noteParent = parentParam
    }
    
    
    func applyModification(newDataCellSet: Set<Underlying_Data_Cell>){
        if newDataCellSet.count > 0{

            let newDataCellArray = newDataCellSet.sorted(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
            self.dataCellArray.removeAll()
            self.dataCellArray = newDataCellArray
            
            if self.dataCellArray.count == 1{
                self.dataCellArray[0].change_Type(newType: .single_Note)
                for cell in self.dataCellArray{
                    if cell.in_Resize_Set == true {cell.handleVisibleStateChange(type: .deActivate_Resize_Set)}
                }
            }
            else if self.dataCellArray.count == 2{
                self.dataCellArray[0].change_Type(newType: .start_Note)
                self.dataCellArray[1].change_Type(newType: .end_Note)
                for cell in self.dataCellArray{
                    if cell.in_Resize_Set == true {cell.handleVisibleStateChange(type: .deActivate_Resize_Set)}
                }
            }
            else if self.dataCellArray.count > 2{
                let firstIndex = 0
                let finalIndex = self.dataCellArray.count-1
                self.dataCellArray[firstIndex].change_Type(newType: .start_Note)
                for x in 1..<finalIndex{
                    self.dataCellArray[x].change_Type(newType: .mid_Note)
                }
                self.dataCellArray[finalIndex].change_Type(newType: .end_Note)
                for cell in self.dataCellArray {
                    if cell.in_Resize_Set == true {cell.handleVisibleStateChange(type: .deActivate_Resize_Set)}
                }
            }
            
            if let minCell = newDataCellSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                self.lowest_X_Index = minCell.dataCell_X_Number
            }
            if let maxCell = newDataCellSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                self.highest_X_Index = maxCell.dataCell_X_Number
            }
            
            self.containing_Data_Line = newDataCellArray[0].parentLine
            
            self.highestFourFourHalfCellIndex = newDataCellArray[newDataCellArray.count-1].four_Four_Half_Cell_Index
            self.lowestFourFourHalfCellIndex = newDataCellArray[0].four_Four_Half_Cell_Index
            
            self.highestSixEightHalfCellIndex = newDataCellArray[newDataCellArray.count-1].six_Eight_Half_Cell_Index
            self.lowestSixEightHalfCellIndex = newDataCellArray[0].six_Eight_Half_Cell_Index
            
            
            self.lowest_X_Index = self.dataCellArray[0].dataCell_X_Number
            self.highest_X_Index = self.dataCellArray[self.dataCellArray.count-1].dataCell_X_Number
            
            self.minimumSet.removeAll()
            
            if self.dataCellArray.count == 2 {
                self.minimumSet.insert(self.dataCellArray[0])
                self.minimumSet.insert(self.dataCellArray[1])
            }
            else if self.dataCellArray.count > 2 {
                self.minimumSet.insert(self.dataCellArray[0])
                self.minimumSet.insert(self.dataCellArray[1])
                self.minimumSet.insert(self.dataCellArray[2])
            }
            
            for cell in self.dataCellArray{
                cell.note_Im_In = noteParent
            }
            
        }
    }
    
    
    func applyModification(newDataCellArray: [Underlying_Data_Cell]){
        if newDataCellArray.count > 0{
            
            let newDataCellSet = Set<Underlying_Data_Cell>(newDataCellArray)
            self.dataCellArray.removeAll()
            self.dataCellArray = newDataCellArray
            
            if self.dataCellArray.count == 1{
                self.dataCellArray[0].change_Type(newType: .single_Note)
                for cell in self.dataCellArray{
                    if cell.in_Resize_Set == true {cell.handleVisibleStateChange(type: .deActivate_Resize_Set)}
                }
            }
            else if self.dataCellArray.count == 2{
                self.dataCellArray[0].change_Type(newType: .start_Note)
                self.dataCellArray[1].change_Type(newType: .end_Note)
                for cell in self.dataCellArray{
                    if cell.in_Resize_Set == true {cell.handleVisibleStateChange(type: .deActivate_Resize_Set)}
                }
            }
            else if self.dataCellArray.count > 2{
                let firstIndex = 0
                let finalIndex = self.dataCellArray.count-1
                self.dataCellArray[firstIndex].change_Type(newType: .start_Note)
                for x in 1..<finalIndex{
                    self.dataCellArray[x].change_Type(newType: .mid_Note)
                }
                self.dataCellArray[finalIndex].change_Type(newType: .end_Note)
                for cell in self.dataCellArray {
                    if cell.in_Resize_Set == true {cell.handleVisibleStateChange(type: .deActivate_Resize_Set)}
                }
            }
            
            if let minCell = newDataCellSet.min(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                self.lowest_X_Index = minCell.dataCell_X_Number
            }
            if let maxCell = newDataCellSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                self.highest_X_Index = maxCell.dataCell_X_Number
            }
            
            self.containing_Data_Line = newDataCellArray[0].parentLine
            
            self.highestFourFourHalfCellIndex = newDataCellArray[newDataCellArray.count-1].four_Four_Half_Cell_Index
            self.lowestFourFourHalfCellIndex = newDataCellArray[0].four_Four_Half_Cell_Index
            
            self.highestSixEightHalfCellIndex = newDataCellArray[newDataCellArray.count-1].six_Eight_Half_Cell_Index
            self.lowestSixEightHalfCellIndex = newDataCellArray[0].six_Eight_Half_Cell_Index
            
            
            self.lowest_X_Index = self.dataCellArray[0].dataCell_X_Number
            self.highest_X_Index = self.dataCellArray[self.dataCellArray.count-1].dataCell_X_Number
            
            self.minimumSet.removeAll()
            
            if self.dataCellArray.count == 2 {
                self.minimumSet.insert(self.dataCellArray[0])
                self.minimumSet.insert(self.dataCellArray[1])
            }
            else if self.dataCellArray.count > 2 {
                self.minimumSet.insert(self.dataCellArray[0])
                self.minimumSet.insert(self.dataCellArray[1])
                self.minimumSet.insert(self.dataCellArray[2])
            }
            
            for cell in self.dataCellArray{
                cell.note_Im_In = noteParent
            }
            
        }
    }

    
    
    // do like note rewrites in here instead
}
