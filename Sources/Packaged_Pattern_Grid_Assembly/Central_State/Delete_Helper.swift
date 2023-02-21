//
//  File.swift
//  
//
//  Created by Jon on 21/02/2023.
//

import Foundation
import SwiftUI

class Delete_Helper {
    
    let dimensions = ComponentDimensions.StaticDimensions
    var current_Cell_Line_Set = Set<Underlying_Data_Cell>()
    
    var deleteHelper_currentData : Underlying_Data_Cell{
        didSet {
            establish_Delete_Square_Set()
        }
    }
    
    var delete_Square_Set = Set<Underlying_Data_Cell>(){
        willSet {
            let delta = delete_Square_Set.symmetricDifference(newValue)
            for cell in delta {
                cell.handleVisibleStateChange(type: .deActivate_Delete_Square_Set)
            }
        }
        didSet {
            for cell in delete_Square_Set {
                cell.handleVisibleStateChange(type : .activate_Delete_Square_Set)
            }
        }
    }
    
    init(initialDataParam : Underlying_Data_Cell){deleteHelper_currentData = initialDataParam}
    
    func establish_Delete_Square_Set(){
        print("establish_Delete_Square_Set()")
        if dimensions.patternTimingConfiguration == .fourFour {
            delete_Square_Set = current_Cell_Line_Set.filter({$0.four_Four_Half_Cell_Index == deleteHelper_currentData.four_Four_Half_Cell_Index})
            
        }
        else if dimensions.patternTimingConfiguration == .sixEight {
            delete_Square_Set = current_Cell_Line_Set.filter({$0.six_Eight_Half_Cell_Index == deleteHelper_currentData.six_Eight_Half_Cell_Index})
        }
    }

    func nil_Delete_Square_Set(){
        if delete_Square_Set.count > 0 {
            for cell in delete_Square_Set {
                cell.handleVisibleStateChange(type: .deActivate_Delete_Square_Set)
            }
            delete_Square_Set.removeAll()
        }
    }
    
    
    
}
