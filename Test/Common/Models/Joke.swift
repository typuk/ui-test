import Foundation

struct Joke: Identifiable, Hashable, Equatable {
    let type: String
    let setup: String
    let punchline: String
    let id: Int
}

extension Joke {
    static var mock: Joke {
        .init(type: "Knock-Knock", setup: "Who is there", punchline: "Cow", id: 0)
    }
}
