//
//  Cat.swift
//  TheCatApi
//
//  Created by Mike Saradeth on 5/25/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import UIKit

struct Cat: Codable {
    var id: String
    var imageUrl: String
    var image: UIImage?
    var isFavorite: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id 
        case imageUrl = "url"
    }
}




//MARK: save and load favorite
extension Cat {
    struct Favorite: Codable {  //wrapper class
        var isFavorite: Bool
        
        enum CodingKeys: String, CodingKey {
            case isFavorite
        }
    }
    
    func saveMyFavorite() {
        let favorite = Favorite(isFavorite: (self.isFavorite ?? false))
        
        do {
            //setup directory and file
            let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(TheCatApi.subDirectory.value(), isDirectory: true)
            if !FileManager.default.fileExists(atPath: directoryURL.path) {
                try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
            }
            let fileName = TheCatApi.fileNameFavorite.value() + "_" + id
            let fileURLWithPath = URL(fileURLWithPath: fileName, relativeTo: directoryURL)
                .appendingPathExtension(TheCatApi.fileExtension.value())
            
            //encode to json and write data
            let encoder = JSONEncoder()
            let data = try encoder.encode(favorite)
            try data.write(to: fileURLWithPath, options: .atomic)
            print("saveMyFavorite:  ", fileURLWithPath.path, favorite.isFavorite)
            
        }catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func loadFavorite() -> Bool {
        var myFavorite = false
        do {
            //setup directory and file
            let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(TheCatApi.subDirectory.value(), isDirectory: true)
            let fileName = TheCatApi.fileNameFavorite.value() + "_" + id
            let fileURLWithPath = URL(fileURLWithPath: fileName, relativeTo: directoryURL)
                .appendingPathExtension(TheCatApi.fileExtension.value())
            
            
            //try to decode data from contents of file and return myFavorite
            if let data = try? Data(contentsOf: fileURLWithPath) {
                let decoder = JSONDecoder()
                let tmpFavorite = try decoder.decode(Favorite.self, from: data)
                myFavorite = tmpFavorite.isFavorite
            }
            print("getMyFavorite:  ", fileURLWithPath.path, myFavorite)
            
        }catch let error {
            fatalError(error.localizedDescription)
        }
        return myFavorite
    }
}



//MARK: save and read array of Cat
extension Array where Element == Cat {
    func save() throws {
        //Setup directory and file
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        .appendingPathComponent(TheCatApi.subDirectory.value(), isDirectory: true)
        if !FileManager.default.fileExists(atPath: directoryURL.path) {
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        }
        let fileURLWithPath = URL(fileURLWithPath: TheCatApi.fileNameFavorites.value(), relativeTo: directoryURL)
                            .appendingPathExtension(TheCatApi.fileExtension.value())
        
        //Encode to json and save data
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        try data.write(to: fileURLWithPath, options: .atomic)
    }
    
    func load() throws -> [Cat] {
        var items = [Cat]()
        //Setup directory and file
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        .appendingPathComponent(TheCatApi.subDirectory.value(), isDirectory: true)
        let fileURLWithPath = URL(fileURLWithPath: TheCatApi.fileNameFavorites.value(), relativeTo: directoryURL)
                            .appendingPathExtension(TheCatApi.fileExtension.value())
        
        //if file exit decode json file
        if FileManager.default.fileExists(atPath: directoryURL.path) {
            let data = try Data(contentsOf: fileURLWithPath)
            let decoder = JSONDecoder()
            items = try decoder.decode([Cat].self, from: data)
        }
        return items
    }
}
