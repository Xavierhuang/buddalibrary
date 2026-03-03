//
//  BookmarksView.swift
//  Buddha
//
//  Created by Weijia Huang on 12/14/25.
//

import SwiftUI
import SwiftData

struct BookmarksView: View {
    @Query(sort: \Bookmark.createdAt, order: .reverse) private var bookmarks: [Bookmark]
    @Environment(\.modelContext) private var modelContext
    @State private var searchText = ""
    
    var filteredBookmarks: [Bookmark] {
        if searchText.isEmpty {
            return bookmarks
        }
        return bookmarks.filter { $0.textTitle.localizedCaseInsensitiveContains(searchText) || 
                                 $0.text.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationView {
            Group {
                if filteredBookmarks.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "bookmark")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        Text(NSLocalizedString("No bookmarks yet", comment: ""))
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(NSLocalizedString("Bookmark chapters while reading to access them quickly", comment: ""))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else {
                    List {
                        ForEach(filteredBookmarks, id: \.id) { bookmark in
                            NavigationLink(destination: ReadingView(textTitle: bookmark.textTitle, chapterNumber: bookmark.chapterNumber)) {
                                BookmarkRow(bookmark: bookmark)
                            }
                        }
                        .onDelete { indexSet in
                            deleteBookmarks(at: indexSet)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Bookmarks")
            .searchable(text: $searchText, prompt: "Search bookmarks...")
        }
    }
    
    private func deleteBookmarks(at offsets: IndexSet) {
        for index in offsets {
            let bookmark = filteredBookmarks[index]
            modelContext.delete(bookmark)
        }
        try? modelContext.save()
    }
}

struct BookmarkRow: View {
    let bookmark: Bookmark
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "bookmark.fill")
                .font(.title3)
                .foregroundColor(.orange)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(bookmark.textTitle)
                    .font(.headline)
                
                Text(String(format: NSLocalizedString("Chapter %d", comment: ""), bookmark.chapterNumber) + (bookmark.verseNumber != nil ? ", " + String(format: NSLocalizedString("Verse %d", comment: ""), bookmark.verseNumber!) : ""))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if !bookmark.text.isEmpty {
                    Text(bookmark.text)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            Text(bookmark.createdAt, style: .relative)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

