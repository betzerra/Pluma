//
//  Shop.swift
//  
//
//  Created by Ezequiel Becerra on 23/04/2022.
//

import Foundation

/// Dummy struct to test decoding
struct Shop: Decodable {
    let id: Int
    let title: String
    let latitude: Float
    let longitude: Float
    let hasDelivery: Bool
    let createdAt: Date
    let image: ShopImage
}

struct ShopImage: Decodable {
    let url: URL
    let thumbnail: URL
}
