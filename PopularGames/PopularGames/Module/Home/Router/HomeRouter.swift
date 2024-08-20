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
import HomeModule

class HomeRouter {
  func makeDetailGame(gameId: Int) -> some View {
      let useCase: Interactor<
        Any,
        DetailGameEntity,
        GetDetailGameRepository<
          GetDetailGameLocalDataSource,
          GetDetailGameRemoteDataSource, DetailGameTransformer>
      > = Injection.init().provideDetailUsecase()

      let presenter = GetDetailGamePresenter(useCase: useCase)

    return GameDetailView(gameId: gameId, presenter: presenter)
    }
}
