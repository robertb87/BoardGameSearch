//
//  File.swift
//  
//
//  Created by Robert Bradish on 14/05/2023.
//

import Foundation

public struct SearchResults: Decodable {
    public let games: [GameDetails]
    public let count: Int
}
