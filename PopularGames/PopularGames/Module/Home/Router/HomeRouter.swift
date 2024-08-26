//
//  HomeRouter.swift
//  PopularGames
//
//  Created by WDT on 08/08/24.
//

import Foundation
import SwiftUI
import Core
import DetailGameModule
import FavoriteGameModule

class HomeRouter {
  func makeDetailGame(gameId: Int) -> some View {
    let getUseCase: Interactor<
      Any,
      DetailGameEntity,
      GetDetailGameRepository<
        GetDetailGameLocalDataSource,
        GetDetailGameRemoteDataSource, DetailGameTransformer>
    > = Injection.init().provideDetailUsecase()
    
    let deleteUseCase: Interactor<
      Any,
      Bool,
      GetDeleteFavoriteGameRepository<GetDetailGameLocalDataSource, DetailRealmTransformer>
    > = Injection.init().provideDeleteFavoriteUsecaseDetail()
    
    let addUseCase: Interactor<
      Any,
      Bool,
      GetAddFavoriteDetailModuleRepository<GetDetailGameLocalDataSource, DetailRealmTransformer>
    > = Injection.init().provideAddFavoriteDetailUsecase()
    
    let presenter = GetDetailGamePresenter(
      getDetailFavoriteUseCase: getUseCase,
      deleteFavoriteUseCase: deleteUseCase,
      addFavoriteUseCase: addUseCase
    )
    
    return GameDetailView(gameId: gameId, presenter: presenter)
  }
  
  func makeFavoriteGameView() -> some View {
    let favoriteGameUsecase: Interactor<
      Any, [FavoriteGameEntity],
      GetListFavoriteGameRepository<GetFavoriteGameLocalDataSource, FavoriteRealmTransformer>
    > = Injection.init().provideFavoriteGameUsecase()
    
    let deleteUsecase: Interactor<
      Any, Bool,
      GetDeleteFavoriteFavoriteModuleRepository<GetFavoriteGameLocalDataSource, FavoriteDeleteRealmTransformer>
    > = Injection.init().provideFavoriteDeleteFavoriteUsecase()
    
    let presenter = GetFavoriteGamePresenter(favoriteGameUsecase: favoriteGameUsecase, deleteUsecase: deleteUsecase)
    return FavoriteGameView(presenter: presenter)
  }
  
}
