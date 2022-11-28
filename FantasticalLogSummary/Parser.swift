//
//  Parser.swift
//  FantasticalLogSummary
//
//  Created by Constantin Loew on 28.11.22.
//

import Foundation
import Parsing

struct Account: Identifiable {
    var name: String
    var id: String
    var mail: String?
}

struct Calendar: Identifiable {
    var name: String
    var id: String
}

struct SyncQueue: Identifiable {
    var name: String
    var id: String
}

var exampleInput = """
2022/11/28 06:57:15:686 [FBCalendarStore+Debug.m:227|com.apple.main-thread] Calendar store state
2022/11/28 06:57:15:693 [FBCalendarStore+Debug.m:228|com.apple.main-thread] Accounts:
2022/11/28 06:57:15:693 [FBCalendarStore+Debug.m:232|com.apple.main-thread]     Google, 12bd453010cc17ebabf51a10f8e540df6307fdef, enabled, caldav, averagetryhardbear@gmail.com, https://apidata.googleusercontent.com/caldav/v2/averagetryhardbear%40gmail.com/user
2022/11/28 06:57:15:693 [FBCalendarStore+Debug.m:232|com.apple.main-thread]     Exchange, b9ca7354dafd95ebc9a78cf8d292220ef620955f, enabled, exchange, consti.loew@live.com, https://outlook.office365.com/EWS/Exchange.asmx
2022/11/28 06:57:15:693 [FBCalendarStore+Debug.m:234|com.apple.main-thread]     Calendar, com.apple.iCal, enabled, eventkit
2022/11/28 06:57:15:694 [FBCalendarStore+Debug.m:232|com.apple.main-thread]     Constantin Loew, f17ed554195612f629f9a59b4d95381c253aef31, disabled, caldav, c.loew@adnymics.com, https://apidata.googleusercontent.com/caldav/v2/c.loew%40adnymics.com/user
2022/11/28 06:57:15:694 [FBCalendarStore+Debug.m:234|com.apple.main-thread]     Contacts, internal-addressbook-source, enabled, addressbook
2022/11/28 06:57:15:694 [FBCalendarStore+Debug.m:232|com.apple.main-thread]     Flexibits, internal-flexibits-source, enabled, flexibits, f07b0923-34af-4daf-982f-a9a2eeb565f4, https://flexibits.com
2022/11/28 06:57:15:694 [FBCalendarStore+Debug.m:234|com.apple.main-thread]     Subscriptions, internal-subscription-source, enabled, subscription
2022/11/28 06:57:15:694 [FBCalendarStore+Debug.m:234|com.apple.main-thread]     Weather, internal-weather-source, enabled, weather
2022/11/28 06:57:15:694 [FBCalendarStore+Debug.m:238|com.apple.main-thread] Calendars:
2022/11/28 06:57:15:697 [FBCalendarStore+Debug.m:244|YapDatabaseConnection]     Calendar, b9ca7354dafd95ebc9a78cf8d292220ef620955f, 9fc34fe63f4a579362f1c304116e0094c40283c6, 1/0 (count: 265)
2022/11/28 06:57:15:697 [FBCalendarStore+Debug.m:244|YapDatabaseConnection]     Birthdays, b9ca7354dafd95ebc9a78cf8d292220ef620955f, 3ad1c301a71881730cefc863bcecf87ff9b56a2d, 1/0 (count: 45)
2022/11/28 06:57:15:697 [FBCalendarStore+Debug.m:244|YapDatabaseConnection]     Familienbereich, b9ca7354dafd95ebc9a78cf8d292220ef620955f, 9f3a072a7facc42c2abff786827bc02cebcecfa9, 1/0 (count: 0)
2022/11/28 06:57:15:698 [FBCalendarStore+Debug.m:244|YapDatabaseConnection]     US Holidays, b9ca7354dafd95ebc9a78cf8d292220ef620955f, 61829d371bf2b120f015a9ef54c0f49af62f02f5, 1/0 (count: 237)
2022/11/28 06:57:15:698 [FBCalendarStore+Debug.m:244|YapDatabaseConnection]     Tasks, b9ca7354dafd95ebc9a78cf8d292220ef620955f, 4d4504429e797ba2e059d9cae953a743dbe0d811, 0/1 (count: 6)
2022/11/28 06:57:15:698 [FBCalendarStore+Debug.m:244|YapDatabaseConnection]     Familienbereich, b9ca7354dafd95ebc9a78cf8d292220ef620955f, f96fbc7b46c1a6654ac93e7228da11885e3857c2, 0/1 (count: 2)
2022/11/28 06:57:15:698 [FBCalendarStore+Debug.m:244|YapDatabaseConnection]     Proposals, internal-flexibits-source, flexibits-proposals, 1/0 (count: 0)
2022/11/28 06:57:15:700 [FBCalendarStore+Debug.m:244|YapDatabaseConnection]     Feiertage in Deutschland, 12bd453010cc17ebabf51a10f8e540df6307fdef, 5c903f0e8657e41511592bfa85feee40888befc6, 1/0 (count: 325)
2022/11/28 06:57:15:701 [FBCalendarStore+Debug.m:244|YapDatabaseConnection]     Holidays in Germany, 12bd453010cc17ebabf51a10f8e540df6307fdef, 17fac217f3f08c6287c518a385c1e116e8f4753c, 1/0 (count: 325)
2022/11/28 06:57:15:701 [FBCalendarStore+Debug.m:244|YapDatabaseConnection]     Contacts, 12bd453010cc17ebabf51a10f8e540df6307fdef, 83c341a647bd065516e25eb8ed57fcb251e67939, 1/0 (count: 6)
2022/11/28 06:57:15:701 [FBCalendarStore+Debug.m:244|YapDatabaseConnection]     averagetryhardbear@gmail.com, 12bd453010cc17ebabf51a10f8e540df6307fdef, cb89fb2884db618530e3d6f89f4fc959e0e54152, 1/0 (count: 206)
2022/11/28 06:57:15:702 [FBCalendarStore+Debug.m:244|YapDatabaseConnection]     Constantin Loew's list, 12bd453010cc17ebabf51a10f8e540df6307fdef, 9b376430808e1f2ebc59fdc447676d8c6825f546, 0/1 (count: 1)
2022/11/28 06:57:15:702 [FBCalendarStore+Debug.m:244|YapDatabaseConnection]     Reminders, com.apple.iCal, 3C8C2A71-84BF-4C87-8EFD-BB4827650D15, 0/1 (count: 0)
2022/11/28 06:57:15:702 [FBCalendarStore+Debug.m:244|YapDatabaseConnection]     TUM, internal-subscription-source, 6B266B53-ACDF-468B-A141-B1A1EDF9CC7F, 1/0 (count: 0)
2022/11/28 06:57:15:702 [FBCalendarStore+Debug.m:244|YapDatabaseConnection]     Anniversaries, internal-addressbook-source, anniversaries, 1/0 (count: 0)
2022/11/28 06:57:15:702 [FBCalendarStore+Debug.m:244|YapDatabaseConnection]     Birthdays, internal-addressbook-source, birthdays, 1/0 (count: 0)
2022/11/28 06:57:15:702 [FBCalendarStore+Debug.m:268|com.apple.main-thread] No current calendar set
2022/11/28 06:57:15:702 [FBCalendarStore+Debug.m:274|com.apple.main-thread] Default event calendar: Calendar 9fc34fe63f4a579362f1c304116e0094c40283c6
2022/11/28 06:57:15:702 [FBCalendarStore+Debug.m:275|com.apple.main-thread] Default task calendar: Tasks 4d4504429e797ba2e059d9cae953a743dbe0d811
2022/11/28 06:57:15:702 [FBCalendarStore+Debug.m:276|com.apple.main-thread] Sync queues: ExchangeSourceHandler / b9ca7354dafd95ebc9a78cf8d292220ef620955f (consti.loew@live.com, last sync: (null), 0): <FBSyncQueue: 0x60000371ba00, active? 0, (
)>

FBFlexibitsSourceHandler / internal-flexibits-source (f07b0923-34af-4daf-982f-a9a2eeb565f4, last sync: (null), 0): <FBSyncQueue: 0x600003743300, active? 0, (
)>

FBGoogleSourceHandler / 12bd453010cc17ebabf51a10f8e540df6307fdef (averagetryhardbear@gmail.com, last sync: (null), 0): <FBSyncQueue: 0x60000371b700, active? 0, (
)>

2022/11/28 06:57:15:702 [FBCalendarStore+Debug.m:278|com.apple.main-thread] Verbose sources:

"""

let logBeginParser = Parse {
    Skip {
        Prefix { $0 != " " }; " "
        Prefix { $0 != " " }; " "
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
    logBeginParser; "Sync queues: "
    Many {
        syncQueueParser
    } separator: {
        "\n"
    }
}

let calendarParser = Parse {
    Calendar(name: $0[0], id: $0[2])
} with: {
    logBeginParser
    Whitespace(1, .horizontal)
    Many {
        Prefix { $0 != "," && $0 != "\n" }.map(String.init)
    } separator: {
        ", "
    }
}
let calendarsParser = Parse {
    logBeginParser; "Calendars:\n"
    Many {
        calendarParser
    } separator: {
        "\n"
    }
    "\n"
}

let accountParser = Parse {
    print($0)
    return Account(name: $0[0], id: $0[1], mail: ($0.count > 4) ? $0[4] : nil)
} with: {
    logBeginParser; Whitespace(1, .horizontal)
    Many {
        Prefix { $0 != "," && $0 != "\n" }.map(String.init)
    } separator: {
        ", "
    }
}
let accountsParser = Parse {
    logBeginParser; "Accounts:\n"
    Many {
        accountParser
    } separator: {
        "\n"
    }
    "\n"
}

let (accounts, calendars, syncQueues) = try! Parse {
    print($2)
    return ($0, $1, $2)
} with: {
    Skip { logBeginParser; "Calendar store state\n" }
    accountsParser
    calendarsParser
    Skip {
        PrefixThrough("\n")
        PrefixThrough("\n")
        PrefixThrough("\n")
    }
    syncQueuesParser
    Skip { Rest() }
}.parse(exampleInput)
