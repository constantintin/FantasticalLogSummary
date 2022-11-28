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
    
    @State var filename = ""
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
                                calendarStores = parseCalendarStores(file)
                            } catch let error {
                                calendarStores = []
                                print("Error: \(error)")
                            }
                        }
                    }
                } label: {
                    Text("Pick Log File")
                }
                .padding()
            }
            
            if calendarStores.isEmpty {
                VStack {
                    Text("No calendar store loaded")
                                .font(.body)
                                .foregroundColor(.secondary)
                }
            } else {
                Picker(selection: $selected) {
                    ForEach(Array(calendarStores.enumerated()), id: \.element) { index, store in
                        Text(store.timestamp)
                            .tag(index)
                            .font(.title2)
                    }
                } label: {
                    Text("Calendar Store:")
                        .font(.title2)
                }
                .onChange(of: calendarStores) { _ in
                    selected = 0
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
                            noSelection
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
                            noSelection
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
                            noSelection
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
    
    var noSelection: some View {
        Text("No calendar store selected")
            .font(.body)
            .foregroundColor(.secondary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
