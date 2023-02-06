//
//  File.swift
//  
//
//  Created by Jon on 16/11/2022.
//

import Foundation
import SwiftUI

// --
// need to make a factory for Injected_Unassigned, then all the rest of em
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
