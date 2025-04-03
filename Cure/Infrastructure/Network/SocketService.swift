//
//  SocketService.swift
//  Cure
//
//  Created by MacBook Air MII  on 27/3/25.
//

import Starscream
import SocketIO

protocol SocketService {
    func connect(from vc: String)
    func dissconnect()
    func socketStatus() -> SocketIOStatus
    func send(message: String)
    func subscribe(to event: @escaping (Result<String, Error>) -> Void)
}

final class DefaultSocketService: SocketService {
    private let manager: SocketManager
    
    private let socket: SocketIOClient
    
    private let key: String
    
    private var isConnected: Bool = false
    
    private var appConfiguration: AppConfiguration
    private let getUserUsecase: DefaultGetCurrentUserUseCase
    
    private init() {
        let keychainRepository = DefaultKeychainRepository()
        self.appConfiguration = AppConfiguration()
        self.getUserUsecase = DefaultGetCurrentUserUseCase(keychainRepository: keychainRepository)
        self.manager = SocketManager(socketURL: URL(string: appConfiguration.newApiBaseURL)!)
        self.socket = manager.defaultSocket
        self.key = appConfiguration.keyConnection
    }
    
    func connect(from vc: String) {
        printed(vc, "conn_established")
        addHandlers()
        socket.connect(withPayload: ["token": key])
    }
        
    func dissconnect() {
        printed("dissconnect")
        socket.disconnect()
    }
    
    func socketStatus() -> SocketIOStatus {
        return socket.status
    }
        
    func send(message: String) {}
    
    func subscribe(to event: @escaping (Result<String, any Error>) -> Void) {
        
    }
    
    private func printed(_ items: Any...) {
    }
    
    private func emit() {
        if let id = getUserUsecase.execute()?.token {
            let payload: [String:Any] = [
                "employeeID": id,
                "device": "iOS"
            ]
            printed("emit", payload)
            socket.emit("joined", payload)
        } else {
            printed("emit", "ID Employee Error")
        }
    }
    
    private func emitPong() {
        let payload = ["data":"pong"]
        socket.emit("pong", payload)
        self.printed(["emit-pong"])
    }
    
    private func addHandlers() {
        printed("addHandlers")
        socket.on(clientEvent: .connect, callback: { data,ack in
            self.printed("connect", data, ack)
            self.emit()
            NotificationCenter.default.post(name: .socketConnected, object: nil)
        })
        socket.on(clientEvent: .disconnect, callback: { data,ack in
            self.printed("disconnect", data, ack)
            NotificationCenter.default.post(name: .socketDisconnected, object: nil)
        })
        socket.on("joined", callback: { data,ack in
            self.printed("joined", data, ack)
            NotificationCenter.default.post(name: .socketJoined, object: nil)
        })
        socket.on("new-message-status", callback: { data,ack in
            self.printed("new-message-status", data, ack)
            NotificationCenter.default.post(name: .socketNewMessageStatus, object: data)
        })
        socket.on("new-message", callback: { data,ack in
            NotificationCenter.default.post(name: .socketNewMessage, object: data)
        })
        socket.on("contact-paired", callback: { data,ack in
            self.printed("contact-paired", data, ack)
            NotificationCenter.default.post(name: .socketContactPaired, object: nil)
        })
        socket.on("broadcast-status", callback: { data, ack in
            self.printed("broadcast-status", data, ack)
            
            // Assuming data is an array with one dictionary
            if let dictArray = data as? [[String: Any]],
               let dict = dictArray.first {
                NotificationCenter.default.post(name: .socketBroadcastStatus, object: dict)
            }
        })

        socket.on("online-status", callback: { data,ack in
            self.printed("online-status", data, ack)
            NotificationCenter.default.post(name: .socketOnlineStatus, object: nil)
        })
        
        socket.on(clientEvent: .statusChange) { data, ack in
            self.printed("statusChange", data, ack)
        }
        
        socket.on(clientEvent: .ping) { data, ack in
            self.printed("ping", data, ack, self.socketStatus())
            self.emitPong()
        }
        
        socket.on(clientEvent: .pong) { data, ack in
            self.printed("pong", data, ack, self.socketStatus())
        }
    }
}
