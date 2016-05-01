;;;; -*- Mode: LISP; Syntax: Common-lisp; Package: USER; Base: 10 -*-   ;;;; Name: Spencer Allen  Date: April 15, 2016   ;;;; File: BafflingBackwoods.lisp                                                                                                                                                                                                                                                                    
(defconstant +ID+ "Spencer Allen") ;Defines the ID of the person whose file this is

;;;Defines the areas in the game associated to a description of that area. The rest of the areas added at bottom of file using new-location.
(defparameter *nodes* '((f4-5 (you are in a small clearing with a crackling campfire and a golden chest sitting atop a stump.))
                        (f4-4 (you are in a forest. the path here is well-trodden.))              
                        ))

;;;counts the number of times you walked during the game
(defparameter *walked* 0)

;;;counts the number of monsters you killed
(defparameter *killed* 0)

;;;counts the number of times you ran away
(defparameter *ran* 0)

;;;a variable to hold a random number for various purposes
(defparameter *random* 0)

;;;boolean that keeps track of whether you are in battle or not
(defparameter *inbattle* nil)

;;;keeps track of the current monster
(defparameter *currentmonster* 'bat)

;;;defines the possible monster names/types
(defparameter *eNames* '(rat bat goblin skeleton boar bear wolf))

;;;defines the additional stats associated with each type of monster.  Format is: NAME/ATK/DEF/HP
(defparameter *estats* '(
                         (rat 0 -1 1) 
                         (bat -1 -2 0)
                         (goblin 0 -5 15)
                         (skeleton 3 3 -10)
                         (boar 0 1 4)
                         (wolf 5 -5 -2)
                         (bear 4 0 16)
                         (dragon 20 10 50)
                         
                         )
)
;;;defines player base stats
(defparameter *HP* 50)
(defparameter *HPmax* 50)
(defparameter *attack* 17)
(defparameter *attackmax* 17)
(defparameter *defense* 0)
(defparameter *defensemax* 0)
(defparameter *defended* 0)

;;;defines enemy base stats
(defparameter *eHP* 35)
(defparameter *eHPmax* 35)
(defparameter *eattack* 7)
(defparameter *eattackmax* 7)
(defparameter *edefense* 0)
(defparameter *edefensemax* 0)

;;;determines how fast the players and enemies level their stats up. The lower the number, the faster the leveling occurs.
(defparameter *levelrates* '(30 20 10) )

;;;defines the difficulty level of the game, with 1 being hardest and 5 being easiest
(defparameter *difficulty* 5)

;;;holds temporary combat calculations
(defparameter *val* 0)

;;;the number of key pieces to collect
(defparameter *numpieces* 7)

;;;defines whether you have the master-key or not
(defparameter *master-key* nil)

;;;defines the equippable items and their stats. Format: NAME/TYPE/ATK/DEF/HP.  Types are: 1-WPN 2-SHLD 3-ARMR
(defparameter *equippable* '(
                             (dagger 1 5 0 0)
                             (wood-shield 2 0 3 0)
                             (tunic 3 0 1 10)
                             (sword 1 12 0 0)
                             (kiteshield 2 0 6 0)
                             (chainmail 3 0 3 25)
                             )
  )

;;;defines the npcs, their locations, and their dialogue
(defparameter *npcs* '(
                       (traveler f2-3 
                                 ("TRAVELER: I was in such a rush running away from a monster that I misplaced my shield and potion...")
                                 ("TRAVELER: What is with this forest anyway? I can never tell where I'm going!")
                                 ("TRAVELER: I've been running for days. Maybe I'll just keep resting here for now.")
                                 )
                       
                       (knight f5-1 
                               ("KNIGHT: Salutations! Wearing my old armor are you?") 
                               ("KNIGHT: I would leave this place... but I do not want to get sent back to the beginning.") 
                               ("KNIGHT: It is too bad there is no duel function implemented or I would challenge you right here!")
                               )
                       
                       (adventurer f3-7
                                   ("ADVENTURER: Strange... when I walk east I end up north.") 
                                   ("ADVENTURER: I hope I can find some better equipment out here.") 
                                   ("ADVENTURER: That potion back there looked sketchy--I bet it's been sitting out in the sun for hours.")
                                   )
                       
                       (blacksmith f5-6
                                   ("BLACKSMITH: Now where did I leave my tools...?") 
                                   ("BLACKSMITH: You want me to make something for you?  Well too bad!") 
                                   ("BLACKSMITH: The forge can be used to smelt pieces of metal together.")
                                   )
                       
                       (vagrant f1-5
                                ("VAGRANT: I thought if I kept going in one direction I'd eventually get out...") 
                                ("VAGRANT: Care to help a poor beggar out with some coin?") 
                                ("VAGRANT: How did I end up in this forest anyway?")
                                )
                       
                       ))

;;;Defines objects, which are on the floor.  More objects placed at bottom of the file using new-object.
(defparameter *objects* '(dagger wood-shield tunic sword kiteshield chainmail 
                                   ;key-piece-1
                                   ;key-piece-2
                                   ;key-piece-3 
                                   ;key-piece-4 
                                   ;key-piece-5 
                                   ;key-piece-6 
                                   ;key-piece-7 
                                 ))

;;;Defines object locations, which tells us which area each object is in. More object locations added at the bottom of the file using new-object.
(defparameter *object-locations* '(
                                   (dagger f4-5)
                                   (wood-shield f3-4)
                                   (tunic f5-5)
                                   (sword f6-4)
                                   (chainmail f6-1)
                                   (kiteshield f2-8)
                                   ;(key-piece-1 body)
                                   ;(key-piece-2 body)
                                   ;(key-piece-3 body)
                                   ;(key-piece-4 body)
                                   ;(key-piece-5 body)
                                   ;(key-piece-6 body)
                                   ;(key-piece-7 body)
                                   ))

;;;defines the usable items in the games, such as potions, and their stats. Format: NAME/TYPE/AMOUNT.  Types: 1-HEALING 2-ATTACK 3-DEFENSE.
(defparameter *usable* '(
                         (small-potion 1 25)
                         (med-potion 1 44)
                         (big-potion 1 70)
                         (endurance-potion 3 4)
                         (strength-potion 2 4)
                         (brave-potion 3 8)
                         (fierce-potion 2 8)
                         ))

;;;keeps track of the player's current equipment
(defparameter *weapon* nil)
(defparameter *shield* nil)
(defparameter *armor* nil)

;;;Defines the allowed commands in our game
(defparameter *allowed-commands* 
'(look walk pickup inventory help h ? about attack defend run item equip use stats talk drop))

;;;Defines where you are.  By default it is tile f4-5 in the forest
(defparameter *location* 'f4-5)

;;;Function describe-location takes a location and finds it in the given list of nodes, and gets the second item (description)
(defun describe-location (location nodes)
  (cadr (assoc location nodes)))

;;;Defines the edges that connect the areas in the game. rest of the edges defined at the bottom
(defparameter *edges* '((f4-5 (f4-4 west path) )
                        (f4-4 (f4-5 east path))
                        ))

;;;Function describe-path takes an edge and prints where it is going and describes via what route
(defun describe-path (edge)
  `(There is a,(caddr edge) going ,(cadr edge) from here.))

;;;Function describe-paths takes a location and a list of edges, and describes the edges that are connected to the location
(defun describe-paths (location edges)
  (apply #'append (mapcar #'describe-path (cdr (assoc location edges)))))

;;;finds the paths that are associated to this location
(defun get-paths (location edges)
  (apply #'append (cdr (assoc location edges))))

;;;Function objects-at finds all the objects at the given location
(defun objects-at (loc objs obj-loc)
  (labels ((is-at (obj)
             (eq (cadr (assoc obj obj-loc)) loc)))
    (remove-if-not #'is-at objs)))

;;;Function describe-objects finds available objects in the area and describes them on the floor
(defun describe-objects (loc objs obj-loc)
  (labels ((describe-obj (obj)
             `(There is a ,obj on the floor.)))
    (apply #'append (mapcar #'describe-obj (objects-at loc objs obj-loc)))))

;;;Function look describes your location, the paths from where you are, and the objects at your location
(defun look ()
  (princ (coerce (tweak-text (coerce (string-trim "() " (prin1-to-string  (describe-location *location* *nodes*) )) 'list) t nil) 'string))
  (format t " " )
  (append(describe-paths *location* *edges*)
         (describe-objects *location* *objects* *object-locations*))
  )

;;;Function walk attempts to move you to the area along the edge in the direction specified. Enemies randomly level up when you walk. Cannot walk in battle. Chance on walking to get attacked by a monster.
(defun walk (direction)
  (cond ((not(not *inbattle*)) (format nil "You cannot just walk away from a battle." ) )
        ((not *inbattle*)
         (labels ((correct-way (edge)
                    (eq (cadr edge) direction)))
           (let ((next (find-if #'correct-way (cdr (assoc *location* *edges*)))))
             (if next 
                 (progn (setf *location* (car next))
                   (setf *walked* (+ *walked* 1))
                   (cond 
                    ((equal (random (* *difficulty* (nth 0 *levelrates*)))1) (setf *eattack* (+ *eattack* 1)))
                    ((equal (random (* *difficulty* (nth 1 *levelrates*)))1) (setf *edefense* (+ *edefense* 1)))
                    ((equal (random (* *difficulty* (nth 2 *levelrates*)))1) (setf *eHP* (+ *eHP* 1))  (setf *eHPmax* (+ *eHPmax* 1)))
                    )
                   (if(equal(random (+ 1 *difficulty*)) 1) 
                       (battle-start)
                     (look)
                     ))
        '(you cannot go that way.))))
         )
        )
  )

;;;battle-start determines the monster type, sets the monster stats to match the monster type and initiates the battle
(defun battle-start ()
  (format t "Something rustles in the bushes.~%Your movement attracted a monster!~%")
  (setf *currentmonster* (random-element *eNames*))
  (monster-stats)
  (setf *inbattle* t)
  (format t "You are attacked by a ~a. What will you do?~%" *currentmonster*)
  (battle)
  )

;;;battle-text shows the periodic random text displayed after each round of attacks, then continues the battle
(defun battle-text ()
  (progn
    (setf *random* (random 4))
    (cond  
     ((equal *currentmonster* 'skeleton) (format t "The ~a rattles its bones.~%" *currentmonster*))
     ((equal *currentmonster* 'dragon) (format t "The ~a roars at you.~%" *currentmonster*))
     ((equal *random* 0) (format t "The ~a thinks you look tasty.~%" *currentmonster*))
     ((equal *random* 1) (format t "The ~a eyes you warily.~%" *currentmonster*))
     ((equal *random* 2) (format t "The ~a wants to beat you up.~%" *currentmonster*))
     ((equal *random* 3) (format t "The ~a looks pretty mad.~%" *currentmonster*))
     )
    (battle)
    )
  )

;;;presents the battle options to the player, as well as their HP and the monster's HP. Clears temporary effects that end after every round.
(defun battle ()
  (setf *defended* 0)
  (format nil "HP: ~a     ~a HP: ~a  ~%------------------------------~%ATTACK - DEFEND - RUN - ITEM~%------------------------------" *HP* *currentmonster* *eHP*)
  )

;;;attacks the monster. if it dies, you win and can level up.  otherwise, the monster gets to attack you back
(defun attack ()
  (cond 
   ((not(null *inbattle*))
    (setf *val* (- *attack* *edefense*))
    (cond ((> 0 *val*)
           (setf *val* 0)
           )
          )
    (format t "You attack the ~a for ~a damage!~%" *currentmonster* *val*)
    (setf *eHP* (- *eHP* *val*))
    (cond ((< *eHP* 1 ) 
           (format t "You felled the ~a!~%" *currentmonster*)
           (cond ((equal 'dragon *currentmonster* ) 
                  (format nil "Congratulations, the treasure is yours.  You win!~%=======================GAME STATS=======================~%Walks taken: ~a~%Monsters killed: ~a~%Times you ran away: ~a" *walked* *killed* *ran*) )
                 (t (progn (cond 
                            ((equal (random (- (nth 0 *levelrates*) *difficulty*)) 1) (setf *attack* (+ *attack* 1)) (setf *attackmax* (+ *attackmax* 1) ) (setf *HP*  *HPmax* )
                             (format t "LEVEL UP: The experience you gained from defeating ~a increased your ATK by 1!~%" *currentmonster*))
                            ((equal (random (- (nth 1 *levelrates*) *difficulty*))1) (setf *defense* (+ *defense* 1) )(setf *defensemax* (+ *defensemax* 1) ) (setf *HP*  *HPmax* )
                             (format t "LEVEL UP: The experience you gained from defeating ~a increased your DEF by 1!~%" *currentmonster*))
                            ((equal (random (- (nth 2 *levelrates*) *difficulty*))1) (setf *HPmax* (+ *HPmax* 1)) (setf *HP*  *HPmax* ) 
                             (format t "LEVEL UP: The experience you gained from defeating ~a increased your HP by 1!~%" *currentmonster*) )
                            ))

                    ;;reset variables for next encounter and increment kill counter
                    (setf *inbattle* nil) 
                    (setf *defense* *defensemax*)
                    (setf *attack* *attackmax*)
                    (setf *eHP* *eHPmax*)
                    (setf *edefense* *edefensemax*)
                    (setf *eattack* *eattackmax*)
                    (setf *killed* (+ *killed* 1))
                    (look) )))
          ((> *ehp* 0)
           ;;monster survived, so it gets to counterattack
           (monster-attack)
           )
          ) 
    )
   ((null *inbattle*) (format nil "There is nothing to attack."))
   
   )
  )

;;;the monster attacks you.  if you survive, restart the battle loop.  if you die, it is GAME OVER.
(defun monster-attack ()
  (setf *val* (- *eattack* *defense* *defended*))
  (cond ((> 0 *val*)
         (setf *val* 0)
         )
        )
  (format t "The ~a attacks you for ~a damage!~%~%" *currentmonster* *val*)
  (setf *HP* (- *HP* *val*))
  (cond ((< *HP* 1 ) 
         ;;GAME OVER
         (format t "You were slain by the ~a!~%~%G A M E O V E R" *currentmonster*) 
         (format nil "~%~%Type quit to exit.")
         )
        ((> *HP* 0)

         ;;restart the battle cycle
         (battle-text)
         )
        )
  )

;;;starts the boss battle with the dragon
(defun dragon-attack ()
  (setf *currentmonster* 'dragon)
  (monster-stats)
  (setf *inbattle* t)
  (format t "You are attacked by a ~a. This is the end!~%" *currentmonster*)
  (battle)
  
)

;;;applies the additional monster stats of the chosen type to the base monster stats
(defun monster-stats ()
(setf *eattack* (+ *eattack* (nth 1 (assoc *currentmonster* *estats*))))
(setf *edefense* (+ *edefense* (nth 2 (assoc *currentmonster* *estats*))))
(setf *eHP* (+ *eHP* (nth 3 (assoc *currentmonster* *estats*))))
)

;;;defend temporarily raises your defense for a turn
(defun defend ()
  (cond ((not(null *inbattle*))
         (format t "You take a defensive stance.~%")
         (if (haveshield)
             (setf *defended*  (+ *defended* (nth 3 (assoc *shield* *equippable*)))) ;get bonus defense if using a shield
           (setf *defended* (+ *defended* 1))                                        ;otherwise get only +1 defense
           )
         (monster-attack)
         )
        (t (format nil "There is nothing to defend yourself from."))
        )
  )

;;;run attempts to flee combat, but it might fail, in which case you take extra damage
(defun run ()
  (setf *random* (random 101))
  (cond ((not(null *inbattle*))
         (cond
          ((< *random* 40) (format t "You failed to run away!~%" ) (setf *defense* (- *defense* *eattack*))(monster-attack) )
          ((> *random* 38) (format t "You ran away!~%")
           (setf *defense* *defensemax*)
           (setf *attack* *attackmax*)
           (setf *inbattle* nil) 
           (setf *eHP* *eHPmax*) 
           (setf *edefense* *edefensemax*)
           (setf *eattack* *eattackmax*)
           (setf *ran* (+ *ran* 1))
           (look) )
          ))    
        (t (format nil "There is nothing to run from."))
        )
  
  )

;;;randomly selects a hint to show
(defun printhint ()
 (progn
    (setf *random* (random 9))
    (cond  
     ((equal *random* 0) (format nil "HINT: Every time you walk, monsters have a chance to level up. Try to open the chest before the monsters get too strong for you to handle.~%"))
     ((equal *random* 1) (format nil "HINT: Paths do not always lead where they say they do.~%" ))
     ((equal *random* 2) (format nil "HINT: Use the room descriptions to remember where they are in the forest.~%" ))
     ((equal *random* 3) (format nil "HINT: Save potions for when you really need them.~%" ))
     ((equal *random* 4) (format nil "HINT: When you level up, you will be fully healed.~%" ))
     ((equal *random* 5) (format nil "HINT: Each time you fail when attempting to run away, you will take more and more damage.~%" ))
     ((equal *random* 6) (format nil "HINT: Defending in combat gets stronger based on your equipped shield.~%" ))
     ((equal *random* 7) (format nil "HINT: At the beginning of the game, try to find the equipment near the starting location.~%" ))
     ((equal *random* 8) (format nil "HINT: Higher difficulties makes monsters attack and level up more often, increases their base stats, and makes it less likely you will level up.~%" ))

     )
  
    )

)

;;;equip an item, gaining its beneficial stats. can only have 1 item per slot.
(defun equip (item)
  (cond 
   ((not(have item))  (format nil "You do not have ~a in your inventory." item )  ) ;check that we have the item
   ((not(assoc item *equippable*)) (format nil "~a can not be equipped." item) )     ;check that the item is equippable
   ( (isweapon item)  (cond ((haveweapon) (unequip *weapon*))) (equipitem item) )  ;if it's a weapon, check if we already have one on, in which case unequip it
   ( (isshield item)  (cond ((haveshield) (unequip *shield*))) (equipitem item) ) ;if it's a shield, check if we already have one on, in which case unequip it
   ( (isarmor item)  (cond ((havearmor) (unequip *armor*))) (equipitem item) )  ;if it's armor, check if we already have one on, in which case unequip it
   )
  
  )

;;;shows your stats and equipped items, also print a hint out
(defun stats ()
  (format t "========================~%HP: ~a  ATK: ~a  DEF: ~a~%WPN: ~a~%SHLD: ~a~%ARMR: ~a~%========================~%" *HP* *attack* *defense* *weapon* *shield* *armor*)
  (printhint)
  )

;;;gives your character the stats from the item you are currently trying to equip. sets your equipped item and then shows your stats.
(defun equipitem (item)
  (setf *attack* (+ *attack* (nth 2 (assoc item *equippable*)))) (setf *attackmax* (+ *attackmax* (nth 2 (assoc item *equippable*)))) 
  (setf *defense* (+ *defense* (nth 3 (assoc item *equippable*)))) (setf *defensemax* (+ *defensemax* (nth 3 (assoc item *equippable*))))
  (setf *HPmax* (+ *HPmax* (nth 4 (assoc item *equippable*)))) 
  (setf *HP* (+ *HP* (nth 4 (assoc item *equippable*))))
  (cond
   ((isweapon item) (setf *weapon* item))
   ((isshield item) (setf *shield* item))
   ((isarmor item) (setf *armor* item))
)

  (stats)
(format nil "You equip the ~a." item)
  )

;;;returns t if item is a weapon, otherwise returns nil
(defun isweapon (item)
  (if (equal(nth 1(assoc item *equippable*)) 1) 
      t
    nil
    )
  )

;;;returns t if item is a shield, otherwise returns nil
(defun isshield (item)
  (if (equal(nth 1(assoc item *equippable*)) 2) 
      t
    nil
    ) 
  )

;;;returns t if item is armor, otherwise returns nil
(defun isarmor (item)
  (if (equal(nth 1(assoc item *equippable*)) 3) 
      t
    nil
    )
  )

;;;returns t if you are equipping a weapon, or nil otherwise
(defun haveweapon ()
  (if *weapon*
      t
    nil
    )
  )

;;;returns t if you are equipping a shield, or nil otherwise
(defun haveshield ()
  (if *shield*
      t
    nil
    )
  )

;;;returns t if you are equipping armor, or nil otherwise
(defun havearmor ()
  (if *armor*
      t
    nil
    )
  )

;;;unequips the given item, losing its stats. Only called on items you already have equipped.
(defun unequip (item)
  (setf *attack* (- *attack* (nth 2 (assoc item *equippable*)))) (setf *attackmax* (- *attackmax* (nth 2 (assoc item *equippable*))))
  (setf *defense* (- *defense* (nth 3 (assoc item *equippable*)))) (setf *defensemax* (- *defensemax* (nth 3 (assoc item *equippable*))))
  (setf *HPmax* (- *HPmax* (nth 4 (assoc item *equippable*))))
  (setf *HP* (- *HP* (nth 4 (assoc item *equippable*)))) 
  (cond
   ((isweapon item) (setf *weapon* nil))
   ((isshield item) (setf *shield* nil))
   ((isarmor item) (setf *armor* nil))
   )
  )

;;;isequipped checks if you have the given item equipped
(defun isequipped (item)
  (or (or (equal *weapon* item) (equal *shield* item))
   (equal *armor* item)    
   )
  )

;;;drop lets you drop an item on the ground
(defun drop (item)
  (cond 
   ((not(have item))  (format nil "You do not have ~a.~%" item)) ;check that you have the item
   ((not(null (have item))) 
    (cond ((isequipped item)  (unequip item)) )   ;if it's equipped, unequip it first
    (drop2 item *location*))      ;drop it
   )
  )

;;;drop2 is the helper method for drop, that removes the original object location and pushes it to the ground where you're standing
(defun drop2 (item location)
  (setf *object-locations* (eliminate (list item 'body) *object-locations*))
  (pushnew (list item location) *object-locations*)
  (format nil "You drop the ~a on the ground." item)
  )

;;;use lets you use usable items such as potions
(defun use (item)
  (cond 
   ((not(isusable item)) (format nil "You cannot use ~a." item))
   ((equal(nth 1 (assoc item *usable*))1) (usehealing item))     ;use a healing item
   ((equal(nth 1 (assoc item *usable*))2) (useatkup item) )     ;use an atk up item
   ((equal(nth 1 (assoc item *usable*))3) (usedefup item) )     ;use a def up item
   )
  )

;;;uses a healing item, recovering your HP stat
(defun usehealing (item)
  (setf *HP* (+ *HP* (nth 2 (assoc item *usable*))))
  (setf *object-locations* (eliminate (list item 'body) *object-locations*))
  (cond 
   ((> *HP* *HPmax*)
    (setf *HP* *HPmax*) (format nil "You were fully healed by ~a."item))
   ((< *HP* *HPmax*)
    (format nil "~a healed you for ~a." item (nth 2 (assoc item *usable*))))
   )
)

;;;uses an ATK up item, raising your attack temporarily (one battle)
(defun useatkup (item)
  (setf *attack* (+ *attack* (nth 2 (assoc item *usable*))))
  (setf *object-locations* (eliminate (list item 'body) *object-locations*))
  (format nil "Your attack temporarily rose by ~a!~%" (nth 2 (assoc item *usable*)))
  )

;;;uses a DEF up item, raising your defense temporarily (one battle)
(defun usedefup (item)
  (setf *defense* (+ *defense* (nth 2 (assoc item *usable*))))
  (setf *object-locations* (eliminate (list item 'body) *object-locations*))
  (format nil "Your defense temporarily rose by ~a!~%" (nth 2 (assoc item *usable*)))
  )

;;;checks if an item is usable
(defun isusable (item)
(if (assoc item *usable*)
t
nil
)
)

;;;battle command to show your inventory and prompt item usage
(defun item ()
  (format t "What will you use?~%")
  (inventory)
  )

;;;returns a random element from the list
(defun random-element (inlist)
  (nth (random (length inlist)) inlist))

;;;Function pickup attempts to pick up the given object name
(defun pickup (object)
  (cond ((member object (objects-at *location* *objects* *object-locations*))
         (push (list object 'body) *object-locations*)
         (setf *object-locations* (eliminate (list object *location*) *object-locations*))
         `(you are now carrying the ,object))
        (t '(you cannot get that.))))

;;;Function inventory displays the items in your inventory
(defun inventory ()
  (cons 'items- (objects-at 'body *objects* *object-locations*)))

;;;shows available commands to help player
(defun help()
  
  (format nil 
"Available Commands:~%about: Describes the goal of the game.~%help/h/?: Prints information about available commands.
~%===================GAMEWORLD ACTIONS===================~%look: Describes the location and objects around you.~%walk: Moves your character to the location in a given direction.~%pickup: Picks up an object that is in your current location.~%inventory: Shows all the items you are carrying.~%drop: Drops an item from your inventory on to the ground.  If it was equipped, you unequip it.~%use: Use an item from your inventory.~%equip: Equip an item from your inventory, increasing your stats.~%talk: Talk to an NPC to hear their dialogue.~%stats: Display your stats and equipment, as well as a hint.~%~%smelt: when you have all the key pieces, you can 'smelt key-piece-1 key-piece-2' to make the master-key (if you are in the same room as it).~%unlock: when you have the master key, you can 'unlock master-key chest' if you are in the same room as it.
~%===================COMBAT ACTIONS===================~%attack: Attack your enemy in combat.~%defend: Defend yourself, increasing defense temporarily.~%run: Attempt to run away. Failing to do so means you take more damage.~%item: Select an item to use from your inventory.")
  )

;;;calls help
(defun h()
  (help))

;;;calls help
(defun ?()
  (help))

;;;about describes the goal of the game to the player. nil argument
(defun about()
(format nil "Collect the ~a pieces of the master key scattered around the forest.~%Forge the pieces back into the key and open the treasure chest!~%Along the way you will be attacked by monsters, who you must defeat in combat. Find equipment and potions to aid you in battle.~%Type 'help' to see available commands.~%" *numpieces* )
)

;;;about describes the goal of the game to the player. t argument
(defun aboutt()
(format t "Collect the ~a pieces of the master key scattered around the forest.~%Forge the pieces back into the key and open the treasure chest!~%Along the way you will be attacked by monsters, who you must defeat in combat. Find equipment and potions to aid you in battle.~%Type 'help' to see available commands.~%" *numpieces* )
)

;;;eliminate returns the list without the target nested sublist in it
(defun eliminate (target inlist &optional l0)
  (cond ((null inlist) (reverse l0))
        ((equal target (car inlist)) (eliminate target (cdr inlist) l0))
        (T (eliminate target (cdr inlist) (cons (if (not (atom (car inlist))) 
                                                    (eliminate target (car inlist)) 
                                                  (car inlist))
                                                l0)))))

;;;talks to an npc to hear their dialogue, randomly selected
(defun talk (npc)
  (if (equal *location* (nth 1(assoc npc *npcs*)))
      (format nil (coerce (tweak-text (coerce (string-trim "() " (prin1-to-string  (nth (+ 2 (random 3))(assoc npc *npcs*)) )) 'list) t nil) 'string))
    (format nil "There is no ~a to talk to here." npc)
    )
  )

;;;Function have checks whether you have the given item in your inventory
(defun have (object) 
    (member object (cdr (inventory))))

;;;set-diff-stats alters the monster base stats based on the difficulty
(defun set-diff-stats ()
(setf *eattack* (+ *eattack* (- 6 *difficulty*)) ) (setf *eattackmax* (+ *eattackmax* (- 6 *difficulty*)) )
(setf *edefense* (+ *edefense* (- 6 *difficulty*)) ) (setf *edefensemax* (+ *edefensemax* (- 6 *difficulty*)) )
(setf *eHP* (+ *eHP* (- 6 *difficulty*)) ) (setf *eHPmax* (+ *eHPmax* (- 6 *difficulty*)) )
)

;;;asks the player for the difficulty they want to play at
(defun ask-diff ()
(format t "Select the game's difficulty level from 1 to 5, with 1 being the hardest and 5 the easiest.~%")
(setf *difficulty* (read))
(cond
((not(numberp *difficulty*)) (princ "Must enter a number.")(fresh-line) (ask-diff))
((or(> *difficulty* 5) (< *difficulty* 1)) (princ "Invalid difficulty selection.")(fresh-line) (ask-diff)  )
(t (set-diff-stats)(aboutt))
)
)

;;;prints the game title
(defun print-title ()
(format t "
'||''|.             .'|.   .'|. '||   ||                      '||''|.                   '||                                       '||         
 ||   ||   ....   .||.   .||.    ||  ...  .. ...     ... .     ||   ||   ....     ....   ||  ..  ... ... ...   ...     ...      .. ||   ....  
 ||'''|.  '' .||   ||     ||     ||   ||   ||  ||   || ||      ||'''|.  '' .||  .|   ''  || .'    ||  ||  |  .|  '|. .|  '|.  .'  '||  ||. '  
 ||    || .|' ||   ||     ||     ||   ||   ||  ||    |''       ||    || .|' ||  ||       ||'|.     ||| |||   ||   || ||   ||  |.   ||  . '|.. 
.||...|'  '|..'|' .||.   .||.   .||. .||. .||. ||.  '||||.    .||...|'  '|..'|'  '|...' .||. ||.    |   |     '|..|'  '|..|'  '|..'||. |'..|' 
                                                   .|....'                                                                                    
                                                                                                                                               ~%")

)



;;;starts the game-repl, prints title, asks for difficulty
(defun start()
(print-title)
(ask-diff)
(game-repl)
)

;;;starts the game-repl, prints title, asks for difficulty
(defun play()
(print-title)
(ask-diff)
(game-repl)
)

;;;starts the game-repl, which is the main REPL for our game
(defun game-repl ()
  (let ((cmd (game-read)))
    (unless (eq (car cmd) 'quit)
      (game-print (game-eval cmd))
      (game-repl))))

;;;game-read gets a line of user input and parses for the command and parameters
(defun game-read ()
  (let ((cmd (read-from-string (concatenate 'string "(" (read-line) ")"))))
    (flet ((quote-it (x)
             (list 'quote x)))
      (cons (car cmd) (mapcar #'quote-it (cdr cmd))))))

;;;game-eval evaluates whether the user given command is valid
(defun game-eval (sexp)
  (if (member (car sexp) *allowed-commands*)
      (eval sexp)
    '(i do not know that command.)))

;;;tweak-text alters text to make it more readable for humans
(defun tweak-text (lst caps lit)
  (when lst
    (let ((item (car lst))
          (rest (cdr lst)))
      (cond ((eql item #\space) (cons item (tweak-text rest caps lit)))
            ((member item '(#\! #\? #\.)) (cons item (tweak-text rest t lit)))
            ((eql item #\") (tweak-text rest caps (not lit)))
            (lit (cons item (tweak-text rest nil lit)))
            (caps (cons (char-upcase item) (tweak-text rest nil lit)))
            (t (cons (char-downcase item) (tweak-text rest nil nil)))))))

;;;game-print prints everything that is returned from evaluating our command
(defun game-print (lst)
  (princ (coerce (tweak-text (coerce (string-trim "() " (prin1-to-string lst)) 'list) t nil) 'string))
  (fresh-line))

;;;defines how game macros work
(defmacro game-action (command subj obj place &body body)
  `(progn (defun ,command (subject object)
            (if (and (eq *location* ',place)
                     (eq subject ',subj)
                     (eq object ',obj)
                     (have ',subj))
                ,@body
              '(i cant ,command like that.)))
     (pushnew ',command *allowed-commands*)))

;;;combines the key pieces to form the master key. Only works with all the pieces, at the location of the forge.
(game-action smelt key-piece-1 key-piece-2 f4-6
  (if 
      (and
       (and
        (and
         (and
          (and
           (and (have 'key-piece-1) (have 'key-piece-2))   
           (have 'key-piece-3)
           )
          (have 'key-piece-4)
          )
         (have 'key-piece-5)
         )
        (have 'key-piece-6)
        )
       (have 'key-piece-7)
       )
      (progn (setf *master-key* 't)
        (setf *object-locations*  (eliminate 'key-piece-1 *object-locations*))
        (setf *object-locations* (eliminate 'key-piece-2 *object-locations*))
        (setf *object-locations* (eliminate 'key-piece-3 *object-locations*))
        (setf *object-locations* (eliminate 'key-piece-4 *object-locations*))
        (setf *object-locations* (eliminate 'key-piece-5 *object-locations*))
        (setf *object-locations* (eliminate 'key-piece-6 *object-locations*))
        (setf *object-locations* (eliminate 'key-piece-7 *object-locations*))
        (new-object master-key f4-6)
        (pickup 'master-key)
        '(you have forged the master key!))
    '(you do not have all the key pieces.)))

;;;uses the master key to unlock the chest
            (game-action unlock master-key chest f4-5
              (cond 
               ((not *master-key*) '(you do not have the master-key.))
               (t (format t "You unlock the chest and see it is full of gold and treasure. A dragon swoops down to protect its treasure!~%")
                  (dragon-attack))
                    )
              )


;;;new-object creates a new object at the given location
(defmacro new-object (object location)
  "new-object creates a new object at the given location"
  `(
    cond
    (
     (searchlistcar ',object *objects*)
     (format t "Invalid object: ~a already exists.~%" ',object)()    ;check to make sure the object doesn't already exist
     )
    (t
     (cond
  (
   (not(searchlistcaar ',location *nodes*))
   (format t "Invalid location: ~a does not exist.~%" ',location)  ;check to make sure the location exists
  )
  (
   t
 (progn
   (pushnew ',object *objects*)                            ;create new object in objects
  (pushnew '(,object ,location) *object-locations*)       ;create new object-location in object-locations
  )
 )
  )
 )
    )
  )

;;;new-location creates a new location with a given text description
(defmacro new-location (location &rest text)
  "new-location creates a new location with a given text description"
  `(
    cond
    (
     (not (searchlistcaar ',location *nodes*))    ;check to make sure that the location doesn't already exist
     (pushnew '(,location (,@text)) *nodes*)      ;add the new location to our list of nodes      
     (pushnew '(,location) *edges*)               ;add the anchor for edges to spawn off our new node
     )
    (
     t 
     (format t "Invalid location: ~a already exists.~&" ',location) ;location already existed
     ) 
    )
  )

;;;make-path creates a path from a valid source to a valid destination, using the given parameters
(defmacro make-path (source destination direction portal)
  "new-path creates a path from source to destination, and optionally from destination back to source"
  `(
    cond
    (                                            
     (not (searchlistcaar ',source *nodes*))                ;check if the source location exists in nodes
     (format t "Invalid path: ~a does not exist.~%" ',source)(terpri)()
     )     
    (                               
     (not (searchlistcaar ',destination *nodes*))               ;check if the destination location exists in nodes
     (format t "Invalid path: ~a does not exist.~%" ',destination)(terpri)()
     )                                         
    (
     t
     (
      cond
      (
       (searchlistcar '(,destination ,direction ,portal) (assoc ',source *edges*))   ;check to see if the edge we're trying to add already exists
       (format t "Invalid path: edge from ~a to ~a already exists.~%" ',source ',destination)(terpri)()
       )
      (
       t
       (pushnew '(,destination ,direction ,portal)(cdr (assoc ',source *edges*)))    ;add the new edge to the existing anchor in *edges*
       )
      )
     )
    )
  )

;;;new-path creates a path from source to destination, and optionally from destination back to source, by calling make-path
(defmacro new-path (source destination direction portal &optional (direction2 nil)  (portal2 nil))
  "new-path creates a path from source to destination, and optionally from destination back to source, by calling make-path "
  `(
    progn 
     (make-path ,source ,destination ,direction ,portal)
     (
      cond 
      (
       (and(not(equal ',direction2 nil)) (not(equal ',portal2 nil)))
       (make-path ,destination ,source ,direction2 ,portal2)
       )
      )  
     )
  )

;;;searchlistcar recursively searches the car place of the inlist for the item given
(defun searchlistcar (item inlist)
  "searchlistcar recursively searches the car place of the inlist for the item given"
  (
   cond 
   (
    (null inlist)
    (terpri)()
    )
   (
    (equal (car inlist) item)
    t
    )
   (
    t
    (searchlistcar item (cdr inlist))
    )
   )
  )

;;;searchlistcar recursively searches the caar place of the inlist for the item given
(defun searchlistcaar (item inlist)
  "searchlistcar recursively searches the car place of the inlist for the item given"
  (
   cond 
   (
    (null inlist)
    (terpri)()
    )
   (
    (equal (caar inlist) item)
    t
    )
   (
    t
    (searchlistcaar item (cdr inlist))
    )
   )
  )

(progn
  (new-location f1-1 you can feel the wind through the trees. you see some abandoned alchemy supplies which are too confusing for you to use.)
  (new-location f1-2 you can feel the wind through the trees.)
  (new-location f1-3 you can feel the wind through the trees.)
  (new-location f1-4 you can feel the wind through the trees. there was a path to your north but it is blocked by rubble from a landslide.)
  (new-location f1-5 you can feel the wind through the trees. there is a haggard looking vagrant trudging north.)
  (new-location f1-6 you can feel the wind through the trees.)
  (new-location f1-7 you can feel the wind through the trees. there are faded footprints headed east.)
  (new-location f1-8 you can feel the wind through the trees.)
 
 (new-location f2-1 you can feel the wind through the trees. the undergrowth closes behind you. it blocks the path back!)
  (new-location f2-2 the forest is misty here.)
  (new-location f2-3 you see a traveler resting under a tree near a cliff next to the road.)
  (new-location f2-4 you are in a forest. you see a pit to the east with no way down.)
  (new-location f2-5 you are in a pit.  you can see the sky when you look up.)
  (new-location f2-6 you are in a forest. you see a pit to the west.)
  (new-location f2-7 you are in a dense part of the forest.)
  (new-location f2-8 you can feel the wind through the trees.)

 (new-location f3-1 you can feel the wind through the trees.)
  (new-location f3-2 you are in clearing. there is a hill to your west and north-but you cannot climb it.)
  (new-location f3-3 you are in a forest. there are footprints leading north down the road.)
  (new-location f3-4 you are in a secluded grove. someone forgot their belongings beneath a shady tree.)
  (new-location f3-5 you are at the edge of a clearing. you see a pit to the north with no way down.)
  (new-location f3-6 you are in a forest. there is a blacksmithing satchel full of tools hanging from a tree branch. it is out of reach.)
  (new-location f3-7 you are in a forest. there is an adventurer looking east.)
  (new-location f3-8 you can feel the wind through the trees. the skeletal remains of an adventurer are resting against a tree.)

  (new-location f4-1 you can feel the wind through the trees. the knight watches you from far away behind a tree.)
  (new-location f4-2 you are at a crossroads.  of sorts?)
  (new-location f4-3 you are in a forest. there are footprints leading north down the road.)
  (new-location f4-6 you are in an open clearing. there is a furnace in front of you.)
  (new-location f4-7 you are in a forest. the pines loom threateningly from the east.)
  (new-location f4-8 you can feel the wind blowing from the east.)

  (new-location f5-1 you can feel the wind through the trees. there is a knight with diamond-encrusted armor idly sharpening his sword on a rock.)
  (new-location f5-2 you are in a forest. there is a cliff to your west. you can hear a slicing noise echoing down from above...)
  (new-location f5-3 you are in a forest. you swear you have been here before. maybe it is just your imagination.)
  (new-location f5-4 you are at a well-traveled crossroads.)
  (new-location f5-5 you are in a forest.)
  (new-location f5-6 you are in a forest. there is a blacksmith rummaging through the bushes.)
  (new-location f5-7 you are in a forest. you sense a piece of the key is nearby.)
  (new-location f5-8 you can feel the wind through the trees.)
 
 (new-location f6-1 you can feel the wind through the trees. there is a cliff looming over you)
  (new-location f6-2 you can feel the wind through the trees. you consider flipping a coin to choose which direction to take.)
  (new-location f6-3 you can feel the wind through the trees.)
  (new-location f6-4 you can feel the wind through the trees.)
  (new-location f6-5 you can feel the wind through the trees. you try to remember how you got here... but it just makes your head hurt.)
  (new-location f6-6 you can feel the wind through the trees.)
  (new-location f6-7 you can feel the wind through the trees. it seems no one has been here in a while.)
  (new-location f6-8 you can feel the wind through the trees.)

  (new-path f1-1 f4-5 west path)
  (new-path f1-1 f1-2 east path)

  (new-path f1-2 f4-5 east path)

 (new-path f1-3 f4-5 west path)
 (new-path f1-3 f2-2 south path)

 (new-path f1-4 f1-3 east path)
 (new-path f1-4 f2-4 south path)

 (new-path f1-5 f1-4 west path)
 (new-path f1-5 f4-5 north path)
 (new-path f1-5 f3-5 south bridge)
 (new-path f1-5 f1-6 east path)

 (new-path f1-6 f1-5 west path)
 (new-path f1-6 f1-7 east path)

 (new-path f1-7 f4-5 west path)
 (new-path f1-7 f1-8 east path)

 (new-path f1-8 f4-5 north path)
 (new-path f1-8 f4-5 east path)

 (new-path f2-1 f1-1 north path)
 (new-path f2-1 f2-2 west path)
 (new-path f2-1 f4-5 south path)

 (new-path f2-2 f2-1 west path)
 (new-path f2-2 f3-2 south path)

 (new-path f2-3 f2-4 east path)
 (new-path f2-3 f3-3 south path)

 (new-path f2-4 f1-4 north path)
 (new-path f2-4 f2-3 west path)
 (new-path f2-4 f2-6 east bridge)

 (new-path f2-5 f3-5 up rope)

 (new-path f2-6 f2-5 down rope)
 (new-path f2-6 f1-6 north path)

 (new-path f2-7 f2-8 east path)

 (new-path f2-8 f3-8 south path)
 (new-path f2-8 f2-6 west path)

 (new-path f3-1 f3-2 east path)
 (new-path f3-1 f4-5 west path)

 (new-path f3-2 f3-3 east path)
 (new-path f3-2 f4-2 south path)

 (new-path f3-3 f2-3 north path)
 (new-path f3-3 f3-2 west path)
 (new-path f3-3 f4-3 south path)

 (new-path f3-4 f4-4 south path)
 
 (new-path f3-5 f1-5 north bridge)
 (new-path f3-5 f4-5 south path)
 (new-path f3-5 f3-6 east path)

 (new-path f3-6 f4-6 south path)
 (new-path f3-6 f3-5 west path)
 (new-path f3-6 f3-7 east path)

 (new-path f3-7 f4-7 south path)
(new-path f3-7 f4-5 north path)
(new-path f3-7 f2-7 east path)

(new-path f3-8 f2-8 north path)
(new-path f3-8 f4-5 east path)
(new-path f3-8 f4-8 south path)
(new-path f3-8 f4-5 west path)

(new-path f4-1 f4-5 north path)
(new-path f4-1 f3-1 east path)
(new-path f4-1 f4-2 west path)

(new-path f4-2 f5-2 north path)
(new-path f4-2 f3-2 south path)

(new-path f4-3 f3-3 north path)
(new-path f4-3 f4-5 west path)
(new-path f4-3 f4-4 east path)
(new-path f4-3 f5-2 south path)

(new-path f4-4 f3-4 north path)
(new-path f4-4 f4-3 west path)
(new-path f4-4 f5-4 south path)

(new-path f4-5 f3-5 north path)
(new-path f4-5 f4-6 east path)
(new-path f4-5 f5-5 south path)

(new-path f4-6 f4-5 west path)
(new-path f4-6 f3-6 north path)
(new-path f4-6 f4-7 east path)
(new-path f4-6 f5-6 south path)

(new-path f4-7 f4-6 west path)
(new-path f4-7 f3-7 east path)

(new-path f4-8 f4-5 north path)
(new-path f4-8 f4-5 west path)
(new-path f4-8 f4-5 south path)
(new-path f4-8 f5-8 east path)

(new-path f5-1 f4-1 north path)

(new-path f5-2 f4-2 north path)
(new-path f5-2 f5-3 east path)
(new-path f5-2 f6-2 south path)

(new-path f5-3 f4-3 north path)
(new-path f5-3 f5-4 east path)
(new-path f5-3 f4-5 south path)

(new-path f5-4 f4-4 north path)
(new-path f5-4 f5-5 east path)
(new-path f5-4 f4-5 south path)
(new-path f5-4 f5-3 west path)

(new-path f5-5 f5-4 west path)
(new-path f5-5 f4-5 north path)
(new-path f5-5 f6-5 south path)

(new-path f5-6 f5-7 east path)
(new-path f5-6 f4-6 north path)

(new-path f5-7 f4-7 north path)
(new-path f5-7 f4-5 south path)

(new-path f5-8 f4-5 east path)
(new-path f5-8 f4-5 south path)

(new-path f6-1 f4-5 north path)
(new-path f6-1 f5-1 up ladder)
(new-path f6-1 f5-2 east path)

(new-path f6-2 f6-1 west path)
(new-path f6-2 f6-3 east path)

(new-path f6-3 f6-4 east path)
(new-path f6-3 f4-5 south path)

(new-path f6-4 f4-5 south path)
(new-path f6-4 f6-5 east path)
(new-path f6-4 f4-5 west path)

(new-path f6-5 f4-5 north path)
(new-path f6-5 f6-6 south path)
(new-path f6-5 f5-6 east path)

(new-path f6-6 f6-7 south path)

(new-path f6-7 f6-8 east path)
(new-path f6-7 f4-5 south path)

(new-path f6-8 f6-7 west path)
(new-path f6-8 f4-5 east path)
(new-path f6-8 f4-5 south path)

  (new-object small-potion f3-4)
  (new-object med-potion f3-8)
  (new-object big-potion f1-1)
  (new-object endurance-potion f1-3)
  (new-object strength-potion f5-2)
  (new-object brave-potion f4-7)
  (new-object fierce-potion f6-6)
  
  (new-object key-piece-1 f6-8)
  (new-object key-piece-2 f1-8)
  (new-object key-piece-3 f6-3)
  (new-object key-piece-4 f2-5)
  (new-object key-piece-5 f5-8)
  (new-object key-piece-6 f3-1)
  (new-object key-piece-7 f1-2)


  )







