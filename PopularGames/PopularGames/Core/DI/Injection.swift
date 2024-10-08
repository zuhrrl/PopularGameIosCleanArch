//
//  Injection.swift
//  PopularGames
//
//  Created by WDT on 07/08/24.
//

import Foundation
import RealmSwift
import Core
import HomeModule
import DetailGameModule
import FavoriteGameModule

final class Injection: NSObject {
  
  private let realm = try? Realm()
  
  func provideHomeUsecase<U: UseCase>() -> U where U.Request == Any, U.Response == [GameEntity] {
    let locale = GetHomeLocalDataSource(realm: realm!)
    let remote = GetPopularGameRemoteDataSource(endpoint: "https://rawg-mirror.vercel.app/api/games")
    let mapper = GameTransformer()
    
    let repository = GetPopularGameRepository(
      
      remoteDataSource: remote,
      localDataSource: locale,
      mapper: mapper)
    
    return Interactor(repository: repository) as! U
  }
  
  func provideDetailUsecase<U: UseCase>() -> U where U.Request == Any, U.Response == DetailGameEntity {
    let locale = GetDetailGameLocalDataSource(realm: realm!)
    let remote = GetDetailGameRemoteDataSource(endpoint: "https://rawg-mirror.vercel.app/api/games")
    let mapper = DetailGameTransformer()
    
    let repository = GetDetailGameRepository(
      remoteDataSource: remote,
      localDataSource: locale,
      mapper: mapper)
    
    return Interactor(repository: repository) as! U
  }
  
  func provideAddFavoriteUsecase<U: UseCase>() -> U where U.Request == Any, U.Response == Bool {
    let locale = GetHomeLocalDataSource(realm: realm!)
    let mapper = HomeRealmTransformer()
    
    let repository = GetAddFavoriteGameRepository(localDataSource: locale, mapper: mapper)
    return Interactor(repository: repository) as! U
  }
  
  func provideDeleteFavoriteUsecase<U: UseCase>() -> U where U.Request == Any, U.Response == Bool {
    let locale = GetHomeLocalDataSource(realm: realm!)
    let mapper = HomeRealmTransformer()
    
    let repository = GetDeleteFavoriteGameRepository(localDataSource: locale, mapper: mapper)
    return Interactor(repository: repository) as! U
  }

  func provideDeleteFavoriteUsecaseDetail<U: UseCase>() -> U where U.Request == Any, U.Response == Bool {
    let locale = GetDetailGameLocalDataSource(realm: realm!)
    let mapper = DetailRealmTransformer()
    
    let repository = GetDeleteFavoriteGameRepository(localDataSource: locale, mapper: mapper)
    return Interactor(repository: repository) as! U
  }
  
  func provideAddFavoriteDetailUsecase<U: UseCase>() -> U where U.Request == Any, U.Response == Bool {
    let locale = GetDetailGameLocalDataSource(realm: realm!)
    let mapper = DetailRealmTransformer()
    
    let repository = GetAddFavoriteDetailModuleRepository(localDataSource: locale, mapper: mapper)
    return Interactor(repository: repository) as! U
  }

  
  func provideFavoriteGameUsecase<U: UseCase>() -> U where U.Request == Any, U.Response == [FavoriteGameEntity] {
    let locale = GetFavoriteGameLocalDataSource(realm: realm!)
    let mapper = FavoriteRealmTransformer()
    
    let repository = GetListFavoriteGameRepository(localDataSource: locale, mapper: mapper)
    return Interactor(repository: repository) as! U
  }
  
  func provideFavoriteDeleteFavoriteUsecase<U: UseCase>() -> U where U.Request == Any, U.Response == Bool {
    let locale = GetFavoriteGameLocalDataSource(realm: realm!)
    let mapper = FavoriteDeleteRealmTransformer()
    
    let repository = GetDeleteFavoriteFavoriteModuleRepository(localDataSource: locale, mapper: mapper)
    return Interactor(repository: repository) as! U
  }


}
