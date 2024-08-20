//
//  File.swift
//
//
//  Created by WDT on 16/08/24.
//

import Foundation
import Core
import Combine

public struct GetPopularGameRepository<
  LocalDataSource: LocaleDataSource,
  RemoteDataSource: DataSource,
  Transformer: Mapper>: Repository
where

RemoteDataSource.Response == [ItemGame],
Transformer.Response == [ItemGame],
Transformer.Entity == [GameEntity],
Transformer.Domain == [GameEntity] {
  
  
  public typealias Request = Any
  public typealias Response = [GameEntity]
  
  private let remoteDataSource: RemoteDataSource
  private let localDataSource: LocalDataSource
  private let mapper: Transformer
  
  public init(
    remoteDataSource: RemoteDataSource,
    localDataSource: LocalDataSource,
    mapper: Transformer) {
      self.remoteDataSource = remoteDataSource
      self.mapper = mapper
      self.localDataSource = localDataSource
    }
  
  public func execute(request: Request?) -> AnyPublisher<[GameEntity], any Error> {
    return remoteDataSource.execute(request: nil)
      .flatMap { [self] response -> AnyPublisher<[GameEntity], any Error> in
        if response.isEmpty {
          return Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        }
        
        let gameEntitiesPublishers = response.map { item in
          return self.localDataSource.get(id: item.id)
            .map { isFavorite -> GameEntity in
              let genres = item.genres.map { $0.name }.joined(separator: ",")
              return GameEntity(
                id: item.id,
                title: item.name,
                genres: genres,
                rating: item.rating,
                description: item.descriptionRaw,
                backgroundImage: item.backgroundImage,
                releasedDate: item.released,
                isFavorite: isFavorite as! Bool
              )
            }
            .eraseToAnyPublisher()
        }
        return Publishers.MergeMany(gameEntitiesPublishers)
          .collect()
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
  
  
}
