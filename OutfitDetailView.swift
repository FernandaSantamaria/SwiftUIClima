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
                Image("fondo")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack {
                    if viewModel.isLoading {
                        ProgressView("Generando...")
                            .scaleEffect(1.5)
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else if let outfit = viewModel.outfitRecommendation {
                        ScrollView {
                            VStack(spacing: 20) {
                                Picker("Género", selection: $viewModel.selectedGender) {
                                    ForEach(OutfitViewModel.Gender.allCases, id: \.self) {
                                        Text($0.rawValue.capitalized)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(12)
                                .padding(.horizontal)
                                .onChange(of: viewModel.selectedGender) { _ in
                                    Task {
                                        await viewModel.loadOutfitRecommendation(for: city)
                                    }
                                }

                                WeatherCard(title: "Ubicación", value: outfit.ubicacion, icon: "mappin.and.ellipse", color: .purple)
                                WeatherCard(title: "Temperatura", value: String(format: "%.1f°C", outfit.temperatura), icon: "thermometer", color: .red)
                                WeatherCard(title: "Condición", value: outfit.condicion.capitalized, icon: "cloud.fill", color: .blue)

                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Recomendación:")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text(outfit.recomendacion)
                                        .font(.body)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                            }
                            .padding()
                        }
                    } else if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                    }

                    Spacer()
                }

                // Botón "Salir"
                VStack {
                    HStack {
                        Spacer()
                        if let temp = viewModel.outfitRecommendation?.temperatura {
                            Button(action: {
                                withAnimation {
                                    dismiss()
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .font(.headline.bold())
                                    .foregroundColor(.white)
                                    .padding(12)
                                    .background(
                                        Circle()
                                            .fill(colorForTemperature(temp).opacity(0.85))
                                            .shadow(color: colorForTemperature(temp).opacity(0.6), radius: 8, x: 0, y: 4)
                                    )
                                    .scaleEffect(1.05)
                            }
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .padding(.trailing, 20)
                            .padding(.top, 50)
                        }
                    }
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden(true)
        }
        .task {
            await viewModel.loadOutfitRecommendation(for: city)
        }
    }

    func colorForTemperature(_ temp: Double?) -> Color {
        guard let temp = temp else { return .gray.opacity(0.6) }
        switch temp {
        case ..<10: return .blue
        case 10..<20: return .teal
        case 20..<30: return .orange
        default: return .red
        }
    }
}
