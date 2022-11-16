//
//  File.swift
//  
//
//  Created by Jon on 16/11/2022.
//

import Foundation
import SwiftUI

public struct Visual_Grid_View : View {
     
    public var grid_Store : Visual_Grid_Store
    
    public var body: some View {
        return ZStack(alignment: .topLeading){
            ForEach(grid_Store.lineArray){ lineStore in
                ForEach(lineStore.visualCellArray){ cellStore in
                    Visual_Cell_View(visual_Cell_Store: cellStore).offset(x:cellStore.xFloat,y:cellStore.yFloat)
                }
            }
        }
    }
}

public struct Visual_Cell_View : View {
    
    @ObservedObject public var visual_Cell_Store : Visual_Cell_Store
    
    public init(visual_Cell_Store: Visual_Cell_Store) {
        self.visual_Cell_Store = visual_Cell_Store
    }
    
    public var body: some View {
        return ZStack(alignment: .topLeading){
            
            Data_Cell_Display_View<Default_Unassigned_View,Default_Start_View,Default_Mid_View,Default_End_View,Default_Single_View>(
            current_Underlying_Data_Cell: visual_Cell_Store.underlying_Data_Cell
            , unassigned_View: Default_Unassigned_View()
            , start_View: Default_Start_View(current_Underlying_Data_Param: visual_Cell_Store.underlying_Data_Cell)
            , mid_View: Default_Mid_View(current_Underlying_Data_Param: visual_Cell_Store.underlying_Data_Cell)
            , end_View: Default_End_View(current_Underlying_Data_Param: visual_Cell_Store.underlying_Data_Cell)
            , single_View: Default_Single_View(current_Underlying_Data_Param: visual_Cell_Store.underlying_Data_Cell))

        }
    }
}
