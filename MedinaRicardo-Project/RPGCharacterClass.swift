// Project: MedinaRicardo-Project
// EID: rem3885
// Course: CS329E
//
//  RPGCharacterClass.swift
//  MedinaRicardo-Project
//
//  Created by Ricardo Medina on 4/28/25.
//

class RPGCharacter { // RPGCharacter Super Class
    var name: String
    var health: Int
    var currentWeapon: Weapon
    
    init(name: String, health: Int, currentWeapon: Weapon){
        self.name = name
        self.health = health
        self.currentWeapon = currentWeapon
    }
    
    func wield(weaponObject weapon: Weapon){ // wield weapon
        self.currentWeapon = weapon
    }
    
    func unwield(){ // unwield weapon
        let defaultWeapon = Weapon(weaponType: "none")
        self.currentWeapon = defaultWeapon
    }
        
    func fight(opponent: RPGCharacter) -> String { // fight
        var msg = "\n\(self.name) attacked \(opponent.name) with a(n) \(currentWeapon.weaponType)\n"
        opponent.health -= currentWeapon.weaponDamage
        msg += "\(self.name) did \(currentWeapon.weaponDamage) damage to \(opponent.name)\n"
        msg += "\(opponent.name) went down to \(opponent.health) health\n"
        msg += checkForDefeat(opponent: opponent)
        
        return msg
    }
    
    func eat(foodItem: Food) { // heal up by eating food
        self.health += foodItem.healthPoints
    }
    
    func show() -> String{ // check health and weapon currently wielding
        let msg = "\n\(self.name)\n\tCurrent Health: \(self.health)\n\tWielding: \(currentWeapon.weaponType)\n"
        return msg
    }
    
    func checkForDefeat(opponent: RPGCharacter) -> String { // helper function
        var msg = ""
        if opponent.health <= 0 {
            if opponent.name == "You" {  msg += "\n\(opponent.name) have been defeated!" } else { msg += "\n\(opponent.name) has been defeated!\n" }
        }
        return msg
    }
}

class Soldier: RPGCharacter { // Subclass of RPGCharacter
    var maxHealth: Int = 40
    let defaultWeapon = Weapon(weaponType: "sword")

    init(name: String){
        super.init(name: name, health: maxHealth, currentWeapon: defaultWeapon)
    }
}

class Bandit: RPGCharacter { // Subclass of RPGCharacter
    var maxHealth: Int = 20
    let defaultWeapon = Weapon(weaponType: "dagger")

    init(name: String) {
        super.init(name: name, health: maxHealth, currentWeapon: defaultWeapon)
    }
}

class Hero: RPGCharacter { // Subclass of RPGCharacter
    var currHealth: Int = 100
    let defaultWeapon = Weapon(weaponType: "none")
    init() {
        super.init(name: "You", health: currHealth, currentWeapon: defaultWeapon)
    }
}
