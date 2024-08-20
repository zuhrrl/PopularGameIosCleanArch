//
//  File.swift
//  
//
//  Created by WDT on 21/08/24.
//

import Foundation
import Core

public struct DetailRealmTransformer: Mapper {
  public typealias Response = GameEntityRealm
  public typealias Entity = DetailGameEntity
  public typealias Domain = DetailGameEntity
  
  // Initializer
  public init() {}
  
  // Convert API response to internal entity
  public func toEntity(response: GameEntityRealm) -> DetailGameEntity {
    return DetailGameEntity(id: response.id, title: response.title, genres: "test", rating: response.rating, description: response.description, backgroundImage: response.backgroundImage, releasedDate: response.releasedDate, isFavorite: false)
  }
  
  public func toDomain(entity: DetailGameEntity) -> DetailGameEntity {
    return entity
  }
}
