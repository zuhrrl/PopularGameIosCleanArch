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

public class GetDetailGamePresenter<Request, Response, Interactor: UseCase, DeleteFavoriteUsecase: UseCase, AddFavoriteUsecase: UseCase>: Presenter, ObservableObject where Interactor.Request == Request, Interactor.Response == Response {
  
  public typealias DetailRequest = Request
  public typealias DeleteFavoriteRequest = Any
  public typealias AddFavoriteRequest = Any
  public typealias Detail = Any
  
  private var cancellables: Set<AnyCancellable> = []
  private let _useCase: Interactor
  private let deleteUsecase: DeleteFavoriteUsecase
  private let addfavoriteUsecase: AddFavoriteUsecase

  @Published public var detail: Response?
  @Published public var errorMessage: String = ""
  @Published public var isLoading: Bool = false
  @Published public var isError: Bool = false
  @Published public var selectedGame: Int? = nil
  
  public init(useCase: Interactor, deleteUsecase: DeleteFavoriteUsecase, addfavoriteUsecase: AddFavoriteUsecase) {
    _useCase = useCase
    self.deleteUsecase = deleteUsecase
    self.addfavoriteUsecase = addfavoriteUsecase
  }
  
  public func getList(request: Request?) {
    
  }
  
  public func getDetail(request: DetailRequest?) -> Detail {
    
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
      }, receiveValue: { self.detail = $0
      })
      .store(in: &cancellables)
    return detail
  }
  
  public func deleteFavorite(request: DeleteFavoriteRequest?) {
    self.deleteUsecase.execute(request: request as! DeleteFavoriteUsecase.Request)
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
  
  public func addToFavorite(request: AddFavoriteRequest?) {
    isLoading = true
    var item = self.detail as! DetailGameEntity
    if item.isFavorite {
      debugPrint("TRYING TO DELETE GAME: \(item.id)")
      self.deleteFavorite(request: request)
      item.isFavorite = false
      self.detail = item as! Response
      isLoading = false
      return
    }
    
    self.addfavoriteUsecase.execute(request: request as! AddFavoriteUsecase.Request)
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
    
    item.isFavorite = true
    self.detail = item as! Response
    isLoading = false

  }
  
}
