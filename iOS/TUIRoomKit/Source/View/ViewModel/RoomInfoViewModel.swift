//
//  RoomInfoViewModel.swift
//  TUIRoomKit
//
//  Created by 唐佳宁 on 2023/1/3.
//  Copyright © 2022 Tencent. All rights reserved.
//

import Foundation

class RoomInfoViewModel {
    private(set) var messageItems: [ListCellItemData] = []
    
    init() {
        createSourceData()
    }
    
    func createSourceData() {
        let roomHostItem = ListCellItemData()
        roomHostItem.titleText = .roomHostText
        var userName = EngineManager.shared.store.roomInfo.owner
        if let userModel = EngineManager.shared.store.attendeeList.first(where: { $0.userId == EngineManager.shared.store.roomInfo.owner}) {
            userName = userModel.userName
        }
        roomHostItem.messageText = userName
        messageItems.append(roomHostItem)
        
        let roomTypeItem = ListCellItemData()
        roomTypeItem.titleText = .roomTypeText
        if EngineManager.shared.store.roomInfo.enableSeatControl {
            roomTypeItem.messageText = .raiseHandSpeakText
        } else {
            roomTypeItem.messageText = .freedomSpeakText
        }
        messageItems.append(roomTypeItem)
        
        let roomIdItem = ListCellItemData()
        roomIdItem.titleText = .roomIdText
        roomIdItem.messageText = EngineManager.shared.store.roomInfo.roomId
        roomIdItem.hasButton = true
        roomIdItem.normalIcon = "room_copy"
        roomIdItem.resourceBundle = tuiRoomKitBundle()
        roomIdItem.action = { [weak self] sender in
            guard let self = self, let button = sender as? UIButton else { return }
            self.copyAction(sender: button, text: roomIdItem.messageText)
        }
        messageItems.append(roomIdItem)
        
        let roomLinkItem = ListCellItemData()
        roomLinkItem.titleText = .roomLinkText
        roomLinkItem.messageText = "https://web.sdk.qcloud.com/component/tuiroom/index.html#/" + "#/room?roomId=" +
        EngineManager.shared.store.roomInfo.roomId
        roomLinkItem.hasButton = true
        roomLinkItem.normalIcon = "room_copy"
        roomLinkItem.resourceBundle = tuiRoomKitBundle()
        roomLinkItem.action = { [weak self] sender in
            guard let self = self, let button = sender as? UIButton else { return }
            self.copyAction(sender: button, text: roomLinkItem.messageText)
        }
        messageItems.append(roomLinkItem)
    }
    
    func copyAction(sender: UIButton, text: String) {
        UIPasteboard.general.string = text
    }
    
    func codeAction(sender: UIButton) {
        RoomRouter.shared.dismissPopupViewController(animated: false)
        RoomRouter.shared.pushQRCodeViewController()
    }
    
    deinit {
        debugPrint("deinit \(self)")
    }
}

private extension String {
    static let freedomSpeakText = localized("TUIRoom.freedom.speaker")
    static let raiseHandSpeakText = localized("TUIRoom.raise.speaker")
    static let roomHostText = localized("TUIRoom.host")
    static let roomTypeText = localized("TUIRoom.room.type")
    static let roomIdText = localized("TUIRoom.room.num")
    static let roomLinkText = localized("TUIRoom.room.link")
}