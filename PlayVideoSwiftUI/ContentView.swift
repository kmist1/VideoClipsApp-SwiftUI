//
//  ContentView.swift
//  PlayVideoSwiftUI
//
//  Created by Krunal Mistry on 10/29/22.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @State var videos: [RemoteVideo] = []
    @ObservedObject var videosVM = VideoViewModel()
    @State private var selectedVideo: RemoteVideo?

    var body: some View {
        NavigationView {
                ScrollView {
                    ForEach(videos, id: \.self) { video in
                        VStack(alignment: .center) {
                            AsyncImage(url: URL(string: video.imgUrl)) { image in
                                image
                                    .resizable()
                                    .frame(width: 150, height: 300)
                                    .border(.black)
                            } placeholder: {
                                Image(systemName: "photo.fill")
                            }

                            VStack(alignment: .center) {
                                Text(video.title)
                                    .font(.title2)
                                    .bold()
                                Text(video.Description)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .onTapGesture {
                            selectedVideo = video
                        }
                        Divider()
                    }
                }
            .onAppear {
                videosVM.getVideoData()
            }
            .onChange(of: videosVM.videos) { newValue in
                self.videos = newValue
            }
        }
        .ignoresSafeArea()
        .fullScreenCover(item: $selectedVideo) {
            // on dismiss closure
        } content: { item in

            ZStack(alignment: .topLeading) {
                makeFullScreenVideoPlayer(for: item)

                Button {
                    selectedVideo = nil
                } label: {
                    Image(systemName: "xmark")
                }
                .background(Color.white)
                .padding(20)
            }

        }
    }

    @ViewBuilder
    private func makeFullScreenVideoPlayer(for video: RemoteVideo) -> some View {

        if let url = URL(string: video.remoteVideoUrl) {
            let avPlayer = AVPlayer(url: url)

            VideoPlayer(player: avPlayer)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    avPlayer.play()
                }
        } else {
            Text("Can not play video")
                .foregroundColor(.red)
                .font(.largeTitle)
        }
    }
}

class VideoViewModel: ObservableObject {
    let apiHandler = APIServices()
    @Published var videos: [RemoteVideo] = []

    func getVideoData() {
        Task {
            do {
                let data = try await apiHandler.fetchLocalData(fileName: "RemoteVideos", of: [RemoteVideo].self)
                if let videoData = try data?.get() {
                    DispatchQueue.main.async {
                        self.videos = videoData
                    }
                }
            } catch {
                NSLog("Error: \(error)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
