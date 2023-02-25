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
    
    var min_X : Int?
    var max_X : Int?
    var min_Y : Int?
    var max_Y : Int?
    
    var current_Line_Set = Set<Underlying_Data_Cell>()
    
    var delete_Cursor_CurrentData : Underlying_Data_Cell
    
    var delete_Cursor_Set = Set<Underlying_Data_Cell>(){
        willSet {
            let delta = delete_Cursor_Set.symmetricDifference(newValue)
            for cell in delta {
                cell.handleVisibleStateChange(type: .deActivate_Delete_Square_Set)
            }
        }
        didSet {
            for cell in delete_Cursor_Set {
                cell.handleVisibleStateChange(type : .activate_Delete_Square_Set)
            }
        }
    }
    
    var current_Start_Cell : Underlying_Data_Cell?{
        didSet{
            if let lclInitialCursorCell = current_Start_Cell {
                min_X = lclInitialCursorCell.dataCell_X_Number
                max_X = lclInitialCursorCell.dataCell_X_Number
                min_Y = lclInitialCursorCell.dataCell_Y_Number
                max_Y = lclInitialCursorCell.dataCell_Y_Number
            }
        }
    }
    
    var current_Direction : E_DeleteLineDirection = .stationary {
        didSet{
            print("movement plane changed, new plane: ",current_Direction)
        }
    }

    init(initialDataParam : Underlying_Data_Cell){
        delete_Cursor_CurrentData = initialDataParam
    }
    
    var currentLineSet = Set<Underlying_Data_Cell>(){
        willSet {
            let delta = currentLineSet.symmetricDifference(newValue)
            for cell in delta {
                cell.handleVisibleStateChange(type: .deActivate_Delete_Square_Set)
            }
        }
        didSet {
            for cell in currentLineSet {
                cell.handleVisibleStateChange(type : .activate_Delete_Square_Set)
            }
        }
    }
    
    var gridSnakeSet : Set<Set<Underlying_Data_Cell>> = Set<Set<Underlying_Data_Cell>>()
    
    func process_Delete_Cursor_Position() {
        if dimensions.patternTimingConfiguration == .fourFour {
            let nuSet = current_Line_Set.filter({$0.four_Four_Half_Cell_Index == delete_Cursor_CurrentData.four_Four_Half_Cell_Index})
            delete_Cursor_Set = nuSet
        }
        else if dimensions.patternTimingConfiguration == .sixEight {
            let nuSet = current_Line_Set.filter({$0.six_Eight_Half_Cell_Index == delete_Cursor_CurrentData.six_Eight_Half_Cell_Index})
            delete_Cursor_Set = nuSet
        }
        process_Current_Line()
    }

    func process_Current_Line() {
        // a change of direction is only warranted when the current pos is actually different from the current initial
        if let lclInitialCell = current_Start_Cell {
            
            if delete_Cursor_CurrentData.dataCell_X_Number < lclInitialCell.dataCell_X_Number {
              //the direction is horizontal
                if current_Direction != .horizontal{current_Direction = .horizontal}
            }
            else if delete_Cursor_CurrentData.dataCell_X_Number > lclInitialCell.dataCell_X_Number {
                if current_Direction != .horizontal{current_Direction = .horizontal}
            }

            if delete_Cursor_CurrentData.dataCell_Y_Number < lclInitialCell.dataCell_Y_Number {
                if current_Direction != .vertical{current_Direction = .vertical}
            }
            else if delete_Cursor_CurrentData.dataCell_Y_Number > lclInitialCell.dataCell_Y_Number {
                if current_Direction != .vertical{current_Direction = .vertical}
            }
            
        }
        
    }

    var delete_Area_Set = Set<Underlying_Data_Cell>(){
        willSet {
            let delta = delete_Area_Set.symmetricDifference(newValue)
            for cell in delta {
                cell.handleVisibleStateChange(type: .deActivate_Delete_Square_Set)
            }
        }
        didSet {
            for cell in delete_Area_Set {
                cell.handleVisibleStateChange(type : .activate_Delete_Square_Set)
            }
        }
    }
    
    func nil_Delete_Square_Set(){
        if current_Direction != .stationary{current_Direction = .stationary}
        if current_Start_Cell != nil{current_Start_Cell = nil}
        
        if min_X != nil{min_X=nil}
        if max_X != nil{max_X=nil}
        if min_Y != nil{min_Y=nil}
        if max_Y != nil{max_Y=nil}

        if delete_Cursor_Set.count > 0 {
            for cell in delete_Cursor_Set {
                cell.handleVisibleStateChange(type: .deActivate_Delete_Square_Set)
            }
            delete_Cursor_Set.removeAll()
        }
        
        if delete_Area_Set.count > 0 {
            for cell in delete_Area_Set {
                cell.handleVisibleStateChange(type: .deActivate_Delete_Square_Set)
            }
            delete_Area_Set.removeAll()
        }
        //gridSnakeSet
        var lines = Array(gridSnakeSet)
        for l in 0..<lines.count {
            for cell in lines[l] {
                cell.handleVisibleStateChange(type: .deActivate_Delete_Square_Set)
            }
            lines[l].removeAll()
        }
        gridSnakeSet.removeAll()
    }
    
}

enum E_DeleteLineDirection : String {
    case horizontal = "horizontal"
    case vertical = "vertical"
    case stationary = "stationary"
}

// this is the traditional 'form a rectangle' selection deletion function - this is to form part of the overall set analysis later
//    func analyse_Delete_Square_Set(){
//        if let lclInitialCell = initialCursorCell {
//
//            if deleteHelper_currentData.dataCell_X_Number < lclInitialCell.dataCell_X_Number {
//                if let lclMinX = min_X {
//                    //if deleteHelper_currentData.dataCell_X_Number < lclMinX{min_X=deleteHelper_currentData.dataCell_X_Number}
//                    min_X=deleteHelper_currentData.dataCell_X_Number
//                    max_X=lclInitialCell.dataCell_X_Number
//                }
//            }
//            else if deleteHelper_currentData.dataCell_X_Number > lclInitialCell.dataCell_X_Number {
//                if let lclMaxX = max_X {
//                    //if deleteHelper_currentData.dataCell_X_Number > lclMaxX{max_X=deleteHelper_currentData.dataCell_X_Number}
//                    max_X=deleteHelper_currentData.dataCell_X_Number
//                    min_X=lclInitialCell.dataCell_X_Number
//                }
//            }
//
//            if deleteHelper_currentData.dataCell_Y_Number < lclInitialCell.dataCell_Y_Number {
//                if let lclMinY = min_Y {
//                    //if deleteHelper_currentData.dataCell_Y_Number < lclMinY{min_Y=deleteHelper_currentData.dataCell_Y_Number}
//                    min_Y=deleteHelper_currentData.dataCell_Y_Number
//                    max_Y=lclInitialCell.dataCell_Y_Number
//                }
//            }
//            else if deleteHelper_currentData.dataCell_Y_Number > lclInitialCell.dataCell_Y_Number {
//                if let lclMaxY = max_Y {
//                    //if deleteHelper_currentData.dataCell_Y_Number > lclMaxY{max_Y=deleteHelper_currentData.dataCell_Y_Number}
//                    max_Y=deleteHelper_currentData.dataCell_Y_Number
//                    min_Y=lclInitialCell.dataCell_Y_Number
//                }
//            }
//
//            if let lclMinx = min_X,let lclMinY = min_Y,let lclMax_X = max_X,let lclMax_Y = max_Y {
//                delete_Area_Set = Underlying_Data_Grid.Static_Underlying_Data_Grid.grid_Of_Cells_Set
//                .filter{$0.dataCell_Y_Number <= lclMax_Y && $0.dataCell_Y_Number >= lclMinY && $0.dataCell_X_Number <= lclMax_X && $0.dataCell_X_Number >= lclMinx}
//            }
//
//        }
//
//
//
//        // 1: get initial
//        // 2: get max vals of up down left and right
////        for cell in delete_Square_Set {
////            if let note = cell.note_Im_In {
////                if let lclNoteCollection = note_Collection_Ref {
////                    lclNoteCollection.reset_Note_Data_Cells(noteParam: note)
////                }
////            }
////        }
//    }
