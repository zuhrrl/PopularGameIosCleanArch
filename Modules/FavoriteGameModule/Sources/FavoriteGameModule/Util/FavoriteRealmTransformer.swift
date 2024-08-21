//
//  File.swift
//
//
//  Created by WDT on 21/08/24.
//

import Foundation
import Core

public struct FavoriteRealmTransformer: Mapper {
  public typealias Response = [GameEntityRealm]
  public typealias Entity = [FavoriteGameEntity]
  public typealias Domain = [FavoriteGameEntity]
  
  // Initializer
  public init() {}
  
  // Convert API response to internal entity
  public func toEntity(response: [GameEntityRealm]) -> [FavoriteGameEntity] {
    return response.map { item in
      FavoriteGameEntity(id: item.id, title: item.title, genres: item.genres, rating: item.rating, description: item.description, backgroundImage: item.backgroundImage, releasedDate: item.releasedDate, isFavorite: (item.isFavorite != 0))
    }
  }
  
  public func toDomain(entity: [FavoriteGameEntity]) -> [FavoriteGameEntity] {
    return entity
  }
}
