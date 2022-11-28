//
//  CalendarView.swift
//  FantasticalLogSummary
//
//  Created by Constantin Loew on 28.11.22.
//

import SwiftUI

struct CalendarView: View {
    let calendar: Calendar
    var body: some View {
        HStack {
            if calendar.defaultTask {
                Image(systemName: "star.fill")
            }
            if calendar.defaultEvent {
                Image(systemName: "star")
            }
            VStack(alignment: .leading) {
                Text(calendar.name)
                    .font(.body)
                    .foregroundColor(.primary)
                    .textSelection(.enabled)
                Text(calendar.id)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .textSelection(.enabled)
            }
        }
    }
}
