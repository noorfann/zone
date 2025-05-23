//
//  TimerMode.swift
//  zone
//
//  Created by Zulfikar Noorfan on 23/05/25.
//

import Foundation

enum TimerMode: String, Codable {
    case work
    case shortBreak
    case longBreak
    case idle
    case custom

    var displayName: String {
        switch self {
        case .work: return "Work"
        case .shortBreak: return "Short Break"
        case .longBreak: return "Long Break"
        case .custom: return "Custom"
        case .idle: return "Idle"
        }
    }
}
