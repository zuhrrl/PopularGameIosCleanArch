//
//  File.swift
//
//
//  Created by WDT on 16/08/24.
//

import Foundation
import Core
import Combine

public struct GetListFavoriteGameRepository<
  LocalDataSource: LocaleDataSource,
  Transformer: Mapper>: Repository
where
LocalDataSource.Response == GameEntityRealm,
Transformer.Response == [GameEntityRealm],
Transformer.Entity == [FavoriteGameEntity],
Transformer.Domain == [FavoriteGameEntity] {
  
  
  public typealias Request = Any
  public typealias Response = [FavoriteGameEntity]
  
  private let localDataSource: LocalDataSource
  private let mapper: Transformer
  
  public init(
    localDataSource: LocalDataSource,
    mapper: Transformer) {
      self.localDataSource = localDataSource
      self.mapper = mapper
    }
  
  public func execute(request: Request?) -> AnyPublisher<[FavoriteGameEntity], any Error> {
    return self.localDataSource.list(request: nil)
      .flatMap { [self] response -> AnyPublisher<[FavoriteGameEntity], any Error> in
        if response.isEmpty {
          return Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        }
        
        let gameEntitiesPublishers = response.map { item in
          return self.localDataSource.get(id: item.id)
            .map { isFavorite -> FavoriteGameEntity in
              return FavoriteGameEntity(
                id: item.id,
                title: item.title,
                genres: item.genres,
                rating: item.rating,
                description: item.description,
                backgroundImage: item.backgroundImage,
                releasedDate: item.releasedDate,
                isFavorite: isFavorite
              )
            }
            .eraseToAnyPublisher()
        }
        return Publishers.MergeMany(gameEntitiesPublishers)
          .collect()
          .eraseToAnyPublisher()
      }.eraseToAnyPublisher()
  }
  
}
