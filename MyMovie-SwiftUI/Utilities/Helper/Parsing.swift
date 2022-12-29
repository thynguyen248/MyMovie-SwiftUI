//
//  Parsing.swift
//  MyMovie-SwiftUI
//
//  Created by Thy Nguyen on 5/1/20.
//  Copyright © 2020 Thy Nguyen. All rights reserved.
//

import Foundation
import Combine

func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, NetworkRequestError> {
    return Just(data).decode(type: T.self, decoder: JSONDecoder())
        .mapError { error in
            .decodingError(error.localizedDescription)
        }
        .eraseToAnyPublisher()
}
