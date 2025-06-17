//
//  BackgroundView.swift
//  proyectoFinal2
//
//  Created by ISSC_412_2024 on 21/05/25.
//
import SwiftUI

struct BackgroundView: View {
    var body: some View {
        Image("fondo") 
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
    }
}
