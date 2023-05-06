import Foundation

public struct BoardGameSearch {
    public private(set) var text = "Hello, World!"

    public init() {
    }
}

public struct GameDetails: Codable {
    let id: String
    let name: String
    let names: [String]
    let year_published: Int
    let min_players: Int
    let max_players: Int
    let min_playtime: Int
    let max_playtime: Int
    let min_age: Int
    let description: String
    let description_preview: String
    let thumb_url: String
    let image_url: String
    let url: String
    let price: Float
    let msrp: Float
    let discount: Float
    let primary_publisher: [String]
//    let mechanics: String
//    let categories: String
    let designers: [String]
    let developers: [String]
    let artists: [String]
    let reddit_all_time_count: Int
    let reddit_week_count: Int
    let reddit_day_count: Int
}

public class Search {
    var url: URL? //https://api.boardgameatlas.com/api/search?ids=TAAifFP590&client_id=JLBr5npPhV

    public func search() {
        url = URL(string:"https://api.boardgameatlas.com/api/search?")
        let query = URLQueryItem(name: "name", value: "Monopoly")
        let clientID = URLQueryItem(name: "client_id", value: "GEFPATEZMn")
        if #available(iOS 16.0, *) {
            url?.append(queryItems: [query, clientID])
        } else {
            // Fallback on earlier versions
            fatalError()
        }
        if let url = url {
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    let gameDetails: [GameDetails] = try! JSONDecoder().decode([GameDetails].self, from: data)
                    print(gameDetails)
                }

                if let response = response {
                    print("RESPONSE \(response.description)")
                }

                if let error = error {
                    print("ERROR \(error.localizedDescription)")
                }
            }
            .resume()

        }



    }
}
