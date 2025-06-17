//
//  SearchBarView.swift
//  proyectoFinal2
//
//  Created by ISSC_412_2024 on 21/05/25.
//
import SwiftUI

struct SearchBarView: View {
    @State private var searchText = ""
    
    var body: some View {
        HStack {
            TextField("Ubicacion", text: $searchText)
                .padding()
                .background(Color.white.opacity(0.3))
                .cornerRadius(15)
                .overlay(
                    HStack {
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .padding(.trailing, 10)
                            .foregroundColor(.gray)
                    }
                )
                .padding(.horizontal)
        }
    }
}
