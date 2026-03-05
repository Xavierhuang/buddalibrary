//
//  ChapterListView.swift
//  Buddha
//
//  Created by Weijia Huang on 12/14/25.
//

import SwiftUI

struct ChapterListView: View {
    let textTitle: String
    let chapters: [Chapter]
    let currentChapterNumber: Int
    let onChapterSelected: (Int) -> Void
    
    var body: some View {
        NavigationView {
            List {
                ForEach(chapters, id: \.id) { chapter in
                    NavigationLink(destination: ReadingView(textTitle: textTitle, chapterNumber: chapter.number)) {
                        HStack {
                            Text("Chapter \(chapter.number)")
                                .fontWeight(.medium)
                            if !chapter.title.isEmpty {
                                Text(": \(chapter.title)")
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            if chapter.number == currentChapterNumber {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.purple)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Chapters")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

