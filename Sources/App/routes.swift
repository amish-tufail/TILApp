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
}
