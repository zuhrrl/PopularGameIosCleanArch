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

public class GetFavoriteGamePresenter<Request, Response, Interactor: UseCase, DeleteFavoriteGameUsecase: UseCase>: Presenter, ObservableObject where Interactor.Request == Request, Interactor.Response == Response {
  
  
  public typealias DetailRequest = Request
  public typealias DeleteFavoriteRequest = GameEntityRealm
  public typealias AddFavoriteRequest = Any
  public typealias Detail = Any
  
  private var cancellables: Set<AnyCancellable> = []
  private let favoriteGameUsecase: Interactor
  private let deleteFavoriteGameUsecase: DeleteFavoriteGameUsecase
  
  @Published public var list: Response?
  @Published public var errorMessage: String = ""
  @Published public var isLoading: Bool = false
  @Published public var isError: Bool = false
  @Published public var selectedGame: Int? = nil
  
  public init(favoriteGameUsecase: Interactor, deleteUsecase: DeleteFavoriteGameUsecase) {
    self.favoriteGameUsecase = favoriteGameUsecase
    self.deleteFavoriteGameUsecase = deleteUsecase
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
    isLoading = true
    let items = self.list as! [FavoriteGameEntity]
    let index = items.firstIndex(where: {
      let item = $0 as! FavoriteGameEntity
      return item.id == request?.id})
    debugPrint("FOUND GAME INDEX: \(String(describing: index))")
    
    var foundItem = items[index!] as! FavoriteGameEntity
    if foundItem.isFavorite {
      debugPrint("TRYING TO DELETE GAME: \(foundItem.id)")
      
      self.deleteFavoriteGameUsecase.execute(request: request as! DeleteFavoriteGameUsecase.Request)
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
        }, receiveValue: { _ in })
        .store(in: &cancellables)
      
      var updateList = self.list as! [FavoriteGameEntity]
      updateList.remove(at: index!)
      self.list = updateList as! Response
      isLoading = false
      return
    }
    
    
  }
  
  public func addToFavorite(request: AddFavoriteRequest?) {
    fatalError("")
  }
}
