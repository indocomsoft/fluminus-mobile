//
//  Modules.swift
//  Fluminus
//
//  Created by Julius on 25/12/19.
//  Copyright © 2019 Julius. All rights reserved.
//

import Combine
import Foundation

struct Module: Codable, Identifiable {
    struct Access: Codable {
        let full: Bool
        let read: Bool
        let create: Bool
        let update: Bool
        let delete: Bool
        let settingsRead: Bool
        let settingsUpdate: Bool

        private enum CodingKeys: String, CodingKey {
            case full = "access_Full"
            case read = "access_Read"
            case create = "access_Create"
            case update = "access_Update"
            case delete = "access_Delete"
            case settingsRead = "access_Settings_Read"
            case settingsUpdate = "access_Settings_Update"
        }
    }

    let id: String
    let code: String
    let name: String
    let term: String
    let access: Access

    var isTeaching: Bool {
        access.full || access.create || access.update || access.delete || access.settingsRead || access.settingsUpdate
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case code = "name"
        case name = "courseName"
        case term
        case access
    }

    func getAnnouncements(loginToken: LoginToken, archived: Bool = false)
        -> AnyPublisher<[Announcement], FluminusError> {
        let archivedPath = archived ? "Archived" : "NonArchived"
        let path = "/announcement/\(archivedPath)/\(id)?sortby=displayFrom%20ASC"
        return loginToken.api(path: path, of: [Announcement].self)
            .map { $0.map { announcement in announcement.removingHTMLTags() ?? announcement } }
            .eraseToAnyPublisher()
    }
}
