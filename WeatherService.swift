//
//  WeatherService.swift
//  proyectoFinal2
//
//  Created by ISSC_412_2024 on 13/06/25.
//

import Foundation
import Combine


class WeatherService: ObservableObject {
    private let baseURL = "https://5a72-192-141-247-104.ngrok-free.app"
    
    func getWeatherData(for city: String, gender: String = "mujer") async throws -> WeatherData {
        guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/weather-outfit?city=\(encodedCity)&genero=\(gender)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 15
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard httpResponse.statusCode == 200 else {
            throw URLError(.init(rawValue: httpResponse.statusCode))
        }

        return try JSONDecoder().decode(WeatherData.self, from: data)
    }
}
