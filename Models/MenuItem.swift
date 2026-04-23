//
//  MenuItem.swift
//  Restaurante
//
//  Created by ALUMNO on 20/04/26.
//

import Foundation

struct MenuItem: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let detailText: String
    let price: Double
    let category: String
    let imageURL: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case detailText = "description"
        case price
        case category
        case imageURL = "image_url"
    }
}
