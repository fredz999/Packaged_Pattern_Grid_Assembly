//
//  File.swift
//  
//
//  Created by Jon on 27/12/2022.
//

import Foundation
import SwiftUI

public class Data_Vals_Holder : ObservableObject {

   // these are prolly going to be closure responders
   @Published public var referenced_dataCell_X_Number : Int
   @Published public var referenced_dataCell_Y_Number : Int
   @Published public var referenced_isHighlighted : Bool = false
   @Published public var referenced_currentStatus : E_CellStatus
   {
       didSet {
           if let lclStatusClosureResponder = statusClosureResponder {
               lclStatusClosureResponder(referenced_currentStatus)
           }
       }
   }
    
    public var referenced_note_Im_In : Note?{
        didSet{
            if let lclNoteClosureResponder = noteClosureResponder{
                if referenced_note_Im_In != nil{
                    lclNoteClosureResponder(true)
                }
                else if referenced_note_Im_In == nil{
                    lclNoteClosureResponder(false)
                }
            }
        }
    }
    
   // these might have to completely change , I might try to read data from this class directly
   // in fact I think I should, this is very complex
   public var statusClosureResponder : ((E_CellStatus)->())?
   public var isHighlightedClosureResponder : ((Bool)->())?
   public var noteClosureResponder : ((Bool)->())?
   

   public init(xNumParam:Int,yNumParam:Int,typeParam:E_CellStatus){
   referenced_dataCell_X_Number = xNumParam
   referenced_dataCell_Y_Number = yNumParam
   referenced_currentStatus = typeParam
   }
    
   func updateValsFromNewData(newXNum:Int,newYNum:Int,newHighlightedStatus:Bool,newCellStatus:E_CellStatus,newNoteImIn:Note?){
       
    if referenced_dataCell_X_Number != newXNum{referenced_dataCell_X_Number = newXNum}
    if referenced_dataCell_Y_Number != newYNum{referenced_dataCell_Y_Number = newYNum}
    if referenced_isHighlighted != newHighlightedStatus{
        referenced_isHighlighted = newHighlightedStatus
        if let lclHighlighter = isHighlightedClosureResponder{
            lclHighlighter(newHighlightedStatus)
        }
    }
    if referenced_currentStatus != newCellStatus{referenced_currentStatus = newCellStatus}

    if let lclCurrentNote = referenced_note_Im_In {
        if let lclNewNote = newNoteImIn {
            if lclNewNote != lclCurrentNote {
                referenced_note_Im_In = lclNewNote
                if let lclNoteClosureResponder = noteClosureResponder{
                    lclNoteClosureResponder(true)
                }
            }
        }
        else if newNoteImIn == nil{
            referenced_note_Im_In = nil
            if let lclNoteClosureResponder = noteClosureResponder{
                lclNoteClosureResponder(false)
            }
        }
    }
    else if referenced_note_Im_In == nil {
        if let lclNewNote = newNoteImIn {
            referenced_note_Im_In = lclNewNote
            if let lclNoteClosureResponder = noteClosureResponder{
                lclNoteClosureResponder(true)
            }
        }
    }
       
       
   }

    


}
