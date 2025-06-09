//
//  ChatContactsResponseStorage.swift
//  Cure
//
//  Created by Saifulloh Fadli on 24/04/25.
//

protocol ChattingResponseStorage {
    func getResponse(
        for requestDto: ChattingRequestDTO,
        completion: @escaping (Result<MessagesPageDTO, Error>) -> Void
    )
    
    func save(
        responseDto: MessagesPageDTO,
        for requestDto: ChattingRequestDTO
    )
    
    func load(
        for requestDto: ChattingRequestDTO,
        completion: @escaping (MessagesPageDTO?) -> Void
    )
}
