//
//  APIServices.swift
//  PlayVideoSwiftUI
//
//  Created by Krunal Mistry on 10/31/22.
//

import Foundation

enum APIError: Error {
    case failToCreatePath
}

protocol APIServiceProtocol {
    func fetchLocalData<T: Codable>(fileName: String, of: T.Type) async throws -> Result<T, Error>?
}

class APIServices: APIServiceProtocol {
    let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchLocalData<T>(fileName: String, of: T.Type) async throws -> Result<T, Error>? where T : Decodable {

        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            NSLog("Path does not exist")
            throw APIError.failToCreatePath
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            let decodedData = try decoder.decode(T.self, from: data)

            return .success(decodedData)
        } catch {
            throw error
        }
    }
}
