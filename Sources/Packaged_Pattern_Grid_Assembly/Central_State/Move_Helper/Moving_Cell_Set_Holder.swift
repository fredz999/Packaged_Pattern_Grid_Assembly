//
//  File.swift
//  
//
//  Created by Jon on 29/04/2023.
//

import Foundation
import SwiftUI

class Moving_Cell_Set_Holder {
    
    var noteImIn : Note
    
    var initial_Snapshot : Note_Movement_SnapShot
    
    @Published public var movingNoteCurrentlyWriteable : Bool = false
    {
        didSet {
            print("movingNoteCurrentlyWriteable set to: ",movingNoteCurrentlyWriteable.description)
            handleNoteWriteabilityChange(noteWriteable: movingNoteCurrentlyWriteable)
        }
    }
    
    func handleNoteWriteabilityChange(noteWriteable:Bool)
    {
        if noteWriteable == true {
            for cell in potential_Moved_Set {
                if cell.in_Prohibited_Moving_Cell_Set == true {
                    cell.handleVisibleStateChange(type: .deActivate_Prohibited_Moving_Cell)
                }
            }
        }
        else if noteWriteable == false {
            for cell in potential_Moved_Set {
                if cell.in_Prohibited_Moving_Cell_Set == false {
                    cell.handleVisibleStateChange(type: .activate_Prohibited_Moving_Cell)
                }
            }
        }
    }

    var potential_Moved_Set = Set<Underlying_Data_Cell>(){
        willSet {
            let delta = potential_Moved_Set.symmetricDifference(newValue)
            for cell in delta {
                if cell.in_Potential_Set{cell.handleVisibleStateChange(type: .deActivate_Potential_Set)}
                if cell.in_Prohibited_Moving_Cell_Set{cell.handleVisibleStateChange(type: .deActivate_Prohibited_Moving_Cell)}
            }
        }
        didSet {
            if movingNoteCurrentlyWriteable == true {
                for cell in potential_Moved_Set {
                    if cell.in_Potential_Set == false {
                        cell.handleVisibleStateChange(type : .activate_Potential_Set)
                    }
                }
            }
            else if movingNoteCurrentlyWriteable == false {
                for cell in potential_Moved_Set {
                    if cell.in_Prohibited_Moving_Cell_Set == false {
                        cell.handleVisibleStateChange(type: .activate_Prohibited_Moving_Cell)
                    }
                }
            }
        }
    }
    
    var prohibition_Indicator_Set = Set<Underlying_Data_Cell>(){
        willSet {
            let delta = prohibition_Indicator_Set.symmetricDifference(newValue)
            for cell in delta {
                cell.handleVisibleStateChange(type: .deActivate_Prohibited_Clashing_Cell)
            }
        }
        didSet {
            if prohibition_Indicator_Set.count == 0 {
                if movingNoteCurrentlyWriteable == false {
                    movingNoteCurrentlyWriteable = true
                }
            }
            else if prohibition_Indicator_Set.count > 0 {
                if movingNoteCurrentlyWriteable == true {
                    movingNoteCurrentlyWriteable = false
                }
                for cell in prohibition_Indicator_Set {
                    cell.handleVisibleStateChange(type : .activate_Prohibited_Clashing_Cell)
                }
            }
        }
    }

    init(initial_Snapshot_Param:Note_Movement_SnapShot,noteParam:Note){
        noteImIn = noteParam
        initial_Snapshot = initial_Snapshot_Param
    }

}
