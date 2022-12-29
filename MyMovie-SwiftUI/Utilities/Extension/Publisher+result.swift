//
//  Publisher+result.swift
//  MyMovie-SwiftUI
//
//  Created by Thy Nguyen on 12/28/22.
//  Copyright © 2022 Thy Nguyen. All rights reserved.
//

import Combine

extension Publisher {
    func asResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        self.map(Result.success)
            .catch { error in
                Just(.failure(error))
            }
            .eraseToAnyPublisher()
    }
}
