//
//  HighlightsView.swift
//  Buddha
//
//  Created by Weijia Huang on 12/14/25.
//

import SwiftUI
import SwiftData

struct HighlightsView: View {
    @Query(sort: \Highlight.createdAt, order: .reverse) private var highlights: [Highlight]
    @Environment(\.modelContext) private var modelContext
    @State private var searchText = ""
    
    var filteredHighlights: [Highlight] {
        if searchText.isEmpty {
            return highlights
        }
        return highlights.filter { $0.text.localizedCaseInsensitiveContains(searchText) || 
                                 $0.textTitle.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationView {
            Group {
                if filteredHighlights.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "highlighter")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        Text(NSLocalizedString("No highlights yet", comment: ""))
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(NSLocalizedString("Long press on a verse while reading to add a highlight", comment: ""))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else {
                    List {
                        ForEach(filteredHighlights, id: \.id) { highlight in
                            NavigationLink(destination: ReadingView(textTitle: highlight.textTitle, chapterNumber: highlight.chapterNumber)) {
                                HighlightRow(highlight: highlight)
                            }
                        }
                        .onDelete { indexSet in
                            deleteHighlights(at: indexSet)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Highlights")
            .searchable(text: $searchText, prompt: "Search highlights...")
        }
        .navigationViewStyle(.stack)
    }
    
    private func deleteHighlights(at offsets: IndexSet) {
        for index in offsets {
            let highlight = filteredHighlights[index]
            modelContext.delete(highlight)
        }
        try? modelContext.save()
    }
}

struct HighlightRow: View {
    let highlight: Highlight
    
    var body: some View {
        HStack(spacing: 15) {
            // Color indicator
            Circle()
                .fill(Color.fromString(highlight.color))
                .frame(width: 30, height: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(highlight.textTitle)
                    .font(.headline)
                
                Text(String(format: NSLocalizedString("Chapter %d", comment: ""), highlight.chapterNumber) + (highlight.verseNumber != nil ? ", " + String(format: NSLocalizedString("Verse %d", comment: ""), highlight.verseNumber!) : ""))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(highlight.text)
                    .font(.body)
                    .lineLimit(3)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(Color.fromString(highlight.color).opacity(0.2))
                    .cornerRadius(6)
            }
            
            Spacer()
            
            Text(highlight.createdAt, style: .relative)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}
