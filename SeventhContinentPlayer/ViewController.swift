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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    var player: AVPlayer? = nil;
    
    @IBAction func StopMusic(_ sender: Any) {
        currentlyPlayingLabel.text = labels[0];
        if(player != nil) {
            player!.pause()
        }
    }

    let filenames: [String] = [
        "none",
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
        "Stopped",
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
    
    @IBOutlet weak var currentlyPlayingLabel: UILabel!
    
    
    @IBAction func playArea(_ sender: UIButton) {

        guard let filename = filenames[sender.tag] as String? else {
            return
        }
        
        guard let labelText = labels[sender.tag] as String? else {
                return
        }

        self.currentlyPlayingLabel.text = labelText;
        
        //TODO: Load music locally if downloaded
        guard let url = URL(string: "https://the7thcontinent.seriouspoulp.com/audio/t7c/music/" + filename) else {
            return
        }

        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        player = AVPlayer(url: url)
        player!.play()

    }
    
    @IBAction func downloadMusic(_ sender: Any) {
        
        //TODO: Download music
        
    }
    
    private func downloadFile(_ filename: String) {

        
        // Create destination URL
        let documentsUrl:URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
        let destinationFileUrl = documentsUrl.appendingPathComponent(filename)
        
        //Create URL to the source file you want to download
        let fileURL = URL(string: "https://s3.amazonaws.com/learn-swift/IMG_0001.JPG")
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        let request = URLRequest(url:fileURL!)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded. Status code: \(statusCode)")
                }
                
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                } catch (let writeError) {
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                }
                
            } else {
                print("Error took place while downloading a file. Error description: \(error?.localizedDescription ?? "???")");
            }
        }
        
    }
}

