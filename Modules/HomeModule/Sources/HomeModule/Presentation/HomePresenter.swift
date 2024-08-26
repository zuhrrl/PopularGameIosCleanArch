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

public class HomePresenter<
  Request,
  Response,
  GetFavoriteUseCase: UseCase,
  AddFavoriteUseCase: UseCase,
  DeleteFavoriteUseCase: UseCase
>: Presenter, ObservableObject where GetFavoriteUseCase.Request == Request, GetFavoriteUseCase.Response == [Response] {
    
  public typealias DetailRequest = Request
  public typealias DeleteFavoriteRequest = Any
  public typealias AddFavoriteRequest = GameEntityRealm
  public typealias Detail = Any
  
  @Published public var list: [Response] = []
  @Published public var errorMessage: String = ""
  @Published public var isLoading: Bool = false
  @Published public var isError: Bool = false
  @Published public var selectedGame: Int? = nil
    
  private var cancellables = Set<AnyCancellable>()
  private let getFavoriteUseCase: GetFavoriteUseCase
  private let addFavoriteUseCase: AddFavoriteUseCase
  private let deleteFavoriteUseCase: DeleteFavoriteUseCase
  

  public init(
    getFavoriteUseCase: GetFavoriteUseCase,
    addFavoriteUseCase: AddFavoriteUseCase,
    deleteFavoriteUseCase: DeleteFavoriteUseCase
  ) {
    self.getFavoriteUseCase = getFavoriteUseCase
    self.addFavoriteUseCase = addFavoriteUseCase
    self.deleteFavoriteUseCase = deleteFavoriteUseCase
  }
  
  public func getList(request: Request?) {
    isLoading = true
    getFavoriteUseCase.execute(request: request)
      .receive(on: RunLoop.main)
      .sink(
        receiveCompletion: { [weak self] completion in
          guard let self = self else { return }
          if case .failure(let error) = completion {
            self.errorMessage = error.localizedDescription
            self.isError = true
          }
          self.isLoading = false
        },
        receiveValue: { [weak self] list in
          self?.list = list
        }
      ).store(in: &cancellables)
  }
  public func getDetail(request: DetailRequest?) -> Detail {
    return [] // This method seems incomplete. Ensure proper implementation.
  }
  
  public func deleteFavorite(request: DeleteFavoriteRequest?) {
    guard let request = request as? DeleteFavoriteUseCase.Request else {
      debugPrint("Invalid delete request")
      return
    }
    
    deleteFavoriteUseCase.execute(request: request)
      .receive(on: RunLoop.main)
      .sink(
        receiveCompletion: { [weak self] completion in
          guard let self = self else { return }
          if case .failure(let error) = completion {
            self.errorMessage = error.localizedDescription
            self.isError = true
          }
          self.isLoading = false
        },
        receiveValue: { _ in }
      ).store(in: &cancellables)
  }
  
  public func addToFavorite(request: AddFavoriteRequest?) {
    guard let request = request,
          let index = list.firstIndex(where: { ($0 as? GameEntity)?.id == request.id }),
          var foundItem = list[index] as? GameEntity else {
      debugPrint("Game not found or invalid request")
      return
    }
    
    foundItem.isFavorite.toggle()
    list[index] = foundItem as! Response
    
    if foundItem.isFavorite {
      addFavoriteUseCase.execute(request: request as! AddFavoriteUseCase.Request)
        .receive(on: RunLoop.main)
        .sink(
          receiveCompletion: { [weak self] completion in
            guard let self = self else { return }
            if case .failure(let error) = completion {
              self.errorMessage = error.localizedDescription
              self.isError = true
            }
            self.isLoading = false
          },
          receiveValue: { _ in }
        ).store(in: &cancellables)
    } else {
      deleteFavorite(request: request)
    }
  }
  
}
