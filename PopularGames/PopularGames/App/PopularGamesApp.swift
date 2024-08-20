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

let homeUsecase: Interactor<Any, [GameEntity], GetPopularGameRepository<GetHomeLocalDataSource,GetPopularGameRemoteDataSource, GameTransformer>> = injection.provideHomeUsecase()

let addFavoriteUseCase: Interactor<Any, Bool, GetAddFavoriteGameRepository<GetHomeLocalDataSource, HomeRealmTransformer>> = injection.provideAddFavoriteUsecase()

@main
struct PopularGamesApp: App {
  let homePresenter = HomePresenter(useCase: homeUsecase, addFavoriteUsecase: addFavoriteUseCase)
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(homePresenter)
    }
  }
}
