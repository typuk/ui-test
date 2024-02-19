import Foundation
import SwiftData

@Model
class JokeDAO {
    let type: String
    let setup: String
    let punchline: String
    @Attribute(.unique) let id: Int

    init(type: String, setup: String, punchline: String, id: Int) {
        self.type = type
        self.setup = setup
        self.punchline = punchline
        self.id = id
    }
}
