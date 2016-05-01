# Baffling-Backwoods
###Author: Spencer Allen
An old school RPG with a mazelike forest, monsters to combat, and items to find and equip!

The userguide is formatted better and has a secret at the end in case you get stuck.


##How to Install:
1. Download and install lispworks from http://www.lispworks.com/
2. Download the lisp project file (BafflingBackwoods.lisp) from https://github.com/icssa/Baffling-Backwoods/
3. In Lispworks, select Open and select the lisp project file you downloaded
4. Select File → Compile and Load
5. Click Tools → Listener to open the listener and type (start) or (play) in it to begin the game.

##How to Play:
* Enter commands via text to play the game ex. “look”, “walk north”, “attack”, etc.
* Type “help” to view available commands.
* Certain commands are only usable under certain conditions  ie. You can only attack in combat, you can only smelt the master-key when you have all the pieces of the key in your inventory, etc.
* When you start the game up, it will ask what difficulty you want to play on, 1 being the hardest and 5 the easiest.  Difficulty affects enemy encounter rate, enemy base stats, enemy level rate, and your level rate. The hardest difficulty is very hard to survive, while the easiest difficulty makes it very hard to die.

#About
##General:
* You are an adventurer lost in a magical forest, where the paths do not lead where they seem to.  
  * In order to navigate the forest, you must remember which paths lead where.
* Your goal is to find all the pieces of the master-key and reforge it to open the chest.
  * The key pieces are scattered and hidden throughout the forest.
  * To reforge the key, you must smelt the pieces in a forge.
* Talk to the NPCs around the map to get some hints (maybe).
* Whenever you use the stats command, you will also see a hint that will help you out.
* When you reach 0 HP, you lose the game.

##Battle:
* Monsters will occasionally attack you when you walk. Defeat them or run away in order to continue exploring the forest.
  * Monsters slowly level up the longer the game takes.  If you do not open the chest in time, the monsters may become too strong for you to defeat.
  * Different monsters have different stats.  Rats are unremarkable, while wolves have high attack but low defense.
* When you defeat a monster, you have a chance to level up in each of your attributes (ATK/DEF/HP) by 1.  Leveling up fully heals your HP.
  * When you attack a monster it loses HP, and if it survives, it will attack you back.
* When you defend, you take reduced damage for one turn. This becomes more powerful if you have a shield.
* When you run, you have a chance to escape combat unscathed. If you fail to escape, you take successively more and more damage for each failed attempt.
* When you use an item, it is consumed from your inventory and you gain a benefit. You can use an unlimited number of items in one turn and still attack after, but be careful, as there are few items to be found in the forest.

##Equipment and Potions:
* Equipment consists of items which you can equip in 3 possible slots: weapon, armor, and shield.
  * You start the game with no equipment, but there is some scattered throughout the forest.
  * Weapons increase your attack.
  * Armor increases your defense slightly, and HP greatly.
  * Shields increase your defense greatly, and can be used when defending.
  * You can only equip one piece of equipment in any one slot at a time.
* Consumable items (potions) can be found in the forest.  They come in three types: healing, attack, and defense.
  * Healing potions restore missing HP, allowing you to survive longer.
  * Attack potions temporarily increase your attack for one battle.
  * Defense potions temporarily increase your defense for one battle.
* Consumable items can be used out of combat or in combat, through the USE and ITEM command.
  * When used, consumables are removed from your inventory; you only get one use!

##Tips:
* Use the room descriptions to remember where they are in the forest. You can also use the available paths to rule out possible locations of where you are. 
* Rooms at the edge of the map might have a unique description...
* You can drop unneeded items to mark a room, making it unique and therefore easier to navigate.
* Save potions for when you really need them.
* Finding stronger equipment early on can help more than finding key pieces early on.
* If you find yourself dying too fast, try turning down the difficulty.
* Mark the empty map and use it to keep track of your location in the forest.
	
#Commands Overview
 
about: Describes the goal of the game. 

help/h/?: Prints information about available commands. 
 
===================GAMEWORLD ACTIONS=================== 

look: Describes the location and objects around you. 

walk: Moves your character to the location in a given direction. 

pickup: Picks up an object that is in your current location. 

inventory: Shows all the items you are carrying. 

drop: Drops an item from your inventory on to the ground.  If it was equipped, you unequip it. 

use: Use an item from your inventory. 

equip: Equip an item from your inventory, increasing your stats. 

talk: Talk to an NPC to hear their dialogue. 

stats: Display your stats and equipment, as well as a hint. 

 
smelt: when you have all the key pieces, you can 'smelt key-piece-1 key-piece-2' to make the master-key (if you are in the same room as it). 

unlock: when you have the master key, you can 'unlock master-key chest' if you are in the same room as it. 
 
 
===================COMBAT ACTIONS=================== 

attack: Attack your enemy in combat. 

defend: Defend yourself, increasing defense temporarily. 

run: Attempt to run away. Failing to do so means you take more damage. 

item: Select an item to use from your inventory. 

