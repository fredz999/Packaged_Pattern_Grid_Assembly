//
//  File.swift
//  
//
//  Created by Jon on 16/11/2022.
//

import Foundation
import SwiftUI

// --

public struct Default_Unassigned_View : View {
    public init(){}
    public var body: some View {
        return ZStack(alignment: .topLeading){
            Rectangle().frame(width: 30,height: 30).foregroundColor(Color(red: 0.6, green: 0, blue: 0))
            Rectangle().frame(width: 30,height: 1).foregroundColor(Color(red: 0.8, green: 0, blue: 0))
            Rectangle().frame(width: 1,height: 30).foregroundColor(Color(red: 0.8, green: 0, blue: 0))
        }
    }
}

public struct Default_Start_View : View {
    public init(current_Underlying_Data_Param:Underlying_Data_Cell){
        current_Underlying_Data_Cell = current_Underlying_Data_Param
    }
    @ObservedObject public var current_Underlying_Data_Cell : Underlying_Data_Cell
    public var body: some View {
        return ZStack(alignment: .topLeading){
            if current_Underlying_Data_Cell.isHighlighted == true{
                Rectangle().frame(width: 30,height: 30).foregroundColor(Color(red: 0.3, green: 0.6, blue: 0))
                Rectangle().frame(width: 30,height: 1).foregroundColor(Color(red: 0.5, green: 1, blue: 0))
                Rectangle().frame(width: 1,height: 30).foregroundColor(Color(red: 0.5, green: 1, blue: 0))
            }
            if current_Underlying_Data_Cell.isHighlighted == false{
                Rectangle().frame(width: 30,height: 30).foregroundColor(Color(red: 1, green: 1, blue: 1))
                Rectangle().frame(width: 30,height: 1).foregroundColor(Color(red: 0.5, green: 1, blue: 0))
                Rectangle().frame(width: 1,height: 30).foregroundColor(Color(red: 0.5, green: 1, blue: 0))
            }
        }
    }
}

public struct Default_Mid_View : View {
    public init(current_Underlying_Data_Param:Underlying_Data_Cell){
        current_Underlying_Data_Cell = current_Underlying_Data_Param
    }
    @ObservedObject public var current_Underlying_Data_Cell : Underlying_Data_Cell
    public var body: some View {
        return ZStack(alignment: .topLeading){
            if current_Underlying_Data_Cell.isHighlighted == true{
                Rectangle().frame(width: 30,height: 30).foregroundColor(Color(red: 0.3, green: 0.6, blue: 0))
                Rectangle().frame(width: 30,height: 1).foregroundColor(Color(red: 0.5, green: 1, blue: 0))
                Rectangle().frame(width: 1,height: 30).foregroundColor(Color(red: 0.5, green: 1, blue: 0))
            }
            else if current_Underlying_Data_Cell.isHighlighted == false{
                Rectangle().frame(width: 30,height: 30).foregroundColor(Color(red: 0, green: 0.6, blue: 0))
                Rectangle().frame(width: 30,height: 1).foregroundColor(Color(red: 0, green: 0.8, blue: 0))
                Rectangle().frame(width: 1,height: 30).foregroundColor(Color(red: 0, green: 0.8, blue: 0))
            }
        }
    }
}

public struct Default_End_View : View {
    public init(current_Underlying_Data_Param:Underlying_Data_Cell){
        current_Underlying_Data_Cell = current_Underlying_Data_Param
    }
    @ObservedObject public var current_Underlying_Data_Cell : Underlying_Data_Cell
    public var body: some View {
        return ZStack(alignment: .topLeading){
            if current_Underlying_Data_Cell.isHighlighted == true{
                Rectangle().frame(width: 30,height: 30).foregroundColor(Color(red: 0.3, green: 0.6, blue: 0))
                Rectangle().frame(width: 30,height: 1).foregroundColor(Color(red: 0.5, green: 1, blue: 0))
                Rectangle().frame(width: 1,height: 30).foregroundColor(Color(red: 0.5, green: 1, blue: 0))
            }
            else if current_Underlying_Data_Cell.isHighlighted == false{
                Rectangle().frame(width: 30,height: 30).foregroundColor(Color(red: 0, green: 0, blue: 0.6))
                Rectangle().frame(width: 30,height: 1).foregroundColor(Color(red: 0, green: 0, blue: 0.8))
                Rectangle().frame(width: 1,height: 30).foregroundColor(Color(red: 0, green: 0, blue: 0.8))
            }
        }
    }
}

public struct Default_Single_View : View {
    public init(current_Underlying_Data_Param:Underlying_Data_Cell){
        current_Underlying_Data_Cell = current_Underlying_Data_Param
    }
    @ObservedObject public var current_Underlying_Data_Cell : Underlying_Data_Cell
    public var body: some View {
        return ZStack(alignment: .topLeading){
            if current_Underlying_Data_Cell.isHighlighted == true{
                Rectangle().frame(width: 30,height: 30).foregroundColor(Color(red: 0.3, green: 0.6, blue: 0))
                Rectangle().frame(width: 30,height: 1).foregroundColor(Color(red: 0.5, green: 1, blue: 0))
                Rectangle().frame(width: 1,height: 30).foregroundColor(Color(red: 0.5, green: 1, blue: 0))
            }
            else if current_Underlying_Data_Cell.isHighlighted == false{
                Rectangle().frame(width: 30,height: 30).foregroundColor(Color(red: 0.6, green: 0, blue: 0.6))
                Rectangle().frame(width: 30,height: 1).foregroundColor(Color(red: 0.8, green: 0, blue: 0.8))
                Rectangle().frame(width: 1,height: 30).foregroundColor(Color(red: 0.8, green: 0, blue: 0.8))
            }
        }
    }
}
