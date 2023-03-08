//
//  File.swift
//  
//
//  Created by Jon on 08/03/2023.
//

import Foundation
import SwiftUI
//class Component_Central_Library {
//    var central_State = Central_State()
//    static let Static_Component_Central_Library = Component_Central_Library()
//}
//Central_State()
//ComponentDimensions
//Underlying_Data_Grid
//Note_Collection
public class Init_Tracker{
    
    var centralStateOT = OneTimeInjector(nameEnumParam: .Central_State)
    var componentDimensionsOT = OneTimeInjector(nameEnumParam: .ComponentDimensions)
    var underlying_Data_GridOT = OneTimeInjector(nameEnumParam: .Underlying_Data_Grid)
    var note_CollectionOT = OneTimeInjector(nameEnumParam: .Note_Collection)
    
    public func registerClass(classParam:E_ClassNameEnum){
        if classParam == .Central_State{
            centralStateOT.injectTitle(classNameArray: &classStringArray)
        }
        else if classParam == .ComponentDimensions{
            centralStateOT.injectTitle(classNameArray: &classStringArray)
        }
        else if classParam == .Underlying_Data_Grid{
            centralStateOT.injectTitle(classNameArray: &classStringArray)
        }
        else if classParam == .Note_Collection{
            centralStateOT.injectTitle(classNameArray: &classStringArray)
        }
    }
    
    var classStringArray : [String] = [String]()
    
    public func yieldData(){
        var yieldString = "the classes were: "
        for s in classStringArray{
            yieldString += ", "+s
        }
        print("yieldStr: "+yieldString)
    }
    
    static let Static_Init_Tracker = Init_Tracker()
}

class OneTimeInjector{
    var nameEnum : E_ClassNameEnum
    var hasInjected :Bool = false
    
    init(nameEnumParam :E_ClassNameEnum){
        nameEnum = nameEnumParam
    }
    
    func injectTitle(classNameArray:inout [String]){
        if hasInjected == false{
            classNameArray.append(nameEnum.rawValue)
            hasInjected = true
        }
    }
    
}

public enum E_ClassNameEnum : String{
    case Central_State = "Central_State"
    case ComponentDimensions = "ComponentDimensions"
    case Underlying_Data_Grid = "Underlying_Data_Grid"
    case Note_Collection = "Note_Collection"
}
