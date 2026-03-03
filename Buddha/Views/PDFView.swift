//
//  PDFView.swift
//  Buddha
//
//  Created by Weijia Huang on 12/14/25.
//

import SwiftUI
import PDFKit

struct PDFView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> PDFKit.PDFView {
        let pdfView = PDFKit.PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        
        if let document = PDFDocument(url: url) {
            pdfView.document = document
        }
        
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFKit.PDFView, context: Context) {
        // No updates needed
    }
}

struct PDFReaderView: View {
    let pdfName: String
    @Environment(\.dismiss) private var dismiss
    
    var pdfURL: URL? {
        // First try the main bundle
        if let url = Bundle.main.url(forResource: pdfName, withExtension: "pdf") {
            return url
        }
        // Try without extension
        if let url = Bundle.main.url(forResource: pdfName, withExtension: nil) {
            return url
        }
        // Try in the app's Documents directory
        if let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let url = documentsPath.appendingPathComponent("\(pdfName).pdf")
            if FileManager.default.fileExists(atPath: url.path) {
                return url
            }
        }
        return nil
    }
    
    var body: some View {
        NavigationView {
            Group {
                if let url = pdfURL {
                    PDFView(url: url)
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        Text("PDF not found")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Could not find: \(pdfName).pdf")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("Please ensure the PDF file is added to the app bundle.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
            }
            .navigationTitle(pdfName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

