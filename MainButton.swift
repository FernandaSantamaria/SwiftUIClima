//
//  MainButton.swift
//  proyectoFinal2
//
//  Created by ISSC_412_2024 on 16/06/25.
//

import Foundation
import SwiftUI

struct MainButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .frame(width: 120, height: 120)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(color)
                    .shadow(color: color.opacity(0.5), radius: 10, x: 0, y: 6)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
