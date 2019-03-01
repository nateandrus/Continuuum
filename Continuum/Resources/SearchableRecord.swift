//
//  SearchableRecord.swift
//  Continuum
//
//  Created by Nathan Andrus on 2/27/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation

protocol SearchableRecord {
    func matches(searchTerm: String) -> Bool
}
