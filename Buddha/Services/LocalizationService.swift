//
//  LocalizationService.swift
//  Buddha
//
//  Created by Weijia Huang on 12/14/25.
//

import Foundation

class LocalizationService {
    static var isChineseLocale: Bool {
        guard let languageCode = Locale.current.language.languageCode?.identifier else {
            return false
        }
        return languageCode.hasPrefix("zh")
    }
    
    static var shouldShowEnglishByDefault: Bool {
        return !isChineseLocale
    }
}

// MARK: - Localization Helper
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(with arguments: CVarArg...) -> String {
        return String(format: NSLocalizedString(self, comment: ""), arguments: arguments)
    }
}
