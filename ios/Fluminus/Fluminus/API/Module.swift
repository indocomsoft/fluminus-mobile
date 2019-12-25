//
//  Modules.swift
//  Fluminus
//
//  Created by Julius on 25/12/19.
//  Copyright © 2019 Julius. All rights reserved.
//

import Foundation

struct Module: Codable {
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
}
