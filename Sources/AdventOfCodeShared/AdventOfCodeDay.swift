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
    let urlString: String = baseURL + String(year) + "/day/" + String(day) + "/input"
    
    guard let url = URL(string: urlString) else {
        throw InputError.invalidURL
    }
    
    let cookieFileUrl = Bundle.module.url(forResource: "cookie", withExtension: "json")

    guard 
      let cookieFileUrl = cookieFileUrl,
      let cookieData = try? Data(contentsOf: cookieFileUrl) 
    else {
      throw InputError.missingCookieFile
    }
    
    let cookie = try JSONDecoder().decode(Cookie.self, from: cookieData)
    
    var urlRequest = URLRequest(url: url)
    urlRequest.setValue(cookie.value, forHTTPHeaderField: "Cookie")
    let (data, response) = try await URLSession.shared.data(for: urlRequest)
    
    guard 
      let urlResponse = response as? HTTPURLResponse,
      urlResponse.statusCode == 200
    else {
      throw InputError.invalidStatusCode
    }
    
    return String(decoding: data, as: UTF8.self)
  }
}

fileprivate struct Cookie: Decodable {
  let value: String
}

fileprivate enum InputError: Error {
  case invalidStatusCode
  case invalidURL
  case missingCookieFile
}
