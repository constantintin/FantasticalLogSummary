//
//  Parser.swift
//  FantasticalLogSummary
//
//  Created by Constantin Loew on 28.11.22.
//

import Foundation
import Parsing

struct Account: Identifiable, Hashable {
    var name: String
    var id: String
    var mail: String?
}

struct Calendar: Identifiable, Hashable {
    var name: String
    var id: String
    var defaultEvent: Bool = false
    var defaultTask: Bool = false
}

struct SyncQueue: Identifiable, Hashable {
    var name: String
    var id: String
}

struct CalendarStore: Identifiable, Hashable {
    let id = UUID()
    var timestamp: String
    var accounts: [Account]
    var calendars: [Calendar]
    var syncQueues: [SyncQueue]
}

let logBeginParser = Parse {
    String($0 + " " + $1)
} with: {
    Prefix { $0 != " " && $0 != "\n" }
    " "
    Prefix { $0 != " " && $0 != "\n" }
    " "
    Skip {
        "["; PrefixThrough("]"); " "
    }
}

let syncQueueParser = Parse {
    SyncQueue(name: $0, id: $1)
} with: {
    Prefix { $0 != " " }.map(String.init)
    " / "
    Prefix { $0 != " " }.map(String.init)
    Skip { Prefix { $0 != "\n" } }
    "\n)>\n"
}

let syncQueuesParser = Parse {
    Skip {
        logBeginParser; "Sync queues: "
    }
    Many {
        syncQueueParser
    } separator: {
        "\n"
    }
}

let calendarParser = Parse {
    Calendar(name: $0[0], id: $0[2])
} with: {
    Skip {
        logBeginParser
        "\t"
    }
    Many {
        Prefix { $0 != "," && $0 != "\n" }.map(String.init)
    } separator: {
        ", "
    }
}
let calendarsParser = Parse {
    Skip {
        logBeginParser; "Calendars:\n"
    }
    Many {
        calendarParser
    } separator: {
        "\n"
    }
    "\n"
}

let accountParser = Parse {
    Account(name: $0[0], id: $0[1], mail: ($0.count > 4) ? $0[4] : nil)
} with: {
    Skip {
        logBeginParser
        "\t"
    }
    Many {
        Prefix { $0 != "," && $0 != "\n" }.map(String.init)
    } separator: {
        ", "
    }
}
let accountsParser = Parse {
    Skip {
        logBeginParser; "Accounts:\n"
    }
    Many {
        accountParser
    } separator: {
        "\n"
    }
    "\n"
}

let defaultCalendarsParser = Parse {
    return (event: $0, task: $1)
} with: {
    Skip {
        PrefixThrough("\n")
        logBeginParser; "Default event calendar: "
        PrefixThrough(" ")
    }
    PrefixUpTo("\n")
    Skip {
        "\n"
        logBeginParser; "Default task calendar: "
        PrefixThrough(" ")
    }
    PrefixUpTo("\n")
    "\n"
}

let calendarStoreParser = Parse {
    // mark default calendars before returning
    let defaults = $3
    var calendars = $2
    if let eventCalendarIndex = calendars.firstIndex(where: { $0.id == defaults.event }) {
        calendars[eventCalendarIndex].defaultEvent = true
    }
    if let taskCalendarIndex = calendars.firstIndex(where: { $0.id == defaults.task }) {
        calendars[taskCalendarIndex].defaultTask = true
    }
    return CalendarStore(timestamp: $0, accounts: $1, calendars: calendars, syncQueues: $4)
} with: {
    logBeginParser; "Calendar store state\n"
    accountsParser
    calendarsParser
    defaultCalendarsParser
    syncQueuesParser
}

let skipNotCalendarStoreParser = Parse {
    print("skpped")
    print($0.count)
} with: {
    Many {
        Not { logBeginParser; "Calendar store state\n" }
        PrefixThrough("\n")
    }
}

/// search for all occurrences of "Calendar store state" and parse the following string
/// throws away all failed parse attempts
func parseCalendarStores(_ string: String) -> [CalendarStore] {
    var stores: [CalendarStore?] = []
    let lines = string.split(whereSeparator: \.isNewline)
    for (index, line) in lines.enumerated() {
        if line.contains("Calendar store state") {
            stores.append(try? Parse {
                calendarStoreParser
                Skip { Rest() }
            }.parse(lines.suffix(lines.count - index).joined(separator: "\n")))
        }
    }
    return stores.compactMap{ $0 }
}

