// Project: MedinaRicardo-Project
// EID: rem3885
// Course: CS329E
//
//  RoomClass.swift
//  MedinaRicardo-Project
//
//  Created by Ricardo Medina on 3/24/25.
//

class Room { // Defining the room class
    let name: String
    var north :String
    var east: String
    var south: String
    var west: String
    var up: String
    var down: String
    var contents:[String]
    var enemy: RPGCharacter?
    
    init (name:String, north :String, east: String, south: String, west: String, up: String, down: String, contents:[String]) {
        self.name = name
        self.north = north
        self.east = east
        self.south = south
        self.west = west
        self.up = up
        self.down = down
        self.contents = contents
        self.enemy = nil
    }
    
    func displayRoom() -> String {
        /* method to display the room with the specified format */
        let roomBuild = ""
        print("Room name:  \(self.name)")
        
        if self.north != "None" {
            print("\tRoom to the north:  \(self.north)")
        }
        if self.east != "None" {
            print("\tRoom to the east:   \(self.east)")
        }
        if self.south != "None" {
            print("\tRoom to the south: \(self.south)")
        }
        if self.west != "None" {
            print("\tRoom to the west:   \(self.west)")
        }
        if self.up != "None"  {
            print("\tRoom above:\t\t    \(self.up)")
        }
        if self.down != "None" {
            print("\tRoom below:\t\t    \(self.down)")
        }
        return roomBuild
    }
}
