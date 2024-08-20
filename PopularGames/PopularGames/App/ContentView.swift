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
  @EnvironmentObject var homePresenter: HomePresenter<Any, GameEntity, Interactor<Any, [GameEntity], GetPopularGameRepository< GetPopularGameRemoteDataSource, GameTransformer>>>
  
  var body: some View {
    NavigationStack {
      HomeView(presenter: homePresenter)
    }
  }
}
