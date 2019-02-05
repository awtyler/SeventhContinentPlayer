//
//  CreditsTableTableViewController.swift
//  SeventhContinentPlayer
//
//  Created by Aaron Tyler on 2/4/19.
//  Copyright © 2019 Aaron Tyler. All rights reserved.
//

import UIKit

class CreditsTableViewController: UITableViewController {

    var creditList: [[Credit]] = []
    
    var areaCreditLists: [AreaCreditList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundView = nil;
        
        //Load Credits:
        self.areaCreditLists = [
            AreaCreditList(trackNumber: 1, areaName: "Area I", creditList: [
                Credit(trackNumber: 1, trackName: "Area I", soundName: "A forest on the island", artist: "originalmaja"),
                Credit(trackNumber: 1, trackName: "Area I", soundName: "Flock of seagulls", artist: "juskiddink"),
                Credit(trackNumber: 1, trackName: "Area I", soundName: "Gentle surf rolling on sandy beach Close Up", artist: "Jillismolenaar"),
                Credit(trackNumber: 1, trackName: "Area I", soundName: "RAM Mouth Hawk dry v1", artist: "reidedo"),
                Credit(trackNumber: 1, trackName: "Area I", soundName: "Sea - Ocean - Beach - Close", artist: "nebulousflynn"),
                Credit(trackNumber: 1, trackName: "Area I", soundName: "Seagulls 1.wav", artist: "GoodListener"),
                Credit(trackNumber: 1, trackName: "Area I", soundName: "StormInOregonRainforest", artist: "daveincamas"),
                Credit(trackNumber: 1, trackName: "Area I", soundName: "SummerInsectChorus", artist: "kvgarlc"),
                Credit(trackNumber: 1, trackName: "Area I", soundName: "Windy Autumn Forest Soundscape 2", artist: "Porphyr")
            ]),
            AreaCreditList(trackNumber: 2, areaName: "Area II", creditList: [
                Credit(trackNumber: 2, trackName: "Area II", soundName: "A tree is creaking in the patagonian forest of Argentina in a deep creaky sound", artist: "felix.blume"),
                Credit(trackNumber: 2, trackName: "Area II", soundName: "Birds Singing", artist: "ivolipa"),
                Credit(trackNumber: 2, trackName: "Area II", soundName: "Country side night ambience", artist: "marlo1981"),
                Credit(trackNumber: 2, trackName: "Area II", soundName: "Crickets in Manistee forest in Michigan", artist: "johnaudiotech"),
                Credit(trackNumber: 2, trackName: "Area II", soundName: "flys-I", artist: "galeku"),
                Credit(trackNumber: 2, trackName: "Area II", soundName: "Hulottes-Nièvte", artist: "thecityrings"),
                Credit(trackNumber: 2, trackName: "Area II", soundName: "Light forest rain", artist: "Corsica_S"),
                Credit(trackNumber: 2, trackName: "Area II", soundName: "LightningCrash", artist: "NoiseNoir"),
                Credit(trackNumber: 2, trackName: "Area II", soundName: "Owl", artist: "AndrewJonesFo"),
                Credit(trackNumber: 2, trackName: "Area II", soundName: "spooky fox", artist: "gezortenplotz"),
                Credit(trackNumber: 2, trackName: "Area II", soundName: "stream2", artist: "gluckose"),
                Credit(trackNumber: 2, trackName: "Area II", soundName: "Sylvia communis", artist: "urupin"),
                Credit(trackNumber: 2, trackName: "Area II", soundName: "Wind in the foliage of a tree, in California", artist: "felix.blume"),
                Credit(trackNumber: 2, trackName: "Area II", soundName: "Windy Autumn Forest Soundscape 2", artist: "Porphyr"),
                Credit(trackNumber: 2, trackName: "Area II", soundName: "woodpecker and other birds on a spring morning", artist: "Kyster")
            ]),
            AreaCreditList(trackNumber: 3, areaName: "Area III", creditList: [
                Credit(trackNumber: 3, trackName: "Area III", soundName: "33 bluemonkeys kakamega", artist: "LukeIRL"),
                Credit(trackNumber: 3, trackName: "Area III", soundName: "Asian Koels", artist: "genghis attenborough"),
                Credit(trackNumber: 3, trackName: "Area III", soundName: "big flying insects", artist: "arnaud coutancier"),
                Credit(trackNumber: 3, trackName: "Area III", soundName: "Birds and Jungle", artist: "Spankous"),
                Credit(trackNumber: 3, trackName: "Area III", soundName: "Borneo Jungle - Day", artist: "RTB45"),
                Credit(trackNumber: 3, trackName: "Area III", soundName: "Borneo Jungle - Night", artist: "RTB45"),
                Credit(trackNumber: 3, trackName: "Area III", soundName: "Jaguar whistle fx", artist: "quetzacontla"),
                Credit(trackNumber: 3, trackName: "Area III", soundName: "lar gibbon04", artist: "soundbytez"),
                Credit(trackNumber: 3, trackName: "Area III", soundName: "monkey jungle", artist: "soundbytez"),
                Credit(trackNumber: 3, trackName: "Area III", soundName: "Riflebird Flapping 4", artist: "digifishmusic"),
                Credit(trackNumber: 3, trackName: "Area III", soundName: "siamangs03", artist: "soundbytez"),
                Credit(trackNumber: 3, trackName: "Area III", soundName: "Small bird jungle sound", artist: "M4D3R0"),
                Credit(trackNumber: 3, trackName: "Area III", soundName: "Voice elephant", artist: "vataaa")
            ]),
            AreaCreditList(trackNumber: 4, areaName: "Area IV", creditList: [
                Credit(trackNumber: 4, trackName: "Area IV", soundName: "A tree is creaking in the patagonian forest of Argentina in a deep creaky sound", artist: "felix.blume"),
                Credit(trackNumber: 4, trackName: "Area IV", soundName: "Ape Cave", artist: "Corsica_S"),
                Credit(trackNumber: 4, trackName: "Area IV", soundName: "drops (in a cave)", artist: "arnaud coutancier"),
                Credit(trackNumber: 4, trackName: "Area IV", soundName: "Hallway stones over sandy floor", artist: "erpe"),
                Credit(trackNumber: 4, trackName: "Area IV", soundName: "Hundreds of bats screaming coming out of their nest", artist: "felix.blume"),
                Credit(trackNumber: 4, trackName: "Area IV", soundName: "Indy Rocks Falling Cue 4", artist: "pscsound"),
                Credit(trackNumber: 4, trackName: "Area IV", soundName: "Rockfall in mine", artist: "Benboncan"),
                Credit(trackNumber: 4, trackName: "Area IV", soundName: "Walking in a flooded mine", artist: "Benboncan")
            ]),
            AreaCreditList(trackNumber: 5, areaName: "Area V", creditList: [
                //No credits for Area V
            ]),
            AreaCreditList(trackNumber: 6, areaName: "Area VI", creditList: [
                Credit(trackNumber: 6, trackName: "Area VI", soundName: "02006 mountain wind", artist: "Robinhood76"),
                Credit(trackNumber: 6, trackName: "Area VI", soundName: "Asian Koels", artist: "genghis attenborough"),
                Credit(trackNumber: 6, trackName: "Area VI", soundName: "Hallway stones over sandy floor", artist: "erpe"),
                Credit(trackNumber: 6, trackName: "Area VI", soundName: "Indy Rocks Falling Cue 4", artist: "pscsound"),
                Credit(trackNumber: 6, trackName: "Area VI", soundName: "LightningCrash", artist: "NoiseNoir"),
                Credit(trackNumber: 6, trackName: "Area VI", soundName: "RAM Mouth Hawk dry v1", artist: "reidedo"),
                Credit(trackNumber: 6, trackName: "Area VI", soundName: "Riflebird Flapping 4", artist: "digifishmusic"),
                Credit(trackNumber: 6, trackName: "Area VI", soundName: "Rockfall in mine", artist: "Benboncan"),
                Credit(trackNumber: 6, trackName: "Area VI", soundName: "Seagulls 1.wav", artist: "GoodListener"),
                Credit(trackNumber: 6, trackName: "Area VI", soundName: "Wind", artist: "ERH"),
                Credit(trackNumber: 6, trackName: "Area VI", soundName: "Wind howling and singing in a sign", artist: "felix.blume"),
            ]),
            AreaCreditList(trackNumber: 7, areaName: "Area VII", creditList: [
                Credit(trackNumber: 7, trackName: "Area VII", soundName: "20120714 buzz", artist: "dobride"),
                Credit(trackNumber: 7, trackName: "Area VII", soundName: "Bees getting a drink", artist: "tbaucom"),
                Credit(trackNumber: 7, trackName: "Area VII", soundName: "big flying insects", artist: "arnaud coutancier"),
                Credit(trackNumber: 7, trackName: "Area VII", soundName: "flys-I", artist: "galeku"),
                Credit(trackNumber: 7, trackName: "Area VII", soundName: "Footsteps, wading, walking in water", artist: "YleArkisto"),
                Credit(trackNumber: 7, trackName: "Area VII", soundName: "Owl", artist: "AndrewJonesFo"),
                Credit(trackNumber: 7, trackName: "Area VII", soundName: "siamangs03", artist: "soundbytez"),
            ]),
            AreaCreditList(trackNumber: 8, areaName: "Area VIII", creditList: [
                Credit(trackNumber: 8, trackName: "Area VIII", soundName: "130721 Biokovo", artist: "blaukreuz"),
                Credit(trackNumber: 8, trackName: "Area VIII", soundName: "Bees getting a drink", artist: "tbaucom"),
                Credit(trackNumber: 8, trackName: "Area VIII", soundName: "Crickets in the desert", artist: "felix.blume"),
                Credit(trackNumber: 8, trackName: "Area VIII", soundName: "Desert at night", artist: "kangaroovindalc"),
                Credit(trackNumber: 8, trackName: "Area VIII", soundName: "grizzly fumaroles", artist: "hoersturz"),
                Credit(trackNumber: 8, trackName: "Area VIII", soundName: "RAM Mouth Hawk dry v1", artist: "reidedo"),
                Credit(trackNumber: 8, trackName: "Area VIII", soundName: "Sea - Ocean - Beach - Close", artist: "nebulousflynn"),
            ]),
            AreaCreditList(trackNumber: 9, areaName: "Area IX", creditList: [
                Credit(trackNumber: 9, trackName: "Area IX", soundName: "A couple of bears growing, brown bear", artist: "YleArkisto"),
                Credit(trackNumber: 9, trackName: "Area IX", soundName: "blue whale D walls", artist: "MBARI_MARS"),
                Credit(trackNumber: 9, trackName: "Area IX", soundName: "Heavy snow storm", artist: "martypinso"),
                Credit(trackNumber: 9, trackName: "Area IX", soundName: "Ice 2", artist: "Benboncan"),
                Credit(trackNumber: 9, trackName: "Area IX", soundName: "Ice cracking, crashing and banging, melting, crevasses", artist: "YleArkisto"),
                Credit(trackNumber: 9, trackName: "Area IX", soundName: "Waves from the sea on the beach", artist: "felix.blume"),
                Credit(trackNumber: 9, trackName: "Area IX", soundName: "Wind", artist: "ERH"),
            ]),
            AreaCreditList(trackNumber: 10, areaName: "Area X", creditList: [
                Credit(trackNumber: 10, trackName: "Area X", soundName: "A couple of bears growing, brown bear", artist: "YleArkisto"),
                Credit(trackNumber: 10, trackName: "Area X", soundName: "blue whale D walls", artist: "MBARI_MARS"),
                Credit(trackNumber: 10, trackName: "Area X", soundName: "Flock of seagulls", artist: "juskiddink"),
                Credit(trackNumber: 10, trackName: "Area X", soundName: "Heavy snow storm", artist: "martypinso"),
                Credit(trackNumber: 10, trackName: "Area X", soundName: "Ice 2", artist: "Benboncan"),
                Credit(trackNumber: 10, trackName: "Area X", soundName: "Ice cracking, crashing and banging, melting, crevasses", artist: "YleArkisto"),
                Credit(trackNumber: 10, trackName: "Area X", soundName: "Lapping waves", artist: "Benboncan"),
                Credit(trackNumber: 10, trackName: "Area X", soundName: "LightningCrash", artist: "NoiseNoir"),
                Credit(trackNumber: 10, trackName: "Area X", soundName: "Rowing 2", artist: "juskiddink"),
                Credit(trackNumber: 10, trackName: "Area X", soundName: "Waves from the sea on the beach", artist: "felix.blume"),
                Credit(trackNumber: 10, trackName: "Area X", soundName: "Wind", artist: "ERH")
            ]),
            AreaCreditList(trackNumber: 11, areaName: "Area XI", creditList: [
                //No credits for Area XI
            ]),
            AreaCreditList(trackNumber: 12, areaName: "Area XII", creditList: [
                //No credits for Area XII
            ])
        ]
        
    }

    
    // MARK: - Table Header Theming
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.brown
        header.textLabel?.font = header.textLabel?.font.withSize(20)
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ([
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
        ])[section]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return areaCreditLists.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if areaCreditLists[section].creditList.count == 0 {
            return 1
        }
        return areaCreditLists[section].creditList.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "creditCell", for: indexPath)

        // Configure the cell...

        let area = areaCreditLists[indexPath.section]
        
        if area.creditList.count == 0 {
            cell.textLabel!.text = "No credits for this track"
            cell.detailTextLabel!.text = ""
        } else {
            let credit = area.creditList[indexPath.item]
            cell.textLabel!.text = credit.soundName
            cell.detailTextLabel!.text = "Artist: \(credit.artist)"
        }

        return cell
    }

}
