//
//  File.swift
//  
//
//  Created by Jon on 16/11/2022.
//

import Foundation
import SwiftUI

public struct Data_Cell_Display_View<UnassignedView:View,StartView:View,MidView:View,EndView:View,SingleView:View> : View {
    
    @ObservedObject public var current_Underlying_Data_Cell : Underlying_Data_Cell
    
    public var unassigned_View : UnassignedView?
    
    public var start_View : StartView?
    
    public var mid_View : MidView?
    
    public var end_View : EndView?
    
    public var single_View : SingleView?

    public init(current_Underlying_Data_Cell: Underlying_Data_Cell
         , unassigned_View: UnassignedView
         , start_View: StartView
         , mid_View: MidView
         , end_View: EndView
         , single_View: SingleView
    ) {
        self.current_Underlying_Data_Cell = current_Underlying_Data_Cell
        self.unassigned_View = unassigned_View
        self.start_View = start_View
        self.mid_View = mid_View
        self.end_View = end_View
        self.single_View = single_View
    }
    
    @ViewBuilder public func currView()->(some View) {
 
        if current_Underlying_Data_Cell.currentType == .unassigned {
            unassigned_View
        }
        else if current_Underlying_Data_Cell.currentType == .start {
                self.start_View
        }
        else if current_Underlying_Data_Cell.currentType == .mid {
                self.mid_View
        }
        else if current_Underlying_Data_Cell.currentType == .end {
                self.end_View
        }
        else if current_Underlying_Data_Cell.currentType == .single {
                self.single_View
        }
    }
    
    public var body: some View {
        return ZStack(alignment: .topLeading){
            currView()
        }
    }
    
}
