import Foundation

struct JokeMapper {
    static func mapDTO(_ dto: JokeDTO) -> JokeDAO {
        .init(type: dto.type, setup: dto.setup, punchline: dto.punchline, id: dto.id)
    }

    static func mapDAO(_ dao: JokeDAO) -> Joke {
        .init(type: dao.type, setup: dao.setup, punchline: dao.punchline, id: dao.id)
    }
}
