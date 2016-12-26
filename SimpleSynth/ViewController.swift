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
    var osc3: AKOscillator?
    var osc4: AKOscillator?
    var oscMixer: AKMixer?
    var lp: AKLowPassFilter?
    var bp: AKBandPassFilter?
    var hp: AKHighPassFilter?
    var filter: AKMixer?
    var mixer: AKMixer?
    var mainFilterFreq = 2000.0
    var mainFilterRes = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        osc1 = AKOscillator(waveform: AKTable(.sawtooth))
        osc2 = AKOscillator(waveform: AKTable(.square))
        osc3 = AKOscillator(waveform: AKTable(.triangle))
        osc4 = AKOscillator(waveform: AKTable(.sine))
        oscMixer = AKMixer(osc1!, osc2!, osc3!, osc4!)
        
        lp = AKLowPassFilter(oscMixer!, cutoffFrequency: mainFilterFreq)
        bp = AKBandPassFilter(oscMixer!, centerFrequency: mainFilterFreq)
        hp = AKHighPassFilter(oscMixer!, cutoffFrequency: mainFilterFreq)
        filter = AKMixer(lp!,bp!,hp!)
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
        osc3?.frequency = pow(10, Double(sender.value))
        osc4?.frequency = pow(10, Double(sender.value))
    }
    
    @IBAction func ResSlider(_ sender: UISlider) {
        lp?.cutoffFrequency = pow(10,Double(sender.value))
        bp?.centerFrequency = pow(10,Double(sender.value))
        hp?.cutoffFrequency = pow(10,Double(sender.value))
    }
    
    @IBAction func OscSelector(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                osc1?.amplitude = 1.0
                osc2?.amplitude = 0.0
                osc3?.amplitude = 0.0
                osc4?.amplitude = 0.0
            case 1:
                osc1?.amplitude = 0.0
                osc2?.amplitude = 1.0
                osc3?.amplitude = 0.0
                osc4?.amplitude = 0.0
            case 2:
                osc1?.amplitude = 0.0
                osc2?.amplitude = 0.0
                osc3?.amplitude = 1.0
                osc4?.amplitude = 0.0
            case 3:
                osc1?.amplitude = 0.0
                osc2?.amplitude = 0.0
                osc3?.amplitude = 0.0
                osc4?.amplitude = 1.0
            default: break
        }//end switch
    }
    
    @IBAction func FilterSelector(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            //low pass
            case 0:
                lp?.start()
                bp?.stop()
                hp?.stop()
            //band pass
            case 1:
                lp?.stop()
                bp?.start()
                hp?.stop()
            //high pass
            case 2:
                lp?.stop()
                bp?.stop()
                hp?.start()
            //None. bypass filters
            case 3:
                lp?.bypass()
                bp?.stop()
                hp?.stop()
            default: break
        }
    }
    @IBAction func PlayStop(_ sender: UIButton) {
        
        if (osc1?.isPlaying)! {
            osc1?.stop()
            osc2?.stop()
            osc3?.stop()
            osc4?.stop()
            sender.setTitle("Play", for: .normal)
            sender.setTitleColor(UIColor.blue, for: .normal)

        } else {
            osc1?.start()
            osc2?.start()
            osc3?.start()
            osc4?.start()
            sender.setTitle("Stop", for: .normal)
            sender.setTitleColor(UIColor.red, for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

