//
//  ContentView.swift
//  PopularGames
//
//  Created by WDT on 21/07/24.
//

import SwiftUI
import Core
import HomeModule

struct ContentView: View {
  @EnvironmentObject var homePresenter: HomePresenter<Any, GameEntity, Interactor<Any, [GameEntity], GetPopularGameRepository< GetHomeLocalDataSource, GetPopularGameRemoteDataSource, GameTransformer>>,Interactor<Any, Bool, GetAddFavoriteGameRepository< GetHomeLocalDataSource, HomeRealmTransformer>>,Interactor<Any, Bool, GetDeleteFavoriteGameRepository< GetHomeLocalDataSource, HomeRealmTransformer>>>
  
  var body: some View {
    NavigationStack {
      HomeView(presenter: homePresenter)
    }
  }
}
