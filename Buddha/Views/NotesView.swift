//
//  NotesView.swift
//  Buddha
//
//  Created by Weijia Huang on 12/14/25.
//

import SwiftUI
import SwiftData

struct NotesView: View {
    @Query(sort: \Note.updatedAt, order: .reverse) private var notes: [Note]
    @Environment(\.modelContext) private var modelContext
    @State private var searchText = ""
    @State private var selectedNote: Note?
    @State private var showEditSheet = false
    
    var filteredNotes: [Note] {
        if searchText.isEmpty {
            return notes
        }
        return notes.filter { $0.content.localizedCaseInsensitiveContains(searchText) || 
                             $0.text.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationView {
            Group {
                if filteredNotes.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "note.text")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        Text(NSLocalizedString("No notes yet", comment: ""))
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(NSLocalizedString("Long press on a verse while reading to add a note", comment: ""))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else {
                    List {
                        ForEach(filteredNotes, id: \.id) { note in
                            NoteRow(note: note)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedNote = note
                                    showEditSheet = true
                                }
                        }
                        .onDelete { indexSet in
                            deleteNotes(at: indexSet)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Notes")
            .searchable(text: $searchText, prompt: "Search notes...")
            .sheet(item: $selectedNote) { note in
                NoteDetailView(note: note)
            }
        }
    }
    
    private func deleteNotes(at offsets: IndexSet) {
        for index in offsets {
            let note = filteredNotes[index]
            modelContext.delete(note)
        }
        try? modelContext.save()
    }
}

struct NoteRow: View {
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(note.textTitle)
                    .font(.headline)
                Spacer()
                Text(note.updatedAt, style: .relative)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(String(format: NSLocalizedString("Chapter %d", comment: ""), note.chapterNumber) + (note.verseNumber != nil ? ", " + String(format: NSLocalizedString("Verse %d", comment: ""), note.verseNumber!) : ""))
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(note.text)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(Color(.systemGray6))
                .cornerRadius(6)
            
            Text(note.content)
                .font(.body)
                .lineLimit(3)
        }
        .padding(.vertical, 4)
    }
}

struct NoteDetailView: View {
    let note: Note
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var noteContent: String
    @State private var isEditing = false
    @FocusState private var isFocused: Bool
    
    init(note: Note) {
        self.note = note
        _noteContent = State(initialValue: note.content)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Verse reference
                    NavigationLink(destination: ReadingView(textTitle: note.textTitle, chapterNumber: note.chapterNumber)) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(note.textTitle)
                                .font(.headline)
                            Text(String(format: NSLocalizedString("Chapter %d", comment: ""), note.chapterNumber) + (note.verseNumber != nil ? ", " + String(format: NSLocalizedString("Verse %d", comment: ""), note.verseNumber!) : ""))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text(note.text)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        .padding()
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Note content
                    if isEditing {
                        TextEditor(text: $noteContent)
                            .focused($isFocused)
                            .frame(minHeight: 200)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                    } else {
                        Text(noteContent)
                            .font(.body)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                    }
                    
                    // Metadata
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(NSLocalizedString("Created:", comment: ""))
                            Text(note.createdAt, style: .date)
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                        HStack {
                            Text(NSLocalizedString("Updated:", comment: ""))
                            Text(note.updatedAt, style: .date)
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Delete") {
                        deleteNote()
                    }
                    .foregroundColor(.red)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isEditing {
                        Button("Save") {
                            saveNote()
                        }
                    } else {
                        Button("Edit") {
                            isEditing = true
                            isFocused = true
                        }
                    }
                }
            }
        }
    }
    
    private func saveNote() {
        note.content = noteContent
        note.updatedAt = Date()
        try? modelContext.save()
        isEditing = false
    }
    
    private func deleteNote() {
        modelContext.delete(note)
        try? modelContext.save()
        dismiss()
    }
}

