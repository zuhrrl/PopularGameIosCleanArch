//
//  File.swift
//
//
//  Created by WDT on 20/08/24.
//

import Foundation
import Core

public struct HomeRealmTransformer: Mapper {
 
  
  public typealias Response = GameEntityRealm
  public typealias Entity = GameEntity
  public typealias Domain = GameEntity
  
  // Initializer
  public init() {}
  
  // Convert API response to internal entity
  public func toEntity(response: GameEntityRealm) -> GameEntity {
    return GameEntity(id: response.id, title: response.title, genres: "test", rating: response.rating, description: response.description, backgroundImage: response.backgroundImage, releasedDate: response.releasedDate, isFavorite: false)
  }
  
  public func toDomain(entity: GameEntity) -> GameEntity {
    return entity
  }
}

