//
//  ChatContactsResponseStorage.swift
//  Cure
//
//  Created by Saifulloh Fadli on 24/04/25.
//

protocol ChatContactsResponseStorage {
    func getResponse(
        for requestDto: ChatContactsRequestDTO,
        completion: @escaping (Result<ChatContactsPageDTO, Error>) -> Void
    )
    
    func save(
        responseDto: ChatContactsPageDTO,
        for requestDto: ChatContactsRequestDTO
    )
    
    func load(
        for requestDto: ChatContactsRequestDTO,
        completion: @escaping (ChatContactsPageDTO?) -> Void
    )
}
