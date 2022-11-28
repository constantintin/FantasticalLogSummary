//
//  ContentView.swift
//  FantasticalLogSummary
//
//  Created by Constantin Loew on 28.11.22.
//

import SwiftUI

struct ContentView: View {
    @State private var calendarStores = exampleStores
    @State private var selected: Int = 0
    
    @State var filename = "Filename"
    @State var showFileChooser = false
    
    var body: some View {
        VStack {
            Picker("Calendar Store", selection: $selected) {
                ForEach(Array(calendarStores.enumerated()), id: \.element) { index, store in
                    Text(store.timestamp).tag(index)
                }
            }
            .pickerStyle(.menu)
            .padding()

            TabView {
                VStack {
                    ForEach(calendarStores[selected].accounts) { account in
                        Text(account.name)
                    }
                }
                .tabItem {
                    Text("Accounts")
                }
                VStack {
                    ForEach(calendarStores[selected].calendars) { calendar in
                        Text(calendar.name)
                    }
                }
                .tabItem {
                    Text("Calendars")
                }
                VStack {
                    ForEach(calendarStores[selected].syncQueues) { syncQueue in
                        Text(syncQueue.name)
                    }
                }
                .tabItem {
                    Text("Sync Queues")
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
