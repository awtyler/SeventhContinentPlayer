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
    func downloadComplete(_ track: AreaTrack)
    func downloadProgressed(_ track: AreaTrack, percentComplete: Double)
}



public class AreaTrack: NSObject, URLSessionDownloadDelegate {

    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if let delegate = self.delegate {
            let pct = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
            delegate.downloadProgressed(self, percentComplete: pct)
        }
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Download complete")
        
        let tempLocalUrl = location
        let error = downloadTask.error
        let response = downloadTask.response

        let destinationFileUrl = self.getLocalUrl()
        
        if FileManager.default.fileExists(atPath: destinationFileUrl.path) {
            print("Removing existing file...")
            do {
                try FileManager.default.removeItem(at: destinationFileUrl)
            } catch(let error) {
                print("Error removing file: \(error)")
            }
        }
        
        if error == nil {
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
            } catch (let writeError) {
                print("Error creating a file \(destinationFileUrl) : \(writeError)")
                self.updateStatus(to: .Error)
            }
            
        } else {
            print("Error took place while downloading a file. Error description: \(error?.localizedDescription ?? "???")");
            self.updateStatus(to: .Error)
        }
        
        if let delegate = self.delegate {
            delegate.downloadComplete(self)
        }
        
    }
    
    static let MUSIC_BASE_URL = "https://the7thcontinent.seriouspoulp.com/audio/t7c/music/"
    
    let filename: String
    let areaName: String
    let buttonImage: String
    var downloadStatus: DownloadStatus
    let buttonTag: Int
    let imageTag: Int
    let progressBarTag: Int
    var button: UIButton? = nil
    var imageView: UIImageView? = nil
    weak var delegate: AreaTrackDelegate?
    var downloadSession: URLSession?
    var progressBar: CircularProgressBar?
    var urlSessionConfig: URLSessionConfiguration
    
    init(filename: String, areaName: String, buttonImage: String, downloadStatus: DownloadStatus, buttonTag: Int, imageTag: Int, progressBarTag: Int) {
        self.filename = filename
        self.areaName = areaName
        self.buttonImage = buttonImage
        self.downloadStatus = downloadStatus
        self.buttonTag = buttonTag
        self.imageTag = imageTag
        self.progressBarTag = progressBarTag
        
        urlSessionConfig = URLSessionConfiguration.default
        urlSessionConfig.allowsCellularAccess = true
        urlSessionConfig.httpMaximumConnectionsPerHost = 3
        urlSessionConfig.timeoutIntervalForResource = 600

        super.init()

        downloadSession = URLSession(configuration: self.urlSessionConfig, delegate: self, delegateQueue: OperationQueue.main)

    }
    
    func setProgressBar(_ progressBar: CircularProgressBar) {
        self.progressBar = progressBar
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
        download(withProgress: nil, successHandler: successHandler)
    }
    
    func download(withProgress progressView: UIProgressView?, successHandler: ((_ track: AreaTrack) -> Void)?) -> Void {
        
        guard let downloadSession = self.downloadSession else {
            print("Error with downloadSession")
            return
        }
        
        let request = URLRequest(url:self.getRemoteUrl())
        
        self.updateStatus(to: .Downloading)
        
        let task = downloadSession.downloadTask(with: request);
        if let pv = progressView {
            pv.observedProgress = task.progress
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
