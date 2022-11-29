//
//  ContentView.swift
//  FantasticalLogSummary
//
//  Created by Constantin Loew on 28.11.22.
//

import SwiftUI
import Zip

struct ContentView: View {
    @State private var calendarStores: [CalendarStore] = []
    @State private var selected: Int = 0
    
    @State private var failedParsing = false
    
    @State var filename = ""
    @State var showFileChooser = false
    
    var body: some View {
        VStack {
            HStack {
                Text(filename)
                    .font(.title)
                    .padding()
                Button {
                    let panel = NSOpenPanel()
                    panel.allowsMultipleSelection = false
                    panel.canChooseDirectories = false
                    if panel.runModal() == .OK {
                        if let url = panel.url {
                            openLogFile(url)
                        }
                    }
                } label: {
                    Text("Pick Log File")
                }
                .padding()
            }
            
            if calendarStores.isEmpty {
                if failedParsing {
                    Text("Error parsing log")
                        .font(.body)
                        .foregroundColor(.secondary)
                } else {
                    Text("No calendar store in log file or no log file loaded")
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
                    Text("App Launch Timestamp: ")
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
    
    /// handle chosen file
    func openLogFile(_ url: URL) {
        self.filename = url.lastPathComponent
        do {
            var logString = ""
            if url.pathExtension == "zip" {
                // file is zip, unpack and concat
                let file_name = url.lastPathComponent.prefix(url.lastPathComponent.count - 4)
                let destDir = FileManager.default.temporaryDirectory.appending(path: file_name)
                print(destDir.path)
                try Zip.unzipFile(url, destination: destDir, overwrite: true, password: nil)
                let dirEnumerator = FileManager.default.enumerator(at: destDir, includingPropertiesForKeys: [.isDirectoryKey])!
                for case let file as URL in dirEnumerator {
                    if file.pathExtension == "log" && !file.path().contains("helper") {
                        let fileString = try String(contentsOf: file)
                        logString += fileString
                    }
                }
            } else {
                // treat file as a log directly
                logString = try String(contentsOf: url)
            }
            calendarStores = parseCalendarStores(logString)
            failedParsing = false
        } catch let error {
            failedParsing = true
            calendarStores = []
            print("Error: \(error)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
