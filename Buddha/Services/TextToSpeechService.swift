//
//  TextToSpeechService.swift
//  Buddha
//
//  Created by Weijia Huang on 12/14/25.
//

import Foundation
import AVFoundation
import Combine

class TextToSpeechService: NSObject, ObservableObject {
    @Published var isSpeaking = false
    @Published var currentVerse: Verse?
    @Published var speakingProgress: Double = 0.0
    
    private let synthesizer = AVSpeechSynthesizer()
    private var allVerses: [Verse] = []
    private var currentIndex: Int = 0
    private var utterance: AVSpeechUtterance?
    
    override init() {
        super.init()
        synthesizer.delegate = self
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .spokenAudio, options: [.allowBluetooth, .allowBluetoothA2DP, .duckOthers])
            try audioSession.setActive(true, options: [])
        } catch {
            print("Failed to setup audio session for TTS: \(error)")
        }
    }
    
    func speakVerses(_ verses: [Verse], startingFrom index: Int = 0) {
        guard !verses.isEmpty else { return }
        
        stop()
        allVerses = verses
        currentIndex = max(0, min(index, verses.count - 1))
        
        speakCurrentVerse()
    }
    
    func speakVerse(_ verse: Verse) {
        stop()
        allVerses = [verse]
        currentIndex = 0
        speakCurrentVerse()
    }
    
    private func speakCurrentVerse() {
        guard currentIndex < allVerses.count else {
            stop()
            return
        }
        
        // Reactivate audio session before speaking
        do {
            try AVAudioSession.sharedInstance().setActive(true, options: [])
        } catch {
            print("Failed to activate audio session: \(error)")
        }
        
        let verse = allVerses[currentIndex]
        currentVerse = verse
        
        // Use English text, or fallback to pinyin or chinese
        let textToSpeak = verse.text.isEmpty ? (verse.pinyin ?? verse.chinese ?? "") : verse.text
        
        guard !textToSpeak.isEmpty else {
            // Skip empty verses and move to next
            currentIndex += 1
            speakCurrentVerse()
            return
        }
        
        let utterance = AVSpeechUtterance(string: textToSpeak)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.85 // Slightly slower for clarity
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0
        
        self.utterance = utterance
        synthesizer.speak(utterance)
        DispatchQueue.main.async {
            self.isSpeaking = true
        }
    }
    
    func pause() {
        synthesizer.pauseSpeaking(at: .immediate)
        DispatchQueue.main.async {
            self.isSpeaking = false
        }
    }
    
    func continueSpeaking() {
        synthesizer.continueSpeaking()
        DispatchQueue.main.async {
            self.isSpeaking = true
        }
    }
    
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        DispatchQueue.main.async {
            self.isSpeaking = false
            self.currentVerse = nil
            self.speakingProgress = 0.0
        }
        currentIndex = 0
        allVerses = []
    }
    
    func skipToNext() {
        guard isSpeaking else { return }
        synthesizer.stopSpeaking(at: .immediate)
        currentIndex += 1
        speakCurrentVerse()
    }
    
    func skipToPrevious() {
        guard currentIndex > 0 else { return }
        synthesizer.stopSpeaking(at: .immediate)
        currentIndex -= 1
        speakCurrentVerse()
    }
}

extension TextToSpeechService: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = true
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        // Move to next verse
        currentIndex += 1
        if currentIndex < allVerses.count {
            speakCurrentVerse()
        } else {
            // Finished all verses
            DispatchQueue.main.async {
                self.isSpeaking = false
                self.currentVerse = nil
                self.speakingProgress = 0.0
            }
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = false
            self.speakingProgress = 0.0
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        // Update progress
        let text = utterance.speechString as NSString
        let progress = Double(characterRange.location + characterRange.length) / Double(text.length)
        DispatchQueue.main.async {
            self.speakingProgress = progress
        }
    }
}

