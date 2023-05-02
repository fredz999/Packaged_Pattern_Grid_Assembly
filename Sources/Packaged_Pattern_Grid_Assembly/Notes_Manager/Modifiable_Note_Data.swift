//
//  Modifiable_Note_Data.swift
//  
//
//  Created by Jon on 15/04/2023.
//

import Foundation
import SwiftUI

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
        
        var most_Shrunk_Set = Set<Underlying_Data_Cell>()

        if self.dataCellArray.count == 2 {
            most_Shrunk_Set.insert(self.dataCellArray[0])
            most_Shrunk_Set.insert(self.dataCellArray[1])
        }
        else if self.dataCellArray.count > 2 {
            most_Shrunk_Set.insert(self.dataCellArray[0])
            most_Shrunk_Set.insert(self.dataCellArray[1])
            most_Shrunk_Set.insert(self.dataCellArray[2])
        }
        self.minimumSet = most_Shrunk_Set
        noteParent = parentParam
    }
    
    
    func reWrite_Note_Data(newDataCellSet: Set<Underlying_Data_Cell>){
//poss need to hit data_Y_Vals here
        if newDataCellSet.count > 0{

            let newDataCellArray = newDataCellSet.sorted(by: {$0.dataCell_X_Number < $1.dataCell_X_Number})
            noteParent.resetCells()
            self.dataCellArray.removeAll()// this actually has to reset the note cells as well
            self.dataCellArray = newDataCellArray
            
            if self.dataCellArray.count == 1{
                if self.dataCellArray[0].currentType != .single_Note{self.dataCellArray[0].change_Type(newType: .single_Note)}
                for cell in self.dataCellArray{
                    if cell.in_Resize_Set == true {cell.handleVisibleStateChange(type: .deActivate_Resize_Set)}
                }
            }
            else if self.dataCellArray.count == 2{
                if self.dataCellArray[0].currentType != .start_Note{self.dataCellArray[0].change_Type(newType: .start_Note)}
                if self.dataCellArray[1].currentType != .end_Note{self.dataCellArray[1].change_Type(newType: .end_Note)}
                for cell in self.dataCellArray{
                    if cell.in_Resize_Set == true {cell.handleVisibleStateChange(type: .deActivate_Resize_Set)}
                }
            }
            else if self.dataCellArray.count > 2{
                let firstIndex = 0
                let finalIndex = self.dataCellArray.count-1
                if self.dataCellArray[firstIndex].currentType != .start_Note{self.dataCellArray[firstIndex].change_Type(newType: .start_Note)}
                
                for x in 1..<finalIndex{
                    if self.dataCellArray[x].currentType != .mid_Note{self.dataCellArray[x].change_Type(newType: .mid_Note)}
                }
                if self.dataCellArray[finalIndex].currentType != .end_Note{self.dataCellArray[finalIndex].change_Type(newType: .end_Note)}

            }
            
            for cell in self.dataCellArray {
                if cell.in_Resize_Set == true {cell.handleVisibleStateChange(type: .deActivate_Resize_Set)}
                if cell.in_Potential_Set == true {cell.handleVisibleStateChange(type: .deActivate_Potential_Set)}
                cell.note_Im_In = noteParent
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
                if let lclDataValsHolder = cell.currentConnectedDataVals{
                    if lclDataValsHolder.referenced_note_Im_In == nil
                    || lclDataValsHolder.referenced_note_Im_In != noteParent{
                        lclDataValsHolder.updateNoteFromNewData(newNoteImIn: noteParent)
                    }
                }
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
}
