//
//  File.swift
//  
//
//  Created by WDT on 21/08/24.
//

import Foundation
import Core
import Combine

public struct GetDeleteFavoriteFavoriteModuleRepository<
  DeleteLocalDataSource: LocaleDataSource,
  Transformer: Mapper>: Repository
where
DeleteLocalDataSource.Response == GameEntityRealm,
Transformer.Response == GameEntityRealm,
Transformer.Entity == FavoriteGameEntity,
Transformer.Domain == FavoriteGameEntity {
  
  public typealias Request = Any
  public typealias Response = Bool
  
  private let localDataSource: DeleteLocalDataSource
  private let mapper: Transformer
  
  public init(
    localDataSource: DeleteLocalDataSource,
    mapper: Transformer) {
      self.localDataSource = localDataSource
      self.mapper = mapper
    }
  
  public func execute(request: Request?) -> AnyPublisher<Bool, any Error> {
    return localDataSource.delete(entity: request as! GameEntityRealm)
      .map {$0}
      .eraseToAnyPublisher()
  }
  
}
