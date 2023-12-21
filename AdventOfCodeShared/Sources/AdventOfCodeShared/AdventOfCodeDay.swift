//
//  AdventOfCodeDay.swift
//
//
//  Created by Matt Dailey on 11/30/23.
//

import Foundation

public protocol AdventOfCodeDay {
  func part1(_ input: String) throws -> CustomStringConvertible
  func part2(_ input: String) throws -> CustomStringConvertible
}

public extension AdventOfCodeDay {
  func inputFor(day: Int, year: Int) async throws -> String {
    let baseURL = "https://adventofcode.com/"
    let cookie = ""
    let urlString: String = baseURL + String(year) + "/day/" + String(day) + "/input"
    
    guard let url = URL(string: urlString) else {
        throw InputError.invalidURL
    }
    
    var urlRequest = URLRequest(url: url)
    urlRequest.setValue(cookie, forHTTPHeaderField: "Cookie")
    let (data, _) = try await URLSession.shared.data(for: urlRequest)
    return String(decoding: data, as: UTF8.self)
  }
}

fileprivate enum InputError: Error {
  case invalidURL
}
