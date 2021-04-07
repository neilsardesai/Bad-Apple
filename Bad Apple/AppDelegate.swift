//
//  AppDelegate.swift
//  Bad Apple
//
//  Created by Neil Sardesai on 4/7/21.
//

import Cocoa
import SpriteKit
import AVFoundation

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    static let videoSize = CGSize(width: 27, height: 20)
    let statusItem = NSStatusBar.system.statusItem(withLength: videoSize.width)
    let videoPlayer = AVPlayer(url: Bundle.main.url(forResource: "badapple-alpha", withExtension: "mov")!)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let menu = NSMenu()
        menu.addItem(withTitle: "Restart", action: #selector(restart), keyEquivalent: "")
        menu.addItem(withTitle: "Quit", action: #selector(quit), keyEquivalent: "")
        statusItem.menu = menu
        
        let scene = SKScene(size: statusItem.button!.frame.size)
        scene.backgroundColor = .clear
        
        let view = ClickIgnoringView(frame: statusItem.button!.frame)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.allowsTransparency = true
        view.wantsLayer = true
        
        // Technically not supposed to modify the layer like this but yolo
        view.layer?.cornerRadius = 4
        view.layer?.cornerCurve = .continuous
        
        statusItem.button?.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: statusItem.button!.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: statusItem.button!.centerYAnchor),
            view.widthAnchor.constraint(equalToConstant: AppDelegate.videoSize.width),
            view.heightAnchor.constraint(equalToConstant: AppDelegate.videoSize.height)
        ])
                
        view.presentScene(scene)
        
        // For some reason it crashes if the video node is the only thing in the scene ಠ_ಠ
        let randomSprite = SKSpriteNode(color: .clear, size: statusItem.button!.frame.size)
        scene.addChild(randomSprite)
                
        let video = SKVideoNode(avPlayer: videoPlayer)
        video.position = CGPoint(x: view.frame.midX, y: view.frame.midY)
        video.size = CGSize(width: view.frame.width, height: view.frame.height)
        scene.addChild(video)
        videoPlayer.play()
    }
    
    @objc func restart() {
        videoPlayer.seek(to: .zero)
        videoPlayer.play()
    }
    
    @objc func quit() {
        NSApp.terminate(self)
    }

}

class ClickIgnoringView: SKView {
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        nil
    }
    
}
