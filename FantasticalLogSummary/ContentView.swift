//
//  ContentView.swift
//  FantasticalLogSummary
//
//  Created by Constantin Loew on 28.11.22.
//

import SwiftUI

struct ContentView: View {
    @State private var calendarStores: [CalendarStore] = exampleStores
    @State private var selected: Int = 0
    
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
                    if calendarStores.count > selected {
                        List {
                            ForEach(calendarStores[selected].accounts) { account in
                                AccountView(account: account)
                            }
                        }
                    } else {
                        Text("No calendar store loaded")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
                .tabItem {
                    Text("Accounts")
                }
                VStack {
                    if calendarStores.count > selected {
                        List {
                            ForEach(calendarStores[selected].calendars) { calendar in
                                CalendarView(calendar: calendar)
                            }
                        }
                    } else {
                        Text("No calendar store loaded")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
                .tabItem {
                    Text("Calendars")
                }
                VStack {
                    if calendarStores.count > selected {
                        List {
                            ForEach(calendarStores[selected].syncQueues) { syncQueue in
                                SyncQueueView(syncQueue: syncQueue)
                            }
                        }
                    } else {
                        Text("No calendar store loaded")
                            .font(.body)
                            .foregroundColor(.secondary)
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
