//
//  Acronym.swift
//  
//
//  Created by Amish Tufail on 01/03/2024.
//

import Vapor
import Fluent

// 1
final class Acronym: Model {
  // 2
  static let schema = "acronyms" // Name of table in the database
  
  // 3
  @ID
  var id: UUID? // It must be called id, and must use UUID
  
  // 4
  @Field(key: "short") // Specifies a column in the DB, use @OptionalField if property is optional else use @Field
  var short: String
  
  @Field(key: "long")
  var long: String
  
  // 5
  init() {} // This is required
  
  // 6
  init(id: UUID? = nil, short: String, long: String) {
    self.id = id
    self.short = short
    self.long = long
  }
}

extension Acronym: Content {}
