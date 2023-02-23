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
    
    public var note_Collection_Ref : Note_Collection?
    
    var current_DellCell_Line_Set = Set<Underlying_Data_Cell>()
    
    var deleteHelper_currentData : Underlying_Data_Cell
//    {
//        didSet {
//            establish_Delete_Square_Set()
//        }
//    }
    
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
    
    init(initialDataParam : Underlying_Data_Cell){
        deleteHelper_currentData = initialDataParam
        postInitSetup()
    }
    
    func postInitSetup(){
        note_Collection_Ref = Note_Collection.Static_Note_Collection
    }
    
    func establish_Delete_Square_Set() {
        if dimensions.patternTimingConfiguration == .fourFour {
            let nuSet = current_DellCell_Line_Set.filter({$0.four_Four_Half_Cell_Index == deleteHelper_currentData.four_Four_Half_Cell_Index})
            delete_Square_Set = nuSet
        }
        else if dimensions.patternTimingConfiguration == .sixEight {
            let nuSet = current_DellCell_Line_Set.filter({$0.six_Eight_Half_Cell_Index == deleteHelper_currentData.six_Eight_Half_Cell_Index})
            delete_Square_Set = nuSet
        }
        analyse_Delete_Square_Set()
    }
    
    func analyse_Delete_Square_Set(){
        
        for cell in delete_Square_Set {
            if let note = cell.note_Im_In {
                if let lclNoteCollection = note_Collection_Ref{
                    lclNoteCollection.reset_Note_Data_Cells(noteParam: note)
                }
            }
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
