//
//  File.swift
//  
//
//  Created by WDT on 20/08/24.
//

import Foundation
import Core
import Combine

public struct GetAddFavoriteGameRepository<
  HomeLocalDataSource: LocaleDataSource,
  Transformer: Mapper>: Repository
where
GetHomeLocalDataSource.Response == HomeGameEntityRealm,
Transformer.Response == HomeGameEntityRealm,
Transformer.Entity == GameEntity,
Transformer.Domain == GameEntity {
  
  public typealias Request = Any
  public typealias Response = Bool
  
  private let localDataSource: HomeLocalDataSource
  private let mapper: Transformer
  
  public init(
    localDataSource: HomeLocalDataSource,
    mapper: Transformer) {
      self.localDataSource = localDataSource
      self.mapper = mapper
    }
  
  public func execute(request: Request?) -> AnyPublisher<Bool, any Error> {
    return localDataSource.add(entities: request as! [HomeLocalDataSource.Response])
      .map {$0}
      .eraseToAnyPublisher()
  }
  
  
}
