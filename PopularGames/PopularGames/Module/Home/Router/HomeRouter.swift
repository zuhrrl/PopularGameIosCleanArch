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

class HomeRouter {
  func makeDetailGame() -> some View {
      let useCase: Interactor<
        Any,
        DetailGameEntity,
        GetDetailGameRepository<
          GetDetailGameRemoteDataSource, DetailGameTransformer>
      > = Injection.init().provideDetailUsecase()

      let presenter = GetDetailGamePresenter(useCase: useCase)

      return GameDetailView(presenter: presenter)
    }
}
