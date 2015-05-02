# mobile-ios-game
For Mobile Game Development Class

## Game Design
### Objective
* You lose your way and get a magic compass to help you.
* Swipe correctly means you are on the right way, try to swipe quickly and earn high scores.

### Gameplay Mechanics
* There are 2 concentric compasses. One white one black, both with random rotation.
* There's an arrow at the center of the overlaid compasses, white or black (random)
* The arrow's color tells which compass shows your real geomagnetic field. For example, if the arrow is black, it means the black compass shows your  real geomagnetic field, and the other compass show the direction you need to go. if the black arrow points to W on the white compass, it means you need to go W in your real geomagnetic field, so  swipe toward W on black compass. If the arrow is white, vise verser. 

## Technical
### Scenes
* Main Menu
* Gameplay
* Retry

### Controls/Input
* Swipe the screen

### Classes/CCBs
* Scenes
  * MainScene
  * GameOver
* Nodes/Sprites
  * WhiteCompass
  * BlackCompass
  * TimeCircle
  * Arrow

## MVP Milestones
### Week 1 (3/17 - 3/23/2015) _finishing the playable build_
* Plan:
    * Find more images to add
    * Alternate pictures for directions, compass, and arrow
* Completed:
    * Found some images for background 
    * Replace the compass image

### Week 2 (3/24 - 3/30/2015) - _finishing a better playable build_
* Plan:
    * Add the background image, add scenario for the game (someone lost his way)
* Completed
    * Add scoreboard, add background

### Week 3 (3/31 - 4/6/2014)
* Plan
    * Add time limit
    * Fix direction bug
* Completed
    * Fix direction bug
    * Add time circle, when the circle shrink to a specific size, time runs out

### Week 4 (4/7 - 4/13/2014) - _finishing core gameplay_
* Plan
    * Change the direction mechanism
    * Change to portrait mode
* Completed
    * Change the direction mechanism
    * Need to show correct direction, keep using landscape mode

### Week 5 (4/14 - 4/20/2014)
* Plan
    * Show the correct direction when player loses
    * Record high score
* Completed
    * Show the correct direction when player loses
    * Record high score

### Week 6 (4/21 - 4/27/2014) - _finishing the polish_
* Plan
    * Add sound effect 
    * Make the outside compass also rotates randomly
* Completed
    * Add sound effect
    * Add retry scence
    * Make the outside compass also rotates randomly

### Week 7 (4/28 - 5/2/2014) - _finishing the polish_
* Plan
    * Polish game
    * Add more understandable tutorial
