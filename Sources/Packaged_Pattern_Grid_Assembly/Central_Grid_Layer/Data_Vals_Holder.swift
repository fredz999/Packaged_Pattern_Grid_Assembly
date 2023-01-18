//
//  File.swift
//  
//
//  Created by Jon on 27/12/2022.
//

import Foundation
import SwiftUI

public class Data_Vals_Holder : ObservableObject {
    let dimensions = ComponentDimensions.StaticDimensions
    let colors = ComponentColors.StaticColors
    @Published public var referenced_dataCell_X_Number : Int
    @Published public var referenced_dataCell_Y_Number : Int
    @Published public var sub_Cell_Width : CGFloat
    @Published public var sub_Cell_Height : CGFloat
    @Published public var cell_X_Offset : CGFloat = 0
    
    
    // these boyos will become private ======================
    private var referenced_in_Highlighted_Set : Bool = false
    
    private var referenced_in_Viable_Set_Right : Bool = false
    
    private var referenced_in_Viable_Set_Left : Bool = false
    
    private var referenced_in_Prohibited_Set : Bool = false
    
    private var referenced_in_Potential_Set : Bool = false
    // hmmm maybe do this last ... theres shenanigans with the witdth and so on
    // need to eventually make this private ... wait ..... no I dont ... but ..... I guess I could
    @Published public var referenced_currentStatus : E_CellStatus
    {
        didSet{
            if referenced_currentStatus == .start_Note
                || referenced_currentStatus == .mid_Note
                || referenced_currentStatus == .end_Note {
                if statusColor != colors.grid_Note_Color{statusColor = colors.grid_Note_Color}
                if sub_Cell_Width != dimensions.pattern_Grid_Sub_Cell_Width{sub_Cell_Width = dimensions.pattern_Grid_Sub_Cell_Width}
                if cell_X_Offset != dimensions.pattern_Mid_End_XOffset{cell_X_Offset = dimensions.pattern_Mid_End_XOffset}
            }
            else {
                if statusColor != colors.grid_Blank_Color{statusColor = colors.grid_Blank_Color}
                if referenced_currentStatus == .start_Blank{
                    if sub_Cell_Width != dimensions.pattern_Start_Blank_Width {sub_Cell_Width = dimensions.pattern_Start_Blank_Width}
                    if cell_X_Offset != dimensions.pattern_Start_Blank_XOffset{cell_X_Offset = dimensions.pattern_Start_Blank_XOffset}
                }
                else if referenced_currentStatus != .start_Blank{
                    if sub_Cell_Width != dimensions.pattern_Grid_Sub_Cell_Width {sub_Cell_Width = dimensions.pattern_Grid_Sub_Cell_Width}
                    if cell_X_Offset != dimensions.pattern_Mid_End_XOffset{cell_X_Offset = dimensions.pattern_Mid_End_XOffset}
                }
            }
        }
    }
    
    public func update_Cell_Status(status_Update_TypeParam:status_Update_Type,value:Bool){
        if status_Update_TypeParam == .highlighted {
            if value == true {
                if referenced_in_Highlighted_Set == false{referenced_in_Highlighted_Set=true}
            }
            else if value == false {
                if referenced_in_Highlighted_Set == true{referenced_in_Highlighted_Set=false}
            }
        }
        else if status_Update_TypeParam == .potentialSet {
            if value == true {
                if referenced_in_Potential_Set == false{referenced_in_Potential_Set=true}
            }
            else if value == false {
                if referenced_in_Potential_Set == true{referenced_in_Potential_Set=false}
            }
        }
        else if status_Update_TypeParam == .prohibitedSet {
            if value == true {
                if referenced_in_Prohibited_Set == false{referenced_in_Prohibited_Set=true}
            }
            else if value == false {
                if referenced_in_Prohibited_Set == true{referenced_in_Prohibited_Set=false}
            }
        }
        else if status_Update_TypeParam == .viableSetLeft {
            if value == true {
                if referenced_in_Viable_Set_Left == false{referenced_in_Viable_Set_Left=true}
            }
            else if value == false {
                if referenced_in_Viable_Set_Left == true{referenced_in_Viable_Set_Left=false}
            }
        }
        else if status_Update_TypeParam == .viableSetRight {
            if value == true {
                if referenced_in_Viable_Set_Right == false{referenced_in_Viable_Set_Right=true}
            }
            else if value == false {
                if referenced_in_Viable_Set_Right == true{referenced_in_Viable_Set_Right=false}
            }
        }
    }
    
    
    // /these boyos will become private =====================
    // this will have to be called AFTER there hasbeen an assignment to status ... so all the referenced potentials should get set
    // to private and I will write an accessor function with an enum type and a val to set them, then the visual update can get called via
    // the same line of logic
    func update_Cell_Visual_Status(){
        if check_Cell_Blank() == false {
            check_Highlighted() // terminal
        }
        else if check_Cell_Blank() == true {
            if check_In_Viable_Set() == true {
                if check_In_Potential_Set() == true{
                    check_In_Prohib_Set()
                }
            }
        }
    }
    
    // remember the functions internal workings set the color - the functions return var determines whether the eval proceeds
    func check_Cell_Blank()->Bool{
        var retval = true
        if referenced_currentStatus == .start_Blank
            || referenced_currentStatus == .mid_Blank
            || referenced_currentStatus == .end_Blank {
            if statusColor != colors.grid_Blank_Color{statusColor = colors.grid_Blank_Color}
        }
        else if referenced_currentStatus == .start_Note
            || referenced_currentStatus == .mid_Note
            || referenced_currentStatus == .end_Note {
            retval = false
            if statusColor != colors.grid_Note_Color{statusColor = colors.grid_Note_Color}
        }
        return retval
    }
    
    func check_Highlighted(){
        if referenced_in_Highlighted_Set == true {
            if statusColor != colors.grid_Note_Highlighted_Color{statusColor = colors.grid_Note_Highlighted_Color}
        }
    }
    
    //terminal func
    func check_In_Prohib_Set() {
        //if referenced_in_Prohibited_Set
        if referenced_in_Prohibited_Set == true {
            if statusColor != colors.prohibited_Cell_Color{statusColor = colors.prohibited_Cell_Color}
        }
    }
    
    func check_In_Potential_Set() -> Bool {
        var retVal = false
        if referenced_in_Potential_Set == true{
            retVal = true
            if statusColor != colors.potentialColor{statusColor = colors.potentialColor}
        }
        return retVal
    }
    
    func check_In_Viable_Set()->Bool{
        var retVal = false
        if referenced_in_Viable_Set_Left == true || referenced_in_Viable_Set_Right == true {
            if referenced_in_Viable_Set_Left == true {
                if statusColor != colors.viable_Set_Left_Color{statusColor = colors.viable_Set_Left_Color}
            }
            else if referenced_in_Viable_Set_Right == true {
                if statusColor != colors.viable_Set_Right_Color{statusColor = colors.viable_Set_Right_Color}
            }
            retVal = true
        }
        return retVal
    }

//    if referenced_in_Highlighted_Set == true{}
//    // in note
//    if referenced_currentStatus == .start_Note || referenced_currentStatus == .mid_Note || referenced_currentStatus == .end_Note{}
//    if referenced_in_Prohibited_Set == true{}
//    if referenced_in_Potential_Set == true{}
//    if referenced_in_Viable_Set_Left || referenced_in_Viable_Set_Right == true {}
//    if referenced_currentStatus == .start_Blank || referenced_currentStatus == .mid_Blank || referenced_currentStatus == .end_Blank{}
    
    
    
    
//    func updateTempVisualStatus(){
//
//
//        if referenced_in_Highlighted_Set == true{}
//        // in note
//        if referenced_currentStatus == .start_Note || referenced_currentStatus == .mid_Note || referenced_currentStatus == .end_Note{}
//
//        if referenced_in_Prohibited_Set == true{}
//        if referenced_in_Potential_Set == true{}
//        if referenced_in_Viable_Set_Left || referenced_in_Viable_Set_Right == true {}
//        if referenced_currentStatus == .start_Blank || referenced_currentStatus == .mid_Blank || referenced_currentStatus == .end_Blank{}
//        // in note takes precedent over viable
//
//
//
//
//        // what do I do here?......
//        // the thing thats coming to mind are the old school truth tables.....tho im not sure how this will work .....
//
//
//
//
//
//
//
//
////        if referenced_in_Highlighted_Set == true {
////            statusColor = colors.grid_Note_Highlighted_Color
////        }
////        else if referenced_in_Viable_Set_Right == true {
////            statusColor = colors.viable_Set_Right_Color
////        }
////        else if referenced_in_Viable_Set_Left == true {
////            statusColor = colors.viable_Set_Left_Color
////        }
////        else if referenced_in_Prohibited_Set == true {
////            statusColor = colors.prohibited_Cell_Color
////        }
////        else if referenced_in_Potential_Set == true {
////            statusColor = colors.potentialColor
////        }
////        else {
////            if referenced_currentStatus == .start_Note
////                || referenced_currentStatus == .mid_Note
////                || referenced_currentStatus == .end_Note {
////                if statusColor != colors.grid_Note_Color{statusColor = colors.grid_Note_Color}
////            }
////            else if referenced_currentStatus == .start_Blank
////                || referenced_currentStatus == .mid_Blank
////                || referenced_currentStatus == .end_Blank{
////                if statusColor != colors.grid_Note_Color{statusColor = colors.grid_Blank_Color}
////            }
////        }
//
//
//
//
//    }
    
 
    
    
   @Published public var statusColor : Color

   public var referenced_note_Im_In : Note?
   
   public init(xNumParam:Int,yNumParam:Int,typeParam:E_CellStatus,cellWidthParam:CGFloat,cellHeightParam:CGFloat,xOffsetParam:CGFloat){
   cell_X_Offset = xOffsetParam
   sub_Cell_Width = cellWidthParam
   sub_Cell_Height = cellHeightParam
   referenced_dataCell_X_Number = xNumParam
   referenced_dataCell_Y_Number = yNumParam
   referenced_currentStatus = typeParam
   statusColor = colors.grid_Blank_Color
   }

    
    func updateValsFromNewData(newXNum:Int,newYNum:Int,newCellStatus:E_CellStatus,newNoteImIn:Note?,isHighlightedParan:Bool){
    if referenced_dataCell_X_Number != newXNum{referenced_dataCell_X_Number = newXNum}
    if referenced_dataCell_Y_Number != newYNum{referenced_dataCell_Y_Number = newYNum}
    if referenced_in_Highlighted_Set != isHighlightedParan{referenced_in_Highlighted_Set = isHighlightedParan}
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

public enum status_Update_Type {
    case highlighted
    case viableSetRight
    case viableSetLeft
    case prohibitedSet
    case potentialSet
}

//private var referenced_in_Highlighted_Set : Bool = false
//
//private var referenced_in_Viable_Set_Right : Bool = false
//
//private var referenced_in_Viable_Set_Left : Bool = false
//
//private var referenced_in_Prohibited_Set : Bool = false
//
//private var referenced_in_Potential_Set : Bool = false
//// hmmm maybe do this last ... theres shenanigans with the witdth and so on
//@Published private var referenced_currentStatus : E_CellStatus


//func updateTempVisualStatus(){
//    if referenced_isHighlighted == true{
//        statusColor = colors.grid_Note_Highlighted_Color
//    }
//    else if referenced_in_Viable_Set_Right == true {
//        statusColor = colors.viable_Set_Right_Color
//    }
//    else if referenced_in_Viable_Set_Left == true {
//        statusColor = colors.viable_Set_Left_Color
//    }
//    else if referenced_is_Prohibited_Set == true{
//        statusColor = colors.prohibited_Cell_Color
//    }
//    else if referenced_in_Potential_Set == true{
//        statusColor = colors.potentialColor
//    }
//    else {
//        if referenced_currentStatus == .start_Note
//            || referenced_currentStatus == .mid_Note
//            || referenced_currentStatus == .end_Note {
//            if statusColor != colors.grid_Note_Color{statusColor = colors.grid_Note_Color}
//        }
//        else if referenced_currentStatus == .start_Blank
//            || referenced_currentStatus == .mid_Blank
//            || referenced_currentStatus == .end_Blank{
//            if statusColor != colors.grid_Note_Color{statusColor = colors.grid_Blank_Color}
//        }
//    }
//}
