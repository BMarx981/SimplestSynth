//
//  ViewController.swift
//  SimpleSynth
//
//  Created by Marx, Brian on 12/22/16.
//  Copyright © 2016 Marx, Brian. All rights reserved.
//

import UIKit
import AudioKit

class ViewController: UIViewController {
    
    var osc1: AKOscillator?
    var osc2: AKOscillator?
    var oscMixer: AKMixer?
    var filter: AKLowPassFilter?
    var mixer: AKMixer?
    var mainFilterFreq = 2000.0
    var mainFilterRes = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        osc1 = AKOscillator(waveform: AKTable(.sawtooth))
        osc2 = AKOscillator(waveform: AKTable(.square))
        oscMixer = AKMixer(osc1!, osc2!)
        filter = AKLowPassFilter(oscMixer!, cutoffFrequency: mainFilterFreq, resonance: mainFilterRes)
        filter?.start()
        mixer = AKMixer(filter!)
        mixer?.start()
        
        AudioKit.output = mixer
        AudioKit.start()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func OscSlider(_ sender: UISlider) {
        osc1?.frequency = pow(10, Double(sender.value))
        osc2?.frequency = pow(10, Double(sender.value))
    }
    
    @IBAction func ResSlider(_ sender: UISlider) {
        filter?.cutoffFrequency = pow(10,Double(sender.value))
    }
    
    
    @IBAction func PlayStop(_ sender: UIButton) {
        
        if (osc1?.isPlaying)! {
            osc1?.stop()
            osc2?.stop()
            sender.setTitle("Play", for: .normal)
            sender.setTitleColor(UIColor.blue, for: .normal)

        } else {
            osc1?.start()
            osc2?.start()
            sender.setTitle("Stop", for: .normal)
            sender.setTitleColor(UIColor.red, for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

