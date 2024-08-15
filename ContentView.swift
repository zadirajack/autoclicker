import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AutoClickerViewModel()

    var body: some View {
        VStack {
            Text("Auto Clicker")
                .font(.largeTitle)
                .padding()

            Toggle(isOn: $viewModel.isActive) {
                Text("Enable Auto Clicker")
            }
            .padding()

            HStack {
                Text("Interval (seconds):")
                TextField("Interval", value: $viewModel.clickInterval, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .keyboardType(.decimalPad)
            }

            Button(action: {
                viewModel.saveSettings()
            }) {
                Text("Save Settings")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            NavigationLink(destination: ScheduleView()) {
                Text("Schedule Clicks")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Spacer()
        }
        .padding()
    }
}
