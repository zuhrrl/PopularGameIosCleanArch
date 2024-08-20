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

public class HomePresenter<Request, Response, Interactor: UseCase, AddFavoriteUsecase: UseCase, DeleteFavoriteUsecase: UseCase>: Presenter, ObservableObject where Interactor.Request == Request, Interactor.Response == [Response] {
  
  public typealias DetailRequest = Request
  public typealias DeleteFavoriteRequest = Any
  public typealias AddFavoriteRequest = GameEntityRealm
  public typealias Detail = Any
  
  private var cancellables: Set<AnyCancellable> = []
  private let _useCase: Interactor
  private let addFavoriteUsecase: AddFavoriteUsecase
  private let deleteFavoriteUsecase: DeleteFavoriteUsecase

  
  
  @Published public var list: [Response] = []
  @Published public var errorMessage: String = ""
  @Published public var isLoading: Bool = false
  @Published public var isError: Bool = false
  @Published public var selectedGame: Int? = nil
  
  public init(useCase: Interactor, addFavoriteUsecase: AddFavoriteUsecase, deleteFavoriteUsecase: DeleteFavoriteUsecase) {
    _useCase = useCase
    self.addFavoriteUsecase = addFavoriteUsecase
    self.deleteFavoriteUsecase = deleteFavoriteUsecase
  }

  
  public func getList(request: Request?) {
    isLoading = true
    _useCase.execute(request: request)
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
    return []
  }
  
  public func deleteFavorite(request: DeleteFavoriteRequest?) {
    self.deleteFavoriteUsecase.execute(request: request as! DeleteFavoriteUsecase.Request)
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
  }
  
  /**
   * Halo mas admin saya zuhrul, ini saya mengalami kesulitan tapi ga pengen post di forum saya note aja disni
   * Sebelumnya fiture addToFavorite ini sebelum apply modular tidak panjang seperti dibawah ini
   * Saya harus cast as sebagai GameEntity dulu karena generic Response tidak bisa dapet id contoh Response.id ga bisa kan
   * nah jadi harus saya cast, gimana ya biar ga terlalu panjang gini saya jadi males bikinya, sama terlalu lama puyeng berjam
   * jam cuman buat kaya gini doang
   */
  public func addToFavorite(request: AddFavoriteRequest?) {
    isLoading = true
    let index = self.list.firstIndex(where: {
      let item = $0 as! GameEntity
      return item.id == request?.id})
    debugPrint("FOUND GAME INDEX: \(String(describing: index))")
    
    var foundItem = self.list[index!] as! GameEntity
    if foundItem.isFavorite {
      debugPrint("TRYING TO DELETE GAME: \(foundItem.id)")
      deleteFavorite(request: request)
      var updateList = self.list as! [GameEntity]
      updateList[index!].isFavorite = false
      self.list = updateList as! [Response]
      isLoading = false
      return
    }
    
    
    self.addFavoriteUsecase.execute(request: request as! AddFavoriteUsecase.Request)
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
    
    var updateList = self.list as! [GameEntity]
    updateList[index!].isFavorite = true
    self.list = updateList as! [Response]
    isLoading = false
  }
  
}
