//
//  Domain.swift
//  Fluminus
//
//  Created by Julius on 24/12/19.
//  Copyright © 2019 Julius. All rights reserved.
//

import Foundation

enum Domain: String, Identifiable, CaseIterable {
    var id: String { rawValue }

    case nusstu = "NUSSTU"
    case nusstf = "NUSSTF"
}
