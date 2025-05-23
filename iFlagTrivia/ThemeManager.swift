import SwiftUI

enum Theme: String, CaseIterable {
    case light, dark, system
}

class ThemeManager: ObservableObject {
    @Published var currentTheme: Theme {
        didSet {
            storeTheme()
            applyTheme()
        }
    }

    init() {
        if let storedTheme = UserDefaults.standard.string(forKey: "appTheme"),
           let theme = Theme(rawValue: storedTheme) {
            self.currentTheme = theme
        } else {
            self.currentTheme = .system
        }
        applyTheme()
    }

    func toggleTheme() {
        let allCases = Theme.allCases
        guard let currentIndex = allCases.firstIndex(of: currentTheme) else {
            currentTheme = .system // Default to system if something goes wrong
            return
        }
        let nextIndex = allCases.index(after: currentIndex)
        currentTheme = allCases[nextIndex == allCases.endIndex ? allCases.startIndex : nextIndex]
    }

    private func storeTheme() {
        UserDefaults.standard.set(currentTheme.rawValue, forKey: "appTheme")
    }

    func applyTheme() {
        guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }

        for window in firstScene.windows {
            switch currentTheme {
            case .light:
                window.overrideUserInterfaceStyle = .light
            case .dark:
                window.overrideUserInterfaceStyle = .dark
            case .system:
                window.overrideUserInterfaceStyle = .unspecified
            }
        }
    }
}
