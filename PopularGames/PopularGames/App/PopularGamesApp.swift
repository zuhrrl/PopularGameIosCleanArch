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

let homeUsecase: Interactor<Any, [GameEntity], GetPopularGameRepository<GetPopularGameRemoteDataSource, GameTransformer>> = injection.provideHomeUsecase()

@main
struct PopularGamesApp: App {
  let homePresenter = HomePresenter(useCase: homeUsecase)
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(homePresenter)
    }
  }
}
