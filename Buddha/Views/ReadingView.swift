//
//  ReadingView.swift
//  Buddha
//
//  Created by Weijia Huang on 12/14/25.
//

import SwiftUI
import SwiftData

struct ReadingView: View {
    let textTitle: String
    let chapterNumber: Int
    
    @Query private var texts: [BuddhistText]
    @Query private var bookmarks: [Bookmark]
    @Query private var highlights: [Highlight]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @AppStorage("fontSize") private var fontSize: Double = 16
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("showEnglishTranslation") private var showEnglishTranslation: Bool = true
    
    // Initialize based on locale if not already set
    private func initializeEnglishTranslationSetting() {
        if UserDefaults.standard.object(forKey: "showEnglishTranslation") == nil {
            showEnglishTranslation = LocalizationService.shouldShowEnglishByDefault
        }
    }
    
    @State private var selectedVerse: Verse? = nil
    @State private var showNoteSheet = false
    @State private var showHighlightSheet = false
    @State private var showSettingsSheet = false
    @State private var showChapterList = false
    @StateObject private var ttsService = TextToSpeechService()
    
    var currentText: BuddhistText? {
        texts.first { $0.title == textTitle }
    }
    
    var currentChapter: Chapter? {
        currentText?.chapters.first { $0.number == chapterNumber }
    }
    
    var sortedVerses: [Verse] {
        currentChapter?.verses.sorted(by: { $0.number < $1.number }) ?? []
    }
    
    var sortedChapters: [Chapter] {
        currentText?.chapters.sorted(by: { $0.number < $1.number }) ?? []
    }
    
    var previousChapter: Chapter? {
        guard let current = currentChapter else { return nil }
        return sortedChapters.last { $0.number < current.number }
    }
    
    var nextChapter: Chapter? {
        guard let current = currentChapter else { return nil }
        let next = sortedChapters.first { $0.number > current.number }
        return next
    }
    
    var body: some View {
        Group {
            if let chapter = currentChapter {
                ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Chapter Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text(chapter.title)
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("\(textTitle) - \(String(format: NSLocalizedString("Chapter %d", comment: ""), chapter.number))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Verses
                    ForEach(sortedVerses, id: \.id) { verse in
                        VerseView(
                            verse: verse,
                            textTitle: textTitle,
                            chapterNumber: chapterNumber,
                            fontSize: fontSize,
                            showEnglishTranslation: showEnglishTranslation,
                            isHighlighted: isVerseHighlighted(verse),
                            highlightColor: getHighlightColor(for: verse),
                            onLongPress: {
                                selectedVerse = verse
                            },
                            onNote: {
                                selectedVerse = verse
                                showNoteSheet = true
                            },
                            onHighlight: {
                                selectedVerse = verse
                                showHighlightSheet = true
                            }
                        )
                        .padding(.horizontal)
                    }
                    
                    // Chapter Navigation
                    HStack(spacing: 20) {
                        if let prevChapter = previousChapter {
                            NavigationLink(destination: ReadingView(textTitle: textTitle, chapterNumber: prevChapter.number)) {
                                HStack {
                                    Image(systemName: "chevron.left")
                                    Text(String(format: NSLocalizedString("Chapter %d", comment: ""), prevChapter.number))
                                }
                                .font(.subheadline)
                                .foregroundColor(.purple)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                            }
                        } else {
                            Spacer()
                                .frame(maxWidth: .infinity)
                        }
                        
                        if let nextChapter = nextChapter {
                            NavigationLink(destination: ReadingView(textTitle: textTitle, chapterNumber: nextChapter.number)) {
                                HStack {
                                    Text(String(format: NSLocalizedString("Chapter %d", comment: ""), nextChapter.number))
                                    Image(systemName: "chevron.right")
                                }
                                .font(.subheadline)
                                .foregroundColor(.purple)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                            }
                        } else {
                            Spacer()
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                }
                .padding(.bottom, 100)
            }
            .navigationTitle(textTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if let nextChapter = nextChapter {
                        // Use the bottom navigation button's approach - it works reliably
                        // We'll create a NavigationLink that matches the working pattern
                        NavigationLink(destination: ReadingView(textTitle: textTitle, chapterNumber: nextChapter.number)) {
                            HStack(spacing: 4) {
                                Text("Next")
                                Image(systemName: "chevron.right")
                            }
                            .font(.subheadline)
                        }
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Button(action: {
                        showChapterList = true
                    }) {
                        Text(String(format: NSLocalizedString("Ch. %d", comment: ""), chapterNumber))
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 12) {
                        // TTS Control Button
                        Button(action: {
                            if ttsService.isSpeaking {
                                ttsService.pause()
                            } else {
                                if ttsService.currentVerse == nil {
                                    ttsService.speakVerses(sortedVerses)
                                } else {
                                    ttsService.continueSpeaking()
                                }
                            }
                        }) {
                            Image(systemName: ttsService.isSpeaking ? "pause.circle.fill" : "speaker.wave.2.fill")
                                .font(.title3)
                        }
                        .disabled(sortedVerses.isEmpty)
                        
                        Menu {
                            Button(action: { showSettingsSheet = true }) {
                                Label("Settings", systemImage: "gearshape")
                            }
                            
                            Button(action: { addBookmark() }) {
                                Label("Bookmark", systemImage: "bookmark")
                            }
                            
                            Button(action: { 
                                if selectedVerse != nil {
                                    showNoteSheet = true
                                }
                            }) {
                                Label("Add Note", systemImage: "note.text")
                            }
                            
                            Button(action: { 
                                if selectedVerse != nil {
                                    showHighlightSheet = true
                                }
                            }) {
                                Label("Highlight", systemImage: "highlighter")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
            }
            .sheet(isPresented: $showNoteSheet) {
                if let verse = selectedVerse {
                    NoteEditView(
                        textTitle: textTitle,
                        chapterNumber: chapterNumber,
                        verseNumber: verse.number,
                        verseText: verse.text
                    )
                }
            }
            .sheet(isPresented: $showHighlightSheet) {
                if let verse = selectedVerse {
                    HighlightColorPickerView(
                        textTitle: textTitle,
                        chapterNumber: chapterNumber,
                        verseNumber: verse.number,
                        verseText: verse.text
                    )
                }
            }
            .sheet(isPresented: $showSettingsSheet) {
                ReadingSettingsView()
            }
            .sheet(isPresented: $showChapterList) {
                ChapterListView(
                    textTitle: textTitle,
                    chapters: sortedChapters,
                    currentChapterNumber: chapterNumber,
                    onChapterSelected: { chapterNum in
                        showChapterList = false
                        // Navigation will happen via the NavigationLink
                    }
                )
            }
            .onAppear {
                initializeEnglishTranslationSetting()
                saveReadingHistory()
            }
            .onDisappear {
                ttsService.stop()
            }
            .overlay(alignment: .bottom) {
                // TTS Controls Bar
                if ttsService.isSpeaking || ttsService.currentVerse != nil {
                    TTSControlBar(ttsService: ttsService, sortedVerses: sortedVerses)
                }
            }
            } else {
                VStack(spacing: 16) {
                    Text("Chapter not found")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text(String(format: NSLocalizedString("Looking for: Chapter %d", comment: ""), chapterNumber))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    if let text = currentText {
                        let chaptersList = text.chapters.map { $0.number }.sorted().map { String($0) }.joined(separator: ", ")
                        Text(String(format: NSLocalizedString("Available chapters: %@", comment: ""), chaptersList))
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding()
                    }
                }
                .padding()
            }
        }
    }
    
    private func isVerseHighlighted(_ verse: Verse) -> Bool {
        highlights.contains { $0.textTitle == textTitle && 
                             $0.chapterNumber == chapterNumber && 
                             $0.verseNumber == verse.number }
    }
    
    private func getHighlightColor(for verse: Verse) -> Color? {
        guard let highlight = highlights.first(where: { $0.textTitle == textTitle && 
                                                       $0.chapterNumber == chapterNumber && 
                                                       $0.verseNumber == verse.number }) else {
            return nil
        }
        return Color.fromString(highlight.color)
    }
    
    private func addBookmark() {
        if let chapter = currentChapter {
            let bookmark = Bookmark(
                text: chapter.title,
                textTitle: textTitle,
                chapterNumber: chapterNumber
            )
            modelContext.insert(bookmark)
            try? modelContext.save()
        }
    }
    
    private func saveReadingHistory() {
        let existing = readingHistory.first { $0.textTitle == textTitle && $0.chapterNumber == chapterNumber }
        if let existing = existing {
            existing.lastReadAt = Date()
        } else {
            let history = ReadingHistory(textTitle: textTitle, chapterNumber: chapterNumber)
            modelContext.insert(history)
        }
        try? modelContext.save()
    }
    
    @Query private var readingHistory: [ReadingHistory]
}

struct VerseView: View {
    let verse: Verse
    let textTitle: String
    let chapterNumber: Int
    let fontSize: Double
    let showEnglishTranslation: Bool
    let isHighlighted: Bool
    let highlightColor: Color?
    let onLongPress: () -> Void
    let onNote: () -> Void
    let onHighlight: () -> Void
    
    var hasMultiLineFormat: Bool {
        verse.notation != nil || verse.pinyin != nil || verse.chinese != nil
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(verse.number)")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .frame(width: 30, alignment: .trailing)
            
            VStack(alignment: .leading, spacing: 6) {
                // Multi-line format (notation, pinyin, chinese, english)
                if hasMultiLineFormat {
                    if let notation = verse.notation {
                        Text(notation)
                            .font(.system(size: fontSize * 0.65, design: .monospaced))
                            .foregroundColor(.secondary)
                            .padding(.bottom, 2)
                    }
                    
                    if let pinyin = verse.pinyin {
                        Text(pinyin)
                            .font(.system(size: fontSize * 0.9))
                            .foregroundColor(.primary)
                            .padding(.bottom, 2)
                    }
                    
                    if let chinese = verse.chinese {
                        Text(chinese)
                            .font(.system(size: fontSize * 1.2))
                            .foregroundColor(.primary)
                            .padding(.bottom, 4)
                    }
                    
                    if showEnglishTranslation {
                        Text(verse.text)
                            .font(.system(size: fontSize))
                            .foregroundColor(.secondary)
                            .italic()
                            .lineSpacing(4)
                    }
                } else {
                    // Single line format (just English)
                    Text(verse.text)
                        .font(.system(size: fontSize))
                        .lineSpacing(6)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, isHighlighted ? 8 : 0)
            .background(isHighlighted ? (highlightColor ?? .yellow).opacity(0.3) : Color.clear)
            .cornerRadius(isHighlighted ? 8 : 0)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .contentShape(Rectangle())
        .onLongPressGesture {
            onLongPress()
        }
        .contextMenu {
            Button(action: onNote) {
                Label("Add Note", systemImage: "note.text")
            }
            Button(action: onHighlight) {
                Label("Highlight", systemImage: "highlighter")
            }
        }
    }
}

extension Color {
    static func fromString(_ colorString: String) -> Color {
        switch colorString {
        case "yellow": return .yellow
        case "green": return .green
        case "blue": return .blue
        case "pink": return .pink
        case "purple": return .purple
        default: return .yellow
        }
    }
}

struct TTSControlBar: View {
    @ObservedObject var ttsService: TextToSpeechService
    let sortedVerses: [Verse]
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 20) {
                // Previous button
                Button(action: {
                    ttsService.skipToPrevious()
                }) {
                    Image(systemName: "backward.fill")
                        .font(.title3)
                }
                .disabled(!ttsService.isSpeaking && ttsService.currentVerse == nil)
                
                // Play/Pause button
                Button(action: {
                    if ttsService.isSpeaking {
                        ttsService.pause()
                    } else {
                        if ttsService.currentVerse == nil {
                            ttsService.speakVerses(sortedVerses)
                        } else {
                            ttsService.continueSpeaking()
                        }
                    }
                }) {
                    Image(systemName: ttsService.isSpeaking ? "pause.circle.fill" : "play.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }
                
                // Next button
                Button(action: {
                    ttsService.skipToNext()
                }) {
                    Image(systemName: "forward.fill")
                        .font(.title3)
                }
                .disabled(!ttsService.isSpeaking && ttsService.currentVerse == nil)
                
                // Stop button
                Button(action: {
                    ttsService.stop()
                }) {
                    Image(systemName: "stop.circle.fill")
                        .font(.title3)
                        .foregroundColor(.red)
                }
                
                Spacer()
                
                // Current verse indicator
                if let currentVerse = ttsService.currentVerse,
                   let index = sortedVerses.firstIndex(where: { $0.id == currentVerse.id }) {
                    Text(String(format: NSLocalizedString("Verse %d of %d", comment: ""), index + 1, sortedVerses.count))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -2)
        }
    }
}

