//
//  AnnouncementView.swift
//  Fluminus
//
//  Created by Julius on 26/12/19.
//  Copyright © 2019 Julius. All rights reserved.
//

import Combine
import SwiftUI

struct AnnouncementView: View {
    @ObservedObject var account: Account = .shared

    let module: Module
    @State var announcements: [Announcement]
    @State var isLoading = true

    @State var cancellables = Set<AnyCancellable>()

    init(module: Module, announcements: [Announcement] = []) {
        self.module = module
        _announcements = State(initialValue: announcements)
    }

    var content: some View {
        List(announcements, id: \.id) { announcement in
            VStack {
                Text(announcement.title).font(.headline)
                Text(announcement.content)
            }
        }
        .navigationBarTitle(module.code)
        .onAppear {
            self.hookAnnouncements()
        }
    }

    @ViewBuilder
    var body: some View {
        if isLoading {
            content.overlay(ActivityIndicator(isShown: $isLoading))
        } else {
            content
        }
    }

    private func hookAnnouncements() {
        account.$accessToken
            .catch { _ in Just(nil) }
            .compactMap { $0 }
            .sink { accessToken in
                self.module.getAnnouncements(loginToken: accessToken)
                    .catch { _ in Just([]) }
                    .sink(receiveValue: { announcements in
                        self.isLoading = false
                        self.announcements = announcements
                    })
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
    }
}

#if DEBUG
    struct AnnouncementView_Previews: PreviewProvider {
        static let access = Module
            .Access(full: true, read: true, create: true, update: true, delete: true,
                    settingsRead: true, settingsUpdate: true)
        static let module = Module(id: "123", code: "CS1101S", name: "Programming Methodology",
                                   term: "1820", access: access)
        static let announcements = [
            Announcement(id: "123",
                         title: "asd",
                         // swiftlint:disable line_length
                         content: "<p>Please apply through this form: <a href=\"https://forms.gle/tGq23jE2BUZHaace8\" rel=\"noreferrer\" target=\"_blank\">https://forms.gle/tGq23jE2BUZHaace8</a></p>\n\n<p>Applications close on 31/1/2020.</p>\n\n<p> </p>\n\n<p>-martin</p>\n",
                         // swiftlint:enable line_length
                         updated: .distantFuture).removingHTMLTags()!,
            Announcement(id: "1", title: "asd", content: "xxx", updated: .distantFuture),
            Announcement(id: "125", title: "asd", content: "xxx", updated: .distantFuture),
        ]

        static var previews: some View {
            NavigationView {
                AnnouncementView(module: module, announcements: announcements)
            }
        }
    }
#endif
