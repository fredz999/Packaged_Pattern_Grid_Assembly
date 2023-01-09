//
//  File.swift
//  
//
//  Created by Jon on 27/12/2022.
//

import Foundation
import SwiftUI

public class Data_Vals_Holder : ObservableObject {
    let colors = ComponentColors.StaticColors
   @Published public var referenced_dataCell_X_Number : Int
   @Published public var referenced_dataCell_Y_Number : Int
    @Published public var referenced_isHighlighted : Bool = false{
        didSet{
            if referenced_isHighlighted == true{statusColor = colors.grid_Note_Highlighted_Color}
            else if referenced_isHighlighted == false{
                if referenced_currentStatus == .start_Note
                    || referenced_currentStatus == .mid_Note
                    || referenced_currentStatus == .end_Note {
                    statusColor = colors.grid_Note_Color
                }
                else{
                    statusColor = colors.grid_Blank_Color
                }
            }
        }
    }
   @Published public var referenced_isProhibited : Bool = false
    
    //TODO: Datavals memory
    @Published public var referenced_currentStatus : E_CellStatus {
        didSet{
            if referenced_currentStatus == .start_Note
                || referenced_currentStatus == .mid_Note
                || referenced_currentStatus == .end_Note {
                statusColor = colors.grid_Note_Color
            }
            else{
                statusColor = colors.grid_Blank_Color
            }
        }
    }
   @Published public var statusColor : Color

   public var referenced_note_Im_In : Note?
   
   public init(xNumParam:Int,yNumParam:Int,typeParam:E_CellStatus){
   referenced_dataCell_X_Number = xNumParam
   referenced_dataCell_Y_Number = yNumParam
   referenced_currentStatus = typeParam
   statusColor = colors.grid_Blank_Color
   }

    
    func updateValsFromNewData(newXNum:Int,newYNum:Int,newCellStatus:E_CellStatus,newNoteImIn:Note?,isHighlightedParan:Bool){
    //TODO: border check call(if write is on)

    if referenced_dataCell_X_Number != newXNum{referenced_dataCell_X_Number = newXNum}
    if referenced_dataCell_Y_Number != newYNum{referenced_dataCell_Y_Number = newYNum}
    if referenced_isHighlighted != isHighlightedParan{referenced_isHighlighted = isHighlightedParan}
    if referenced_currentStatus != newCellStatus{referenced_currentStatus = newCellStatus}

    if let lclCurrentNote = referenced_note_Im_In {
        if let lclNewNote = newNoteImIn {
            if lclNewNote != lclCurrentNote {
                referenced_note_Im_In = lclNewNote
            }
        }
        else if newNoteImIn == nil{
            referenced_note_Im_In = nil
        }
    }
    else if referenced_note_Im_In == nil {
        if let lclNewNote = newNoteImIn {
            referenced_note_Im_In = lclNewNote
        }
    }
   }
    
    
    

}
