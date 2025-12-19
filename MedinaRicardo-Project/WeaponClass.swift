// Project: MedinaRicardo-Project
// EID: rem3885
// Course: CS329E
//
//  WeaponClass.swift
//  MedinaRicardo-Project
//
//  Created by Ricardo Medina on 4/28/25.
//

class Weapon { // Defining Weapon Class
    var weaponType: String
    var weaponDamage: Int
    
    init(weaponType: String){
        self.weaponType = weaponType
                
        if self.weaponType == "dagger"{
            self.weaponDamage = 4
            
        } else if self.weaponType == "axe"{
            self.weaponDamage = 6
            
        } else if self.weaponType == "sword" {
            self.weaponDamage = 10
            
        } else {
            self.weaponDamage = 1
            self.weaponType = "none"
        }
    }
}
