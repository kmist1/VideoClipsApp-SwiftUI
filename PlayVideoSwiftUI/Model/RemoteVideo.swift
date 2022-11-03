//
//  RemoteVideo.swift
//  PlayVideoSwiftUI
//
//  Created by Krunal Mistry on 10/31/22.
//

import Foundation

struct RemoteVideo: Decodable, Hashable, Identifiable {
    let id = UUID()
    let title: String
    let Description: String
    let imgUrl: String
    let fileName: String
    let remoteVideoUrl: String
}
