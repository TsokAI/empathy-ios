//
//  ApiResponse.swift
//  empathy-ios
//
//  Created by Tak on 07/12/2018.
//  Copyright © 2018 tucan9389. All rights reserved.
//

import Foundation



public enum RequestResult<T> {
    case success(T)
    case failure(message: String)
}

