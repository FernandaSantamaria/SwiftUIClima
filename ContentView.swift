//
//  ContentView.swift
//  proyectoFinal2
//
//  Created by santamaria on 21/05/25.
//
import SwiftUI

struct ContentView: View {
    @State private var locationText = "León"
    @State private var showOutfitDetail = false
    @StateObject private var viewModel = WeatherViewModel()

    var body: some View {
        ZStack {
            Image("fondo")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 20) {
                VStack(spacing: 12) {
                    HStack {
                        TextField("Buscar ciudad...", text: $locationText)
                            .padding(.vertical, 8)
                            .padding(.horizontal)
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                        Button(action: {
                            Task {
                                await viewModel.loadWeatherData(for: locationText)
                            }
                        }) {
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    Text(Date(), format: .dateTime.day().month().year())
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(.horizontal, 30)
                .padding(.top, 50)

                if let data = viewModel.weatherData {
                    VStack(spacing: 15) {
                        HStack(spacing: 15) {
                            WeatherInfoCard(title: "Temperatura", value: data.temperatura, icon: "thermometer", color: .red)
                            WeatherInfoCard(title: "Sensación", value: data.sensacion_termica, icon: "thermometer.snowflake", color: .blue)
                        }
                        HStack(spacing: 15) {
                            WeatherInfoCard(title: "Humedad", value: data.humedad, icon: "drop.fill", color: .teal)
                            WeatherInfoCard(title: "UV", value: data.uv, icon: "sun.max.fill", color: .yellow)
                        }
                        HStack(spacing: 15) {
                            WeatherInfoCard(title: "Lluvia", value: data.is_lloviendo, icon: data.is_lloviendo == "Sí" ? "cloud.rain.fill" : "sun.max.fill", color: data.is_lloviendo == "Sí" ? .blue : .yellow)
                            WeatherInfoCard(title: "Viento", value: data.viento, icon: "wind", color: .gray)
                        }
                        WeatherInfoCard(title: "Hora local", value: data.hora_local, icon: "clock.fill", color: .orange)
                    }
                    .padding(.horizontal, 30)
                } else if viewModel.isLoading {
                    ProgressView("Cargando clima...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }

                Spacer()

                HStack {
                    Spacer()
                    Button(action: {
                        showOutfitDetail = true
                    }) {
                        Image(systemName: "tshirt.fill")
                            .font(.title3)
                            .padding(10)
                            .background(Color.orange.opacity(0.3))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 30)
                    .padding(.top, -10)
                }

                HStack {
                      
                }
                .padding(.horizontal, 50)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            Task {
                await viewModel.loadWeatherData(for: locationText)
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
        VStack(spacing: 8) {
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
        .background(Color.black.opacity(0.3))
        .cornerRadius(15)
    }
}
