//
//  FavoriteGameView.swift
//  PopularGames
//
//  Created by WDT on 27/07/24.
//

import SwiftUI
import Core
import FavoriteGameModule

struct FavoriteGameView: View {
  @ObservedObject var presenter: GetFavoriteGamePresenter<Any, [FavoriteGameEntity], Interactor<Any, [FavoriteGameEntity], GetListFavoriteGameRepository<GetFavoriteGameLocalDataSource, FavoriteRealmTransformer>>,Interactor<Any, Bool, GetDeleteFavoriteFavoriteModuleRepository<GetFavoriteGameLocalDataSource, FavoriteDeleteRealmTransformer>>
  >
  
  var body: some View {
    VStack(alignment: .leading) {
      if presenter.isLoading {
        HStack {
          Spacer()
          VStack {
            Text("Loading...")
              .foregroundColor(Color(uiColor: .text))
            ProgressView()
              .tint(.white)
          }
          Spacer()
        }
      } else if presenter.list == nil {
        HStack {
          Spacer()
          VStack {
            Text("Loading...")
              .foregroundColor(Color(uiColor: .white))
            ProgressView()
              .tint(.white)
          }
          Spacer()
        } .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background {
            Color.init(uiColor: .primary)
              .ignoresSafeArea()
          }
        
      } else if presenter.list!.isEmpty {
        Text("Favorite Games")
          .font(.headline)
          .padding(EdgeInsets(top: 0.0, leading: 35.0, bottom: 0, trailing: 0)
          )
          .foregroundColor(Color(uiColor: .text))
          .font(.system(size: 16, weight: .bold))
          .padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0))
        Spacer()
        HStack {
          
          Spacer()
          VStack {
            Text("Favorite game is empty!")
              .foregroundColor(Color(uiColor: .text))
          }
          Spacer()
        }
        Spacer()
      } else {
        Text("Favorite Games")
          .font(.headline)
          .padding(EdgeInsets(top: 0.0, leading: 35.0, bottom: 0, trailing: 0)
          )
          .foregroundColor(Color(uiColor: .text))
          .font(.system(size: 16, weight: .bold))
          .padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0))
        List(presenter.list!, id: \.id) {  item in
          ItemFavoriteGame(game: item, onTap: {
            debugPrint("TRYING TO DELETE FAVORITE GAME FROM FAVORITE SCREEN with ID \(item.id)")
            let itemToDelete = GameEntityRealm()
            itemToDelete.id = item.id
            presenter.deleteFavorite(request: itemToDelete)
          })
          .listRowBackground(Color.clear) // Change Row Color
          .listRowSeparator(.hidden)
          .onTapGesture {
            presenter.selectedGame = item.id
          }
          .overlay {
            NavigationLink(destination: HomeRouter().makeDetailGame(gameId: item.id), tag: item.id, selection: $presenter.selectedGame) {
              EmptyView().frame(height: 0)
            }.opacity(0)
          }
        }.listStyle(.plain) //Change ListStyle
          .scrollContentBackground(.hidden)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background {
      Color.init(uiColor: .primary)
        .ignoresSafeArea()
    }
    .onAppear(perform: {
      presenter.getList(request: nil)
    })
  }
}
