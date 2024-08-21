//
//  GameTransformer.swift
//
//  Created by WDT on 16/08/24.
//

import Foundation
import Core

public struct DetailGameTransformer: Mapper {
  public typealias Response = DetailGameResponse
  public typealias Entity = DetailGameEntity
  public typealias Domain = DetailGameEntity
  
  public init() {}
  
  public func toEntity(response: DetailGameResponse) -> DetailGameEntity {
    let genres = response.genres.map { $0.name }.joined(separator: ",")
    return DetailGameEntity(
      id: response.id,
      title: response.name,
      genres: genres,
      rating: response.rating,
      description: response.descriptionRaw,
      backgroundImage: response.backgroundImage,
      releasedDate: response.released,
      isFavorite: false
    )
  }
  
  public func toDomain(entity: DetailGameEntity) -> DetailGameEntity {
    return entity
  }
}

