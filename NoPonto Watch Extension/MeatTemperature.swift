//
//  MeatTemperature.swift
//  NoPonto Watch Extension
//
//  Created by Decio Montanhani on 18/03/20.
//  Copyright © 2020 Decio Montanhani. All rights reserved.
//

import Foundation

enum MeatTemperature: Int {
    case rare = 0, mediumRare, medium, wellDone

    var stringValue: String {
        let temperatures = ["Cru", "Mal passado", "Ao ponto", "Bem passado"]
        return temperatures[rawValue]
    }

    var timeModifier: Double {
        let modifiers = [0.5, 0.75, 1.0, 1.5]
        return modifiers[rawValue]
    }

    func cookTimeFor(_ kg: Double) -> TimeInterval {
        let baseTime: TimeInterval = 1.3 * 60
        let baseWeight = 0.5
        let weightModifier: Double = kg/baseWeight
        return baseTime * weightModifier * timeModifier
    }
}
