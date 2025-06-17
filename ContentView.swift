//
//  ContentView.swift
//  proyectoFinal2
//
//  Created by santamaria on 21/05/25.
//
import SwiftUI

struct ContentView: View {
    @State private var locationText = "León"
    @State private var selectedGender: Gender = .mujer
    @State private var showOutfitDetail = false
    @StateObject private var viewModel = WeatherViewModel()
    

    enum Gender: String, CaseIterable, Identifiable {
        case mujer = "Mujer"
        case hombre = "Hombre"
        
        var id: String { self.rawValue }
        var apiValue: String {
            self == .mujer ? "mujer" : "hombre"
        }
    }

    var body: some View {
        ZStack {
            Image("fondo")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // 🔍 Barra de búsqueda
                HStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Button(action: {
                            Task {
                                await viewModel.loadWeatherData(for: locationText, gender: selectedGender.apiValue)
                            }
                        }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .buttonStyle(PlainButtonStyle())

                        TextField("Buscar ciudad...", text: $locationText)
                            .foregroundColor(.white)
                            .font(.subheadline)
                            .disableAutocorrection(true)
                    }
                    .padding(.horizontal, 12)
                    .frame(height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.white.opacity(0.5), lineWidth: 1.5)
                            )
                    )

                    Button(action: {
                        Task {
                            await viewModel.loadWeatherData(for: locationText, gender: selectedGender.apiValue)
                        }
                    }) {
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .shadow(radius: 1)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 50)

                // Picker de género
                Picker("Género", selection: $selectedGender) {
                    ForEach(Gender.allCases) { gender in
                        Text(gender.rawValue).tag(gender)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 30)

                // Fecha
                Text(Date(), format: .dateTime.day().month().year())
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))

                // Resultados
                if let data = viewModel.weatherData {
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            WeatherInfoCard(title: "Temperatura", value: data.temperatura, icon: "thermometer", color: .red)
                            WeatherInfoCard(title: "Sensación", value: data.sensacion_termica, icon: "thermometer.snowflake", color: .blue)
                        }
                        HStack(spacing: 16) {
                            WeatherInfoCard(title: "Humedad", value: data.humedad, icon: "drop.fill", color: .teal)
                            WeatherInfoCard(title: "UV", value: data.uv, icon: "sun.max.fill", color: .yellow)
                        }
                        HStack(spacing: 16) {
                            WeatherInfoCard(title: "Lluvia", value: data.is_lloviendo, icon: data.is_lloviendo == "Sí" ? "cloud.rain.fill" : "sun.max.fill", color: data.is_lloviendo == "Sí" ? .blue : .yellow)
                            WeatherInfoCard(title: "Viento", value: data.viento, icon: "wind", color: .gray)
                        }
                        WeatherInfoCard(title: "Hora local", value: data.hora_local, icon: "clock.fill", color: .orange)

                        // Outfit
                        VStack(alignment: .leading, spacing: 10) {
                            Text("👕 Recomendación de outfit")
                                .font(.headline)
                                .foregroundColor(.white)

                            Text(data.outfit)
                                .font(.body)
                                .foregroundColor(.white.opacity(0.9))
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 30)
                    }
                    .padding(.horizontal, 30)
                    .transition(.opacity.combined(with: .slide))
                } else if viewModel.isLoading {
                    ProgressView("Cargando clima...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                        .padding(.top, 20)
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }

                Spacer()

                // Botón para ver detalle completo
                HStack {
                    Spacer()
                    Button(action: {
                        showOutfitDetail = true
                    }) {
                        Image(systemName: "tshirt.fill")
                            .font(.title2)
                            .padding(12)
                            .background(.ultraThinMaterial)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding(.trailing, 30)
                    .padding(.bottom, 10)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.loadWeatherData(for: locationText, gender: selectedGender.apiValue)
            }
        }
        .sheet(isPresented: $showOutfitDetail) {
            OutfitDetailView(city: locationText)
        }
    }
}
struct WeatherInfoCard: View {
    var title: String
    var value: String
    var icon: String
    var color: Color

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            Text(value)
                .font(.headline)
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.3))
                .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
        )
    }
}
