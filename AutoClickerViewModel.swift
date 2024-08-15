import Foundation
import Combine

class AutoClickerViewModel: ObservableObject {
    @Published var isActive: Bool = false
    @Published var clickInterval: Double = 1.0

    private var timer: Timer?
    private var cancellables: Set<AnyCancellable> = []

    init() {
        loadSettings()
        $isActive
            .sink { [weak self] isActive in
                self?.toggleAutoClicker(isActive)
            }
            .store(in: &cancellables)
    }

    func toggleAutoClicker(_ isActive: Bool) {
        if isActive {
            timer = Timer.scheduledTimer(withTimeInterval: clickInterval, repeats: true) { _ in
                self.performClickAction()
            }
        } else {
            timer?.invalidate()
        }
    }

    func performClickAction() {
        let timestamp = Date()
        print("Clicked at \(timestamp)")
        saveClickToLog(timestamp: timestamp)
    }

    func saveClickToLog(timestamp: Date) {
        let fileName = "click_log.txt"
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        let logEntry = "Clicked at \(timestamp)\n"
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            if let fileHandle = FileHandle(forWritingAtPath: fileURL.path) {
                fileHandle.seekToEndOfFile()
                if let data = logEntry.data(using: .utf8) {
                    fileHandle.write(data)
                    fileHandle.closeFile()
                }
            }
        } else {
            try? logEntry.write(to: fileURL, atomically: true, encoding: .utf8)
        }
    }

    func saveSettings() {
        UserDefaults.standard.set(isActive, forKey: "isActive")
        UserDefaults.standard.set(clickInterval, forKey: "clickInterval")
    }

    func loadSettings() {
        isActive = UserDefaults.standard.bool(forKey: "isActive")
        clickInterval = UserDefaults.standard.double(forKey: "clickInterval")
    }
}
