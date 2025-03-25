//
//  UseCase.swift
//  Cure
//
//  Created by MacBook Air MII  on 25/3/25.
//

import Foundation

protocol UseCase {
    @discardableResult
    func start() -> Cancellable?
}
