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
    let useCase: Interactor<
      Any,
      DetailGameEntity,
      GetDetailGameRepository<
        GetDetailGameLocalDataSource,
        GetDetailGameRemoteDataSource, DetailGameTransformer>
    > = Injection.init().provideDetailUsecase()
    
    let deleteUsecase: Interactor<Any, Bool, GetDeleteFavoriteGameRepository<GetDetailGameLocalDataSource, DetailRealmTransformer>>
    = Injection.init().provideDeleteFavoriteUsecaseDetail()
    
    let presenter = GetDetailGamePresenter(useCase: useCase, deleteUsecase: deleteUsecase)
    
    return GameDetailView(gameId: gameId, presenter: presenter)
  }
  
  func makeFavoriteGameView() -> some View {
    let favoriteGameUsecase: Interactor<Any, [FavoriteGameEntity], GetListFavoriteGameRepository<GetFavoriteGameLocalDataSource, FavoriteRealmTransformer>>
    = Injection.init().provideFavoriteGameUsecase()
    
    let presenter = GetFavoriteGamePresenter(favoriteGameUsecase: favoriteGameUsecase)
    return FavoriteGameView(presenter: presenter)
  }
  
}
