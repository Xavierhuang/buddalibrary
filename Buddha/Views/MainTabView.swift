//
//  MainTabView.swift
//  Buddha
//
//  Created by Weijia Huang on 12/14/25.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var dataLoaded = false

    var body: some View {
        Group {
            if dataLoaded {
                TabView {
                    HomeView()
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }

                    LibraryView()
                        .tabItem {
                            Label("Library", systemImage: "book.fill")
                        }

                    NotesView()
                        .tabItem {
                            Label("Notes", systemImage: "note.text")
                        }

                    AudioView()
                        .tabItem {
                            Label("Audio", systemImage: "music.note")
                        }

                    SearchView()
                        .tabItem {
                            Label("Search", systemImage: "magnifyingglass")
                        }
                }
            } else {
                ProgressView("Loading...")
            }
        }
        .onAppear {
            if !dataLoaded {
                Task {
                    DataService.loadSampleData(context: modelContext)
                    dataLoaded = true
                }
            }
        }
    }
}

