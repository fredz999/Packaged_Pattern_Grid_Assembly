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
//            print("deleteHelper_currentData X: ",deleteHelper_currentData.dataCell_X_Number.description,", Y: ",deleteHelper_currentData.dataCell_Y_Number.description)
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
    }
    
    // this has to accumulate...it needs an initial .....? hmmm this is ,,, a bit tricckkky
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
    
    var initialCursorCell : Underlying_Data_Cell?{
        didSet{
            if let lclInitialCursorCell = initialCursorCell {
                min_X = lclInitialCursorCell.dataCell_X_Number
                max_X = lclInitialCursorCell.dataCell_X_Number
                min_Y = lclInitialCursorCell.dataCell_Y_Number
                max_Y = lclInitialCursorCell.dataCell_Y_Number
            }
        }
    }

    var min_X : Int?
    var max_X : Int?
    var min_Y : Int?
    var max_Y : Int?
    
    var delete_Area_Set = Set<Underlying_Data_Cell>()
    
    func analyse_Delete_Square_Set(){
        if let lclInitialCell = initialCursorCell {
            
            if deleteHelper_currentData.dataCell_X_Number < lclInitialCell.dataCell_X_Number {
                if let lclMinX = min_X {
                    if deleteHelper_currentData.dataCell_X_Number < lclMinX{min_X=deleteHelper_currentData.dataCell_X_Number}
                }
            }
            else if deleteHelper_currentData.dataCell_X_Number > lclInitialCell.dataCell_X_Number {
                if let lclMaxX = max_X {
                    if deleteHelper_currentData.dataCell_X_Number > lclMaxX{max_X=deleteHelper_currentData.dataCell_X_Number}
                }
            }
            
            if deleteHelper_currentData.dataCell_Y_Number < lclInitialCell.dataCell_Y_Number {
                if let lclMinY = min_Y {
                    if deleteHelper_currentData.dataCell_Y_Number < lclMinY{min_Y=deleteHelper_currentData.dataCell_Y_Number}
                }
            }
            else if deleteHelper_currentData.dataCell_Y_Number > lclInitialCell.dataCell_Y_Number {
                if let lclMaxY = max_Y {
                    if deleteHelper_currentData.dataCell_Y_Number > lclMaxY{max_Y=deleteHelper_currentData.dataCell_Y_Number}
                }
            }
//            if let lclMinx = min_X,let lclMinY = min_Y,let lclMax_X = max_X,let lclMax_Y = max_Y{
//                print("minX: ",lclMinx,", minY: ",lclMinY,", maxX: ",lclMax_X,", maxY: ",lclMax_Y)
//            }
            // ok, now I have to establish the set of lines and for each lineSet the xmin and max
            // let LinesInDelete
            
            //Underlying_Data_Grid.line_Of_Cells_Set.filter{$0 }
            //line_Of_Cells_Set
           // delete_Area_Set = Underlying_Data_Grid.line_Of_Cells_Set.filter{$0.ynu}
            
            if let lclMinx = min_X,let lclMinY = min_Y,let lclMax_X = max_X,let lclMax_Y = max_Y {
                delete_Area_Set = Underlying_Data_Grid.Static_Underlying_Data_Grid.grid_Of_Cells_Set
                .filter{$0.dataCell_Y_Number <= lclMax_Y && $0.dataCell_Y_Number >= lclMinY && $0.dataCell_X_Number <= lclMax_X && $0.dataCell_X_Number >= lclMinx}
            }
            for cell in delete_Area_Set{
                cell.in_Delete_Square_Set
            }
        }
        
        
        
        // 1: get initial
        // 2: get max vals of up down left and right
//        for cell in delete_Square_Set {
//            if let note = cell.note_Im_In {
//                if let lclNoteCollection = note_Collection_Ref {
//                    lclNoteCollection.reset_Note_Data_Cells(noteParam: note)
//                }
//            }
//        }
    }

    func nil_Delete_Square_Set(){
        
        if initialCursorCell != nil{initialCursorCell = nil}
        
        if min_X != nil{min_X=nil}
        if max_X != nil{max_X=nil}
        if min_Y != nil{min_Y=nil}
        if max_Y != nil{max_Y=nil}

        if delete_Square_Set.count > 0 {
            for cell in delete_Square_Set {
                cell.handleVisibleStateChange(type: .deActivate_Delete_Square_Set)
            }
            delete_Square_Set.removeAll()
        }
        
        if delete_Area_Set.count > 0 {
            for cell in delete_Area_Set {
                cell.handleVisibleStateChange(type: .deActivate_Delete_Square_Set)
            }
            delete_Area_Set.removeAll()
        }
        
    }
    
    
    
}
