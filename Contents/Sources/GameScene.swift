// Code inside modules can be shared between pages and other source files.
import SpriteKit
import GameKit
import PlaygroundSupport
import AVFoundation

public class GameScene : SKScene, SKPhysicsContactDelegate {
    
    //MARK: - Variables and constants
    //Nodes
    private var trackCurrentNode:SKNode?
    private var plantNode:SKSpriteNode?
    private var wormNode:SKSpriteNode?
    private var sunNode: SKSpriteNode?
    
    //Labels
    private var restart:SKLabelNode?
    private var gameOverLabel:SKLabelNode?
    
    //Conditional flags
    private var flag: Bool = false
    private var run:Bool = true
    private var gameOver: Bool = false
    
    var touchEnd: Int = 0
    
    //Animation textures
    private var worms = [SKSpriteNode]()
    private var textures: [SKTexture] = []
    private var textures2: [SKTexture] = []
    private var textureSapling: [SKTexture] = []
    private var textureSapling2: [SKTexture] = []
    
    
    //Time
    private var lastUpdateTime: TimeInterval = 0
    private var currentRainDropSpawnTime: TimeInterval = 0
    private var currentRainDropSpawnRate : TimeInterval = 0.1
    
    private var sunFadeRate : TimeInterval = 0.5
    private var currentSunFadeRate : TimeInterval = 0
    
    
    //Global variables
    private var wormCount: Int = 0
    private var killCount: Int = 0
    private var currentState: Int = 0
    
    
    //user control variables
    private var isRaining : Bool = false
    
    private let random = GKARC4RandomSource()
    private var pageNo : Int = 0
    
    //Sounds
    private var audioPlayer = AVAudioPlayer()
    private var backgroundAudio = AVAudioPlayer()
    
    
    //MARK: - Bitmask
    struct Category{
        
        static let plant: UInt32 = 1 << 1
        static let wormAttack: UInt32 = 1 << 2
        static let disappear: UInt32 = 1 << 3
        
    }
    
    //MARK: - Initialization
    public init(size: CGSize, page: Int, isRaining : Bool) {
        
        
        self.pageNo = page
        self.isRaining = isRaining
        
        for i in 1...4{
            
            //Worm textures
            
            textures.append(SKTexture(imageNamed: "\(i)l"))
            textures2.append(SKTexture(imageNamed: "\(i)r"))
        }
        
        textures.append(textures[2])
        textures.append(textures[1])
        
        textures2.append(textures2[2])
        textures2.append(textures2[1])
        
        
        for i in 1...5 {
            
            //Plant textures
            if i <= 3{
                textureSapling.append(SKTexture(imageNamed: "\(i)"))
            }
            else{
                
                textureSapling2.append(SKTexture(imageNamed: "\(i)"))
            }
            
        }
        
        
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        //Setup Background
        let bg = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "game_bg.png")))
        
        bg.setScale(0.6)
        bg.position = CGPoint(x: frame.midX, y: frame.midY)
        
        bg.zPosition = -10
        
        addChild(bg)
        
        //Initialize plant with respect to it's current state.
        createPlant(plantState: pageNo)
        
        
        
        if isRaining{
            
            print("run block")
            playSound(name: "rain")
            
            plantNode!.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            
            plantNode!.run(SKAction.sequence([SKAction.wait(forDuration: 5.0),SKAction.animate(with: textureSapling, timePerFrame: 3.0),SKAction.scale(to: 0.7, duration: 2.0),SKAction.wait(forDuration: 2.0)])){
                print("Done")
                
                PlaygroundPage.current.assessmentStatus = .pass(message: "Well done, notice how our plant has started to grow.\(getNextPage())")
            }
            
            
        }
        
        
        
        
        /*plant = SKLabelNode(text: "Plant")
        
        if let sapling = plant{
            sapling.color = UIColor.yellow
            sapling.zPosition=10
            sapling.position = CGPoint(x: frame.maxX-150.0, y: frame.maxY-150.0)
            addChild(sapling)
            
        }*/
        
    }
    
    /*public func didBegin(_ contact: SKPhysicsContact) {
        let contactA:SKPhysicsBody = contact.bodyA
        
        let contactB:SKPhysicsBody = contact.bodyB
        
        let nodeA = contactA.node as! SKSpriteNode
        let nodeB = contactB.node as! SKSpriteNode
        
        if contactA.categoryBitMask == 1 || contactB.categoryBitMask == 1{
            print("Collision")
        }
        
    }*/
    
    
    //MARK: - Touch actions
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for touch in touches{
            
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            
            
            //Track the sapling's coordinates
            if node.name == "saplingobject"{
                print("reinitialized")
                self.trackCurrentNode = node
            }
            
            if let sunnyday = sunNode{
                if sunnyday.contains(node){
                    if sunnyday.alpha<=2.0{
                        sunNode!.alpha += 0.05
                        
                    }
                    else{
                        sunNode!.alpha = 1.5
                    }
                }
            }
        }
        
        
        
        guard let touchLocation = touches.first else {return}
        
        let touchCoordinate = touchLocation.location(in: self)
        
        let touchedNode = nodes(at: touchCoordinate)
        
        
        for node in touchedNode{
            for worm in worms {
                
                if node == worm{
                    //Reduce the worm's opacity each time it's pressed on, and play the spray sound.
                    worm.alpha -= 0.2
                    
                    playSound(name: "spray")
                    if worm.alpha <= 0.6 {
                        
                        if (worm.parent != nil){
                            killCount += 1
                        }
                        
                        //If the worm's opacity falls below 0.6, implies successful removal of the worm.
                        worm.physicsBody?.categoryBitMask = Category.disappear
                        worm.removeAllActions()
                        worm.removeFromParent()
                        
                        
                    }
                    
                }
                
                
            }
            
        }
            
            
 
    }
    
    public override func sceneDidLoad() {
        
        //spawnWorm()
        
        //Setup the floor/ground
        let floorNode = SKShapeNode(rectOf: CGSize(width: size.width, height: 105))
        //rgba(124,93,58,255)
        floorNode.position = CGPoint(x: size.width/2, y: 50)
        floorNode.fillColor = UIColor(red: 0.49, green: 0.36, blue: 0.23, alpha: 1.00)
        
        floorNode.strokeColor = .clear
        floorNode.name = "floor"
        
        floorNode.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -size.width/2, y: 50), to: CGPoint(x: size.width, y: 50))
        
        addChild(floorNode)
        
        
    }
    
    
    
    public func didBegin(_ contact: SKPhysicsContact) {
        
        
        
        //wormNode?.isPaused = true
        
        /*if (contact.bodyA.node!.name! == "saplingobject" && contact.bodyB.node!.name == "worm") ||
            (contact.bodyA.node!.name! == "worm" && contact.bodyB.node!.name == "saplingobject"){
            wormNode?.removeAllActions()
            
            
        }*/
        
        if contact.bodyA.categoryBitMask == Category.plant {
            
            for worm in worms {
                if contact.bodyB.node == worm {
                    worm.isPaused = true
                    worm.physicsBody = nil
                    enumerateChildNodes(withName: "worm"){(node, _) in
                        node.removeFromParent()
                    }
                    
                    //If a worms successfully attacks our plant, it means that the user's task was not accomplished. Reset all the values, and display the "restart" option
                    plantNode?.removeFromParent()
                    self.gameOver = true
                    currentState = 1
                    killCount = 0
                    wormCount = 0
                    self.trackCurrentNode = nil
                    gameOverLabel = SKLabelNode(text: "Game Over!")
                    gameOverLabel?.fontSize = 50
                    gameOverLabel?.fontColor = .black
                    gameOverLabel?.fontName = "KannadaSangamMN"
                    gameOverLabel?.position = CGPoint(x: frame.midX, y: 0.75*frame.size.height)
                    gameOverLabel?.zPosition = 10
                    
                    addChild(gameOverLabel!)
                    
                    restart = SKLabelNode(text: "Restart")
                    restart?.position = CGPoint(x: frame.midX, y: frame.midY)
                    restart?.fontColor = .blue
                    restart?.fontSize = 35
                    restart?.fontName = "KannadaSangamMN"
                    addChild(restart!)
                    removeAllActions()
                    
                }
            }
        }
    }
    
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        
        if let saplingNode = trackCurrentNode,let plantcoorinate = plantNode{
            
            touchEnd += 1
            
            let yPos = saplingNode.position.y
            
            
            if yPos > frame.midY { //check if the node position was out of region,if yes re-position it to the actual coordinates.
                
                if touchEnd == 1 {
                    flag = true
                    
                    //Spawn random number of worms ranging anywhere between 5 and 10
                    wormCount = Int.random(in: 5...10)
                    print(wormCount)
                    print("Run touches ended")
                    plantcoorinate.anchorPoint = CGPoint(x: 0.5, y: 0.2)
                    
                    plantcoorinate.run(SKAction.scale(to: 0.5, duration: 0.8))
                    plantcoorinate.position = CGPoint(x: size.width/2,y: plantcoorinate.size.height + 50.0)
                    //plantcoorinate.setScale(0.5)
                    
                    
                    run(SKAction.repeat(SKAction.sequence([SKAction.run { [self] in
                        
                        self.spawnWorm()
                        
                    },SKAction.wait(forDuration: 5.0, withRange: 4)]), count: wormCount))
                }
                
            }
            
            
            if killCount == wormCount && killCount > 0 {
                print("win \(killCount)")
                PlaygroundPage.current.assessmentStatus = .pass(message: "Good job on protecting the sapling against the worms! \(getNextPage())")
                
                
            }
        }
        
        //self.trackCurrentNode = nil
        
        for touch in touches{
            
            let touchCoordinate = touch.location(in: self)
            
            //Reset state values and remove 'game over' and 'restart' nodes from the scene.
            if let restartLabel = restart{
                if restartLabel.contains(touchCoordinate){
                    
                    createPlant(plantState: currentState)
                    restartLabel.removeFromParent()
                    gameOverLabel?.removeFromParent()
                    self.gameOver = false
                    self.trackCurrentNode = nil
                    touchEnd = 0
                    
                }
            }
        }
        
        
        
        if let sunnyday = sunNode {
            
            if sunnyday.alpha >= 0.9 && run{
                
                //Sequential actions
                plantNode!.run(SKAction.sequence([SKAction.wait(forDuration: 4.0),SKAction.animate(with: textureSapling2, timePerFrame: 3.0),SKAction.scale(to: 1.0, duration: 2.0)])){
                    PlaygroundPage.current.assessmentStatus = .pass(message: "Congratulations on completing the task successfully. Level complete!\(getNextPage())")
                }
                run = false
            }
        }
        
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.trackCurrentNode = nil
    }
    
    
    public override func update(_ currentTime: TimeInterval) {
        //spawnRainDrop()
        
        
        if isRaining{
            if self.lastUpdateTime == 0{
                print("once, i think")
                lastUpdateTime = currentTime
            }
            
            
            let delta = currentTime - lastUpdateTime
            self.lastUpdateTime = currentTime
            
            currentRainDropSpawnTime += delta
            
                //Spawn rain drop if current rain drop spawn time exceeds spawn rate of the rain drop.
            if currentRainDropSpawnTime > currentRainDropSpawnRate {
                currentRainDropSpawnTime = 0
                spawnRainDrop()
            }
        }
        
        if let sunnyday = sunNode {
            
            if !gameOver{
                
                if self.lastUpdateTime == 0{
                    print("once, i think")
                    lastUpdateTime = currentTime
                }
                
                let delta = currentTime - lastUpdateTime
                self.lastUpdateTime = currentTime
                currentSunFadeRate += delta
                
                if currentSunFadeRate > sunFadeRate {
                    currentSunFadeRate = 0
                    
                    if sunnyday.alpha >= 1.0{
                        sunnyday.alpha = 1.0
                    }
                    else{
                        sunnyday.alpha -= 0.1
                        //Show 'Game over' message and add 'restart' node to the scene.
                        if(sunnyday.alpha <= 0.0){
                            sunnyday.alpha = 0.0
                            gameOver = true
                            currentState = 3
                            print("Restart ASHandler")
                            gameOverLabel = SKLabelNode(text: "Game Over!")
                            gameOverLabel?.fontSize = 50
                            gameOverLabel?.fontColor = .black
                            gameOverLabel?.fontName = "KannadaSangamMN"
                            gameOverLabel?.position = CGPoint(x: frame.midX, y: 0.75*frame.size.height)
                            gameOverLabel?.zPosition = 10
                            
                            addChild(gameOverLabel!)
                            
                            restart = SKLabelNode(text: "Restart")
                            restart?.position = CGPoint(x: frame.midX, y: frame.midY)
                            restart?.fontColor = .blue
                            restart?.fontSize = 35
                            restart?.fontName = "KannadaSangamMN"
                            addChild(restart!)
                            plantNode?.removeFromParent()
                            removeAllActions()
                        }
                    }
                    
                }
                
            }
            
            
            
            
            
        }
        
        
    }
    
    //MARK: - Spawning
    
    //Instantiates a sapling. Accepts an Integer value, which determines the plant's current state.
    private func createPlant(plantState state:Int)  {
        
        
        switch state {
        case 1:
            plantNode = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "1.png")))
            
            plantNode!.zPosition = 5
            
            plantNode!.name = "saplingobject"
            
            
            plantNode?.position = CGPoint(x: 0.75*frame.maxX, y: 0.75*frame.maxY)
            plantNode?.setScale(0.3)
            plantNode!.physicsBody = SKPhysicsBody(texture: plantNode!.texture!, size: plantNode!.texture!.size())
            
            plantNode?.physicsBody?.isDynamic = false
            
            
            addChild(plantNode!)
            
            
            playSound(name: "natureAmbience")
            //Collision
            
            plantNode?.physicsBody?.categoryBitMask = Category.plant
            
            plantNode?.physicsBody?.contactTestBitMask = Category.wormAttack
        case 2:
                plantNode = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "1.png")))
                
                plantNode!.zPosition = 5
                
                plantNode!.name = "saplingobject"
                
                plantNode!.setScale(0.5)
                plantNode!.anchorPoint = CGPoint(x: 0.5, y: 0.0)
                
                plantNode!.position = CGPoint(x: size.width/2,y: 0.9 * plantNode!.size.height )
                
                addChild(plantNode!)
        
        case 3:
            
            plantNode = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "3.png")))
            
            plantNode!.zPosition = 5
            
            plantNode!.name = "saplingobject"
            
            plantNode!.setScale(0.7)
            plantNode!.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            
            plantNode!.position = CGPoint(x: size.width/2,y: 0.5 * plantNode!.size.height )
            
            addChild(plantNode!)
            
            sunNode = sun()
            addChild(sunNode!)
            playSound(name: "natureAmbience")
            
                    
        default:
            print("No default case found")
        }
        
        
        
    }
    
    
    //Create and return sun node.
    private func sun()-> SKSpriteNode{
        
        let sunTexture = SKSpriteNode(texture: SKTexture(imageNamed: "sun"))
        
        sunTexture.position = CGPoint(x: 0.15*frame.maxX , y: 0.85*frame.maxY)
        
        sunTexture.zPosition = 10
        
        sunTexture.setScale(0.3)
        
        sunTexture.alpha = 0.8
        
        return sunTexture
    }
    
    
    //Creates a single rain drop each time it's called.
    private func spawnRainDrop(){
        
        let rainDropSizes:[CGFloat] = [2.0,2.5,3.0]
        
        let raindrop = SKShapeNode(circleOfRadius: rainDropSizes.randomElement()!)
        raindrop.fillColor = UIColor.cyan
        raindrop.zPosition = 5
        raindrop.position = CGPoint(x: size.width/2, y: size.height/2)
        raindrop.physicsBody = SKPhysicsBody(circleOfRadius: 2.0)
        raindrop.physicsBody?.collisionBitMask = 0
        
        raindrop.physicsBody?.linearDamping = 2
        //raindrop.physicsBody?.angularDamping = 1
        
        //Spawn a rain drop at a random position, within the screen bounds, using truncatingRemainder
        let randomX = abs(CGFloat(random.nextInt()).truncatingRemainder(dividingBy: size.width))
        raindrop.position = CGPoint(x: randomX, y: size.height)
        
        addChild(raindrop)
        
    }
    
    
    
    //Creates a single worm each time it's invoked.
    private func spawnWorm() {
        
        if !gameOver{
            let worm = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "1l.png")) )
            
            worm.name = "worm"
            worm.setScale(0.5)
            worm.zPosition = 5
            
            
            worm.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            
            let xPoints:[CGFloat] = [10.0,size.width-10.0]
            
            let _x = xPoints.randomElement()!
            worm.position = CGPoint(x: _x, y: worm.size.height + 38.0)
            var toX : CGFloat = 0.0
            
            toX = _x == xPoints[0] ? frame.maxX : frame.minX
            
                //If the worm is spawned at the right side of the screen, make it move to the left, right otherwise.
            if toX == frame.maxX{
                worm.run(SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.1)))
                
            }
            else{
                worm.run(SKAction.repeatForever(SKAction.animate(with: textures2, timePerFrame: 0.1)))
                
            }
            
            
            worm.run(SKAction.move(to: CGPoint(x: toX, y: worm.size.height + 38.0), duration: 15.0))
            
            
                //Add physics body to enable collision detection with different bitmasks.
            worm.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: worm.size.width, height: worm.size.height))
            
            worm.physicsBody?.affectedByGravity = false
            worm.physicsBody?.allowsRotation = false
            
            
            
            worm.physicsBody?.categoryBitMask = Category.wormAttack
            worm.physicsBody?.collisionBitMask = Category.plant
            worm.physicsBody?.contactTestBitMask = Category.plant
            
            addChild(worm)
            
            worms.append(worm)
        }
    }
    
    
    //MARK: - Audio
    
    //Helper function to play sounds, accepts a string which determines what sound to play
    func playSound(name resourceName:String){
        
        switch resourceName {
        case "spray":
            let aerosolBugKill = URL(fileURLWithPath: Bundle.main.path(forResource: resourceName, ofType: "mp3")!)
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: aerosolBugKill)
                audioPlayer.play()
            }
            catch{
                print("Couldn't load resource")
            }
            break
            
        case "rain":
            let rain = URL(fileURLWithPath: Bundle.main.path(forResource: resourceName, ofType: "mp3")!)
            
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: rain)
                audioPlayer.play()
                audioPlayer.volume = 0.8
                audioPlayer.numberOfLoops = 3
            }
            catch{
                print("Couldn't load resource")
            }
            break
        case "natureAmbience":
            let natureAmbience = URL(fileURLWithPath: Bundle.main.path(forResource: "sun", ofType: "mp3")!)
            do{
                backgroundAudio = try AVAudioPlayer(contentsOf: natureAmbience)
                backgroundAudio.play()
                backgroundAudio.volume = 0.5
                backgroundAudio.numberOfLoops = 3
            }
            catch{
                print("Couldn't load resource")
            }
            break
            
                
        default:
            print("No default sound")
        }
        
        
    }
    
    
}

