//
//  File.swift
//
//
//  Created by WDT on 19/08/24.
//

import Foundation
import Combine
import Core
import SwiftUI

public class GetFavoriteGamePresenter<Request, Response, Interactor: UseCase>: Presenter, ObservableObject where Interactor.Request == Request, Interactor.Response == Response {
  
  public typealias DetailRequest = Request
  public typealias DeleteFavoriteRequest = Any
  public typealias AddFavoriteRequest = Any
  public typealias Detail = Any
  
  private var cancellables: Set<AnyCancellable> = []
  private let favoriteGameUsecase: Interactor

  @Published public var list: Response?
  @Published public var errorMessage: String = ""
  @Published public var isLoading: Bool = false
  @Published public var isError: Bool = false
  @Published public var selectedGame: Int? = nil
  
  public init(favoriteGameUsecase: Interactor) {
    self.favoriteGameUsecase = favoriteGameUsecase
  }
  
  public func getList(request: Request?) {
    isLoading = true
    self.favoriteGameUsecase.execute(request: request)
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .failure(let error):
          self.errorMessage = error.localizedDescription
          self.isError = true
          self.isLoading = false
        case .finished:
          self.isLoading = false
        }
      }, receiveValue: { list in
        self.list = list
      })
      .store(in: &cancellables)
  }
  
  public func getDetail(request: DetailRequest?) -> Detail {
    fatalError("Unimplemented")
  }
  
  public func deleteFavorite(request: DeleteFavoriteRequest?) {
//    self.deleteUsecase.execute(request: request as! DeleteFavoriteUsecase.Request)
//      .receive(on: RunLoop.main)
//      .sink(receiveCompletion: { completion in
//        switch completion {
//        case .failure(let error):
//          self.errorMessage = error.localizedDescription
//          self.isError = true
//          self.isLoading = false
//        case .finished:
//          self.isLoading = false
//        }
//      }, receiveValue: { _ in })
//      .store(in: &cancellables)
  }
  
  public func addToFavorite(request: AddFavoriteRequest?) {
//    isLoading = true
//    var item = self.detail as! FavoriteGameEntity
//    if item.isFavorite {
//      debugPrint("TRYING TO DELETE GAME: \(item.id)")
//      self.deleteFavorite(request: request)
//      item.isFavorite = false
//      self.detail = item as! Response
//      isLoading = false
//      return
//    }
//    
//    item.isFavorite = true
//    self.detail = item as! Response
//    isLoading = false
  }
}
