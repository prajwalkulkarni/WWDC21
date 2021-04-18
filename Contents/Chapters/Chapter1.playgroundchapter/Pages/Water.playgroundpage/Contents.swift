/*:
 ## No water, no life!
 
 Every creature on this planet requires water for its survival and growth, and so do plants.
 
 Plants consume water dissolved in the soil through their roots.
 This is achieved using a tissue called **Xylem**.
 Xylem is a transport tissue whose basic function is to transport water and minerals from roots to stems and leaves.
 The xylem, vessels, and tracheids of the roots, stems, and leaves are interconnected to form a
 continuous system of water conducting channels reaching all parts of the plant. It is also used to replace water lost during transpiration and photosynthesis.
 
 ---
 
 **Task** :
 Now that we've planted our sapling and protected it against the attack by the worms.
 It's now time to water the plant and help it grow.
 set `isRaining` to `true` below and run the code. After some time, you can observe the plant grow. Click on "Run My Code" when ready.
 
 
 * Note:
   If you experience a laggy scene or notice any drop in frame rate, please consider turning off the "Enable results" under "Run options".
 
 
 */

//#-code-completion(literal, show, boolean)
let isRaining = /*#-editable-code*/false/*#-end-editable-code*/


//#-hidden-code


import SpriteKit
import PlaygroundSupport
import UIKit

let skView = SKView(frame: .zero)

let gameScene = GameScene(size: UIScreen.main.bounds.size, page: 2, isRaining : isRaining)



gameScene.scaleMode = .aspectFill

skView.presentScene(gameScene)
PlaygroundPage.current.liveView = skView
PlaygroundPage.current.wantsFullScreenLiveView = true





//#-end-hidden-code
