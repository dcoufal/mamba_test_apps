//
//  ViewController.swift
//  mamba_tvos_carthage_test
//
//  Created by David Coufal on 12/20/17.
//  Copyright © 2017 David Coufal.
//  Released under an MIT license: https://opensource.org/licenses/MIT
//

import UIKit
import mamba

class ViewController: UIViewController {

    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var testsLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        versionLabel.text = "Version: \(Mamba.version)"
        
        let data = manifestString.data(using: .utf8)!
        let url = URL(string: "http://media.example.com/master.m3u8")!
        
        let parser = HLSParser()
        
        do {
            let playlist = try parser.parse(playlistData: data, url: url)
            if playlist.tags.count == 9 {
                
                let stream = OutputStream.toMemory()
                stream.open()
                
                defer {
                    stream.close()
                }
                
                let writer = HLSWriter()
                try writer.write(hlsPlaylist: playlist, toStream: stream)
                
                if let error = stream.streamError {
                    self.testsLabel.text = "Tests: FAILED WITH WRITE STREAM ERROR: \(error)"
                    self.testsLabel.textColor = UIColor.red
                    return
                }
                
                guard let data = stream.property(forKey: .dataWrittenToMemoryStreamKey) as? Data else {
                    self.testsLabel.text = "Tests: FAILED WITH NO DATA AVILABLE FROM WRITE"
                    self.testsLabel.textColor = UIColor.red
                    return
                }
                
                guard let returnedPlaylist = String(data: data, encoding: .utf8) else {
                    self.testsLabel.text = "Tests: FAILED WITH WRITE DATA NOT CONVERTABLE TO STRING"
                    self.testsLabel.textColor = UIColor.red
                    return
                }
                
                // do some spot checks on output playlist
                guard
                    returnedPlaylist.contains("#EXT-X-TARGETDURATION:10"),
                    returnedPlaylist.contains("http://media.example.com/entire1.ts"),
                    returnedPlaylist.contains("IV=0x9c7db8778570d05c3177c349fd9236aa") else {
                        self.testsLabel.text = "Tests: FAILED WITH UNEXPECTED WRITE OUTPUT"
                        self.testsLabel.textColor = UIColor.red
                        return
                }
                
                self.testsLabel.text = "Tests: PASSED"
                self.testsLabel.textColor = UIColor.green
            }
            else {
                self.testsLabel.text = "Tests: FAILED WITH UNEXPECTED PARSED CONTENT"
                self.testsLabel.textColor = UIColor.red
            }
        }
        catch {
            self.testsLabel.text = "Tests: FAILED WITH EXCEPTION \(error)"
            self.testsLabel.textColor = UIColor.red
        }
    }
}

let manifestString = """
#EXTM3U
#EXT-X-VERSION:4
#EXT-X-TARGETDURATION:10
#EXT-X-KEY:METHOD=SAMPLE-AES,URI="https://priv.example.com/key.php?r=52",IV=0x9c7db8778570d05c3177c349fd9236aa,KEYFORMAT="com.apple.streamingkeydelivery",KEYFORMATVERSIONS="1"
#EXTINF:2,
http://media.example.com/entire.ts
#EXT-X-DISCONTINUITY
#EXTINF:2.002
http://media.example.com/entire1.ts
#EXT-X-ENDLIST
"""
