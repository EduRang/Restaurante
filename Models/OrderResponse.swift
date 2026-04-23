//
//  OrderResponse.swift
//  Restaurante
//
//  Created by ALUMNO on 22/04/26.
//

struct OrderResponse: Codable {
    let prepTime: Int
    
    enum CodingKeys: String, CodingKey {
        case prepTime = "preparation_time"
    }
}
