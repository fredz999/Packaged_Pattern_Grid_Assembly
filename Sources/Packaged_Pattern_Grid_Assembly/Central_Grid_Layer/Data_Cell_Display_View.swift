//
//  File.swift
//  
//
//  Created by Jon on 16/11/2022.
//

import Foundation
import SwiftUI

public struct Data_Cell_Display_View<UnassignedView:View,StartView:View,MidView:View,EndView:View,SingleView:View> : View {
    
    //@ObservedObject public var current_Underlying_Data_Cell : Underlying_Data_Cell
    @ObservedObject public var current_Data_Vals_Holder : Data_Vals_Holder
    
    public var unassigned_View : UnassignedView?
    
    public var start_View : StartView?
    
    public var mid_View : MidView?
    
    public var end_View : EndView?
    
    public var single_View : SingleView?

    public init(current_Data_Vals_Holder: Data_Vals_Holder
         , unassigned_View: UnassignedView
         , start_View: StartView
         , mid_View: MidView
         , end_View: EndView
         , single_View: SingleView
    ) {
        self.current_Data_Vals_Holder = current_Data_Vals_Holder
        self.unassigned_View = unassigned_View
        self.start_View = start_View
        self.mid_View = mid_View
        self.end_View = end_View
        self.single_View = single_View
    }
    
    @ViewBuilder public func currView()->(some View) {
 
//        if current_Data_Vals_Holder.referenced_currentStatus == .unassigned {
//            unassigned_View
//        }
        if current_Data_Vals_Holder.referenced_currentStatus == .start {
                self.start_View
        }
        else if current_Data_Vals_Holder.referenced_currentStatus == .mid {
                self.mid_View
        }
        else if current_Data_Vals_Holder.referenced_currentStatus == .end {
                self.end_View
        }
//        else if current_Data_Vals_Holder.referenced_currentStatus == .single {
//                self.single_View
//        }
    }
    
    public var body: some View {
        return ZStack(alignment: .topLeading){
            currView()
        }
    }
    
}
