//
//  File.swift
//  
//
//  Created by Jon on 19/11/2022.
//

import Foundation
import SwiftUI

struct Note_Write_Layer : View {
    var note_Write_Layer_Store : Note_Write_Layer_Store<Note_Write_Button_View>
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

class Note_Write_Layer_Store<InjectableNoteWriteButtonView:View>:ObservableObject{
    var centralState = Central_State.Static_Central_State
    var injectableButtonView : InjectableNoteWriteButtonView?
    init(injectableBtnParam:InjectableNoteWriteButtonView){
        injectableButtonView = injectableBtnParam
    }
    func pressUpReactor(){
        centralState.writingIsOn.toggle()
    }
    @ViewBuilder func currView()->(some View){
        injectableButtonView
    }
}

struct Note_Write_Button_View : View {
    let colors = ComponentColors.StaticColors
    var body: some View {
        return ZStack {
            Rectangle().frame(width: 90,height: 30).foregroundColor(colors.writeButtonColor)
            Text("write").foregroundColor(colors.writeButtonFontColor)
        }
    }
}
