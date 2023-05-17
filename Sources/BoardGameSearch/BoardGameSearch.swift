import Foundation

public struct GameMechanics: Codable {
    let id: String
}


@available(iOS 13.0.0, *)
public class Search {
    private let _clientID: String
    private var _clientIDQueryItem: URLQueryItem {
        return URLQueryItem(name: "client_id", value: _clientID)
    }
    private var _url: URL

    public init(withClientID clientID: String) {
        guard let url = URL(string: "https://api.boardgameatlas.com/api/search?" ) else { fatalError("Failed to init BoardGame Search, bad URL")}

        self._clientID = clientID
        self._url = url
    }

    public func search(for name: String, onCompletion completion: @escaping ([GameDetails]) -> Void) {
        let query = URLQueryItem(name: "name", value: name)
        let clientID = URLQueryItem(name: "client_id", value: _clientID)

        if #available(iOS 16.0, *) {
            _url.append(queryItems: [query, clientID])
        } else {
            // Fallback on earlier versions
            fatalError()
        }

            let request = URLRequest(url: _url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    let gameDetails: SearchResults = try! JSONDecoder().decode(SearchResults.self, from: data)
                    completion(gameDetails.games)
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


    public func search(withQuery query: SearchQuery) async throws -> [GameDetails] {
        let urlQueryItems = buildURLQueryItems(from: query)
        var url = _url

        if #available(iOS 16.0, *) {
            url.append(queryItems: urlQueryItems)
        } else {
            // Fallback on earlier versions
        }

        let request = URLRequest(url: url)

        do {
            let response: (data: Data, response: URLResponse) = try await URLSession.shared.data(for: request)

            let gameDetails: SearchResults = try! JSONDecoder().decode(SearchResults.self, from: response.data)

            return gameDetails.games
        } catch {
            throw error
        }
    }


    private func buildURLQueryItems(from query: SearchQuery) -> [URLQueryItem] {
        var items: [URLQueryItem] = []

        for item in query.items {
            items.append(URLQueryItem(name: item.queryType.rawValue, value: item.value))
        }

        return items
    }
}

public struct SearchQuery {
    var items: [SearchQueryItem]

    func add(item: SearchQueryItem) -> SearchQuery {
        var newItemsList = items
        newItemsList.append(item)
        return SearchQuery(items: newItemsList)
    }
}
public struct SearchQueryItem {
    let queryType: SearchQueryType
    let value: String
}

public enum SearchQueryType: String {
    case name                       = "name"
    case limit                      = "limit"
    case skip                       = "skip"
    case ids                        = "ids"
    case listID                     = "list_id"
    case kickstarter                = "kickstarter"
    case random                     = "random"
    case exact                      = "exact"
    case fuzzyMatching              = "fuzzy_matching"
    case designer                   = "designer"
    case publisher                  = "publisher"
    case artist                     = "artist"
    case mechanics                  = "mechanics"
    case categories                 = "categories"
    case orderBy                    = "order_by"
    case ascending                  = "ascending"
    case minPlayers                 = "min_players"
    case maxPlayers                 = "max_players"
    case minPlaytime                = "min_playtime"
    case maxPlaytime                = "max_playtime"
    case minAge                     = "min_age"
    case yearPublished              = "year_published"
    case minPlayerGreaterThan       = "gt_min_players"
    case maxPlayersGreaterThan      = "gt_max_players"
    case minPlaytimeGreaterThan     = "gt_min_playtime"
    case maxPlaytimeGreaterThan     = "gt_max_playtime"
    case minAgeGreaterThan          = "gt_min_age"
    case yearPublisedGreaterThan    = "gt_year_published"
    case priceGreaterThan           = "gt_price"
    case msrpGreaterThan            = "gt_msrp"
    case discountGreaterThan        = "gt_discount"
    case minPlayersLessThan         = "lt_min_players"
    case maxPlayersLessThan         = "lt_max_players"
    case playtimeLessThan           = "lt_min_playtime"
    case maxPlaytimeLessThan        = "lt_max_playtime"
    case minAgeLessThan             = "lt_min_age"
    case yearPublishedLessThan      = "lt_year_published"
    case priceLessThan              = "lt_price"
    case msrpLessThan               = "lt_msrp"
    case discountLessThan           = "lt_discount"
    case fields
}
