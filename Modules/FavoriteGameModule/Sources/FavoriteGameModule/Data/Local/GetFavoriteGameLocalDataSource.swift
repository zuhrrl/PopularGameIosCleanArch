//
//  File.swift
//
//
//  Created by WDT on 20/08/24.
//

import Foundation
import Core
import Combine
import RealmSwift

public struct GetFavoriteGameLocalDataSource: LocaleDataSource {
  
  public typealias Request = Any
  
  public typealias Response = GameEntityRealm
  
  private let realm: Realm
  
  public init(realm: Realm) {
    self.realm = realm
  }
  
  public func list(request: Any?) -> AnyPublisher<[GameEntityRealm], Error> {
    return Future<[GameEntityRealm], Error> { completion in
      let favorites: Results<GameEntityRealm> = {
        realm.objects(GameEntityRealm.self)
          .sorted(byKeyPath: "title", ascending: true)
      }()
      if favorites.isEmpty {
        completion(.success([]))
        return
      }
      completion(.success(favorites.toArray(ofType: GameEntityRealm.self)))
    }.eraseToAnyPublisher()
  }
  
  public func add(entity: GameEntityRealm) -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { completion in
      do {
        try self.realm.write {
          self.realm.add(entity, update: .all)
          completion(.success(true))
        }
      } catch {
        completion(.failure(DatabaseError.requestFailed))
      }
      
    }.eraseToAnyPublisher()
  }
  
  public func delete(entity: GameEntityRealm) -> AnyPublisher<Bool, any Error> {
    return Future<Bool, Error> { completion in
      do {
        try realm.write {
          let found = self.realm.objects(GameEntityRealm.self).where {
            $0.id == entity.id
          }.first
          debugPrint("I FOUND OBJECT: \(found)")
          realm.delete(found!)
          completion(.success(true))
        }
      } catch {
        completion(.failure(DatabaseError.requestFailed))
      }
    }.eraseToAnyPublisher()
  }
  
  public func get(id: Int) -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { completion in
      do {
        let found = self.realm.objects(GameEntityRealm.self).where {
          $0.id == id
        }.first
        completion(.success(found != nil ? true : false))
      } catch {
        completion(.failure(DatabaseError.requestFailed))
      }
    }.eraseToAnyPublisher()
  }
  
  public func update(id: Int, entity: GameEntityRealm) -> AnyPublisher<Bool, any Error> {
    fatalError()
  }
}

