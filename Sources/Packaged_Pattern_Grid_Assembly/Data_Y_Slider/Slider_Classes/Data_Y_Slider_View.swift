//
//  File.swift
//  
//
//  Created by Jon on 18/04/2023.
//

import Foundation
import SwiftUI
import UIKit

public struct Data_Y_Slider_View<T:View>: UIViewRepresentable {

    public var v_Slider_Data : [Int] = []
    
    public var generic_Slider_Coordinator : Data_Y_Slider_Coordinator<T>

    public init(generic_Slider_Coordinator_Param : Data_Y_Slider_Coordinator<T>){
        generic_Slider_Coordinator = generic_Slider_Coordinator_Param
        let vSliderStart : Int = 0
        let vSliderEnd : Int = 128
        for i in vSliderStart..<vSliderEnd {
            v_Slider_Data.append(i)
        }
    }

    public func makeUIView(context: Context) -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = context.coordinator
        collectionView.delegate = context.coordinator
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        context.coordinator.v_Collection_View = collectionView
        Slider_Cell.registerWithCollectionView(collectionView: collectionView)
        return collectionView
    }

    public func updateUIView(_ uiView: UICollectionView, context: Context) {
        //
    }

    public func makeCoordinator() -> Data_Y_Slider_Coordinator<T> {
        return generic_Slider_Coordinator
    }
    
}
//=========================================================================================================
