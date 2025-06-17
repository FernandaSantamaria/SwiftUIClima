//
//  WeatherViewModel.swift
//  proyectoFinal2
//
//  Created by ISSC_412_2024 on 16/06/25.
//

import Foundation
import SwiftUI

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var weatherData: WeatherData?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service = WeatherService()
    
    func loadWeatherData(for city: String = "León") async {
        isLoading = true
        errorMessage = nil
        
        do {
            weatherData = try await service.getWeatherData(for: city)
        } catch {
            errorMessage = "Error al cargar datos del clima: \(error.localizedDescription)"
            print("Weather error: \(error)")
        }
        
        isLoading = false
    }
}
