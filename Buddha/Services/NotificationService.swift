//
//  NotificationService.swift
//  Buddha
//
//  Created by Weijia Huang on 12/14/25.
//

import Foundation
import UserNotifications
import SwiftData

class NotificationService {
    static let shared = NotificationService()
    
    private let notificationIdentifier = "dailyQuote"
    
    private init() {}
    
    func requestAuthorization() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
            return granted
        } catch {
            print("Failed to request notification authorization: \(error)")
            return false
        }
    }
    
    func scheduleQuoteNotifications(context: ModelContext) {
        // Cancel existing notifications
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
        
        // Get a random quote
        guard let quote = getRandomQuote(context: context) else {
            print("No quotes available")
            return
        }
        
        // Schedule notifications every 6 hours
        let content = UNMutableNotificationContent()
        content.title = "Daily Wisdom"
        content.body = quote.text
        content.sound = .default
        content.categoryIdentifier = "QUOTE"
        
        // Schedule for every 6 hours (4 times per day)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 6 * 60 * 60, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: notificationIdentifier,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            } else {
                print("Quote notification scheduled successfully")
            }
        }
    }
    
    func scheduleRepeatingNotifications(context: ModelContext) {
        // Cancel existing notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // Get all available quotes
        guard let quotes = getAllQuotes(context: context), !quotes.isEmpty else {
            print("No quotes available for notifications - data may not be loaded yet")
            return
        }
        
        // Schedule 4 notifications per day (every 6 hours: 6am, 12pm, 6pm, 12am)
        let times = [6, 12, 18, 0] // Hours of the day (0 = midnight)
        
        for (index, hour) in times.enumerated() {
            // Rotate through quotes based on day and time slot
            let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
            let quoteIndex = ((dayOfYear - 1) * 4 + index) % quotes.count
            let quote = quotes[quoteIndex]
            
            // Truncate long quotes for notification
            let quoteText = quote.text.count > 200 ? String(quote.text.prefix(197)) + "..." : quote.text
            
            let content = UNMutableNotificationContent()
            content.title = "Daily Wisdom"
            content.body = quoteText
            content.sound = .default
            content.categoryIdentifier = "QUOTE"
            
            // Create date components for the specific hour
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = 0
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let request = UNNotificationRequest(
                identifier: "\(notificationIdentifier)_\(index)",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Failed to schedule notification for hour \(hour): \(error)")
                } else {
                    print("Scheduled notification for \(hour):00")
                }
            }
        }
    }
    
    private func getRandomQuote(context: ModelContext) -> Verse? {
        let descriptor = FetchDescriptor<BuddhistText>()
        guard let texts = try? context.fetch(descriptor), !texts.isEmpty else {
            return nil
        }
        
        let allVerses = texts.flatMap { text in
            text.chapters.flatMap { chapter in
                chapter.verses
            }
        }
        
        guard !allVerses.isEmpty else { return nil }
        
        // Use day of year to get a consistent quote for the day
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = (dayOfYear - 1) % allVerses.count
        return allVerses[index]
    }
    
    private func getAllQuotes(context: ModelContext) -> [Verse]? {
        let descriptor = FetchDescriptor<BuddhistText>()
        guard let texts = try? context.fetch(descriptor), !texts.isEmpty else {
            return nil
        }
        
        let allVerses = texts.flatMap { text in
            text.chapters.flatMap { chapter in
                chapter.verses
            }
        }
        
        return allVerses.isEmpty ? nil : allVerses
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func checkAuthorizationStatus() async -> UNAuthorizationStatus {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return settings.authorizationStatus
    }
}

