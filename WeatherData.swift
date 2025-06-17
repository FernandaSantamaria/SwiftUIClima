//
//  WeatherData.swift
//  proyectoFinal2
//
//  Created by ISSC_412_2024 on 13/06/25.
//
 
import SwiftUI


struct WeatherData: Codable {
    let outfit: String
    let temperatura: String
    let sensacion_termica: String
    let humedad: String
    let viento: String
    let uv: String
    let hora_local: String
    let is_lloviendo: String
}
