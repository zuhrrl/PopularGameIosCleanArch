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
  RemoteDataSource: DataSource,
  Transformer: Mapper>: Repository
where
RemoteDataSource.Response == DetailGameResponse,
Transformer.Response == DetailGameResponse,
Transformer.Entity == DetailGameEntity,
Transformer.Domain == DetailGameEntity {
  

  public typealias Request = Any
  public typealias Response = DetailGameEntity
  
  private let remoteDataSource: RemoteDataSource
  private let mapper: Transformer
  
  public init(
    remoteDataSource: RemoteDataSource,
    mapper: Transformer) {
      self.remoteDataSource = remoteDataSource
      self.mapper = mapper
    }
  
  public func execute(request: Request?) -> AnyPublisher<DetailGameEntity, any Error> {
    return remoteDataSource.execute(request: nil)
      .map {mapper.toEntity(response: $0)}
      .eraseToAnyPublisher()
  }
  
  
}
