//
//  Disk.swift
//  RecipeAppKit
//
//  Created by Hiromi Sakurai on 2020/05/16.
//  Copyright © 2020 HiromiSakurai. All rights reserved.
//

import Foundation

enum FileName: String {
    case favoriteList = "favorite_list.json"
}

/// @mockable
protocol Disk {
    func getObject<T: Decodable>(filename: FileName) -> T?
    func writeObject<T: Encodable>(filename: FileName, jsonEncodable: T)
}

final class DiskImpl: Disk {
    private enum PathSearchError: Error {
        case pathNotFound
    }

    private enum DispatchQueueLabel: String {
        case disk
    }

    static let shared: Disk = DiskImpl()
    private let dispatchQueue: DispatchQueue = DispatchQueue(label: DispatchQueueLabel.disk.rawValue)

    private init() {}

    func getObject<T: Decodable>(filename: FileName) -> T? {
        do {
            let fileURL = try retrieveConfiguredFileURL(filename: filename)
            let localData = try Data(contentsOf: fileURL, options: .alwaysMapped)
            let localItems = try JSONDecoder().decode(T.self, from: localData)
            return localItems
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }

    func writeObject<T: Encodable>(filename: FileName, jsonEncodable: T) {
        dispatchQueue.async { [weak self] in
            guard let self = self else { return }

            let jsonEncoder = JSONEncoder()
            guard let jsonData = try? jsonEncoder.encode(jsonEncodable) else {
                return
            }
            do {
                let fileURL = try self.retrieveConfiguredFileURL(filename: filename)
                try jsonData.write(to: fileURL, options: Data.WritingOptions.atomic)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }

    private func retrieveConfiguredFileURL(filename: FileName, excludeFromBackup: Bool = true) throws -> URL {
        let bundleId = Bundle.main.bundleIdentifier ?? ""
        let appSupportDir = FileManager.SearchPathDirectory.applicationSupportDirectory
        let userMask = FileManager.SearchPathDomainMask.userDomainMask
        guard let appSupportDirURL: URL = FileManager.default.urls(for: appSupportDir, in: userMask).first else {
            throw PathSearchError.pathNotFound
        }
        let dirURL = appSupportDirURL.appendingPathComponent(bundleId, isDirectory: true)
        var isDir: ObjCBool = true
        if !FileManager.default.fileExists(atPath: dirURL.path, isDirectory: &isDir) {
            try? FileManager.default.createDirectory(at: dirURL, withIntermediateDirectories: true, attributes: nil)
        }
        var fullURL = dirURL.appendingPathComponent(filename.rawValue, isDirectory: false)
        if excludeFromBackup {
            var resourceValues = URLResourceValues()
            resourceValues.isExcludedFromBackup = true
            try? fullURL.setResourceValues(resourceValues)
        }
        return fullURL
    }
}

