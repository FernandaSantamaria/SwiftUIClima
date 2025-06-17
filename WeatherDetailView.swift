//
//  WeatherDetailView.swift
//  proyectoFinal2
//
//  Created by ISSC_412_2024 on 16/06/25.
//

import Foundation
import SwiftUI
struct WeatherDetailView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @Environment(\.dismiss) private var dismiss
    var city: String

    var body: some View {
        NavigationView {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
                content
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Cerrar") { dismiss() }
                }
            }
            .navigationTitle("Clima")
        }
        .task { await viewModel.loadWeatherData(for: city) }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            ProgressView("Cargando...")
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(1.5)
        } else if let data = viewModel.weatherData {
            ScrollView {
                VStack(spacing: 20) {
                    WeatherCard(title: "Temperatura", value: data.temperatura, icon: "thermometer", color: .red)
                    WeatherCard(title: "Sensación", value: data.sensacion_termica, icon: "thermometer.snowflake", color: .blue)
                    WeatherCard(title: "Humedad", value: data.humedad, icon: "drop.fill", color: .teal)
                    WeatherCard(title: "Viento", value: data.viento, icon: "wind", color: .gray)
                    WeatherCard(title: "UV", value: data.uv, icon: "sun.max.fill", color: .yellow)
                    WeatherCard(title: "Lluvia", value: data.is_lloviendo, icon: data.is_lloviendo == "Sí" ? "cloud.rain.fill" : "sun.max.fill", color: data.is_lloviendo == "Sí" ? .blue : .yellow)
                }
                .padding()
            }
        } else if let error = viewModel.errorMessage {
            Text(error)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}
