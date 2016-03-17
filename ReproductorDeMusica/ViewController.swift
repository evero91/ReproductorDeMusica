//
//  ViewController.swift
//  ReproductorDeMusica
//
//  Created by Everardo Guevara Soto on 17/03/16.
//  Copyright © 2016 Everardo Guevara Soto. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var portada: UIImageView!
    @IBOutlet weak var pickerCanciones: UIPickerView!
    @IBOutlet weak var controlVolumen: UIStepper!
    
    private var canciones: Array<Array<String>> = []
    private var miSonido: SystemSoundID = 0
    private var reproductor: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canciones.append(["Sins Of The Father", "pp4", "Sins of The Father"])
        canciones.append(["Nuclear", "pp1", "The Phantom Pain Nuclear"])
        canciones.append(["The Man Who Sold The World", "pp5", "The Man Who Sold The World"])
        canciones.append(["Elogia", "pp2", "Elogia"])
        canciones.append(["Here's To You", "pp3", "Here's To You"])
        
        let sonidoURL = NSBundle.mainBundle().URLForResource("mgsCodec", withExtension: "mp3")
        AudioServicesCreateSystemSoundID(sonidoURL! as CFURL, &miSonido)
        
        do {
            try reproductor = AVAudioPlayer(contentsOfURL: NSBundle.mainBundle().URLForResource(canciones[0][2], withExtension: "mp3")!)
            portada.image = UIImage(named: canciones[0][1])
        } catch {
            portada.image = UIImage(named: "itb")
            print("Error al cargar archivo de sonido")
        }
    }
    
    @IBAction func play() {
        AudioServicesPlaySystemSound(miSonido)
        if !reproductor.playing {
            reproductor.play()
        }
    }
    
    @IBAction func pause() {
        AudioServicesPlaySystemSound(miSonido)
        if reproductor.playing {
            reproductor.pause()
        }
    }
    
    @IBAction func stop() {
        AudioServicesPlaySystemSound(miSonido)
        if reproductor.playing {
            reproductor.stop()
            reproductor.currentTime = 0.0
        }
    }
    
    @IBAction func shuffle() {
        let nCancion = Int(arc4random()) % canciones.count
        pickerCanciones.selectRow(nCancion, inComponent: 0, animated: true)
        pickerView(pickerCanciones, didSelectRow: nCancion, inComponent: 0)
        play()
    }
    
    @IBAction func cambioVolumen() {
        reproductor.volume = Float(controlVolumen.value / 10)
    }
    
// MARK: UIPickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return canciones.count
    }
    
// MARK: UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: canciones[row][0], attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        do {
            try reproductor = AVAudioPlayer(contentsOfURL: NSBundle.mainBundle().URLForResource(canciones[row][2], withExtension: "mp3")!)
            portada.image = UIImage(named: canciones[row][1])
            play()
        } catch {
            portada.image = UIImage(named: "itb")
            print("Error al cargar archivo de sonido")
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return canciones[row][0]
    }

}
