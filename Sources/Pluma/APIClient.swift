//
//  APIClient.swift
//  
//
//  Created by Ezequiel Becerra on 23/04/2022.
//

import Foundation

public protocol APIClient {
    func request(method: Pluma.Method, path: String, params: [String: String]?) async throws -> Data
}
