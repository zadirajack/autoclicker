import SwiftUI
import UserNotifications

struct ScheduleView: View {
    @State private var selectedDate = Date()
    @State private var scheduled = false

    var body: some View {
        VStack {
            DatePicker("Select Date and Time", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                .padding()

            Toggle(isOn: $scheduled) {
                Text("Schedule Click")
            }
            .padding()

            Button(action: scheduleClick) {
                Text("Schedule")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }

    func scheduleClick() {
        let content = UNMutableNotificationContent()
        content.title = "Auto Clicker"
        content.body = "Time to click!"
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: selectedDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}

UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
    if granted {
        print("Notification permission granted.")
    } else {
        print("Notification permission denied.")
    }
}
