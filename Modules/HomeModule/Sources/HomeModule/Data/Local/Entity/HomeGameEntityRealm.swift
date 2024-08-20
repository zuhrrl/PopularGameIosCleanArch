//
//  File.swift
//  
//
//  Created by WDT on 17/08/24.
//

import Foundation
import RealmSwift

public class HomeGameEntityRealm: Object {
  
  @objc public dynamic var id: Int = 0
  @objc public dynamic var title: String = ""
  @objc public dynamic var genres: String = ""
  @objc public dynamic var rating: Double = 0.0
  @objc public dynamic var gameDescription: String = ""
  @objc public dynamic var backgroundImage: String = ""
  @objc public dynamic var releasedDate: String = ""
  @objc public dynamic var isFavorite: Int = 0
  
  public override static func primaryKey() -> String? {
    return "id"
  }
}
