//
//  WeatherAppView.swift
//  proyectoFinal2
//
//  Created by ISSC_412_2024 on 21/05/25.
//
//no se usa este view

import SwiftUI

struct WeatherAppView: View {
    @State private var selectedTab: String = "Clima"
    @State private var searchText: String = "Caracas"
    @State private var recomendacion: RecomendacionResponse?
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            Image("fondo")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // Search bar
                HStack {
                    TextField("Buscar ubicación", text: $searchText)
                        .padding(10)
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(10)

                    Button {
                        fetchRecomendacion(for: searchText)
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .padding(10)
                            .background(Color.white.opacity(0.7))
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)

                // Tabs
                HStack {
                    Button("Clima") {
                        selectedTab = "Clima"
                    }
                    .fontWeight(selectedTab == "Clima" ? .bold : .regular)

                    Button("Outfit") {
                        selectedTab = "Outfit"
                    }
                    .fontWeight(selectedTab == "Outfit" ? .bold : .regular)
                }
                .padding(.top)
                .foregroundColor(.black)

                // Content
                if selectedTab == "Clima" {
                    if let rec = recomendacion {
                        WeatherCardView(recomendacion: rec)
                    } else if let error = errorMessage {
                        Text("Error: \(error)").foregroundColor(.red)
                    } else {
                        Text("Ingresa una ciudad y presiona buscar.")
                            .foregroundColor(.gray)
                    }
                } else {
                    OutfitView()
                }

                Spacer()
            }
        }
        .onAppear {
            fetchRecomendacion(for: searchText)
        }
    }

    func fetchRecomendacion(for city: String) {
        guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://clima-api-vewj.onrender.com/clima/\(encodedCity)") else {
            errorMessage = "Ciudad inválida"
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                self.errorMessage = "Error de red: \(error.localizedDescription)"
                return
            }

            guard let data = data else {
                self.errorMessage = "Sin datos desde el servidor"
                return
            }

            do {
                let decoded = try JSONDecoder().decode(RecomendacionResponse.self, from: data)
                DispatchQueue.main.async {
                    self.recomendacion = decoded
                    self.errorMessage = nil
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Formato inesperado"
                }
            }
        }.resume()
    }
}
