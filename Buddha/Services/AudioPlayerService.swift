//
//  AudioPlayerService.swift
//  Buddha
//
//  Created by Weijia Huang on 12/14/25.
//

import Foundation
import AVFoundation
import Combine
import MediaPlayer
import UIKit

class AudioPlayerService: ObservableObject {
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var currentTrack: AudioTrack?
    
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    
    enum AudioTrack: String, CaseIterable {
        case heartSutra = "heart_sutra_audio"
        case greatCompassion = "大悲咒_audio"
        
        var displayName: String {
            switch self {
            case .heartSutra:
                return "Heart Sutra (心經)"
            case .greatCompassion:
                return "Great Compassion Mantra (大悲咒)"
            }
        }
        
        var fileName: String {
            return rawValue
        }
    }
    
    init() {
        setupRemoteCommandCenter()
    }
    
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [.allowBluetooth])
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    private func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.play()
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.pause()
            return .success
        }
        
        commandCenter.stopCommand.addTarget { [weak self] _ in
            self?.stop()
            return .success
        }
        
        commandCenter.togglePlayPauseCommand.addTarget { [weak self] _ in
            if self?.isPlaying == true {
                self?.pause()
            } else {
                self?.play()
            }
            return .success
        }
    }
    
    private func updateNowPlayingInfo() {
        guard let track = currentTrack, let player = audioPlayer else { return }
        
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = track.displayName
        nowPlayingInfo[MPMediaItemPropertyArtist] = "Buddha"
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func loadTrack(_ track: AudioTrack) {
        guard let url = Bundle.main.url(forResource: track.fileName, withExtension: "mp3") else {
            print("Could not find audio file: \(track.fileName).mp3")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = AudioPlayerDelegate(service: self)
            audioPlayer?.prepareToPlay()
            
            duration = audioPlayer?.duration ?? 0
            currentTrack = track
            currentTime = 0
            updateNowPlayingInfo()
        } catch {
            print("Failed to load audio: \(error)")
        }
    }
    
    func play() {
        guard let player = audioPlayer else { return }
        
        // Setup audio session category first
        setupAudioSession()
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            // Activate session
            try audioSession.setActive(true)
        } catch {
            print("Failed to activate audio session: \(error)")
            return
        }
        
        if player.play() {
            isPlaying = true
            startTimer()
            updateNowPlayingInfo()
        }
    }
    
    func pause() {
        audioPlayer?.pause()
        isPlaying = false
        stopTimer()
        updateNowPlayingInfo()
    }
    
    func stop() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        isPlaying = false
        currentTime = 0
        stopTimer()
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }
    
    func seek(to time: TimeInterval) {
        audioPlayer?.currentTime = time
        currentTime = time
    }
    
    private func startTimer() {
        stopTimer()
        timer = Timer(timeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let player = self.audioPlayer else { return }
            DispatchQueue.main.async {
                self.currentTime = player.currentTime
                self.updateNowPlayingInfo()
            }
        }
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    fileprivate func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        stop()
    }
}

private class AudioPlayerDelegate: NSObject, AVAudioPlayerDelegate {
    weak var service: AudioPlayerService?
    
    init(service: AudioPlayerService) {
        self.service = service
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        service?.isPlaying = false
        service?.currentTime = 0
        service?.stopTimer()
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }
}

