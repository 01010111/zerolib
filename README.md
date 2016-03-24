# zerolib
This is a library of utility classes I made for HaxeFlixel users! I've made most of this stuff to facilitate really
quick development for game jams and prototyping, and a lot of it is not as complete as a real library should be, but
it might help you out :)

__WARNING: IT'S ALL CRAPPY AND UNFINISHED__

If you wanna use zerolib utilities in your HaxeFlixel project, you can install it with haxelib:

`haxelib git zerolib https://github.com/01010111/zerolib`

and then in your Project.XML:

`<haxelib name="zerolib" />`

- - - - 

## REALLY COOL STUFF

This stuff should work pretty well, and have decent internal documentation!

###ZPlatformerDolly

![picture alt](http://i.imgur.com/6YYLnhi.gif "Super Mario World style camera!")

A Super Mario World style camera "dolly"

It features platform snapping, a camera window for deadzone, dual forward focus, and manual vertical control! 
Thanks to Itay Keren and his amazing talk "Scroll Back: The Theory and Practice of Cameras in Side-Scrollers"
for making me realize I needed this in my platformers :P

__USAGE__

In your FlxState, make a dolly variable, tell it what to follow, and add it to the state!:

```haxe
dolly = new ZPlatformerDolly(/*FlxSprite to follow*/);
add(dolly);
```

_you can also do things like set the camera's bounds, switch targets, and use manual vertical controls!_

###ZMath

There are a bunch of functions in here for doing math junk, for instance:

**angleFromVelocity(vX:Float, vY:Float):Float** - get angle from velocity - useful for rotating an object 
according to its velocity!

**angleBetween(p1:FlxPoint, p2:FlxPoint):Float** - get angle between two objects - useful for rotating an 
object to point at another object, also works really well in conjunction with:

**velocityFromAngle(angle:Float, speed:Float):FlxPoint** - get a point (that you can use to set an object's
velocity) from an angle and a desired speed - useful for setting an object in motion towards a specific point!

**placeOnCircle(CENTER:FlxPoint, ANGLE:Float, RADIUS:Float):FlxPoint** - get a point (that you can use to set an object's
position) from a desired midpoint, angle, and radius - useful for placing objects on a circle! It's fun to use a variable
for the angle and do fun things like tween that variable!

There are lots of other functions in this Class, but I would recommend checking out FlxMath, because there's a lot of
redundancy between these functions and all of the functionality in FlxMath, and in benchmarking FlxMath usually outperforms
these functions :P

## PRETTY COOL STUFF

This stuff should work ok but maybe they lack features or documentation :0

###ZCountDown

![picture alt](http://i.imgur.com/Wvs2d7p.gif "KEEP MOVING!")

Creates a simple countdown timer! It works based on FPS, and will probably not work with FPS > 99!

__USAGE__

Create the timer, tell it where to be, tell it how many minutes to count down, and add it to your state!

```haxe
var _timer = new ZCountDown(/*FlxPoint to set position*/, /*Minutes to count down*/);
add(_timer);
```

*if you don't want to use the built in graphics (check the source to see how far I went to avoid embedding graphics, 
it's stupid) you can use the built in functions like get_time_string()! You can also set a callback function for when time is up!*

###ZBitmapText

I wanted a quick and easy way to use monospaced bitmap text, so I made this! Check it out!

###ZMenu / ZSimpleMenu###

These are both attempts at making menus less of a burden! Maybe one day they'll be feature-complete enough for me to 
write some documentation for, but if you're desperate, you can try to figure it out yourself :P

###ZArrayUtils###

I just started this one, will probably add in a few more functions, like sorting stuff, shuffling stuff, but for now it's 
pretty barren.

###ZSpotLight###

![picture alt](http://i.imgur.com/HlP6BV1.gif "it looks like you're a spy!")

This uses info from TajamSoft - http://ludumdare.com/compo/2015/07/01/dungeon-of-ricochet-post-mortem-lighting/
	
It can create multiple "spotlights" so it feels like cool lighting :)

__USAGE__

in your FlxState:
	
```haxe
var spotlights = new ZSpotLight();
spotlights.add_to_state();
```

Note - don't add it to state normally. You gotta add the lights too, so just use the add_to_state() function!

Then you add spotlights by setting targets:
	
```haxe
spotlights.add_light_target(/* Your object for the spotlight to track */, /* the size of the spotlight's circle */);
```

You can also add entire groups at once!

```haxe
spotlights.add_light_targets(/* FlxGroup of objects for spotlights to track */, /* the size of each spotlight's circle */);
```

I wanna add graphics support, but it's a bit over my head at this point :P Might give it a shot later!