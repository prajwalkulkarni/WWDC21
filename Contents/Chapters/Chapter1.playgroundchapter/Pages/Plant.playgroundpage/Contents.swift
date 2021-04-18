/*:
 ## Plant a tree, plant a hope!
 
 What better way to fight against climate change than planting a tree?
 Trees give off fresh oxygen, remove carbon dioxide from the atmosphere, prevent soil erosion, provide food and much more.
 
 In this chapter, we're starting off by planting a sapling.
 
 When a sapling or a seedling is planted, it is highly prone to be attacked by worms 🐛🐛.
 
 ---
 
 **Task** :
 Plant the sapling by clicking on the sapling seen on the top right corner.
 
 Watch out for the green evil worms which are eagerly waiting to eat our newly planted sapling.
 Make sure that no worm comes in contact with the plant.
 Contact between the worm and the plant can be avoided by spraying pesticides on the worm(clicking on the worm). Click on "Run My Code" to play.
 
 * Note:
   If you experience a laggy scene or notice any drop in frame rate, please consider turning off the "Enable results" under "Run options".
 
 */


//#-hidden-code


import SpriteKit
import PlaygroundSupport
import UIKit

let skView = SKView(frame: .zero)

let gameScene = GameScene(size: UIScreen.main.bounds.size, page: 1,isRaining: false)



gameScene.scaleMode = .aspectFill

skView.presentScene(gameScene)
PlaygroundPage.current.liveView = skView

PlaygroundPage.current.wantsFullScreenLiveView = true






//#-end-hidden-code
