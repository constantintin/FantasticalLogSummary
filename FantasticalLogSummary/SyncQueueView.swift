//
//  SyncQueueView.swift
//  FantasticalLogSummary
//
//  Created by Constantin Loew on 28.11.22.
//

import SwiftUI

struct SyncQueueView: View {
    let syncQueue: SyncQueue
    var body: some View {
        VStack(alignment: .leading) {
            Text(syncQueue.name)
                .font(.body)
                .foregroundColor(.primary)
                .textSelection(.enabled)
            Text(syncQueue.id)
                .font(.body)
                .foregroundColor(.secondary)
                .textSelection(.enabled)
        }
    }
}
