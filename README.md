# rain_safely_home
A simple game made in Processing (Java). Play as a "fire sprite" that must survive rain storms, 
rain drops, and lightning strikes to reach your goal! </br>

__Link to Game (Open Processing):__ https://www.openprocessing.org/sketch/814169 </br>
__Date:__ October 2019 </br>
__Detailed Summary__:
The player controls a “fire sprite” (red circle) that they must guide safely home to a point
across the screen. To do so, they must dodge “rainclouds” (cloud-shaped objects) that circle the
map in predictable patterns.
The player must also dodge rogue “rain bugs” (small dark blue objects) that spawn at a random
point on a raincloud’s circumference and gravitate towards the “fire sprite” around if the player
gets close enough (the “rain bugs” essentially go into alert mode).
The “rain bugs” disappear after they go off the screen. If the player touches a rainstorm, they
lose a bit of health. If they touch a rain bug, they lose some health, but less than if they touched
a rainstorm. Occasionally, “lightning” strikes occur that take the form of a line connecting all
“rainstorms” and put the player in danger if they’re in the line of fire, immediately frying the
player.
Every time they reach the goal, they gain +150 points. They die when their health runs out and
are brought to the gameover screen. The player should aim to get as many points as possible as
last as long as they can as the “fire sprite.”
