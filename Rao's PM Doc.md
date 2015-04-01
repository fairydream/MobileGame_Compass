# mobile-ios-game
For Mobile Game Development Class

## Game Design
### Objective
~~A string of bubbles snake down the screen in a fixed pattern. The objective is to clear the bubbles in the string, until the entire string is cleared.(Zuma clone)~~

Above design abandoned because physics and curve action is too hard to implement. Bezier actions??? Trying to push objects along a curve at constant speed?? Insane! 

No physics game idea:  
Love Sim + Match 3 P&D style   
You are a slime  
You have another slime  
The other slime is angry with you  
Play match-3 (Puzzle Dragon style?) to make it happier  
Affection gauge = score  
Food gauge too low = death    

### Gameplay Mechanics
Match 3 tiles in a 6x6 grid by sliding a finger. You can rack up combos by drawing lines, Puzzle & Dragon style.

Sliding movement consumes food gauge. If it hits 0, game over.

Block of 3 or more clear and have an effect based on "level"

### Level Design
Each "level" is a different pair of (gender neutral) slimes. Each pair has different effects in diff orbs, e.g. otaku slime like the sword/cosplay orbs, heal slime like the heal orbs (metal slimes eat sword)
 
Example levels (different moe pairings)  
blue slime and green slime (the most generic)  
water slime and fire slime 自古红蓝  
heal slime and metal slime 温暖治愈+三无  
tsundere slime and megane slime  


## Technical
### Scenes
* Main Menu (needs continue button to avoid level select when possible)
* Level Select
* Level
* Gameplay

### Controls/Input
* 6x6 grid that fill the bottom part of the screen
* Slide finger to move a single orb around. 
	* upon collision with another orb, the blob will swap places with the another orb
	* Movement action does not end until finger leave the screen, so long combos are possible.
	* Orb clearing and collapse is only done after finger leave screen 

### Classes/CCBs
* Scenes
  * Main Menu
  * Level Select
  * Level/Grid
  * Gameplay
* Nodes/Sprites
  * Entity (abstract superclass)
    * Orb
  * WorldObject (abstract superclass)
    * SlimeA
    * SlimeB
    * HealthBar
    * AffectionBar
    * IAP items

## Credits
* Core gameplay mechanics implemented by following tutorial from [here](http://www.200monkeys.com/index.php/2012/12/23/cloning-puzzle-and-dragons/) 
* Art Assets 
	* [GameArtForge](http://opengameart.org/users/gameartforge)
	* [Kenny](http://kenney.nl/)
	* [素材提供→【Rド】](http://www.geocities.co.jp/Milano-Cat/3319/muz/002.html)
	* [Epic Runes](http://facebook.com/epicrunes)
	* http://seesaawiki.jp/w/kusaikatana/
	* http://etolier.webcrow.jp/material/xpchara.html
	
* Audio Assets
	* TAM Music Factory

## Features List
* Achievements e.g. go to movies 10 times -> 100 times
* Episode changes based on behavior,  clear different blocks means different behavior, bad ending may occur


## MVP Milestones
### Week 1 (3/17 - 3/23/2015) _Found more assets_
* Planned task:  
	* Secure basic art assets
  	* Scoring code and panel    
* Completed task:
	* Found some audio to use and figured out how to insert and change audio

### Week 2 (3/24 - 3/30/2015) - _finishing a better playable build_
* Planned task
	* Get an expression pack
	* Get some slime animations that are editable (color swap?)
	* Put the slime in 
* Completed task:
	* Fixed a bug with orb swapping visuals
	* Found expression (text)
	* Found slime graphics (with animation from etolier)
	

### Week 3 (3/31 - 4/6/2014)
* Add episode 1 to the core game
	* Implement scoring
	* Score multipliers
	* Add in the slime graphic

### Week 4 (4/7 - 4/13/2014) - _finishing core gameplay_
* add score (and multiplier) animatinos
* add expression change as response to movement

### Week 5 (4/14 - 4/20/2014)
* Fix images and finalize them 
* Add "advanced orb matching tutorial"

### Week 6 (4/21 - 4/27/2014) - _finishing the polish_
* Polish game

### Week 7 (4/28 - 5/2/2014) - _finishing the polish_
*  Write game description, make poster
