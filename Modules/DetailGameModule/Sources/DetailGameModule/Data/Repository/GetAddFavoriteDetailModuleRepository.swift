//
//  File.swift
//  
//
//  Created by WDT on 21/08/24.
//
import Foundation
import Core
import Combine

public struct GetAddFavoriteDetailModuleRepository<
  LocalDataSource: LocaleDataSource,
  Transformer: Mapper>: Repository
where
LocalDataSource.Response == GameEntityRealm,
Transformer.Response == GameEntityRealm,
Transformer.Entity == DetailGameEntity,
Transformer.Domain == DetailGameEntity {
  
  public typealias Request = Any
  public typealias Response = Bool
  
  private let localDataSource: LocalDataSource
  private let mapper: Transformer
  
  public init(
    localDataSource: LocalDataSource,
    mapper: Transformer) {
      self.localDataSource = localDataSource
      self.mapper = mapper
    }
  
  public func execute(request: Request?) -> AnyPublisher<Bool, any Error> {
    return localDataSource.add(entity: request as! LocalDataSource.Response)
      .map {$0}
      .eraseToAnyPublisher()
  }
  
}
