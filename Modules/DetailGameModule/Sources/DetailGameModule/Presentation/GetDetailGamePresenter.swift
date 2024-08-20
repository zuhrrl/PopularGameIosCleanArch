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

public class GetDetailGamePresenter<Request, Response, Interactor: UseCase>: Presenter, ObservableObject where Interactor.Request == Request, Interactor.Response == Response {
  
  public typealias DetailRequest = Request
  public typealias DeleteFavoriteRequest = Any
  public typealias AddFavoriteRequest = Any
  public typealias Detail = Any
  
  private var cancellables: Set<AnyCancellable> = []
  private let _useCase: Interactor
  
  @Published public var detail: Response?
  @Published public var errorMessage: String = ""
  @Published public var isLoading: Bool = false
  @Published public var isError: Bool = false
  @Published public var selectedGame: Int? = nil
  
  public init(useCase: Interactor) {
    _useCase = useCase
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
//    self.deleteFavoriteUsecase.execute(request: request as! DeleteFavoriteUsecase.Request)
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
    isLoading = true
    let item = self.detail as! DetailGameEntity
    if item.isFavorite {
      debugPrint("TRYING TO DELETE GAME: \(item.id)")
      deleteFavorite(request: request)
     
      isLoading = false
      return
    }
  }
  
}
