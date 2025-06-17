//
//  WeatherService.swift
//  proyectoFinal2
//
//  Created by ISSC_412_2024 on 13/06/25.
//

import Foundation
import Combine

class WeatherService: ObservableObject {
    private let baseURL = "https://clima-api-vewj.onrender.com"
    
    func getWeatherData(for city: String) async throws -> WeatherData {
        guard let url = URL(string: "\(baseURL)/weather-outfit?city=\(city)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 15
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if httpResponse.statusCode != 200 {
            throw URLError(.init(rawValue: httpResponse.statusCode))
        }
        
        return try JSONDecoder().decode(WeatherData.self, from: data)
    }
    
    func getOutfitRecommendation(for city: String, gender: String = "mujer") async throws -> OutfitRecommendation {
        guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/clima/recomendar?ubicacion=\(encodedCity)&genero=\(gender)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 30  // Aumentar timeout para Render
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if httpResponse.statusCode != 200 {
            throw URLError(.init(rawValue: httpResponse.statusCode))
        }
        
        return try JSONDecoder().decode(OutfitRecommendation.self, from: data)
    }
}
