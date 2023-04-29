//
//  File.swift
//  
//
//  Created by Jon on 29/04/2023.
//

import Foundation

class Note_Movement_SnapShot{
    var note_Low_Index : Int
    var note_High_Index : Int
    var note_Y_Index : Int
    var snapShot_Note_Id_Param : UUID
    init(note_Low_Index: Int, note_High_Index: Int,note_Y_Index_Param:Int,snapshotNoteIdParam:UUID) {
    self.note_Low_Index = note_Low_Index
    self.note_High_Index = note_High_Index
    snapShot_Note_Id_Param = snapshotNoteIdParam
    note_Y_Index = note_Y_Index_Param
    }
}
