//
//  File.swift
//  
//
//  Created by WDT on 21/08/24.
//

import Foundation
import Core

public struct FavoriteDeleteRealmTransformer: Mapper {
  public typealias Response = GameEntityRealm
  public typealias Entity = FavoriteGameEntity
  public typealias Domain = FavoriteGameEntity
  
  public init() {}
  
  public func toEntity(response: GameEntityRealm) -> FavoriteGameEntity {
    return FavoriteGameEntity(id: response.id, title: response.title, genres: response.genres, rating: response.rating, description: response.description, backgroundImage: response.backgroundImage, releasedDate: response.releasedDate, isFavorite: false)
  }
  
  public func toDomain(entity: FavoriteGameEntity) -> FavoriteGameEntity {
    return entity
  }
}
