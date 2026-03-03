//
//  BuddhistText.swift
//  Buddha
//
//  Created by Weijia Huang on 12/14/25.
//

import Foundation
import SwiftData

@Model
final class BuddhistText {
    var id: UUID
    var title: String
    var author: String?
    var textDescription: String?
    var category: String // e.g., "Sutra", "Teaching", "Commentary"
    var coverImageName: String? // Asset name for cover image
    @Relationship(deleteRule: .cascade) var chapters: [Chapter] = []
    var createdAt: Date

    init(title: String, author: String? = nil, textDescription: String? = nil, category: String = "Sutra", coverImageName: String? = nil) {
        self.id = UUID()
        self.title = title
        self.author = author
        self.textDescription = textDescription
        self.category = category
        self.coverImageName = coverImageName
        self.createdAt = Date()
    }
}

@Model
final class Chapter {
    var id: UUID
    var number: Int
    var title: String
    @Relationship(deleteRule: .cascade) var verses: [Verse] = []
    var text: BuddhistText?
    
    init(number: Int, title: String) {
        self.id = UUID()
        self.number = number
        self.title = title
    }
}

@Model
final class Verse {
    var id: UUID
    var number: Int
    var text: String // English translation (main text)
    var notation: String? // Rhythm notation (circles and lines)
    var pinyin: String? // Pinyin transliteration
    var chinese: String? // Chinese characters
    var chapter: Chapter?
    
    init(number: Int, text: String, notation: String? = nil, pinyin: String? = nil, chinese: String? = nil) {
        self.id = UUID()
        self.number = number
        self.text = text
        self.notation = notation
        self.pinyin = pinyin
        self.chinese = chinese
    }
}

