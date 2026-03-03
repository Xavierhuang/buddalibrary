//
//  SearchView.swift
//  Buddha
//
//  Created by Weijia Huang on 12/14/25.
//

import SwiftUI
import SwiftData

struct SearchView: View {
    @Query private var texts: [BuddhistText]
    @State private var searchText = ""
    @State private var searchResults: [SearchResult] = []
    
    var body: some View {
        NavigationView {
            VStack {
                if searchText.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        Text(NSLocalizedString("Search Buddhist Texts", comment: ""))
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(NSLocalizedString("Enter a word or phrase to search across all texts", comment: ""))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else if searchResults.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "text.magnifyingglass")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        Text(NSLocalizedString("No results found", comment: ""))
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(NSLocalizedString("Try different keywords", comment: ""))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                } else {
                    List {
                        ForEach(searchResults, id: \.id) { result in
                            NavigationLink(destination: ReadingView(textTitle: result.textTitle, chapterNumber: result.chapterNumber)) {
                                SearchResultRow(result: result)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Search")
            .searchable(text: $searchText, prompt: NSLocalizedString("Search verses...", comment: ""))
            .onChange(of: searchText) { oldValue, newValue in
                performSearch(query: newValue)
            }
        }
    }
    
    private func performSearch(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        var results: [SearchResult] = []
        let lowerQuery = query.lowercased()
        
        for text in texts {
            for chapter in text.chapters {
                for verse in chapter.verses {
                    let searchableText = [
                        verse.text,
                        verse.pinyin,
                        verse.chinese,
                        verse.notation
                    ].compactMap { $0 }.joined(separator: " ").lowercased()
                    
                    if searchableText.contains(lowerQuery) {
                        results.append(SearchResult(
                            id: UUID(),
                            textTitle: text.title,
                            chapterNumber: chapter.number,
                            verseNumber: verse.number,
                            verseText: verse.text,
                            matchedText: query
                        ))
                    }
                }
            }
        }
        
        searchResults = results
    }
}

struct SearchResult: Identifiable {
    let id: UUID
    let textTitle: String
    let chapterNumber: Int
    let verseNumber: Int
    let verseText: String
    let matchedText: String
}

struct SearchResultRow: View {
    let result: SearchResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(result.textTitle)
                    .font(.headline)
                Spacer()
                Text(String(format: NSLocalizedString("Ch. %d, V. %d", comment: ""), result.chapterNumber, result.verseNumber))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(result.verseText)
                .font(.body)
                .lineLimit(3)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 4)
    }
}

