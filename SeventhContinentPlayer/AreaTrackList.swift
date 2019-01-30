//
//  AreaTrackList.swift
//  SeventhContinentPlayer
//
//  Created by Aaron Tyler on 1/29/19.
//  Copyright © 2019 Aaron Tyler. All rights reserved.
//

import Foundation
import UIKit

public class AreaTrackList {
    
    private var trackList: [AreaTrack]
    private static var instance: AreaTrackList? = nil
    
    init() {
        trackList = [
            AreaTrack(filename: "01_The7thContinent_AREA_I.mp3",    areaName: "Area I",     buttonImage: "Area_Icons_I",    downloadStatus: .NotDownloaded, buttonTag: 1, imageTag: 21, progressBarTag: 41),
            AreaTrack(filename: "02_The7thContinent_AREA_II.mp3",   areaName: "Area II",    buttonImage: "Area_Icons_II",   downloadStatus: .NotDownloaded, buttonTag: 2, imageTag: 22, progressBarTag: 42),
            AreaTrack(filename: "03_The7thContinent_AREA_III.mp3",  areaName: "Area III",   buttonImage: "Area_Icons_III",  downloadStatus: .NotDownloaded, buttonTag: 3, imageTag: 23, progressBarTag: 43),
            AreaTrack(filename: "04_The7thContinent_AREA_IV.mp3",   areaName: "Area IV",    buttonImage: "Area_Icons_IV",   downloadStatus: .NotDownloaded, buttonTag: 4, imageTag: 24, progressBarTag: 44),
            AreaTrack(filename: "05_The7thContinent_AREA_V.mp3",    areaName: "Area V",     buttonImage: "Area_Icons_V",    downloadStatus: .NotDownloaded, buttonTag: 5, imageTag: 25, progressBarTag: 45),
            AreaTrack(filename: "06_The7thContinent_AREA_VI.mp3",   areaName: "Area VI",    buttonImage: "Area_Icons_VI",   downloadStatus: .NotDownloaded, buttonTag: 6, imageTag: 26, progressBarTag: 46),
            AreaTrack(filename: "07_The7thContinent_AREA_VII.mp3",  areaName: "Area VII",   buttonImage: "Area_Icons_VII",  downloadStatus: .NotDownloaded, buttonTag: 7, imageTag: 27, progressBarTag: 47),
            AreaTrack(filename: "08_The7thContinent_AREA_VIII.mp3", areaName: "Area VIII",  buttonImage: "Area_Icons_VIII", downloadStatus: .NotDownloaded, buttonTag: 8, imageTag: 28, progressBarTag: 48),
            AreaTrack(filename: "09_The7thContinent_AREA_IX.mp3",   areaName: "Area IX",    buttonImage: "Area_Icons_IX",   downloadStatus: .NotDownloaded, buttonTag: 9, imageTag: 29, progressBarTag: 49),
            AreaTrack(filename: "10_The7thContinent_AREA_X.mp3",    areaName: "Area X",     buttonImage: "Area_Icons_X",    downloadStatus: .NotDownloaded, buttonTag: 10, imageTag: 30, progressBarTag: 50),
            AreaTrack(filename: "11_The7thContinent_AREA_XI.mp3",   areaName: "Area XI",    buttonImage: "Area_Icons_XI",   downloadStatus: .NotDownloaded, buttonTag: 11, imageTag: 31, progressBarTag: 51),
            AreaTrack(filename: "12_The7thContinent_AREA_XII.mp3",  areaName: "Area XII",   buttonImage: "Area_Icons_XII",  downloadStatus: .NotDownloaded, buttonTag: 12, imageTag: 32, progressBarTag: 52)
        ]
        
        //Update statuses
        for track in trackList {
            track.updateStatus()
        }
    }

    func setButtons(_ buttons: [UIButton]) {
        for button in buttons {
            let track = find(byButtonTag: button.tag)
            if track != nil {
                track!.button = button
            }
        }
    }
    
    func setStatusImages(_ imageViews: [UIImageView] ) {
        for imageView in imageViews {
            let track = find(byImageTag: imageView.tag)
            if track != nil {
                track!.imageView = imageView
            }
        }
    }
    
    func setProgressBars(_ progressBars: [CircularProgressBar] ) {
        for bar in progressBars {
            let track = find(byProgressBarTag: bar.tag)
            if let t = track {
                t.progressBar = bar
            }
        }
    }
    
    func updateTrackStatus(forTrack track: AreaTrack, newStatus: DownloadStatus?) {
        if(newStatus != nil) {
            track.downloadStatus = newStatus!
        } else {
            //Get the status
            track.updateStatus()
        }
    }
    
    func updateAllStatuses() {
        for track in trackList {
            track.updateStatus()
        }
    }
    
    static func sharedInstance() -> AreaTrackList {
        
        if(instance != nil) {
            return instance!
        }
        
        instance = AreaTrackList()
        return instance!
    }
    
    func find(byButtonTag tag: Int) -> AreaTrack? {
        return trackList.first(where: { (track: AreaTrack) -> Bool in
            return track.buttonTag == tag
        })
    }
    
    func find(byButton button: UIButton) -> AreaTrack? {
        return trackList.first(where: { (track: AreaTrack) -> Bool in
            return track.button == button
        })
    }
    
    func find(byImageTag tag: Int) -> AreaTrack? {
        return trackList.first(where: { (track: AreaTrack) -> Bool in
            return track.imageTag == tag
        })
    }
    
    func find(byProgressBarTag tag: Int) -> AreaTrack? {
        return trackList.first(where: { (track: AreaTrack) -> Bool in
            return track.progressBarTag == tag
        })
    }
    
    func all() -> [AreaTrack] {
        return trackList
    }
    
    func areaCount() -> Int {
        return trackList.count
    }
    
    func setAllDelegates(_ delegate: AreaTrackDelegate) {
        for track in trackList {
            track.delegate = delegate
        }
    }
    
    func areAllDownloaded() -> Bool {
        updateAllStatuses()
        for track in trackList {
            if track.downloadStatus != .Downloaded {
                return false
            }
        }
        return true
    }
    
}

