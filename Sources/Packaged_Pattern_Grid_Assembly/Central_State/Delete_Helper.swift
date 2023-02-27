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
    
    var current_Line_Set = Set<Underlying_Data_Cell>()
    
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
    
    var multiple_Line_Corners_Set = Set<Underlying_Data_Cell>()
//    {
//        willSet {
//            let delta = multiple_Line_Corners_Set.symmetricDifference(newValue)
//            for cell in delta {
//                cell.handleVisibleStateChange(type: .deActivate_Delete_Trail_Set)
//            }
//        }
//        didSet {
//            for cell in multiple_Line_Corners_Set {
//                cell.handleVisibleStateChange(type : .activate_Delete_Trail_Set)
//            }
//        }
//    }

    init(initialDataParam : Underlying_Data_Cell){
        delete_Cursor_CurrentData = initialDataParam
    }

    func process_Delete_Cursor_Position() {
        if dimensions.patternTimingConfiguration == .fourFour {
            let nuSet = current_Line_Set.filter({$0.four_Four_Half_Cell_Index == delete_Cursor_CurrentData.four_Four_Half_Cell_Index})
            delete_Cursor_Set = nuSet
        }
        else if dimensions.patternTimingConfiguration == .sixEight {
            let nuSet = current_Line_Set.filter({$0.six_Eight_Half_Cell_Index == delete_Cursor_CurrentData.six_Eight_Half_Cell_Index})
            delete_Cursor_Set = nuSet
        }
    }
    
    var current_Direction : E_DeleteLineDirection = .stationary
    
    var current_Trail_Corner : Underlying_Data_Cell?
    {
        didSet {
            if let lclDelete_Cursor_StartData = current_Trail_Corner {

                let new_Corner_Set = Underlying_Data_Grid.Static_Underlying_Data_Grid.grid_Of_Cells_Set
                .filter{$0.dataCell_Y_Number == lclDelete_Cursor_StartData.dataCell_Y_Number
                    && $0.four_Four_Half_Cell_Index == lclDelete_Cursor_StartData.four_Four_Half_Cell_Index
                }
                for cell in new_Corner_Set{
                    multiple_Line_Corners_Set.insert(cell)
                }
                
//                let new_Permanent_Line_Set = Underlying_Data_Grid.Static_Underlying_Data_Grid.grid_Of_Cells_Set
//                .filter{$0.dataCell_Y_Number == lclDelete_Cursor_StartData.dataCell_Y_Number
//                    && $0.four_Four_Half_Cell_Index == lclDelete_Cursor_StartData.four_Four_Half_Cell_Index
//                }
                //multiple_Line_Cell_Set
                
            }
        }
    }
    
    var delete_Cursor_CurrentData : Underlying_Data_Cell {
        willSet{
            process_Current_Line(previousDataCell:delete_Cursor_CurrentData,nextDataCell:newValue)
        }
    }

    var curr_Max_X_Right : Int?
    var curr_Max_X_Left : Int?
    var curr_Max_Y_Up : Int?
    var curr_Max_Y_Down : Int?
    
    
    func process_Current_Line(previousDataCell:Underlying_Data_Cell,nextDataCell:Underlying_Data_Cell) {
        
        if let lclCurrent_Initial_Cell = current_Trail_Corner {
            
            let initialX = lclCurrent_Initial_Cell.dataCell_X_Number
            let initialY = lclCurrent_Initial_Cell.dataCell_Y_Number
            
            let prevX = previousDataCell.dataCell_X_Number
            let prevY = previousDataCell.dataCell_Y_Number
            
            let nextX = nextDataCell.dataCell_X_Number
            let nextY = nextDataCell.dataCell_Y_Number

            if current_Direction == .stationary {
                if nextX != initialX{current_Direction = .horizontal}
                else if nextY != initialY{current_Direction = .vertical}
            }
            else if current_Direction == .horizontal {
                if prevY != nextY{
                    current_Trail_Corner = previousDataCell
                    current_Direction = .vertical
                }
                else if prevY == nextY {
                    incorporate_Row_Into_DeleteSet(curr_Y: nextY, initialX: initialX, finalX: nextX)
                }
            }
            else if current_Direction == .vertical {
                if prevX != nextX{
                    current_Trail_Corner = previousDataCell
                    current_Direction = .horizontal
                }
                else if prevX == nextX{
                    incorporate_Column_Into_DeleteSet(curr_X:nextX,initialY:initialY,finalY:nextY)
                }
            }
            
        }

    }
    
    func incorporate_Row_Into_DeleteSet(curr_Y:Int,initialX:Int,finalX:Int){
        if finalX > initialX {
            let new_Horz_Set =
            Underlying_Data_Grid.Static_Underlying_Data_Grid.grid_Of_Cells_Set
            .filter{$0.dataCell_Y_Number ==  curr_Y
                && $0.dataCell_X_Number > initialX
                && $0.dataCell_X_Number < finalX
            }
            for cell in new_Horz_Set{
                if cell.in_Delete_Trail_Set == false{
                    multiple_Line_Corners_Set.insert(cell)
                    //if let cellNote = cell.note_Im_In{note_Collection_Ref?.reset_Note_Data_Cells(noteParam: cellNote)}
                    if let lclNoteCollectionRef = note_Collection_Ref{
                        if let cellNote = cell.note_Im_In{lclNoteCollectionRef.reset_Note_Data_Cells(noteParam: cellNote)}
                    }
                }
            }
        }
        else if finalX < initialX {
            let new_Horz_Set =
            Underlying_Data_Grid.Static_Underlying_Data_Grid.grid_Of_Cells_Set
            .filter{$0.dataCell_Y_Number ==  curr_Y
                && $0.dataCell_X_Number < initialX
                && $0.dataCell_X_Number > finalX
            }
            for cell in new_Horz_Set{
                if cell.in_Delete_Trail_Set == false {
                    multiple_Line_Corners_Set.insert(cell)
                    //if let cellNote = cell.note_Im_In{note_Collection_Ref?.reset_Note_Data_Cells(noteParam: cellNote)}
                    if let lclNoteCollectionRef = note_Collection_Ref{
                        if let cellNote = cell.note_Im_In{lclNoteCollectionRef.reset_Note_Data_Cells(noteParam: cellNote)}
                    }
                }
            }
        }
    }
    
    func incorporate_Column_Into_DeleteSet(curr_X:Int,initialY:Int,finalY:Int){
        if finalY > initialY {
            let new_Vert_Set =
            Underlying_Data_Grid.Static_Underlying_Data_Grid.grid_Of_Cells_Set
            .filter{$0.dataCell_X_Number == curr_X && $0.dataCell_Y_Number >= initialY && $0.dataCell_Y_Number <= finalY}

            for cell in new_Vert_Set{
                let cell_Set = Underlying_Data_Grid.Static_Underlying_Data_Grid.grid_Of_Cells_Set.filter{$0.four_Four_Half_Cell_Index == cell.four_Four_Half_Cell_Index}
                for subCell in cell_Set{
                    multiple_Line_Corners_Set.insert(subCell)
                    if let lclNoteCollectionRef = note_Collection_Ref{
                        if let cellNote = subCell.note_Im_In{lclNoteCollectionRef.reset_Note_Data_Cells(noteParam: cellNote)}
                    }
                }
            }
            
        }
        else if finalY < initialY {
            let new_Vert_Set =
            Underlying_Data_Grid.Static_Underlying_Data_Grid.grid_Of_Cells_Set
            .filter{$0.dataCell_X_Number == curr_X && $0.dataCell_Y_Number >= finalY && $0.dataCell_Y_Number <= initialY}
            
            for cell in new_Vert_Set{
                let cell_Set = Underlying_Data_Grid.Static_Underlying_Data_Grid.grid_Of_Cells_Set.filter{$0.four_Four_Half_Cell_Index == cell.four_Four_Half_Cell_Index}
                for subCell in cell_Set{
                    multiple_Line_Corners_Set.insert(subCell)
                    if let lclNoteCollectionRef = note_Collection_Ref{
                        if let cellNote = subCell.note_Im_In{lclNoteCollectionRef.reset_Note_Data_Cells(noteParam: cellNote)}
                    }
                }
            }
            
        }
    }

    func nil_Delete_Square_Set(){
        if current_Direction != .stationary{current_Direction = .stationary}
        if current_Trail_Corner != nil{current_Trail_Corner = nil}
        
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

        if multiple_Line_Corners_Set.count > 0 {
            multiple_Line_Corners_Set.removeAll()
        }
        
        if delete_Area_Set.count > 0 {
            for cell in delete_Area_Set {
                cell.handleVisibleStateChange(type: .deActivate_Delete_Square_Set)
            }
            delete_Area_Set.removeAll()
        }
    }
    
}

enum E_DeleteLineDirection : String {
    case horizontal = "horizontal"
    case vertical = "vertical"
    case stationary = "stationary"
}

//                    if nextX > initialX {
//                        let newVerticalLineSet =
//                        Underlying_Data_Grid.Static_Underlying_Data_Grid.grid_Of_Cells_Set
//                        .filter{$0.dataCell_Y_Number ==  initialY
//                            && $0.dataCell_X_Number >= initialX
//                            && $0.dataCell_X_Number <= nextX
//                        }
//                        for cell in newVerticalLineSet{
//                            multiple_Line_Corners_Set.insert(cell)
//                        }
//                    }
                    
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

//func process_Current_Line() {
//    // a change of direction is only warranted when the current pos is actually different from the current initial
//    if let lclInitialCell = current_Start_Cell {
//
////            if delete_Cursor_CurrentData.dataCell_X_Number < lclInitialCell.dataCell_X_Number {
////                //newCell : same y val, newCell: different x val, current direction: horizontal = no change to currentStartCell
////                //newCell : different y val, newCell: same x val, current direction: horizontal = start cell = current and direction changed to vert
////
////
////                if current_Direction == .stationary{
////                    current_Direction = .horizontal
////                }
////                else if current_Direction == .vertical{
////                    //current_Start_Cell = delete_Cursor_CurrentData.......you want this to be the previous
////                    current_Direction = .horizontal
////                }
////
////            }
////            else if delete_Cursor_CurrentData.dataCell_X_Number > lclInitialCell.dataCell_X_Number {
////
////                if current_Direction == .stationary{
////                    current_Direction = .horizontal
////                }
////                else if current_Direction == .vertical{
////                    //current_Start_Cell = delete_Cursor_CurrentData
////                    current_Direction = .horizontal
////                }
////
////            }
//
////            if delete_Cursor_CurrentData.dataCell_Y_Number < lclInitialCell.dataCell_Y_Number {
////                if current_Direction == .stationary {
////                    current_Direction = .vertical
////                }
////                else if current_Direction == .horizontal{
////                    //current_Start_Cell = delete_Cursor_CurrentData
////                    current_Direction = .vertical
////                }
////            }
////            else if delete_Cursor_CurrentData.dataCell_Y_Number > lclInitialCell.dataCell_Y_Number {
////                if current_Direction == .stationary {
////                    current_Direction = .vertical
////                }
////                else if current_Direction == .horizontal{
////                    //current_Start_Cell = delete_Cursor_CurrentData
////                    current_Direction = .vertical
////                }
////            }
//
//    }
//
//}
