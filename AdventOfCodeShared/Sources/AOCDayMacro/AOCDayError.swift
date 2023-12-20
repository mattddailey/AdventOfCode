//
//  AOCDayError.swift
//  
//
//  Created by Matt Dailey on 12/20/23.
//

import Foundation

enum AOCDayError: Error {
  case onlyApplicableToStruct
  case nameIncorrectlyFormatted

  var description: String {
    switch self {
    case .onlyApplicableToStruct:
      return "This macro can only be applied to a struct."
    case .nameIncorrectlyFormatted:
      return "The struct name must be in the form Dec<dd><yyyy>"
    }
  }
}
