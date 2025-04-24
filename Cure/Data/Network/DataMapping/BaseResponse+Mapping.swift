//
//  BaseResponse+Mapping.swift
//  Cure
//
//  Created by MacBook Air MII  on 24/4/25.
//
struct BaseSuccessResponse<T: Codable>: Codable {
    let success: Bool
    let data: T
}


struct BaseResponse<T: Codable >: Codable {
    var message: String
    var success: Bool
    var status: Int
    var errors: [BaseErrorResponse]
    var data: T?
}

struct BaseErrorResponse: Codable {
    var path: String?
    var message: String?
}

