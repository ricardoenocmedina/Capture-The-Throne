// Project: MedinaRicardo-Project
// EID: rem3885
// Course: CS329E
//
//  FoodClass.swift
//  MedinaRicardo-Project
//
//  Created by Ricardo Medina on 4/28/25.
//

class Food { // Defining Food Class
    var foodName: String
    var healthPoints: Int
    
    init(foodName: String){
        self.foodName = foodName
                
        if self.foodName == "watermelon"{
            self.healthPoints = 10
            
        } else if self.foodName == "cake"{
            self.healthPoints = 20
            
        } else if self.foodName == "chicken" {
            self.healthPoints = 30
            
        } else {
            self.healthPoints = 0
            self.foodName = "none"
        }
    }
}
