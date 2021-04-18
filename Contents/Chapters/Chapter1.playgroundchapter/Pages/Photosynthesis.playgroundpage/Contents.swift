/*:
 ## A piece of sunshine
 
 
 Sunlight is just as important to plant's growth and its sustainability as water is.
 
 Green plants convert the light from the sun (light energy) to chemical energy.
 This process of conversion of light energy to chemical energy is known to be **Photosynthesis** .
 
 **Chlorophyll** is the molecule responsible to absorb sunlight and use the energy to synthesize carbohydrates from CO2 and water.
 It is also responsible for the green color of the leaves.
 
 The synthesized carbohydrates( plant nutrients) are transported across the plant/tree using **phloem** .
 
 
 Photosynthesis depends on the intensity of light, and thus, it is important to have a constant source of light for a set duration.
 The best source of such light is sunlight.
 
 
 ---
 
 
**Task** :
 
 Our plant is growing well so far, but the growth would still be hindered in the absence of light.
 In this task, we are going to provide our plant with sunlight.
 
 The sun keeps dimming, keep tapping on the sun to avoid dimming. The dimming stops once it reaches a certain point (opacity of 1.0). Further, you can observe the plant grow into a tree, once the light source is constant. Click on "Run My Code" to play.
 
 
 * Note:
   If you experience a laggy scene or notice any drop in frame rate, please consider turning off the "Enable results" under "Run options".
 
 */


//#-hidden-code


import SpriteKit
import PlaygroundSupport
import UIKit

let skView = SKView(frame: .zero)

let gameScene = GameScene(size: UIScreen.main.bounds.size, page: 3, isRaining: false)



gameScene.scaleMode = .aspectFill

skView.presentScene(gameScene)
PlaygroundPage.current.liveView = skView
PlaygroundPage.current.wantsFullScreenLiveView = true


//#-end-hidden-code
