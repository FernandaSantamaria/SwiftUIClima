//
//  RecomendacionResponse.swift
//  proyectoFinal2
//
//  Created by ISSC_412_2024 on 13/06/25.
//

import Foundation
import SwiftUI

struct OutfitRecommendation: Codable {
    let ubicacion: String
    let temperatura: Double
    let condicion: String
    let recomendacion: String
    let error: Bool
}
