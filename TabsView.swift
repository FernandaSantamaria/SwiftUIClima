//
//  TabsView.swift
//  proyectoFinal2
//
//  Created by ISSC_412_2024 on 21/05/25.
//

import SwiftUI

enum Tab {
    case clima
    case outfit
}

struct TabsView: View {
    @Binding var selectedTab: Tab

    var body: some View {
        HStack(spacing: 40) {
            Button(action: {
                selectedTab = .clima
            }) {
                Text("Clima")
                    .font(.headline)
                    .foregroundColor(selectedTab == .clima ? .black : .gray)
                    .padding(.bottom, 4)
                    .overlay(
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(selectedTab == .clima ? .black : .clear),
                        alignment: .bottom
                    )
            }

            Button(action: {
                selectedTab = .outfit
            }) {
                Text("Outfit")
                    .font(.headline)
                    .foregroundColor(selectedTab == .outfit ? .black : .gray)
                    .padding(.bottom, 4)
                    .overlay(
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(selectedTab == .outfit ? .black : .clear),
                        alignment: .bottom
                    )
            }
        }
    }
}



