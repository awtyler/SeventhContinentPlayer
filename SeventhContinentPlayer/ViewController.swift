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
        DownloadStatus.Downloaded: "Status_Icons_Downloaded",
        DownloadStatus.Downloading: "Status_Icons_Downloading",
        DownloadStatus.Error: "Status_Icons_Error",
        DownloadStatus.NotDownloaded: "Status_Icons_NotDownloaded",
        DownloadStatus.WaitingForDownload: "Area_Icons_Play"
    ]
    
    private func updateAllStatuses() {
        //Update status for all tracks
        for track in AreaTrackList.sharedInstance().all() {
            self.updateStatusImage(forAreaTrack: track)
        }
        self.updateDownloadAllVisibility()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        list.setAllDelegates(self)
        
        updateAllStatuses()
        
        disableStopButton()
        
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
            self.stopMusic(nil)
            track.download(withSuccessHandler: { track in
                self.playMusic(forTrack: track)
            })
        } else {
            playMusic(forTrack: track)
        }

    }
    
    @IBAction func downloadMusic(_ sender: Any) {
        
        print("Attempting download...")
        
        //TODO: Only allow x downloads at a time
        for track in AreaTrackList.sharedInstance().all() {
            track.download()
        }
        
        
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
            track.imageView!.image = UIImage(named: imageName)
        }
    }
    
    func updateDownloadAllVisibility() {
        if AreaTrackList.sharedInstance().areAllDownloaded() {
            //Disable button
            self.downloadAllButton.isEnabled = false
            self.downloadAllButton.alpha = 0.5
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

}

