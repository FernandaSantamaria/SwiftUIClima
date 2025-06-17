//
//  OutfitViewModel.swift
//  proyectoFinal2
//
//  Created by ISSC_412_2024 on 16/06/25.
//

import Foundation
import SwiftUI

@MainActor
class OutfitViewModel: ObservableObject {
    @Published var outfitRecommendation: OutfitRecommendation?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedGender: Gender = .mujer
    
    private let service = WeatherService()
    
    enum Gender: String, CaseIterable {
        case mujer = "mujer"
        case hombre = "hombre"
    }
    
    func loadOutfitRecommendation(for city: String) async {
        isLoading = true
        errorMessage = nil

        do {
            let genderParam = selectedGender.rawValue
            let weatherData = try await service.getWeatherData(for: city, gender: genderParam)
        
            self.outfitRecommendation = OutfitRecommendation(
                ubicacion: city,
                temperatura: weatherData.temperaturaDouble,
                condicion: weatherData.condicion,
                recomendacion: weatherData.outfit,
                error: false
            )
        } catch {
            errorMessage = "Error al cargar recomendación: \(error.localizedDescription)"
            print("Outfit error: \(error)")
        }
        isLoading = false
    }
}
