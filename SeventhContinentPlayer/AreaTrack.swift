//
//  AreaTrack.swift
//  SeventhContinentPlayer
//
//  Created by Aaron Tyler on 1/28/19.
//  Copyright © 2019 Aaron Tyler. All rights reserved.
//

import Foundation
import UIKit

protocol AreaTrackDelegate: AnyObject {
    func statusUpdated(_ track: AreaTrack)
}

public class AreaTrack {
    
    static let MUSIC_BASE_URL = "https://the7thcontinent.seriouspoulp.com/audio/t7c/music/"
    
    let filename: String
    let areaName: String
    let buttonImage: String
    var downloadStatus: DownloadStatus
    let buttonTag: Int
    let imageTag: Int
    var button: UIButton? = nil
    var imageView: UIImageView? = nil
    weak var delegate: AreaTrackDelegate?
    let downloadSession: URLSession
    
    init(filename: String, areaName: String, buttonImage: String, downloadStatus: DownloadStatus, buttonTag: Int, imageTag: Int) {
        self.filename = filename
        self.areaName = areaName
        self.buttonImage = buttonImage
        self.downloadStatus = downloadStatus
        self.buttonTag = buttonTag
        self.imageTag = imageTag
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.allowsCellularAccess = true
        sessionConfig.httpMaximumConnectionsPerHost = 3
        sessionConfig.timeoutIntervalForResource = 600
        downloadSession = URLSession(configuration: sessionConfig)

    }
    
    func getLocalUrl() -> URL {
        let documentsUrl:URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let musicFileUrl = documentsUrl.appendingPathComponent(self.filename)
        return musicFileUrl
    }
    
    func getRemoteUrl() -> URL {
        let musicUrl = URL(string: AreaTrack.MUSIC_BASE_URL + filename)!
        return musicUrl
    }
    
    func updateStatus() {
        if FileManager.default.fileExists(atPath: getLocalUrl().path) {
            self.downloadStatus = .Downloaded
        } else {
            self.downloadStatus = .NotDownloaded
        }
        if let d = self.delegate {
            d.statusUpdated(self)
        }
    }
    
    func updateStatus(to status: DownloadStatus) {
        self.downloadStatus = status
        if let d = self.delegate {
            d.statusUpdated(self)
        }
    }
    
    func equals(_ otherTrack: AreaTrack) -> Bool {
        return self.buttonTag == otherTrack.buttonTag
    }
    
    func download() {
        download(withSuccessHandler: nil)
    }
    
    func download(withSuccessHandler successHandler: ((_ track: AreaTrack) -> Void)?) -> Void {
        
        // Destination URL
        let destinationFileUrl = self.getLocalUrl()
        
        let request = URLRequest(url:self.getRemoteUrl())

        //TODO: Make this work
        self.updateStatus(to: .WaitingForDownload)

        let task = downloadSession.downloadTask(with: request) { (tempLocalUrl, response, error) in
        
            if FileManager.default.fileExists(atPath: destinationFileUrl.path) {
                print("Removing existing file...")
                do {
                    try FileManager.default.removeItem(at: destinationFileUrl)
                } catch(let error) {
                    print("Error removing file: \(error)")
                }
            }

            self.updateStatus(to: .Downloading)

            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    if statusCode == 200 {
                        print("Successfully downloaded \(self.filename). Status code: \(statusCode)")
                        self.updateStatus(to: .Downloaded)
                    } else {
                        print("Error downloading file: File not found!")
                        self.updateStatus(to: .Error)
                    }
                }
                
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                    guard successHandler != nil else {
                        return
                    }
                    successHandler!(self)
                } catch (let writeError) {
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                    self.updateStatus(to: .Error)
                }
                
            } else {
                print("Error took place while downloading a file. Error description: \(error?.localizedDescription ?? "???")");
                self.updateStatus(to: .Error)
            }
            
//            DispatchQueue.main.async{
//                self.updateStatus()
//            }
            
        }
        task.resume();
        
        return
        
    }
    
}

public enum DownloadStatus {
    case Downloaded
    case WaitingForDownload
    case Downloading
    case NotDownloaded
    case Error
}
