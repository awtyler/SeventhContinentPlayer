//
//  ViewController.swift
//  SeventhContinentPlayer
//
//  Created by Aaron Tyler on 1/21/19.
//  Copyright © 2019 Aaron Tyler. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AreaTrackDelegate {
    
    func downloadComplete(_ track: AreaTrack) {

        updateViewAfterDownload(track)
        
        if let playTrack = self.trackToPlayAfterDownload {
            if track.equals(playTrack) {
                self.trackToPlayAfterDownload = nil
                playMusic(forTrack: track)
            }
        }
        
    }
    
    func downloadProgressed(_ track: AreaTrack, percentComplete: Double) {
        if let pb = track.progressBar {
            pb.setProgress(to: percentComplete, withAnimation: false)
            if percentComplete >= 1.0 {
                pb.isHidden = true
            }
        }
        
    }

    func statusUpdated(_ track: AreaTrack) {
        //Update track status on the main thread
        DispatchQueue.main.async {
            self.updateStatusImage(forAreaTrack: track)
        }
    }

    public let AREA_COUNT = 12
    public let STOPPED_MUSIC_LABEL = "Stopped"
    public let MUSIC_BASE_URL = "https://the7thcontinent.seriouspoulp.com/audio/t7c/music/"
    public let PLAY_BUTTON_IMAGE = "Area_Icons_Play"
    public let STATUS_IMAGES = [
        DownloadStatus.Downloaded: nil,
        DownloadStatus.Downloading: nil,
        DownloadStatus.Error: "Status_Icons_Error",
        DownloadStatus.NotDownloaded: "Status_Icons_NotDownloaded",
        DownloadStatus.WaitingForDownload: "Area_Icons_Play"
    ]
    
    private func updateAllStatuses() {
        //Update status for all tracks
        for track in AreaTrackList.sharedInstance().all() {
            self.updateStatusImage(forAreaTrack: track)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Print working directory
        print("MP3 Directory: \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)")

        let list = AreaTrackList.sharedInstance()
        
        //Assign buttons to AreaTracks
        list.setButtons([
            area1button,
            area2button,
            area3button,
            area4button,
            area5button,
            area6button,
            area7button,
            area8button,
            area9button,
            area10button,
            area11button,
            area12button
        ])
        
        list.setStatusImages([
            area1statusImage,
            area2statusImage,
            area3statusImage,
            area4statusImage,
            area5statusImage,
            area6statusImage,
            area7statusImage,
            area8statusImage,
            area9statusImage,
            area10statusImage,
            area11statusImage,
            area12statusImage
        ])
        
        let pbList = [
            area1progressBar!,
            area2progressBar!,
            area3progressBar!,
            area4progressBar!,
            area5progressBar!,
            area6progressBar!,
            area7progressBar!,
            area8progressBar!,
            area9progressBar!,
            area10progressBar!,
            area11progressBar!,
            area12progressBar!
        ]
        
        for bar in pbList {
            bar.safePercent = 100
            bar.labelSize = 0
            bar.lineWidth = 7

        }
        
        
        list.setProgressBars(pbList)
        
        list.setAllDelegates(self)
        
        updateAllStatuses()
        
        disableStopButton()
        
//        testProgress.transform = testProgress.transform.scaledBy(x: 1, y: 20)
        
        //Setup Audio session, output to speaker, and allow airplay & bluetooth
        do {
            let instance = AVAudioSession.sharedInstance()
            try instance.setActive(true)
            try instance.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [AVAudioSession.CategoryOptions.allowAirPlay, AVAudioSession.CategoryOptions.allowBluetooth, AVAudioSession.CategoryOptions.allowBluetoothA2DP])
            try instance.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Error Setting Up Audio Session")
        }
        
    }
    

    var player: AVAudioPlayer? = nil;
    var displayTimer: Timer? = nil;
    var trackToPlayAfterDownload: AreaTrack? = nil
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var area1button: UIButton!
    @IBOutlet weak var area2button: UIButton!
    @IBOutlet weak var area3button: UIButton!
    @IBOutlet weak var area4button: UIButton!
    @IBOutlet weak var area5button: UIButton!
    @IBOutlet weak var area6button: UIButton!
    @IBOutlet weak var area7button: UIButton!
    @IBOutlet weak var area8button: UIButton!
    @IBOutlet weak var area9button: UIButton!
    @IBOutlet weak var area10button: UIButton!
    @IBOutlet weak var area11button: UIButton!
    @IBOutlet weak var area12button: UIButton!
    
    @IBOutlet weak var area1progressBar: CircularProgressBar!
    @IBOutlet weak var area2progressBar: CircularProgressBar!
    @IBOutlet weak var area3progressBar: CircularProgressBar!
    @IBOutlet weak var area4progressBar: CircularProgressBar!
    @IBOutlet weak var area5progressBar: CircularProgressBar!
    @IBOutlet weak var area6progressBar: CircularProgressBar!
    @IBOutlet weak var area7progressBar: CircularProgressBar!
    @IBOutlet weak var area8progressBar: CircularProgressBar!
    @IBOutlet weak var area9progressBar: CircularProgressBar!
    @IBOutlet weak var area10progressBar: CircularProgressBar!
    @IBOutlet weak var area11progressBar: CircularProgressBar!
    @IBOutlet weak var area12progressBar: CircularProgressBar!

    @IBOutlet weak var downloadAllButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var area1statusImage: UIImageView!
    @IBOutlet weak var area2statusImage: UIImageView!
    @IBOutlet weak var area3statusImage: UIImageView!
    @IBOutlet weak var area4statusImage: UIImageView!
    @IBOutlet weak var area5statusImage: UIImageView!
    @IBOutlet weak var area6statusImage: UIImageView!
    @IBOutlet weak var area7statusImage: UIImageView!
    @IBOutlet weak var area8statusImage: UIImageView!
    @IBOutlet weak var area9statusImage: UIImageView!
    @IBOutlet weak var area10statusImage: UIImageView!
    @IBOutlet weak var area11statusImage: UIImageView!
    @IBOutlet weak var area12statusImage: UIImageView!

    @IBAction func stopMusic(_ sender: Any?) {
        if(player != nil) {
            player!.stop()
            player = nil;
        }
        if(displayTimer != nil) {
            displayTimer?.invalidate()
            totalTimeLabel.text = "00:00"
            currentTimeLabel.text = "00:00"
            setPlayButton(nil)
        }
        disableStopButton()
    }
    
    @IBAction func playArea(_ sender: UIButton) {

        guard let track: AreaTrack = AreaTrackList.sharedInstance().find(byButton: sender) else {
            print("No track for button")
            return
        }
        
        //Update download status
        track.updateStatus()
        
        //If not downloaded, download now
        if track.downloadStatus == .NotDownloaded {
            //Stop playing the current area
            self.stopMusic(nil)
            
            //Keep only the first downloaded item to play, if multiple items are clicked before the first download completes.
            if self.trackToPlayAfterDownload == nil {
                self.trackToPlayAfterDownload = track
            }
            self.downloadTrack(track)
        } else {
            playMusic(forTrack: track)
        }

    }
    
    @IBAction func downloadMusic(_ sender: Any) {

        let refreshAlert = UIAlertController(title: "Download Tracks", message: "What do you want to download?", preferredStyle: UIAlertController.Style.alert)

        if !AreaTrackList.sharedInstance().areAllDownloaded() {
            refreshAlert.addAction(UIAlertAction(title: "Download Missing Tracks", style: .default, handler: { (action: UIAlertAction!) in
                for track in AreaTrackList.sharedInstance().all() {
                    track.updateStatus()
                    if track.downloadStatus != .Downloaded {
                        self.downloadTrack(track)
                    }
                }
            }))
        }

        refreshAlert.addAction(UIAlertAction(title: "Delete Tracks and Download Again", style: .destructive, handler: { (action: UIAlertAction!) in
            for track in AreaTrackList.sharedInstance().all() {
                self.downloadTrack(track)
            }
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
    }
    
    func setPlayButton() {
        setPlayButton(nil)
    }
    
    func setPlayButton(_ playingTrack: AreaTrack?) {
        
        for track in AreaTrackList.sharedInstance().all() {
            let areaButton = track.button
            var imageName = track.buttonImage
            if playingTrack != nil && track.equals(playingTrack!) {
                imageName = PLAY_BUTTON_IMAGE
            }
            if areaButton != nil {
                areaButton!.setImage(UIImage(named: imageName), for: UIControl.State.normal)
            }
        }
    }
    
    func playMusic(forTrack track: AreaTrack) {
        
        DispatchQueue.main.async {
            //Update the view with play time for the tracks
            self.displayTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {(Timer) in
                self.updateTimeLeft()
            })

            //Set the button image to the "Play" image
            self.setPlayButton(track)
            
            //Enable the Stop button
            self.enableStopButton()
        }
        
        //Get local URL for music
        let musicFileUrl = track.getLocalUrl()

        // Create an AVAudioPlayer, passing it the local URL
        do {
            try player = AVAudioPlayer(contentsOf: musicFileUrl)
            player!.prepareToPlay()
            player!.numberOfLoops = -1      //Repeat indefinitely
            player!.play()
        } catch {
            print("Error playing: \(error)")
            setPlayButton()
        }
    }
    
    
    private func timecodeString(_ seconds: Double) -> String {
        let minutes: Int = Int(seconds) / 60
        let seconds: Int = Int(seconds) % 60
        
        var mStr: String = "00\(minutes)"
        mStr = String(mStr[mStr.index(mStr.endIndex, offsetBy: -2)...])
        
        var sStr: String = "00\(seconds)"
        sStr = String(sStr[sStr.index(sStr.endIndex, offsetBy: -2)...])
        
        return "\(mStr):\(sStr)"
    }
    
    private func updateTimeLeft() {
        if(self.player != nil) {
            self.currentTimeLabel.text = "\(self.timecodeString(self.player!.currentTime.rounded()))"
            self.totalTimeLabel.text = "\(self.timecodeString(self.player!.duration.rounded()))"
        }
    }

    private func updateStatusImage(forAreaTrack track: AreaTrack) {
        guard let imageName = STATUS_IMAGES[track.downloadStatus] else {
            print("Invalid status")
            return
        }
        
        if track.imageView != nil {
            if let iname = imageName {
                track.imageView!.image = UIImage(named: iname)
            } else {
                track.imageView!.image = nil
            }
        }
    }
    
    func disableStopButton() {
        self.stopButton.isEnabled = false
        self.stopButton.alpha = 0.5
    }

    func enableStopButton() {
        self.stopButton.isEnabled = true
        self.stopButton.alpha = 1.0
    }

    func downloadTrack(_ track: AreaTrack) {
        self.updateViewForDownload(track)
        track.download()
    }
    
    func updateViewForDownload(_ track: AreaTrack) {
        if let pb = track.progressBar {
            pb.setProgress(to: 0.0, withAnimation: false)
            pb.isHidden = false
        }
        
        if let btn = track.button {
            btn.alpha = CGFloat(0.5)
        }
    }
    
    func updateViewAfterDownload(_ track: AreaTrack) {
        if let pb = track.progressBar {
            pb.isHidden = true
        }
        if let btn = track.button {
            btn.alpha = CGFloat(1.0)
        }

    }
    
}
