//
//  InputDownloader.swift
//  
//
//  Created by Matt Dailey on 8/15/23.
//

import Foundation

struct Input {
    let data: Data
    
    var asString: String {
        String(decoding: data, as: UTF8.self)
    }
    
    var asLines: [String] {
        asString.components(separatedBy: .newlines).filter { !$0.isEmpty }
    }
    
    private let baseURL = "https://adventofcode.com/"
    private let cookie = "_ga=GA1.2.1302195566.1692136656; _gid=GA1.2.124999209.1692136656; _gat=1; session=53616c7465645f5faa53cec1e59b7a5f2e1ab4326253e8df3d3d49edba7cd4c6904533aed047ddaeeb0c8d42968334875d12d6ba85eb4b91decae9004512a5d5; _ga_MHSNPJKWC7=GS1.2.1692136656.1.1.1692136670.0.0.0"
    
    init(day: Int, year: Int) async throws {
        let urlString: String = baseURL + String(year) + "/day/" + String(day) + "/input"
        guard let url = URL(string: urlString) else {
            throw InputError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(cookie, forHTTPHeaderField: "Cookie")
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        self.data = data
    }
}
