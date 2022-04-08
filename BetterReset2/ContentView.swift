//
//  ContentView.swift
//  BetterReset2
//
//  Created by Isaac Kim on 4/6/22.
//
import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    var sleepResults: String {
        // lot of work need to do
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            // more code to come here
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            return "Your ideal bedtime is " + sleepTime.formatted(date: .omitted, time: .shortened)
            
        } catch {
            return "There was an error"
            
        }
    }
    
    var body: some View {
        NavigationView {
            Spacer()
            Form{
                
                Section("When do you want to wake up?") {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                Section("Desired amount of sleep") {
                    
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                Section("Daily coffee intake") {

                    
                    Picker("Number of cups", selection: $coffeeAmount) {
                        ForEach(1..<21) { num in
                            Text("\(num)")
                        }
                    }
                }
                Section("the result"){
                    Text(sleepResults)
                        .font(.title3)
                    
                }
                
               
                
                
            }
            .navigationTitle("BetterRest")
            Spacer()
        }
    }
    
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
