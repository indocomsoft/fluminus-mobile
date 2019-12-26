//
//  Announcement.swift
//  Fluminus
//
//  Created by Julius on 26/12/19.
//  Copyright © 2019 Julius. All rights reserved.
//

import Foundation

struct Announcement: Codable, Identifiable {
    let id: String
    let title: String
    let content: String
    let updated: Date

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case content = "description"
        case updated = "lastUpdatedDate"
    }

    func removingHTMLTags() -> Announcement? {
        guard let data = content.data(using: .unicode),
            let newContent = try? NSAttributedString(data: data,
                                                     options: [.documentType: NSAttributedString.DocumentType.html],
                                                     documentAttributes: nil).string
        else {
            return nil
        }
        return Announcement(id: id, title: title, content: newContent, updated: updated)
    }
}
