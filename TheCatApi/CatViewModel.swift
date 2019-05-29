//
//  ViewModel.swift
//  TheCatApi
//
//  Created by Mike Saradeth on 5/24/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import UIKit

protocol CatViewModelService {
    func loadData(completion: @escaping () -> Void)
    func toggleFavorite(index: Int) -> Bool
    func loadImage(index: Int, completion: @escaping (UIImage?) -> Void)
    func loadFavorite(index: Int) -> Bool
}

class CatViewModel: NSObject {
    var items: [Cat]
    var catService: CatService

    init(items: [Cat], catService: CatService) {
        self.items = items
        self.catService = catService
    }
    
    deinit {
        print("deinit: CatViewModel")
    }
}


extension CatViewModel: CatViewModelService {
    
    func loadData(completion: @escaping () -> Void) {
        catService.loadData { [weak self] (cats) in
            self?.items = cats
            completion()
        }
    }
    
    func toggleFavorite(index: Int) -> Bool {
        items[index].isFavorite = !(items[index].isFavorite ?? false)
        items[index].saveMyFavorite()
        return items[index].isFavorite!
    }
    
    func loadImage(index: Int, completion: @escaping (UIImage?) -> Void) {
        guard let imageUrl = URL(string: items[index].imageUrl) else { completion(nil); return }
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let data = try? Data(contentsOf: imageUrl) else { completion(nil); return }
            let image = UIImage(data: data)
            self?.items[index].image = image
            completion(image)
        }
    }
    
    func loadFavorite(index: Int) -> Bool {
        let isFavorite = items[index].loadFavorite()
        items[index].isFavorite = isFavorite
        return isFavorite
    }
}




//extension CatViewModel {
//    func saveFavorites() throws {
//        //Setup directory and file
//        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//                        .appendingPathComponent(TheCatApi.subDirectory.value(), isDirectory: true)
//        if !FileManager.default.fileExists(atPath: directoryURL.path) {
//            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
//        }
//        let fileURLWithPath = URL(fileURLWithPath: TheCatApi.fileNameFavorites.value(), relativeTo: directoryURL)
//                            .appendingPathExtension(TheCatApi.fileExtension.value())
//
//        //encode to json and save
//        print("saveFavorites:  ", fileURLWithPath.path)
//        let encoder = JSONEncoder()
//        let data = try encoder.encode(favorites)
//        try data.write(to: fileURLWithPath, options: .atomic)
//        print("saveFavorites:  ", favorites)
//    }
//
//    func loadFavorites() throws {
//        //Setup directory and file
//        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//                        .appendingPathComponent(TheCatApi.subDirectory.value(), isDirectory: true)
//        let fileURLWithPath = URL(fileURLWithPath: TheCatApi.fileNameFavorites.value(), relativeTo: directoryURL)
//                            .appendingPathExtension(TheCatApi.fileExtension.value())
//
//        //if file exist decode json file
//        print("loadFavorites:  ", fileURLWithPath.path)
//        if FileManager.default.fileExists(atPath: fileURLWithPath.path) {
//            let data = try Data(contentsOf: fileURLWithPath)
//            let decoder = JSONDecoder()
//            let favorites = try decoder.decode([String: Bool].self, from: data)
//            print("loadFavorites:  ", favorites)
//        }
//    }
//}

