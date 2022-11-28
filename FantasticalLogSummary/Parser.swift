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
    Prefix { $0 != " " }
    " "
    Prefix { $0 != " " }
    " "
    Skip {
        Prefix { $0 != " " }; " "
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
        Whitespace(4, .horizontal)
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
        Whitespace(4, .horizontal)
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

let calendarStoreParser = Parse {
    return CalendarStore(timestamp: $0, accounts: $1, calendars: $2, syncQueues: $3)
} with: {
    logBeginParser; "Calendar store state\n"
    accountsParser
    calendarsParser
    Skip {
        PrefixThrough("\n")
        PrefixThrough("\n")
        PrefixThrough("\n")
    }
    syncQueuesParser
}

let skipNotCalendarStoreParser = Parse {
    Skip {
         Many {
            Not { logBeginParser; "Calendar store state\n" }
            PrefixUpTo("\n")
        } separator: {
            "\n"
        }
        "\n"
    }
}

let exampleStores: [CalendarStore] = try! Parse {
    skipNotCalendarStoreParser
    Many {
        calendarStoreParser
    } separator: {
        skipNotCalendarStoreParser
    }
    Skip { Rest() }
}.parse(exampleInput)
