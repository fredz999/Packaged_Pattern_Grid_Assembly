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
