//
//  PopularGamesApp.swift
//  PopularGames
//
//  Created by WDT on 21/07/24.
//

import SwiftUI
import Core
import HomeModule

let injection = Injection()

let getFavoriteUseCase: Interactor<Any, [GameEntity], GetPopularGameRepository<GetHomeLocalDataSource,GetPopularGameRemoteDataSource, GameTransformer>> = injection.provideHomeUsecase()

let addFavoriteUseCase: Interactor<Any, Bool, GetAddFavoriteGameRepository<GetHomeLocalDataSource, HomeRealmTransformer>> = injection.provideAddFavoriteUsecase()

let deleteFavoriteUsecase: Interactor<Any, Bool, GetDeleteFavoriteGameRepository<GetHomeLocalDataSource, HomeRealmTransformer>> = injection.provideDeleteFavoriteUsecase()

@main
struct PopularGamesApp: App {
  let homePresenter = HomePresenter(getFavoriteUseCase: getFavoriteUseCase, addFavoriteUseCase: addFavoriteUseCase, deleteFavoriteUseCase: deleteFavoriteUsecase)
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(homePresenter)
    }
  }
}
