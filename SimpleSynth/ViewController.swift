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
    var lpMixer: AKMixer?
    var bp: AKBandPassFilter?
    var bpMixer: AKMixer?
    var hp: AKHighPassFilter?
    var hpMixer: AKMixer?
    var filter: AKMixer?
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
        lpMixer = AKMixer(lp!)
        bp = AKBandPassFilter(oscMixer!, centerFrequency: mainFilterFreq)
        bpMixer = AKMixer(bp!)
        hp = AKHighPassFilter(oscMixer!, cutoffFrequency: mainFilterFreq)
        hpMixer = AKMixer(hp!)
        filter = AKMixer(lpMixer!,bpMixer!,hpMixer!)
        filter?.start()
        
        AudioKit.output = filter
        AudioKit.start()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func OscSlider(_ sender: UISlider) {
        osc1?.frequency = pow(10, Double(sender.value))
        osc2?.frequency = pow(10, Double(sender.value))
        osc3?.frequency = pow(10, Double(sender.value))
        osc4?.frequency = pow(10, Double(sender.value))
    }
    
    @IBAction func FilterSlider(_ sender: UISlider) {
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
        lp?.start()
        hp?.start()
        hp?.start()
        switch sender.selectedSegmentIndex {
            //low pass
            case 0:
                lpMixer?.volume = 1.0
                bpMixer?.volume = 0.0
                hpMixer?.volume = 0.0
            //band pass
            case 1:
                lpMixer?.volume = 0.0
                bpMixer?.volume = 1.0
                hpMixer?.volume = 0.0
            //high pass
            case 2:
                lpMixer?.volume = 0.0
                bpMixer?.volume = 0.0
                hpMixer?.volume = 1.0
            //None. bypass filters
            case 3:
                print("bypass bull shit")
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

