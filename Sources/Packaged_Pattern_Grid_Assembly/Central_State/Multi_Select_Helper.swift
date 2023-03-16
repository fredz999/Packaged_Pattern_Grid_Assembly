//
//  Multi_Select_Helper.swift
//  
//
//  Created by Jon on 14/03/2023.
//

import Foundation
import SwiftUI

//P_Selectable_Mode
class Multi_Select_Helper : P_Selectable_Mode {
    
    var parentCentralState : Central_State
    
    var mode_Active: Bool = false
    
    func activate_Mode(activationCell: Underlying_Data_Cell?) {
        if mode_Active == false {
            mode_Active = true
            
            if let lclActivationCell = activationCell{
                snapshot_Cursor_X = lclActivationCell.dataCell_X_Number
                snapshot_Cursor_Y = lclActivationCell.dataCell_Y_Number
            }

        }
    }

    func deactivate_Mode() {
        if mode_Active == true { mode_Active = false }
    }
    
    init(parentCentral_State_Param:Central_State){
        parentCentralState = parentCentral_State_Param
    }
    
    
    


    var snapshot_Cursor_X : Int?
    var snapshot_Cursor_Y : Int?

    
    var potential_MultiSelect_Set = Set<Underlying_Data_Cell>(){
        willSet {
            let delta = potential_MultiSelect_Set.symmetricDifference(newValue)
            for cell in delta {
                cell.handleVisibleStateChange(type: .deActivate_Potential_Set)
            }
        }
        didSet {
            for cell in potential_MultiSelect_Set {
                cell.handleVisibleStateChange(type : .activate_Potential_Set)
            }
        }
    }
    
    func multi_Select_Move(){
        
        if let lclSnapshot_X = snapshot_Cursor_X, let lclSnapshot_Y = snapshot_Cursor_Y
        {

//        let delta_X_Grid_Units = parentCentralState.curr_Data_Pos_X - lclSnapshot_X
//        let delta_Y_Grid_Units = parentCentralState.curr_Data_Pos_Y - lclSnapshot_Y
            print("multi_Select_Move()")
            
            potential_MultiSelect_Set = parentCentralState.data_Grid.grid_Of_Cells_Set.filter {
                $0.dataCell_X_Number <= parentCentralState.curr_Data_Pos_X
                && $0.dataCell_Y_Number <= parentCentralState.curr_Data_Pos_Y
                && $0.dataCell_X_Number >= lclSnapshot_X
                && $0.dataCell_Y_Number >= lclSnapshot_Y
            }

//        let proposedNewMinIndex = lclNote_Low_Index + delta_X_Grid_Units
//        let proposedNewMaxIndex = lclNote_High_Index + delta_X_Grid_Units
//        let proposedNewYIndex = lclNote_Y_Val + delta_Y_Grid_Units
//
//        if proposedNewMinIndex >= currLeftLimit && proposedNewMaxIndex <= currRightLimit {
//            proposedSet = parentCentralState.currLineSet
//            .filter{$0.dataCell_X_Number >= proposedNewMinIndex && $0.dataCell_X_Number <= proposedNewMaxIndex}
//        }
//        else if proposedNewMinIndex < currLeftLimit {
//            proposedSet = parentCentralState.currLineSet
//            .filter{$0.dataCell_X_Number >= currLeftLimit && $0.dataCell_X_Number <= (lclNote_High_Index - lclNote_Low_Index)}
//        }
//        else if proposedNewMaxIndex > currRightLimit {
//            proposedSet = parentCentralState.currLineSet
//            .filter{$0.dataCell_X_Number >=  currRightLimit-(lclNote_High_Index - lclNote_Low_Index)
//                && $0.dataCell_X_Number <= currRightLimit
//            }
//        }
            
//        potential_Moved_Set = proposedSet
//
//        prohibition_Indicator_Set = proposedSet.filter({$0.note_Im_In != nil})
            
        }
        
    }
    
    
    
}

// just going to use a seperate multi select mode for now ....
// the single select can just be a hover over one note type thing
