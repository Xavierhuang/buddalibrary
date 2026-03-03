//
//  ReadingSettingsView.swift
//  Buddha
//
//  Created by Weijia Huang on 12/14/25.
//

import SwiftUI

struct ReadingSettingsView: View {
    @AppStorage("fontSize") private var fontSize: Double = 16
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("showEnglishTranslation") private var showEnglishTranslation: Bool = true
    @Environment(\.dismiss) private var dismiss
    
    // Initialize based on locale if not already set
    private func initializeEnglishTranslationSetting() {
        if UserDefaults.standard.object(forKey: "showEnglishTranslation") == nil {
            showEnglishTranslation = LocalizationService.shouldShowEnglishByDefault
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Text Size") {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("A")
                                .font(.system(size: 12))
                            Slider(value: $fontSize, in: 12...24, step: 1)
                            Text("A")
                                .font(.system(size: 24))
                        }
                        Text(String(format: NSLocalizedString("Current size: %dpt", comment: ""), Int(fontSize)))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Appearance") {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }
                
                Section("Translation") {
                    Toggle("Show English Translation", isOn: $showEnglishTranslation)
                }
            }
            .navigationTitle("Reading Settings")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                initializeEnglishTranslationSetting()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

