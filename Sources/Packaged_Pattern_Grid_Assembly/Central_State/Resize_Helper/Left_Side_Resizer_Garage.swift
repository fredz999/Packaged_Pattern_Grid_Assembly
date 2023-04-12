//
//  Left_Side_Resizer_Garage.swift
//  
//
//  Created by Jon on 12/04/2023.
//

import Foundation
import SwiftUI

class Left_Side_Resizer_Garage {
    let dimensions = ComponentDimensions.StaticDimensions
    var snapshotMinHalfCellIndex : Int?
    var snapshotMaxHalfCellIndex : Int?
    var leftwardBarrierDataX : Int?
    var snapshot_Line_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    var new_Note_Cell_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    var available_Cell_Set : Set<Underlying_Data_Cell> = Set<Underlying_Data_Cell>()
    var noteReference : Note?

    init(snapshotMinHalfCellIndex: Int, snapshotMaxHalfCellIndex: Int, leftwardBarrierDataX: Int
         , snapshot_Line_Set: Set<Underlying_Data_Cell>,noteParam:Note,resizeModeParam : E_Resize_Mode){
    self.noteReference = noteParam
    self.snapshotMinHalfCellIndex = snapshotMinHalfCellIndex
    self.snapshotMaxHalfCellIndex = snapshotMaxHalfCellIndex
    self.leftwardBarrierDataX = leftwardBarrierDataX
    self.snapshot_Line_Set = snapshot_Line_Set
    }

    func resize_Left_Side_Handler(halfCellDeltaParam:Int) {
        if dimensions.patternTimingConfiguration == .fourFour{
            
            if let lclSnapshotMinHalfCellIndex = snapshotMinHalfCellIndex
                , let lcl_maxHalfCellIndex = snapshotMaxHalfCellIndex
                , let lcl_LeftwardBarrierDataX = leftwardBarrierDataX {

                let currentHalfCellIndexParam = lclSnapshotMinHalfCellIndex + halfCellDeltaParam

                if currentHalfCellIndexParam >= lcl_maxHalfCellIndex{
                    new_Note_Cell_Set = snapshot_Line_Set.filter{$0.four_Four_Half_Cell_Index == lcl_maxHalfCellIndex}
                    available_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number > lcl_LeftwardBarrierDataX &&  $0.four_Four_Half_Cell_Index <= lcl_maxHalfCellIndex}
                }
                else if currentHalfCellIndexParam < lcl_maxHalfCellIndex {
                    available_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number > lcl_LeftwardBarrierDataX &&  $0.four_Four_Half_Cell_Index <= lcl_maxHalfCellIndex}
                    new_Note_Cell_Set = available_Cell_Set.filter{$0.four_Four_Half_Cell_Index >= currentHalfCellIndexParam && $0.four_Four_Half_Cell_Index <= lcl_maxHalfCellIndex}
                }
            }
            
        }
        else if dimensions.patternTimingConfiguration == .sixEight{
            
            if let lclSnapshotMinHalfCellIndex = snapshotMinHalfCellIndex
                , let lcl_maxHalfCellIndex = snapshotMaxHalfCellIndex
                , let lcl_LeftwardBarrierDataX = leftwardBarrierDataX {

                let currentHalfCellIndexParam = lclSnapshotMinHalfCellIndex + halfCellDeltaParam

                if currentHalfCellIndexParam >= lcl_maxHalfCellIndex{
                    new_Note_Cell_Set = snapshot_Line_Set.filter{$0.six_Eight_Half_Cell_Index  == lcl_maxHalfCellIndex}
                    //.filter{$0.four_Four_Half_Cell_Index == lcl_maxHalfCellIndex}
                    available_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number > lcl_LeftwardBarrierDataX &&  $0.six_Eight_Half_Cell_Index <= lcl_maxHalfCellIndex}
                        //.filter{$0.dataCell_X_Number > lcl_LeftwardBarrierDataX &&  $0.four_Four_Half_Cell_Index <= lcl_maxHalfCellIndex}
                }
                else if currentHalfCellIndexParam < lcl_maxHalfCellIndex {
                    available_Cell_Set = snapshot_Line_Set.filter{$0.dataCell_X_Number > lcl_LeftwardBarrierDataX && $0.six_Eight_Half_Cell_Index <= lcl_maxHalfCellIndex}
                        //.filter{$0.dataCell_X_Number > lcl_LeftwardBarrierDataX && $0.four_Four_Half_Cell_Index <= lcl_maxHalfCellIndex}
                    new_Note_Cell_Set = available_Cell_Set.filter{$0.six_Eight_Half_Cell_Index >= currentHalfCellIndexParam && $0.six_Eight_Half_Cell_Index <= lcl_maxHalfCellIndex}
                        //.filter{$0.four_Four_Half_Cell_Index >= currentHalfCellIndexParam && $0.four_Four_Half_Cell_Index <= lcl_maxHalfCellIndex}
                }
            }
            
        }
        
        
        
        paintCells()
    }

    deinit{
    if snapshotMinHalfCellIndex != nil{snapshotMinHalfCellIndex = nil}
    if snapshotMaxHalfCellIndex != nil{snapshotMaxHalfCellIndex = nil}
    if leftwardBarrierDataX != nil{leftwardBarrierDataX = nil}
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
