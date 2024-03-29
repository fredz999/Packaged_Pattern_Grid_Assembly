//
//  Right_Side_Resizer_Garage.swift
//  
//
//  Created by Jon on 12/04/2023.
//

import Foundation
import SwiftUI

class Right_Side_Resizer_Garage {
    
    var snapshotMinHalfCellIndex : Int?
    var snapshotMaxHalfCellIndex : Int?
    var rightwardBarrierDataX : Int?
    var leftwardBarrierDataX : Int?
    
    var snapshot_Line_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    var new_Note_Cell_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    var available_Cell_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    
    var noteReference : Note?
    
    init(snapshotMinHalfCellIndex: Int, snapshotMaxHalfCellIndex: Int
    , rightwardBarrierDataXParam: Int, leftwardBarrierDataXParam: Int
    , snapshot_Line_Set: Set<Underlying_Data_Cell>,noteParam:Note, resizeModeParam : E_Resize_Mode){
    self.noteReference = noteParam
    self.snapshotMinHalfCellIndex = snapshotMinHalfCellIndex
    self.snapshotMaxHalfCellIndex = snapshotMaxHalfCellIndex
    self.rightwardBarrierDataX = rightwardBarrierDataXParam
    self.leftwardBarrierDataX = leftwardBarrierDataXParam
    self.snapshot_Line_Set = snapshot_Line_Set
    }
    
    func resize_Right_Side_Handler(halfCellDeltaParam:Int) {
        let dimensions = ComponentDimensions.StaticDimensions
        
        if dimensions.patternTimingConfiguration == .fourFour {
            resizeFourFourHandler(halfCellDeltaParam: halfCellDeltaParam)
        }
        
        else if dimensions.patternTimingConfiguration == .sixEight {
            resizeSizEightHandler(halfCellDeltaParam:halfCellDeltaParam)
        }
        paintCells()
    }
    
    func resizeFourFourHandler(halfCellDeltaParam:Int){
        if let lclSnapshotMaxHalfCellIndex = snapshotMaxHalfCellIndex
            , let lcl_minHalfCellIndex = snapshotMinHalfCellIndex
            , let lcl_RightwardBarrierDataX = rightwardBarrierDataX
            , let lcl_LeftwardBarrierDataX = leftwardBarrierDataX
            , let lclNoteRef = noteReference{
            let currentHalfCellIndexParam = lclSnapshotMaxHalfCellIndex + halfCellDeltaParam
            
            if currentHalfCellIndexParam < lcl_minHalfCellIndex {
                if let lclModifiableNoteData = lclNoteRef.modifiable_Note_Data {
                    new_Note_Cell_Set = lclModifiableNoteData.minimumSet
                    if let lastMinimalCell = lclModifiableNoteData.minimumSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                    available_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number < lcl_RightwardBarrierDataX &&  $0.dataCell_X_Number > lastMinimalCell.dataCell_X_Number}
                    }
                }
            }
            if currentHalfCellIndexParam >= lcl_minHalfCellIndex {
                available_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number < lcl_RightwardBarrierDataX &&  $0.dataCell_X_Number >= lcl_LeftwardBarrierDataX}
                new_Note_Cell_Set = available_Cell_Set.filter{$0.four_Four_Half_Cell_Index <= currentHalfCellIndexParam}
            }
        }
    }
    
    func resizeSizEightHandler(halfCellDeltaParam:Int){
        if let lclSnapshotMaxHalfCellIndex = snapshotMaxHalfCellIndex
            , let lcl_minHalfCellIndex = snapshotMinHalfCellIndex
            , let lcl_RightwardBarrierDataX = rightwardBarrierDataX
            , let lclNoteRef = noteReference{
            
            
            let currentHalfCellIndexParam = lclSnapshotMaxHalfCellIndex + halfCellDeltaParam
            
            if currentHalfCellIndexParam < lcl_minHalfCellIndex{
 
                if let lclModifiableNoteData = lclNoteRef.modifiable_Note_Data{

                if lclModifiableNoteData.minimumSet.count == 3{
                    
                    if let lastSixEightMinimalCell = lclModifiableNoteData.minimumSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                        
                        let firstTwoMin = lclModifiableNoteData.minimumSet.filter{$0.dataCell_X_Number < lastSixEightMinimalCell.dataCell_X_Number}
                        new_Note_Cell_Set = firstTwoMin
                        available_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number < lcl_RightwardBarrierDataX &&  $0.dataCell_X_Number >= lastSixEightMinimalCell.dataCell_X_Number}
                    }
                }
                else if lclModifiableNoteData.minimumSet.count == 2{
                    if let lastMin = lclModifiableNoteData.minimumSet.max(by: {$0.dataCell_X_Number < $1.dataCell_X_Number}){
                        new_Note_Cell_Set = lclModifiableNoteData.minimumSet
                        available_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number < lcl_RightwardBarrierDataX && $0.dataCell_X_Number > lastMin.dataCell_X_Number}
                    }
                }
                }
            }
            if currentHalfCellIndexParam >= lcl_minHalfCellIndex {
                available_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number < lcl_RightwardBarrierDataX &&  $0.six_Eight_Half_Cell_Index >= lcl_minHalfCellIndex}
                new_Note_Cell_Set = available_Cell_Set.filter{$0.six_Eight_Half_Cell_Index <= currentHalfCellIndexParam}
            }
        }
    }
    
    deinit{
    if snapshotMinHalfCellIndex != nil{snapshotMinHalfCellIndex = nil}
    if snapshotMaxHalfCellIndex != nil{snapshotMaxHalfCellIndex = nil}
    if rightwardBarrierDataX != nil{rightwardBarrierDataX = nil}
    if snapshot_Line_Set.count > 0{snapshot_Line_Set.removeAll()}
    if new_Note_Cell_Set.count > 0{new_Note_Cell_Set.removeAll()}
    if available_Cell_Set.count > 0{available_Cell_Set.removeAll()}
    if noteReference != nil{noteReference = nil}
    }
    
    func paintCells(){
        for cell in available_Cell_Set {
            cell.reset_To_Original()
            if cell.in_Resize_Set == true {
                cell.handleVisibleStateChange(type: .deActivate_Resize_Set)
            }
        }

        for cell in new_Note_Cell_Set {
            cell.reset_To_Original()
            if cell.in_Resize_Set == false {
                cell.handleVisibleStateChange(type: .activate_Resize_Set)
            }
        }
    }
}
