//
//  File.swift
//  
//
//  Created by Jon on 27/12/2022.
//

import Foundation
import SwiftUI

public class Data_Vals_Holder : ObservableObject {
   @Published public var referenced_dataCell_X_Number : Int
   @Published public var referenced_dataCell_Y_Number : Int
   @Published public var referenced_isHighlighted : Bool = false
   @Published public var referenced_currentStatus : E_CellStatus
   public var referenced_note_Im_In : Note?
   

   public init(xNumParam:Int,yNumParam:Int,typeParam:E_CellStatus){
   referenced_dataCell_X_Number = xNumParam
   referenced_dataCell_Y_Number = yNumParam
   referenced_currentStatus = typeParam
   }
    
    //might link the two here weakly...... starting to wonder if this intermediate class is actually the wrong way to do all this
    
    func link_NewData(underlyingDataCellParam: Underlying_Data_Cell ){
        underlyingDataCellParam.currentConnectedDataVals = self
    }
    
   func updateValsFromNewData(newXNum:Int,newYNum:Int,newHighlightedStatus:Bool,newCellStatus:E_CellStatus,newNoteImIn:Note?){
       
    if referenced_dataCell_X_Number != newXNum{referenced_dataCell_X_Number = newXNum}
    if referenced_dataCell_Y_Number != newYNum{referenced_dataCell_Y_Number = newYNum}
    if referenced_isHighlighted != newHighlightedStatus{
        referenced_isHighlighted = newHighlightedStatus
    }
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
