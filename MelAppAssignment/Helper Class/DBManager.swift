//
//  DBManager.swift
//  MelAppAssignment
//
//  Created by Prabhat on 11/12/20.
//  Copyright © 2020 prabhat. All rights reserved.
//

import Foundation
import FMDB

class DBManager: NSObject {
  static let shared: DBManager = DBManager()
  let databaseFileName = "Marvel.sqlite"

  var pathToDatabase: String!

  var queue: FMDatabaseQueue?

  public typealias Completion = ((Bool, Error?)-> Void)

  public typealias ResultCompletion = ((Bool, FMResultSet?, Error?)-> Void)

  override init() {
    super.init()
    let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
    pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
    queue = FMDatabaseQueue(path: pathToDatabase!)
  }

  func createDatabase(createTableQuery:String) {

    if FileManager.default.fileExists(atPath: pathToDatabase) {
      queue = FMDatabaseQueue(path: pathToDatabase!)
      queue?.inDatabase() {
        db in
        if !db.executeUpdate(createTableQuery, withArgumentsIn: []) {
          print("table create failure: \(db.lastErrorMessage())")
          return
        }
      }
    }
  }

  func inserDatabase(insertTableQuery:String, compliting:(Completion)) {
    if FileManager.default.fileExists(atPath: pathToDatabase) {
      queue = FMDatabaseQueue(path: pathToDatabase!)
      queue?.inDatabase() {
        db in
        if !db.executeStatements(insertTableQuery) {
          print("table create failure: \(db.lastErrorMessage())")
          compliting(false, Error.self as? Error)
          return
        } else {
          compliting(true, nil)
        }
      }
    }
  }

  func deleteTable(tableName: String) {
    if FileManager.default.fileExists(atPath: pathToDatabase) {
      queue = FMDatabaseQueue(path: pathToDatabase!)
      queue?.inDatabase() {
        db in
        if !db.executeUpdate("DROP TABLE IF EXISTS `\(tableName)`", withArgumentsIn: []) {
          print("table delete failure: \(db.lastErrorMessage())")
          return
        }
      }
    }
  }

  func deleteEntryFromDatabase (id: Int, completing:(Completion)) {
    if FileManager.default.fileExists(atPath: pathToDatabase) {
      queue = FMDatabaseQueue(path: pathToDatabase!)
      queue?.inDatabase({ (db) in
        do {
          try db.executeQuery("DELETE FROM Characters where `id` = '\(id)'", values: [])
          //completing(true, result, nil)
          completing(true, nil)
        } catch {
          //completing(false, nil, error)
          completing(false, error)
        }
      })
    }
  }

  func getData(query: String, completing:(ResultCompletion)){
    if FileManager.default.fileExists(atPath: pathToDatabase) {
      queue = FMDatabaseQueue(path: pathToDatabase)
      queue?.inDatabase({ (db) in
        do {
          let result = try db.executeQuery(query, values: [])
          completing(true, result, nil)
        }
        catch {
          completing(false, nil, error)
        }

      })
    }
  }
}

