//
//  AudioView.swift
//  Buddha
//
//  Created by Weijia Huang on 12/14/25.
//

import SwiftUI
import AVFoundation

struct AudioView: View {
    @StateObject private var audioPlayer = AudioPlayerService()
    
    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    Spacer(minLength: 0)
                    VStack(spacing: 20) {
                        ForEach(AudioPlayerService.AudioTrack.allCases, id: \.self) { track in
                            AudioTrackCard(track: track, audioPlayer: audioPlayer)
                        }
                    }
                    .frame(maxWidth: 600)
                    .padding(.horizontal)
                    Spacer(minLength: 0)
                }
            }
            .navigationTitle("Audio")
        }
        .navigationViewStyle(.stack)
    }
}

struct AudioTrackCard: View {
    let track: AudioPlayerService.AudioTrack
    @ObservedObject var audioPlayer: AudioPlayerService
    
    var isCurrentTrack: Bool {
        audioPlayer.currentTrack == track
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Track Info
            HStack {
                Image(systemName: "music.note")
                    .font(.title)
                    .foregroundColor(.blue)
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(track.displayName)
                        .font(.headline)
                    
                    if isCurrentTrack {
                        Text("Now Playing")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
                
                Spacer()
                
                if isCurrentTrack {
                    Button(action: {
                        if audioPlayer.isPlaying {
                            audioPlayer.pause()
                        } else {
                            if audioPlayer.currentTrack != track {
                                audioPlayer.loadTrack(track)
                            }
                            audioPlayer.play()
                        }
                    }) {
                        Image(systemName: audioPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                } else {
                    Button(action: {
                        audioPlayer.loadTrack(track)
                        audioPlayer.play()
                    }) {
                        Image(systemName: "play.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                }
            }
            
            // Progress Bar (only show for current track)
            if isCurrentTrack && audioPlayer.duration > 0 {
                VStack(spacing: 8) {
                    ProgressView(value: audioPlayer.currentTime, total: audioPlayer.duration)
                        .tint(.blue)
                    
                    HStack {
                        Text(formatTime(audioPlayer.currentTime))
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text(formatTime(audioPlayer.duration))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

#Preview {
    AudioView()
}

