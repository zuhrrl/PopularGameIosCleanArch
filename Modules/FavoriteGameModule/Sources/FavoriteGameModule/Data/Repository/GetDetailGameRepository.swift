//
//  File.swift
//
//
//  Created by WDT on 16/08/24.
//

import Foundation
import Core
import Combine

public struct GetDetailGameRepository<
  LocalDataSource: LocaleDataSource,
  RemoteDataSource: DataSource,
  Transformer: Mapper>: Repository
where
RemoteDataSource.Response == DetailGameResponse,
Transformer.Response == DetailGameResponse,
Transformer.Entity == DetailGameEntity,
Transformer.Domain == DetailGameEntity {
  
  
  public typealias Request = Any
  public typealias Response = DetailGameEntity
  
  private let localDataSource: LocalDataSource
  private let remoteDataSource: RemoteDataSource
  private let mapper: Transformer
  
  public init(
    remoteDataSource: RemoteDataSource,
    localDataSource: LocalDataSource,
    mapper: Transformer) {
      self.localDataSource = localDataSource
      self.remoteDataSource = remoteDataSource
      self.mapper = mapper
    }
  
  public func execute(request: Request?) -> AnyPublisher<DetailGameEntity, any Error> {
    return remoteDataSource.execute(request: request as! RemoteDataSource.Request)
      .flatMap {response in
        return self.localDataSource.get(id: 3498)
          .map { isFavorite -> DetailGameEntity in
            let genres = response.genres.map { $0.name }.joined(separator: ",")
            return DetailGameEntity(
              id: response.id,
              title: response.name,
              genres: genres,
              rating: response.rating,
              description: response.descriptionRaw,
              backgroundImage: response.backgroundImage,
              releasedDate: response.released,
              isFavorite: isFavorite as! Bool
            )
          }
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
  
  
}
