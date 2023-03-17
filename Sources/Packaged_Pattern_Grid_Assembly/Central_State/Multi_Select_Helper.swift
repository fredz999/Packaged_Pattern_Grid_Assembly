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
        if mode_Active == true {
            mode_Active = false
//            for cell in potential_MultiSelect_Set{
//                if cell.in_MultiSelect_Set == true{cell.in_MultiSelect_Set = false}
//            }
            potential_MultiSelect_Set.removeAll()
            print("potential_MultiSelect_Set.removeAll()")
        }
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
                cell.handleVisibleStateChange(type: .deActivate_Multiselect_Set)
            }
        }
        didSet {
            for cell in potential_MultiSelect_Set {
                cell.handleVisibleStateChange(type : .activate_Multiselect_Set)
            }
        }
    }
    
    func multi_Select_Move(){
        if let lclSnapshot_X = snapshot_Cursor_X, let lclSnapshot_Y = snapshot_Cursor_Y
        {
            potential_MultiSelect_Set = parentCentralState.data_Grid.grid_Of_Cells_Set.filter {
                $0.dataCell_X_Number <= parentCentralState.curr_Data_Pos_X
                && $0.dataCell_Y_Number <= parentCentralState.curr_Data_Pos_Y
                && $0.dataCell_X_Number >= lclSnapshot_X
                && $0.dataCell_Y_Number >= lclSnapshot_Y
            }
        }
    }
    
    
    
}

// just going to use a seperate multi select mode for now ....
// the single select can just be a hover over one note type thing
