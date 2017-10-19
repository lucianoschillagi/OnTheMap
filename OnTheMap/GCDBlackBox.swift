//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Luciano Schillagi on 29/6/17.
//  Copyright © 2017 Luko. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}

