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

public class GetDetailGamePresenter<
  Request,
    Response,
    GetDetailFavoriteUseCase: UseCase,
    DeleteFavoriteUseCase: UseCase,
    AddFavoriteUseCase: UseCase
>: Presenter, ObservableObject where GetDetailFavoriteUseCase.Request == Request, GetDetailFavoriteUseCase.Response == Response {
  
  public typealias DetailRequest = Request
  public typealias DeleteFavoriteRequest = Any
  public typealias AddFavoriteRequest = Any
  public typealias Detail = Any
  
  private var cancellables = Set<AnyCancellable>()
  private let getDetailFavoriteUseCase: GetDetailFavoriteUseCase
  private let addFavoriteUseCase: AddFavoriteUseCase
  private let deleteFavoriteUseCase: DeleteFavoriteUseCase
  
  @Published public var detail: Response?
  @Published public var errorMessage: String = ""
  @Published public var isLoading: Bool = false
  @Published public var isError: Bool = false
  
  public init(
    getDetailFavoriteUseCase: GetDetailFavoriteUseCase,
    deleteFavoriteUseCase: DeleteFavoriteUseCase,
    addFavoriteUseCase: AddFavoriteUseCase
  ) {
    self.getDetailFavoriteUseCase = getDetailFavoriteUseCase
    self.deleteFavoriteUseCase = deleteFavoriteUseCase
    self.addFavoriteUseCase = addFavoriteUseCase
  }
  
  public func getList(request: Request?) {
    
  }
  
  public func getDetail(request: DetailRequest?) -> Detail {
    isLoading = true
    getDetailFavoriteUseCase.execute(request: request)
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { [weak self] completion in
        guard let self = self else { return }
        if case .failure(let error) = completion {
          self.errorMessage = error.localizedDescription
          self.isError = true
        }
        self.isLoading = false
      }, receiveValue: {
        self.detail = $0
      }).store(in: &cancellables)
    return detail
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
    
    guard let request = request, var foundItem = self.detail as? DetailGameEntity else {
      debugPrint("Game not found or invalid request")
      return
    }
    
    foundItem.isFavorite.toggle()
    
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
      self.deleteFavorite(request: request)
    }
  }
}
