//
//  File.swift
//  
//
//  Created by Jon on 19/11/2022.
//

import Foundation
import SwiftUI

struct Note_Write_Layer : View {
    @ObservedObject var note_Write_Layer_Store : Note_Write_Layer_Store
    //@ObservedObject var centralState = Central_State.Static_Central_State
    var body: some View {
        return ZStack(alignment: .topLeading){
            Button(action:{
                note_Write_Layer_Store.pressUpReactor()
            }){
                note_Write_Layer_Store.currView()
            }
        }
    }
}

class Note_Write_Layer_Store : ObservableObject {
    
    var centralState = Central_State.Static_Central_State
    
    func pressUpReactor(){
        centralState.writingIsOn.toggle()
    }
    
    @ViewBuilder func currView() -> (some View) {
        if centralState.writingIsOn == true {
            ZStack {
                Rectangle().frame(width:120,height: 30).foregroundColor(Color(red: 0.6, green: 0, blue: 0))
                Text("Turn Write Off").foregroundColor(.white)
            }
        }
        else if centralState.writingIsOn == false {
            ZStack {
                Rectangle().frame(width:120,height: 30).foregroundColor(Color(red: 0, green: 0.6, blue: 0))
                Text("Turn Write On").foregroundColor(.white)
            }
        }
    }
    
}

// Does tthis need central state injected....I think it might.....for now test without
public class Pattern_Edit_Layer<Injected_Delete_Btn_Type:View,Injected_Lengthen_Shorten_Btns_Type:View
,Injected_Move_Left_Right_Btns_Type:View,Injected_Move_Down_Up_Btns_Type:View> : ObservableObject {
    
    var injected_Delete_Button : Injected_Delete_Btn_Type?
    var injected_Lengthen_Shorten_Buttons : Injected_Lengthen_Shorten_Btns_Type?
    var injected_Move_Left_Right_Buttons : Injected_Move_Left_Right_Btns_Type?
    var injected_Move_Down_Up_Buttons : Injected_Move_Down_Up_Btns_Type?
    
    public init(){
        // future central state
    }
    
    public func inject_Delete_Btn_Factory_Method(injected_Delete_Button_Param: @escaping (()->Injected_Delete_Btn_Type)){
        injected_Delete_Button = injected_Delete_Button_Param()
    }
    
    
    public func inject_Lengthen_Shorten_Btns_Factory_Method(injected_Lengthen_Shorten_Buttons_Param: @escaping (()->Injected_Lengthen_Shorten_Btns_Type)){
        injected_Lengthen_Shorten_Buttons = injected_Lengthen_Shorten_Buttons_Param()
    }
    
    
    public func inject_Move_Left_Right_Btns_Factory_Method(injected_Move_Left_Right_Param: @escaping (()->Injected_Move_Left_Right_Btns_Type)){
        injected_Move_Left_Right_Buttons = injected_Move_Left_Right_Param()
    }
    
    
    public func inject_Move_Down_Up_Btns_Factory_Method(injected_Move_Down_Up_Buttons_Param: @escaping (()->Injected_Move_Down_Up_Btns_Type)){
        injected_Move_Down_Up_Buttons = injected_Move_Down_Up_Buttons_Param()
    }
    
    @ViewBuilder public func return_Delete_Button()->some View{
        if let lclDelBtn = injected_Delete_Button{
            lclDelBtn
        }
        else if injected_Delete_Button == nil{
            Default_Delete_Button_View()
        }
    }
    
    @ViewBuilder public func return_Lengthen_Shorten_Buttons()->some View{
        if let lcl_Lengthen_Shorten_Btns = injected_Lengthen_Shorten_Buttons{
            lcl_Lengthen_Shorten_Btns
        }
        else if injected_Lengthen_Shorten_Buttons == nil{
            Default_Lengthen_Shorten_Buttons_View()
        }
    }
    
    @ViewBuilder public func return_Move_Left_Right_Buttons()->some View{
        if let lcl_Move_Left_Right_Btns = injected_Move_Left_Right_Buttons{
            lcl_Move_Left_Right_Btns
        }
        else if injected_Move_Left_Right_Buttons == nil{
            Default_Move_Left_Right_Buttons_View()
        }
    }
    
    @ViewBuilder public func return_Move_Down_Up_Buttons()->some View{
        if let lclMove_Down_Up_Buttons = injected_Move_Down_Up_Buttons{
            lclMove_Down_Up_Buttons
        }
        else if injected_Move_Down_Up_Buttons == nil{
            Default_Move_Down_Up_Buttons_View()
        }
    }
    
    
}

struct Default_Note_Write_Button_View : View {
    @ObservedObject var centralState = Central_State.Static_Central_State
    let colors = ComponentColors.StaticColors
    var body: some View {
        return ZStack {
            if centralState.writingIsOn == true {
                    Rectangle().frame(width:120,height: 30).foregroundColor(Color(red: 0.6, green: 0, blue: 0))
                    Text("Turn Write Off").foregroundColor(.white)
            }
            else if centralState.writingIsOn == false {
    
                    Rectangle().frame(width:120,height: 30).foregroundColor(Color(red: 0, green: 0.6, blue: 0))
                    Text("Turn Write On").foregroundColor(.white)
            }
        }.onTapGesture {
            centralState.writingIsOn.toggle()
        }
    }
}

struct Default_Delete_Button_View : View {
    @ObservedObject var centralState = Central_State.Static_Central_State
    let dimensions = ComponentDimensions.StaticDimensions
    var body: some View {
        return ZStack(alignment: .topLeading){
            if centralState.a_Note_Is_Highlighted == true {
                Button(action:{
                    if let lclNoteCollection = centralState.note_Collection_Ref{
                        lclNoteCollection.deleteNote()
                        centralState.a_Note_Is_Highlighted = false
                    }
                }){
                    ZStack{
                        Rectangle().frame(width: 90,height: 30).foregroundColor(Color(red: 0.6, green: 0, blue: 0))
                        Text("delete").foregroundColor(.white)
                    }
                }
            }
            else if centralState.a_Note_Is_Highlighted == false {
                ZStack{
                    Rectangle().frame(width: 90,height: 30).foregroundColor(Color(red: 0.6, green: 0, blue: 0))
                    Text("delete").foregroundColor(.white)
                }
            }
        }
    }
}

struct Default_Lengthen_Shorten_Buttons_View : View {
    @ObservedObject var centralState = Central_State.Static_Central_State
    var body: some View {
        return ZStack {
            if centralState.a_Note_Is_Highlighted == true {
                HStack{
                    Button(action:{
                        centralState.changeNoteLength(isIncrement: true)
                    }){
                        ZStack{
                            Rectangle().frame(width: 90,height: 30).foregroundColor(Color(red: 0.6, green: 0, blue: 0))
                            Text("+>").foregroundColor(.white)
                        }
                    }
                    Button(action:{
                        centralState.changeNoteLength(isIncrement: false)
                    }){
                        ZStack{
                            Rectangle().frame(width: 90,height: 30).foregroundColor(Color(red: 0.6, green: 0, blue: 0))
                            Text("<-").foregroundColor(.white)
                        }
                    }
                }
            }
            else if centralState.a_Note_Is_Highlighted == false {
                HStack{
                    ZStack{
                        Rectangle().frame(width: 90,height: 30).foregroundColor(Color(red: 0.6, green: 0, blue: 0))
                        Text("+>").foregroundColor(.white)
                    }
                    ZStack{
                        Rectangle().frame(width: 90,height: 30).foregroundColor(Color(red: 0.6, green: 0, blue: 0))
                        Text("<-").foregroundColor(.white)
                    }
                }
            }
        }
    }
}

struct Default_Move_Left_Right_Buttons_View : View {
    @ObservedObject var centralState = Central_State.Static_Central_State
    var body: some View {
        return ZStack {
        if centralState.a_Note_Is_Highlighted == true {
            HStack{
                Button(action:{
                    centralState.changeNotePosition(movementTyoeParam: .rightWard)
                }){
                    ZStack{
                        Rectangle().frame(width: 90,height: 30).foregroundColor(Color(red: 0.6, green: 0, blue: 0))
                        Text("=>").foregroundColor(.white)
                    }
                }
                
                Button(action:{
                    centralState.changeNotePosition(movementTyoeParam: .leftWard)
                }){
                    ZStack{
                        Rectangle().frame(width: 90,height: 30).foregroundColor(Color(red: 0.6, green: 0, blue: 0))
                        Text("<=").foregroundColor(.white)
                    }
                }
            }
        }
        else if centralState.a_Note_Is_Highlighted == false {
            HStack {
                ZStack {
                    Rectangle().frame(width: 90,height: 30).foregroundColor(Color(red: 0.6, green: 0, blue: 0))
                    Text("=>").foregroundColor(.white)
                }
                ZStack {
                    Rectangle().frame(width: 90,height: 30).foregroundColor(Color(red: 0.6, green: 0, blue: 0))
                    Text("<=").foregroundColor(.white)
                }
            }
        }
    }
  }
}

struct Default_Move_Down_Up_Buttons_View : View {
    @ObservedObject var centralState = Central_State.Static_Central_State
    var body: some View {
        return ZStack {
        if centralState.a_Note_Is_Highlighted == true {
            HStack{
                
                Button(action:{
                    centralState.changeNotePosition(movementTyoeParam: .downward)
                }){
                    ZStack{
                        Rectangle().frame(width: 90,height: 30).foregroundColor(Color(red: 0.6, green: 0, blue: 0))
                        Text("▼").foregroundColor(.white)
                    }
                }
                
                Button(action:{
                    centralState.changeNotePosition(movementTyoeParam: .upward)
                }){
                    ZStack{
                        Rectangle().frame(width: 90,height: 30).foregroundColor(Color(red: 0.6, green: 0, blue: 0))
                        Text("▲").foregroundColor(.white)
                    }
                }
                
            }
        }
        else if centralState.a_Note_Is_Highlighted == false {
            HStack{
                ZStack{
                    Rectangle().frame(width: 90,height: 30).foregroundColor(Color(red: 0.6, green: 0, blue: 0))
                    Text("▼").foregroundColor(.white)
                }
                ZStack{
                    Rectangle().frame(width: 90,height: 30).foregroundColor(Color(red: 0.6, green: 0, blue: 0))
                    Text("▲").foregroundColor(.white)
                }
            }
        }
    }
    }
}
