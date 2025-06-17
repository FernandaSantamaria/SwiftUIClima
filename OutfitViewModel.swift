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
        case mujer = "Mujer"
        case hombre = "Hombre"
    }
    
    func loadOutfitRecommendation(for city: String = "León") async {
        isLoading = true
        errorMessage = nil
        
        do {
            let genderParam = selectedGender == .mujer ? "mujer" : "hombre"
            outfitRecommendation = try await service.getOutfitRecommendation(for: city, gender: genderParam)
        } catch {
            errorMessage = "Error al cargar recomendación: \(error.localizedDescription)"
            print("Outfit error: \(error)")
        }
        
        isLoading = false
    }
}

