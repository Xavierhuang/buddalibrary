//
//  LibraryView.swift
//  Buddha
//
//  Created by Weijia Huang on 12/14/25.
//

import SwiftUI
import SwiftData

struct LibraryView: View {
    @Query(sort: \BuddhistText.title) private var texts: [BuddhistText]
    @State private var searchText = ""
    @State private var selectedCategory: String? = nil
    
    var categories: [String] {
        Array(Set(texts.map { $0.category })).sorted()
    }
    
    // Helper function to localize category names
    private func localizedCategory(_ category: String) -> String {
        return NSLocalizedString(category, comment: "")
    }
    
    var filteredTexts: [BuddhistText] {
        var result = texts
        
        if !searchText.isEmpty {
            result = result.filter { $0.title.localizedCaseInsensitiveContains(searchText) || 
                                    ($0.author?.localizedCaseInsensitiveContains(searchText) ?? false) }
        }
        
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }
        
        return result
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Category Filter
                if !categories.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            CategoryButton(title: NSLocalizedString("All", comment: ""), isSelected: selectedCategory == nil) {
                                selectedCategory = nil
                            }
                            
                            ForEach(categories, id: \.self) { category in
                                CategoryButton(title: localizedCategory(category), isSelected: selectedCategory == category) {
                                    selectedCategory = category
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 10)
                    .background(Color(.systemBackground))
                }
                
                // Text List
                List {
                    ForEach(filteredTexts, id: \.id) { text in
                        NavigationLink(destination: TextDetailView(text: text)) {
                            LibraryRow(text: text)
                        }
                    }
                }
                .listStyle(.plain)
                .searchable(text: $searchText, prompt: "Search texts...")
            }
            .navigationTitle("Library")
        }
    }
}

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color(.systemGray5))
                .cornerRadius(20)
        }
    }
}

struct LibraryRow: View {
    let text: BuddhistText

    var body: some View {
        HStack(spacing: 15) {
            // Cover image or default icon
            if let coverImageName = text.coverImageName, !coverImageName.isEmpty {
                Image(coverImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 80)
                    .cornerRadius(8)
                    .clipped()
                    .onAppear {
                        print("📚 Loading cover: \(coverImageName) for \(text.title)")
                    }
            } else {
                Image(systemName: "book.closed.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .frame(width: 60, height: 80)
                    .onAppear {
                        print("⚠️ No cover for: \(text.title), coverImageName: \(text.coverImageName ?? "nil")")
                    }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(text.title)
                    .font(.headline)

                if let author = text.author {
                    Text(author)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                if let textDescription = text.textDescription {
                    Text(textDescription)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }

                Text(NSLocalizedString(text.category, comment: ""))
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(8)
            }

            Spacer()

            Text(String(format: NSLocalizedString("%d chapters", comment: ""), text.chapters.count))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

struct TextDetailView: View {
    let text: BuddhistText
    @State private var selectedChapter: Chapter?
    @State private var showPDF = false
    
    var isPDFBook: Bool {
        text.title == "What the Buddha Taught" || text.title == "The Life of the Buddha" || text.title == "流浪者之歌 (Siddhartha)"
    }

    var pdfFileName: String {
        // Return the exact filename without extension
        return text.title
    }
    
    var body: some View {
        List {
            Section {
                if let textDescription = text.textDescription {
                    Text(textDescription)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                if let author = text.author {
                    HStack {
                        Text("Author:")
                            .fontWeight(.semibold)
                        Text(author)
                    }
                    .font(.subheadline)
                }
                
                if isPDFBook {
                    Button(action: {
                        showPDF = true
                    }) {
                        HStack {
                            Image(systemName: "doc.text.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Open PDF")
                                    .font(.headline)
                                Text("View the complete book")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 8)
                    }
                }
            } header: {
                Text("About")
            }
            
            if !isPDFBook {
                Section {
                    ForEach(text.chapters, id: \.id) { chapter in
                        NavigationLink(destination: ReadingView(textTitle: text.title, chapterNumber: chapter.number)) {
                            HStack {
                                Text(String(format: NSLocalizedString("Chapter %d", comment: ""), chapter.number))
                                    .fontWeight(.medium)
                                if !chapter.title.isEmpty {
                                    Text(": \(chapter.title)")
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Text(String(format: NSLocalizedString("%d verses", comment: ""), chapter.verses.count))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                } header: {
                    Text("Chapters")
                }
            }
        }
        .navigationTitle(text.title)
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showPDF) {
            PDFReaderView(pdfName: pdfFileName)
        }
    }
}

