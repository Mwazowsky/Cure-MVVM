//
//  KeyedDecodingCOntainer+Helper.swift
//  Cure
//
//  Created by MacBook Air MII  on 9/6/25.
//

extension KeyedDecodingContainer {
    func decodeSafeInt(forKey key: K) -> Int? {
        if let intVal = try? decode(Int.self, forKey: key) {
            return intVal
        } else if let stringVal = try? decode(String.self, forKey: key),
                  let intFromStr = Int(stringVal) {
            return intFromStr
        } else {
            return nil
        }
    }
}
