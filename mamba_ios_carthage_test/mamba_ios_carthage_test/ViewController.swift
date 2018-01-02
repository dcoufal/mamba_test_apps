//
//  ViewController.swift
//  mamba_ios_carthage_test
//
//  Created by David Coufal on 12/20/17.
//  Copyright © 2017 David Coufal.
//  Released under an MIT license: https://opensource.org/licenses/MIT
//

import UIKit
import mamba

class ViewController: UIViewController {

    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var testLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        versionLabel.text = "Version: \(Mamba.version)"
        
        let data = manifestString.data(using: .utf8)!
        let url = URL(string: "http://media.example.com/master.m3u8")!
        
        let parser = HLSParser()
        
        do {
            let manifest = try parser.parse(playlistData: data, url: url)
            if manifest.tags.count == 9 {
                self.testLabel.text = "Tests: PASSED"
                self.testLabel.textColor = UIColor.green
            }
            else {
                self.testLabel.text = "Tests: FAILED WITH UNEXPECTED OUTPUT"
                self.testLabel.textColor = UIColor.red
            }
        }
        catch {
            self.testLabel.text = "Tests: FAILED WITH EXCEPTION \(error)"
            self.testLabel.textColor = UIColor.red
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
