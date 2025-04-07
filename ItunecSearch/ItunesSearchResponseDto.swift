//
//  ItunesResponseDto.swift
//  ItunecSearch
//
//  Created by IVAN on 21.02.2025.
//

import Foundation

struct ItunesSearchResponseDto: Codable {
    let resultCount: Int
    let results: [ItunesSearchResponseResultDto]
}

struct ItunesSearchResponseResultDto: Codable {
    let collectionName: String
}
