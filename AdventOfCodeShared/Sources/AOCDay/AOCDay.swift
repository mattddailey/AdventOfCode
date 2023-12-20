//
//  AOCDay.swift
//
//
//  Created by Matt Dailey on 12/20/23.
//

import Foundation

@attached(member, names: arbitrary)
public macro AOCDay(name: String? = nil) = #externalMacro(module: "AOCDayMacro", type: "AOCDayMacro")
