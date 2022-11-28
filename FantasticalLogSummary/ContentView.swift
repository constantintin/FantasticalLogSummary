//
//  ContentView.swift
//  FantasticalLogSummary
//
//  Created by Constantin Loew on 28.11.22.
//

import SwiftUI

struct ContentView: View {
    @State private var calendarStores: [CalendarStore] = []
    @State private var selected: Int = 0
    
    @State var filename = "<none>"
    @State var showFileChooser = false
    
    var body: some View {
        VStack {
            HStack {
                Text(filename)
                    .font(.title)
                Button {
                    let panel = NSOpenPanel()
                    panel.allowsMultipleSelection = false
                    panel.canChooseDirectories = false
                    if panel.runModal() == .OK {
                        if let url = panel.url {
                            self.filename = url.lastPathComponent
                            do {
                                let file = try String(contentsOf: url)
                                calendarStores = try calendarStoresParser.parse(file)
                            } catch let error {
                                calendarStores = []
                                print("Error: \(error)")
                            }
                        }
                    }
                } label: {
                    Text("Pick Logs")
                }
                .padding()
            }
            
            if calendarStores.isEmpty {
                VStack {
                    Text("No calendar store found")
                                .font(.body)
                                .foregroundColor(.secondary)
                }
            } else {
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
