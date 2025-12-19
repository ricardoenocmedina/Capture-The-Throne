// Project: MedinaRicardo-Project
// EID: rem3885
// Course: CS329E
//
//  ViewController.swift
//  MedinaRicardo-Project
//
//  Created by Ricardo Medina on 3/24/25.
//

import UIKit
import FirebaseAuth

// Defining global variables
var floorPlan: [Room] = []
var current: Room?
var inventory:[String] = []
let protagonist = Hero() // RPG-style game; am using Hero class as the player
let defaults = UserDefaults.standard // using user defaults for saving progress

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var outputArea: UITextView!
    @IBOutlet weak var commandField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var currentLocation: UILabel!
    
    func loadMap() {
        /* populates floorPlan with Room obects defined by arrays */
        let room1:[String] = ["Village Outskirts", "Village Market", "None", "Haunted Forest", "Ancient Ruins", "None", "None"]
        let room2:[String] = ["Village Market", "Castle Courtyard", "None", "Village Outskirts", "None", "None", "None", "watermelon", "chicken", "cake"]
        let room3:[String] = ["Haunted Forest", "Village Outskirts", "None", "Bandit Camp", "None", "None", "None", "axe"]
        let room4:[String] = ["Bandit Camp", "Haunted Forest", "None", "None", "None", "None", "None"]
        let room5:[String] = ["Ancient Ruins", "Wizard's Tower", "Village Outskirts", "None", "None", "None", "None"]
        let room6:[String] = ["Wizard's Tower", "None", "None", "Ancient Ruins", "None", "None", "Underground Catacombs"]
        let room7:[String] = ["Underground Catacombs", "None", "Blacksmith's Forge", "None", "None", "Wizard's Tower", "None"]
        let room8:[String] = ["Blacksmith's Forge","None","None", "None", "Underground Catacombs", "None", "None", "sword", "key"]
        let room9:[String] = ["Castle Courtyard", "Throne Room", "None", "Village Market", "None", "None", "None"]
        let room10:[String] = ["Throne Room", "None","None", "Castle Courtyard", "None", "None", "None", "crown"]
        
        floorPlan = [createRoom(room1), createRoom(room2), createRoom(room3), createRoom(room4), createRoom(room5), createRoom(room6), createRoom(room7), createRoom(room8), createRoom(room9), createRoom(room10)]
    }

    func createRoom(_ room:[String]) -> Room {
        /* helper function to use in loadMap() */
        let contents = Array(room[7...])
        
        let newRoom = Room(name: room[0], north: room[1], east: room[2], south: room[3], west: room[4], up: room[5], down: room[6], contents: contents.isEmpty ? ["None"] : contents)
        return newRoom
    }
    
    func getContentsOfRoom (currentRoom: Room) -> String {
        /* function that returns the contents of the room currently in */
        var contentString = "\nContents of the room:\n"
        
        for item in currentRoom.contents {
            contentString += "\t\(item)\n"
        }
        return contentString
    }

    func look() {
        /* shows user what room they are currently in */
        outputArea.text += "\nYou are currently in \(current!.name).\n"
        outputArea.text += getContentsOfRoom(currentRoom: current!)
        saveGameState()
    }
        
    func getRoom(_ nameOfRoom: String) -> Room? {
        /* helper function to be used in move() function */
        for room in floorPlan {
            if room.name == nameOfRoom {
                return room
            }
        }
        return nil // This should never be returned
    }

    func move(direction: String) -> Room? {
        /* function to move player to desired room */
        var desiredLocation: String = ""
        switch direction { // get the desired location
        case "north":
            desiredLocation = current!.north
        case "south":
            desiredLocation = current!.south
        case "east":
            desiredLocation = current!.east
        case "west":
            desiredLocation = current!.west
        case "up":
            desiredLocation = current!.up
        case "down":
            desiredLocation = current!.down
        default:
            print("Not a valid direction") // this should never run
            return current!
        }
        
        if desiredLocation == "None" { // accounts for "None" directions
            outputArea.text += "\nYou can't move in that direction.\n"
            imageView.image = UIImage(named: current!.name)
            currentLocation.text = "Location: \(current!.name)"
            return current
        }
        
        if desiredLocation == "Castle Courtyard" { // populates Castle Courtyard with soldier
            if let courtyard = getRoom(desiredLocation) {
                if courtyard.enemy == nil {
                    courtyard.enemy = Soldier(name: "Soldier")
                }
            }
        }
        
        if desiredLocation == "Throne Room" {
            if let currentRoomEnemy = current?.enemy, currentRoomEnemy.name == "Soldier" { // soldier blocking entrance
                outputArea.text += "\nA Soldier is blocking the way! Defeat him to proceed!\n"
                imageView.image = UIImage(named: current!.name)
                currentLocation.text = "Location: \(current!.name)"
                saveGameState()
                return current
            }
            
            if !inventory.contains("key") { // door requires lock
                outputArea.text += "\nThe door is locked. You need a key to get in.\n"
                imageView.image = UIImage(named: current!.name)
                currentLocation.text = "Location: \(current!.name)"
                saveGameState()
                return current
            }
            else { // if player defeats guard and gets the key, they get access to the throne
                let newRoom = getRoom(desiredLocation)
                imageView.image = UIImage(named: desiredLocation)
                currentLocation.text = "Location: \(desiredLocation)"
                outputArea.text += "\nYou are now in the \(newRoom!.name).\n"
                outputArea.text += "\nYou are now the King of the kingom! Congratuations, you won!\n"
                saveGameState()
                return newRoom
            }
        }        
        
        if desiredLocation == "Bandit Camp", let newRoom = getRoom(desiredLocation){ // populates Bandit Camp with Bandit
            if let courtyard = getRoom(desiredLocation) {
                if courtyard.enemy == nil {
                    courtyard.enemy = Bandit(name: "Bandit")
                }
                imageView.image = UIImage(named: desiredLocation)
                currentLocation.text = "Location: \(desiredLocation)"
                outputArea.text += "\nYou are now in the \(newRoom.name).\n"
                outputArea.text += "\nThere are armed bandits nearby, be careful!\n"
                saveGameState()
                return newRoom
            }
        }
        if desiredLocation == "Village Market", let newRoom = getRoom(desiredLocation) { // adds extra dialogue to village market
            imageView.image = UIImage(named: desiredLocation)
            currentLocation.text = "Location: \(desiredLocation)"
            outputArea.text += "\nYou are now in the \(newRoom.name).\n"
            outputArea.text += "\nThere is a lot of food nearby. I should take some for the road.\n"
            saveGameState()
            return newRoom
        }
        
        if desiredLocation == "Wizard's Tower", let newRoom = getRoom(desiredLocation) { // adds extra dialogue to wizard's tower
            imageView.image = UIImage(named: desiredLocation)
            currentLocation.text = "Location: \(desiredLocation)"
            outputArea.text += "\nYou are now in the \(newRoom.name).\n"
            outputArea.text += "\nThere is a note on a table that reads:\n\n'If you seek to pass the gates and claim what lies beyond, you'll need more than courage alone. Seek out the blacksmith, for he holds both the blade and the key you require. Arm yourself well, for the guard does not yield to empty hands'.\n"
            saveGameState()
            return newRoom
        }
        
        if desiredLocation != "None", let newRoom = getRoom(desiredLocation){ // if move() is valid, move into that room and tell the user your new location; accounts for every other non-special room
            imageView.image = UIImage(named: desiredLocation)
            currentLocation.text = "Location: \(desiredLocation)"
            outputArea.text += "\nYou are now in the \(newRoom.name).\n"
            saveGameState()
            return newRoom
        }
        else {
            return current! // not a valid direction
        }
    }

    func displayAllRooms() {
        /* function that iterates through the rooms and calls displayRoom() method for each */
        for room in floorPlan {
            print(room.displayRoom())
        }
    }
    
    func pickup(item: String) {
        /* function to pick up item from room, if it exists */
        var inRoom = false // flag
        for roomItem in current!.contents {
            if item == roomItem, let index = current!.contents.firstIndex(of: roomItem) {
                inRoom = true
                current!.contents.remove(at: index)
                break
            }
        }
        if inRoom { // it exists = pick up
            inventory.append(item)
            outputArea.text += "\nYou now have the \(item)\n"
            imageView.image = UIImage(named: item)
            saveGameState()
        }
        if !inRoom { // does not exist
            outputArea.text += "\nThat item is not in this room.\n"
        }
    }
    
    func drop(item: String) { // make sure to replace none with the new item if room empty initially
        /* function to remove item from inventory */
        var inInventory = false
        for inventoryItem in inventory {
            if item == inventoryItem, let index = inventory.firstIndex(of: inventoryItem) {
                inInventory = true
                inventory.remove(at: index)
                break
            }
        }
        
        if inInventory { // in inventory, drop
            current!.contents.append(item)
            outputArea.text += "\nYou have dropped the \(item) from your inventory\n"
            saveGameState()
        }
        
        if !inInventory { // not in inventory
            outputArea.text += "\nYou don't have that item.\n"
        }
    }
    
    func listInventory() {
        /* function to display what is currently in the user's inventory */
        if inventory.isEmpty {
            outputArea.text += "\nYou are currently carrying:\n\tnothing.\n"
        } else {
            outputArea.text += "\nYou are currently carrying:\n"
            for item in inventory{
                outputArea.text += "\t\(item)\n"
            }
        }
    }
    
    func startFight() {
        /* function to start fight with enemey. Player hits first, then enemey hits back every time */
        guard let enemy = current?.enemy else { outputArea.text += "\nThere is no enemy to fight.\n"; return }
        
        outputArea.text += protagonist.fight(opponent: enemy)
        outputArea.text += enemy.fight(opponent: protagonist)
        saveGameState()
        
        if protagonist.health <= 0 { // player died
            outputArea.text += "\nYou died! Please restart the game\n"
        }
        
        if enemy.health <= 0 { // remove enemy from room if defeated
            current?.enemy = nil
            saveGameState()
            
            if enemy.name == "Bandit" { // drop dagger when bandit is defeated
                outputArea.text += "\nThe Bandit dropped a dagger! You now have a dagger in your inventory!\n"
                inventory.append("dagger")
                saveGameState()
            }
        }
    }
    
    func wieldWeapon(item: String) {
        /* function to wield a weapon from the inventory */
        if inventory.contains(item) && (item == "sword" || item == "dagger" || item == "axe"), let weaponIndex = inventory.firstIndex(of: item) {
            let weapon = Weapon(weaponType: item)
            protagonist.wield(weaponObject: weapon)
            outputArea.text += "\nYou are now wielding the \(weapon.weaponType)\n"
            inventory.remove(at: weaponIndex)
            saveGameState()
        } else {
            outputArea.text += "\nThat is not a weapon that can be wielded.\n"
        }
    }
    
    func unwieldWeapon() {
        /* function to unwield current weapon */
        protagonist.unwield()
        saveGameState()
        outputArea.text += "\nYou are no longer wielding anything."
    }
    
    func showHealth() {
        /* function to see your current health and weapon currently wielding */
        outputArea.text += protagonist.show()
    }
    
    func eatFood(foodItem: String) {
        /* function to eat food and heal up */
        if inventory.contains(foodItem) && (foodItem ==  "watermelon" || foodItem == "cake" || foodItem == "chicken"), let foodIndex = inventory.firstIndex(of: foodItem) {
            let food = Food(foodName: foodItem)
            protagonist.eat(foodItem: food)
            outputArea.text += "\nYou increased your health by \(food.healthPoints) points\n"
            inventory.remove(at: foodIndex)
            saveGameState()
        } else {
            outputArea.text += "\nThat is not consumable food.\n"
        }
    }
    
    func exitApp() {
        /* function to quit app */
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true)
        } catch {
            print("Sign out error")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        /* this method is called whenever user hits return key */
        guard let commands = commandField.text?.components(separatedBy: " "), !commands.isEmpty else { return false }
        
        switch commands.first {
        case "look":
            look()
        case "north":
            current = move(direction: "north")
        case "east":
            current = move(direction: "east")
        case "south":
            current = move(direction: "south")
        case "west":
            current = move(direction: "west")
        case "up":
            current = move(direction: "up")
        case "down":
            current = move(direction: "down")
        case "inventory":
            listInventory()
        case "exit": // come back to this!!!!
            exitApp()
        case "get":
            pickup(item: commands[1])
        case "drop":
            drop(item: commands[1])
        case "fight":
            startFight()
        case "wield":
            wieldWeapon(item: commands[1])
        case "unwield":
            unwieldWeapon()
        case "eat":
            eatFood(foodItem: commands[1])
        case "health":
            showHealth()
        case "reset":
            resetGameState()
        case "help":
            let helpMessage = "\nlook:             display the name of the current room and its contents\nnorth:            move north\neast:              move east\nsouth:            move south\nwest:             move west\nup:                 move up\ndown:            move down\ninventory:     list what items you're currently carrying\nget item:       pick up an item currently in the room\ndrop item:    drop an item you're currently carrying\nfight:             attack the enemy\nwield item:   wields item (has to be in inventory first)\nunwield:       unwields weapon item\neat item:      replinish health based on food consumed\nhealth:         shows weapon wielded and player health\nreset:           reset game from the very beginning\nhelp:            print this list\nexit:             quit the game\n"
            outputArea.text += helpMessage
        default: // Alert controller to account for every other input to command
            let alert = UIAlertController(title: "Invalid Input",
                                          message: "Please input a valid command. Type 'help' for more information.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alert, animated: true)
        }

        // get rid of text after clicking return
        textField.text = ""                         // clear the text
        textField.resignFirstResponder()            // dismiss keyboard
        scrollTextViewToBottom()

        return true
    }
    
    func scrollTextViewToBottom() {
        /* method to automatically scroll to the bottom if text outputArea is filled out */
        let range = NSMakeRange(outputArea.text.count - 1, 1)
        outputArea.scrollRangeToVisible(range)
    }
    
    func saveGameState() {
        /* save the game state using user defaults */
        
        // save current location
        defaults.set(current?.name, forKey: "currentRoomName")
        
        // save inventory
        defaults.set(inventory, forKey: "inventoryItems")
        
        // save health
        defaults.set(protagonist.health, forKey: "playerHealth")
        
        // save current wielded weapon
        defaults.set(protagonist.currentWeapon.weaponType, forKey: "currentWeaponType")
        
        // save output text
        defaults.set(outputArea.text, forKey: "outputAreaText")
        
        // save enemies
        var enemyData: [String: [Any]] = [:]
        
        for room in floorPlan {
            if let enemy = room.enemy {
                enemyData[room.name] = [enemy.name, enemy.health]
            }
        }
        
        defaults.set(enemyData, forKey: "enemyData")
    }
    
    func loadGameState() {
        /* load game from previous save */
        let defaults = UserDefaults.standard
        
        // restore current location
        if let savedRoomName = defaults.string(forKey: "currentRoomName") {
            if let savedRoom = getRoom(savedRoomName) {
                current = savedRoom
                imageView.image = UIImage(named: savedRoom.name)
                currentLocation.text = "Location: \(savedRoom.name)"
                print("Loaded saved room: \(savedRoom.name)")
            }
        }
        
        // restore inventory
        if let savedInventory = defaults.stringArray(forKey: "inventoryItems") {
            inventory = savedInventory
            print("Loaded inventory:", inventory)
        }
        
        // restore health
        let savedHealth = defaults.integer(forKey: "playerHealth")
        if savedHealth != 0 { // default is 0 if not found
            protagonist.health = savedHealth
            print("Loaded health:", savedHealth)
        }
        
        // restore current weapon
        if let savedWeaponType = defaults.string(forKey: "currentWeaponType") {
            protagonist.currentWeapon = Weapon(weaponType: savedWeaponType)
            print("Loaded weapon:", savedWeaponType)
        }
        
        // restore output text
        if let savedOutputText = defaults.string(forKey: "outputAreaText") {
            outputArea.text = savedOutputText
        }
            
        // restore enemies
        if let savedEnemyData = defaults.dictionary(forKey: "enemyData") as? [String: [Any]] {
            for (roomName, enemyInfo) in savedEnemyData {
                if let enemyName = enemyInfo[0] as? String,
                   let enemyHealth = enemyInfo[1] as? Int,
                   let room = getRoom(roomName) {
                    
                    if enemyName == "Soldier" {               // store soldier
                        room.enemy = Soldier(name: enemyName)
                    } else if enemyName == "Bandit" {         // store bandit
                        room.enemy = Bandit(name: enemyName)
                    }
                    room.enemy?.health = enemyHealth
                    print("Loaded enemy \(enemyName) with health \(enemyHealth) in \(roomName)")
                }
            }
            
        }
    }
    
    func resetGameState() {
        /* reset game */
        
        // Remove all saved game data
        defaults.removeObject(forKey: "currentRoomName")
        defaults.removeObject(forKey: "inventoryItems")
        defaults.removeObject(forKey: "playerHealth")
        defaults.removeObject(forKey: "currentWeaponType")
        defaults.removeObject(forKey: "enemyData")

        
        // Reset in-memory game variables
        inventory.removeAll()
        protagonist.health = 100 // Or whatever your default health is
        protagonist.currentWeapon = Weapon(weaponType: "none")
        
        // reset enemies in rooms
        for room in floorPlan {
            room.enemy = nil
        }
        
        // Reset current room to starting room
        if !floorPlan.isEmpty {
            current = floorPlan[0] // "Village Outskirts"
            imageView.image = UIImage(named: current!.name)
            currentLocation.text = "Location: \(current!.name)"
        }
        
        outputArea.text = "Game has been restarted.\n"
        saveGameState() // saves the reseted game
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        commandField.delegate = self
        outputArea.text = ""
        loadMap()
        loadGameState() // load game state
        displayAllRooms() // include this to print in console for TA to see all rooms
        if current == nil { // if starting from zero
            current = floorPlan[0]
            imageView.image = UIImage(named: "Village Outskirts")
            currentLocation.text = "Location: \(current!.name)"
        }
        currentLocation.font = UIFont.preferredFont(forTextStyle: .subheadline)
        scrollTextViewToBottom()
    }
}
