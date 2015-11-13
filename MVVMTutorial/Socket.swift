//
//  Socket.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-13.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import Starscream
import ReactiveCocoa

enum SocketType {
  case EchoServer
}

protocol Socket: WebSocketDelegate {}
extension Socket {
  func websocketDidConnect(socket: WebSocket) {
    print("WebSocket Connected")
  }
  
  func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
    print("WebSocket disconneted with error: \(error)")
  }
}

class EchoSocket: Socket {
  private let webSocket: WebSocket
  let text = MutableProperty("")
  let echo = MutableProperty("")
  
  init() {
    webSocket = WebSocket(url: NSURL(string: "ws://echo.websocket.org")!)
    webSocket.delegate = self
    
    text.producer.startWithNext { [unowned self] in self.webSocket.writeString($0) }
  }
  
  func connect() {
    webSocket.connect()
  }
}

extension EchoSocket {
  func websocketDidReceiveMessage(socket: WebSocket, text: String) {
    echo.value = text
  }
  
  func websocketDidReceiveData(socket: WebSocket, data: NSData) {}
}

//class Socket {
//  private let webSocket: WebSocket
//  private let socketType: SocketType
//
//  init(socketType: SocketType) {
//    self.socketType = socketType
//    webSocket = WebSocket(url: NSURL(string: "")!)
//    webSocket.delegate = self
//  }
//
//  func connect() {
//    webSocket.connect()
//  }
//}
//
//extension Socket: WebSocketDelegate {
//  func websocketDidConnect(socket: WebSocket) {
//    print("WebSocket Connected for \(socketType)")
//  }
//
//  func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
//    print("WebSocket Disconneted for \(socketType) with error: \(error)")
//  }
//
//
//}
