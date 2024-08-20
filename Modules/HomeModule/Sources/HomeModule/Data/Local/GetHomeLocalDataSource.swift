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

public struct GetHomeLocalDataSource: LocaleDataSource {

  public typealias Request = Any

  public typealias Response = HomeGameEntityRealm

  private let realm: Realm

  public init(realm: Realm) {
    self.realm = realm
  }

  public func list(request: Any?) -> AnyPublisher<[HomeGameEntityRealm], Error> {
    return Future<[HomeGameEntityRealm], Error> { completion in
      let categories: Results<HomeGameEntityRealm> = {
        self.realm.objects(HomeGameEntityRealm.self)
          .sorted(byKeyPath: "title", ascending: true)
      }()
      completion(.success(categories.toArray(ofType: HomeGameEntityRealm.self)))

    }.eraseToAnyPublisher()
  }

  public func add(entities: [HomeGameEntityRealm]) -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { completion in
      do {
        try self.realm.write {
          for item in entities {
            self.realm.add(item, update: .all)
          }
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
        let found = self.realm.objects(HomeGameEntityRealm.self).where {
          $0.id == id
        }.first
        completion(.success(found != nil ? true : false))
      } catch {
        completion(.failure(DatabaseError.requestFailed))
      }
    }.eraseToAnyPublisher()
  }

  public func update(id: Int, entity: HomeGameEntityRealm) -> AnyPublisher<Bool, any Error> {
    fatalError()
  }
}
