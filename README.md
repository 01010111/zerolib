# ZEROLIB

Zerolib is a library of extensions, utilities, and other helpful classes for making games quickly in haxeflixel!

## Installing
Use `haxelib install zerolib` to install.  
In your game's Project.xml, add `<haxelib name="zerolib" />`.  
Then you'll be set!

## Usage
This library is split into three distinct sections, Extensions, Flixel Utilities, and Other Utilities.

Check the WIKI for specific usage instructions!

### Extensions
Extensions are a neat language feature of Haxe. They can add functionality to preexisting classes. There are several extensions in this library that add some functionality to Haxe Types like `Floats`, `Arrays`, and `Strings`, as well as Flixel classes like `FlxSprites`, `FlxPoints`, and `FlxObjects`. If you're just a normal programmer, you might use this library like this:

import the class you'd like to use:
```haxe
import zero.ext.FloatExt;
```
then, use it to map a number (4) from 0 - 16 to 0 - 1:
```haxe
FloatExt.map(4, 0, 16, 0, 1); // 0.25
```

BUT if you're an EXTRA SPECIAL programmer, you'd use it like this:

use `using` instead of `import`:
```haxe
using zero.ext.FloatExt;
```
then, use it like a pro:
```haxe
4.map(0, 16, 0, 1); // 0.25
```

### Flixel Utilities
This section includes a bunch of classes to help you out in your flixel adventures! It includes:
- A Platformer Dolly for a super smooth 2D platformer camera
- Some lightweight Entity Component System behavior for FlxSprites
- A sturdy controller class that mimics NES/Genesis/SNES controllers
- A Bitmap Text wrapper for quick deplotment of monospace Bitmap Text images
- And some more stuff!

### Other Utilities
This is the smallest section and just contains some classes that I use often in my own projects:
- IntPoint: a Point using Ints instead of Floats
- Range: a utility that stores a min and max value
- Vector: your typical 2D Vector class :)