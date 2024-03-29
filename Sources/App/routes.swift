import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    app.post("api", "acronyms") { req -> EventLoopFuture<Acronym> in
      // 2
      let acronym = try req.content.decode(Acronym.self)
      // 3
      return acronym.save(on: req.db).map { // .save returns EventLoopFuture<Void> so we use map to return an Acronym
        // 4
        acronym
      }
    }
    /*
    
     {
         "long": "OH MY GOD",
         "id": "9404926D-6831-4416-AD95-15AB12E7131A",
         "short": "OMG"
     }
     
     // When you run and send JSON as a request then auto response comes back as Acronym Conforms to Content(Codable), and this ID has value as this acronym has been saved to DB.
     
    */
    
    // 1
    app.get("api", "acronyms") {
      req -> EventLoopFuture<[Acronym]> in
      // 2
      Acronym.query(on: req.db).all()
    }
    
    app.get("api", "acronyms", ":acronymID") {
      req -> EventLoopFuture<Acronym> in
      // 2
      Acronym.find(req.parameters.get("acronymID"), on: req.db)
        // 3
        .unwrap(or: Abort(.notFound))
    }
    
    // 1
    app.put("api", "acronyms", ":acronymID") {
      req -> EventLoopFuture<Acronym> in
      // 2
      let updatedAcronym = try req.content.decode(Acronym.self)
      return Acronym.find(
        req.parameters.get("acronymID"),
        on: req.db)
        .unwrap(or: Abort(.notFound)).flatMap { acronym in
          acronym.short = updatedAcronym.short
          acronym.long = updatedAcronym.long
          return acronym.save(on: req.db).map {
            acronym
          }
      }
    }
    
    // 1
    app.delete("api", "acronyms", ":acronymID") {
      req -> EventLoopFuture<HTTPStatus> in
      // 2
      Acronym.find(req.parameters.get("acronymID"), on: req.db)
        .unwrap(or: Abort(.notFound))
        // 3
        .flatMap { acronym in
          // 4
          acronym.delete(on: req.db)
            // 5
            .transform(to: .noContent)
      }
    }
    
    // 1
    app.get("api", "acronyms", "search") {
      req -> EventLoopFuture<[Acronym]> in
      // 2
      guard let searchTerm =
        req.query[String.self, at: "term"] else {
        throw Abort(.badRequest)
      }
      // 3
//      return Acronym.query(on: req.db)
//        .filter(\.$short == searchTerm)
//        .all()
        
        return Acronym.query(on: req.db).group(.or) { or in
          // 2
          or.filter(\.$short == searchTerm)
          // 3
          or.filter(\.$long == searchTerm)
        // 4
        }.all()
    }
    
    // 1
    app.get("api", "acronyms", "first") {
      req -> EventLoopFuture<Acronym> in
      // 2
      Acronym.query(on: req.db)
        .first()
        .unwrap(or: Abort(.notFound))
    }
    
    // You can also apply .first() to any query, such as the result of a filter.
    
    // 1
    app.get("api", "acronyms", "sorted") {
      req -> EventLoopFuture<[Acronym]> in
      // 2
      Acronym.query(on: req.db)
            .sort(\.$short, .descending)
        .all()
    }
}
