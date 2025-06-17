//
//  OutfitView.swift
//  proyectoFinal2
//
//  Created by ISSC_412_2024 on 21/05/25.
//
import SwiftUI
struct OutfitDetailView: View {
    @StateObject private var viewModel = OutfitViewModel()
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
            .navigationTitle("Outfit")
        }
        .task { await viewModel.loadOutfitRecommendation(for: city) }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            ProgressView("Generando...")
                .scaleEffect(1.5)
        } else if let outfit = viewModel.outfitRecommendation {
            ScrollView {
                VStack(spacing: 20) {
                    Picker("Género", selection: $viewModel.selectedGender) {
                        ForEach(OutfitViewModel.Gender.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()

                    WeatherCard(title: "Ubicación", value: outfit.ubicacion, icon: "mappin.and.ellipse", color: .purple)
                    WeatherCard(title: "Temperatura", value: String(format: "%.1f°C", outfit.temperatura), icon: "thermometer", color: .red)
                    WeatherCard(title: "Condición", value: outfit.condicion.capitalized, icon: "cloud.fill", color: .blue)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recomendación:")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text(outfit.recomendacion)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    .shadow(radius: 4)
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
