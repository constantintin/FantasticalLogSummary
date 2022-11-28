//
//  AccountView.swift
//  FantasticalLogSummary
//
//  Created by Constantin Loew on 28.11.22.
//

import SwiftUI

struct AccountView: View {
    let account: Account
    var body: some View {
        VStack(alignment: .leading) {
            Text(account.name)
                .font(.body)
                .foregroundColor(.primary)
                .textSelection(.enabled)
            Text(account.id)
                .font(.body)
                .foregroundColor(.secondary)
                .textSelection(.enabled)
        }
    }
}
