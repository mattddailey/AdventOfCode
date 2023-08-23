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
    private let cookie = ""
    
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
