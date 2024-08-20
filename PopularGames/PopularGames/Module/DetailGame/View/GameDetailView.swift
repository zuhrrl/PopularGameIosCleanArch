//
//  GameDetailView.swift
//  PopularGames
//
//  Created by WDT on 21/07/24.
//

import SwiftUI
import Core
import DetailGameModule

struct GameDetailView: View {
  let gameId: Int
  @StateObject var presenter: GetDetailGamePresenter<Any, DetailGameEntity, Interactor<Any, DetailGameEntity, GetDetailGameRepository<GetDetailGameLocalDataSource, GetDetailGameRemoteDataSource, DetailGameTransformer>>
  >
  var body: some View {
    let game = presenter.detail
    NavigationView {
      if presenter.isLoading {
        HStack {
          Spacer()
          VStack {
            Text("Loading...")
              .foregroundColor(Color(uiColor: .white))
            ProgressView()
              .tint(.white)
          }
          Spacer()
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
          .background {
            Color.init(uiColor: .primary)
              .ignoresSafeArea()
          }
        
      } else if presenter.detail == nil {
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
        
      } else {
        ScrollView {
          VStack(alignment: .leading){
            AsyncImage(url: URL(string: "\(game!.backgroundImage)")) { image in
              image.resizable()
            } placeholder: {
              Color.gray
            }
            .frame(height: 200.0)
            .clipShape(.rect(cornerRadius: 15))
            HStack {
              Text("Created At: \(game!.releasedDate)")
                .foregroundColor(Color(uiColor: .text))
              
                .font(.system(size: 20))
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
              Spacer()
              Image(systemName: game!.isFavorite ? "heart.fill" :  "heart")
                .resizable()
                .frame(width: 25.0, height: 25.0)
                .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 20.0)
                )
                .foregroundColor(.white)
                .onTapGesture {
                  debugPrint("ONTAP FAVORITE DETAIL VIEW")
                  presenter.addToFavorite(request: game)
                }
            }
            Text("\(game!.title)")
              .foregroundColor(Color(uiColor: .text))
            
              .font(.title)
              .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
            
            
            Text("Genres: \(game!.genres)")
              .foregroundColor(Color(uiColor: .text))
              .font(.system(size: 15))
              .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            
            
            
            Text("\(game!.description)")
              .foregroundColor(Color(uiColor: .text))
              .font(.system(size: 20))
            
            Text("Rating: \(String(format: "%.2f", game!.rating))")
              .foregroundColor(Color(uiColor: .text))
            
              .font(.title)
              .padding(EdgeInsets(top: 15, leading: 0, bottom: 10, trailing: 0))
            
          }
          .padding(25)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
          Color.init(uiColor: .primary)
            .ignoresSafeArea()
        }
      }
    }
    .onAppear {
      presenter.getDetail(request: gameId)
    }
  }
}
