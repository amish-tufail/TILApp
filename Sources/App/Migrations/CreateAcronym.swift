//
//  CreateAcronym.swift
//  
//
//  Created by Amish Tufail on 01/03/2024.
//

import Fluent

// Migration Creates the TABLE
// Migration run only once in DB
// 1
struct CreateAcronym: Migration {
  // 2
  func prepare(on database: Database) -> EventLoopFuture<Void> { // Must be used
    // 3
    database.schema("acronyms") // Defines the table name and MUST match with the schema in the model
      // 4
      .id() // ID column in DB
      // 5
      .field("short", .string, .required) // "short", i mean these names should match the @Field's key
      .field("long", .string, .required)
      // 6
      .create() // Create DB
  }
  
  // 7
  func revert(on database: Database) -> EventLoopFuture<Void> { // Must be used
    database.schema("acronyms").delete()
  }
}
