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

class ViewController: UIViewController {

    public let AREA_COUNT = 12
    public let STOPPED_MUSIC_LABEL = "Stopped"
    public let MUSIC_BASE_URL = "https://the7thcontinent.seriouspoulp.com/audio/t7c/music/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for i in 0..<AREA_COUNT {
            if FileManager.default.fileExists(atPath: getFileUrlForArea(i).path) {
                statuses[i] = "Downloaded"
            } else {
                statuses[i] = "Not Downloaded"
            }
        }
        
        updateStatusLabel()
        
    }

    var player: AVPlayer? = nil;
    
    @IBAction func StopMusic(_ sender: Any) {
        currentlyPlayingLabel.text = STOPPED_MUSIC_LABEL;
        if(player != nil) {
            player!.pause()
        }
    }

    let filenames: [String] = [
        "01_The7thContinent_AREA_I.mp3",
        "02_The7thContinent_AREA_II.mp3",
        "03_The7thContinent_AREA_III.mp3",
        "04_The7thContinent_AREA_IV.mp3",
        "05_The7thContinent_AREA_V.mp3",
        "06_The7thContinent_AREA_VI.mp3",
        "07_The7thContinent_AREA_VII.mp3",
        "08_The7thContinent_AREA_VIII.mp3",
        "09_The7thContinent_AREA_IX.mp3",
        "10_The7thContinent_AREA_X.mp3",
        "11_The7thContinent_AREA_XI.mp3",
        "12_The7thContinent_AREA_XII.mp3"
    ]
    
    let labels: [String] = [
        "Area I",
        "Area II",
        "Area III",
        "Area IV",
        "Area V",
        "Area VI",
        "Area VII",
        "Area VIII",
        "Area IX",
        "Area X",
        "Area XI",
        "Area XII"
    ]
    
    var statuses: [String] = [
        "Not Downloaded",
        "Not Downloaded",
        "Not Downloaded",
        "Not Downloaded",
        "Not Downloaded",
        "Not Downloaded",
        "Not Downloaded",
        "Not Downloaded",
        "Not Downloaded",
        "Not Downloaded",
        "Not Downloaded",
        "Not Downloaded"
    ];
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var currentlyPlayingLabel: UILabel!
    
    private func updateStatusLabel() {
        var text = "";
        for stat: String in statuses {
            if text != "" {
                text += "\n"
            }
            text += stat
        }
        statusLabel.text = text;
    }
    
    private func getFileUrlForArea(_ areaIndex: Int) -> URL {
        //Load music locally if downloaded
        let documentsUrl:URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let musicFileUrl = documentsUrl.appendingPathComponent(filenames[areaIndex])

        return musicFileUrl
    }
    
    @IBAction func playArea(_ sender: UIButton) {

        let areaIndex = sender.tag - 1;
        if areaIndex < 0 {
            return
        }
        
        //Load music locally if downloaded
        let musicFileUrl = getFileUrlForArea(areaIndex)
        
        if(!FileManager.default.fileExists(atPath: musicFileUrl.path)) {
            downloadFile(areaIndex, successHandler: { areaIndex in
                print("Download complete AWT...")
                self.playMusicForArea(areaIndex)
            })
        } else {
            playMusicForArea(areaIndex)
        }

    }
    
    func playMusicForArea(_ areaIndex: Int) {
        
        guard let labelText = labels[areaIndex] as String? else {
            return
        }
        
        DispatchQueue.main.async {
            self.currentlyPlayingLabel.text = labelText;
        }
        
        //Get local URL for music
        let musicFileUrl = getFileUrlForArea(areaIndex)

        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        player = AVPlayer(url: musicFileUrl)
        player!.play()
    }
    
    @IBAction func downloadMusic(_ sender: Any) {
        
        //TODO: Download music
        for i in 0..<AREA_COUNT {
            downloadFile(i, successHandler: nil)
        }
        
        
    }
    
    private func downloadFile(_ areaIndex: Int, successHandler: ((_ result: Int) -> Void)?) -> Void {

        guard let filename = filenames[areaIndex] as String? else {
            return
        }
        
        // Create destination URL
        let documentsUrl:URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationFileUrl = documentsUrl.appendingPathComponent(filename)
        
        //The URL to Save
        let musicUrl = URL(string: self.MUSIC_BASE_URL + filename)

        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        let request = URLRequest(url:musicUrl!)
        
        
        self.statuses[areaIndex] = "Downloading..."
        self.updateStatusLabel()

        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            
            if FileManager.default.fileExists(atPath: destinationFileUrl.path) {
                print("Removing existing file...")
                do {
                    try FileManager.default.removeItem(at: destinationFileUrl)
                } catch(let error) {
                    print("Error removing file: \(error)")
                }
            }
            
            print("Starting download...")
            
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    if statusCode == 200 {
                        print("Successfully downloaded \(filename). Status code: \(statusCode)")
                        self.statuses[areaIndex] = "Downloaded"
                        
                        guard successHandler != nil else {
                            return
                        }
                        
                        successHandler!(areaIndex)
                        
                    } else {
                        self.statuses[areaIndex] = "File not found!"
                    }
                }
                
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                } catch (let writeError) {
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                    self.statuses[areaIndex] = "Error!"
                }
                
            } else {
                print("Error took place while downloading a file. Error description: \(error?.localizedDescription ?? "???")");
                self.statuses[areaIndex] = "Error!"
            }
            
            DispatchQueue.main.async{
                self.updateStatusLabel()
            }
            
        }
        task.resume();

        return
        
    }
}

