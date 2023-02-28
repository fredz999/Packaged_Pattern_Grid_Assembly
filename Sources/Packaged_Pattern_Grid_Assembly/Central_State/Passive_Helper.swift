//
//  Passive_Helper.swift
//  
//
//  Created by Jon on 28/02/2023.
//

import Foundation

class Passive_Helper {
    
    let dimensions = ComponentDimensions.StaticDimensions
    
    let note_Collection_Ref = Note_Collection.Static_Note_Collection
    
    var passive_Cursor_Set = Set<Underlying_Data_Cell>(){
        willSet {
            let delta = passive_Cursor_Set.symmetricDifference(newValue)
            for cell in delta {
                cell.handleVisibleStateChange(type: .deActivate_Passive_Cursor_Set)
            }
        }
        didSet {
            for cell in passive_Cursor_Set {
                cell.handleVisibleStateChange(type : .activate_Passive_Cursor_Set)
            }
        }
    }
    
    func process_Passive_Cursor_Position() {
        if dimensions.patternTimingConfiguration == .fourFour {
        passive_Cursor_Set = Central_State.Static_Central_State.currLineSet.filter({$0.four_Four_Half_Cell_Index == Central_State.Static_Central_State.currentData.four_Four_Half_Cell_Index})
        }
        else if dimensions.patternTimingConfiguration == .sixEight {
        passive_Cursor_Set = Central_State.Static_Central_State.currLineSet.filter({$0.six_Eight_Half_Cell_Index == Central_State.Static_Central_State.currentData.six_Eight_Half_Cell_Index})
        }
    }
    
}
