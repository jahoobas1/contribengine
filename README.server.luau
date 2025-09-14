--[[moved out of the src so I can explain it on devforum

Copyright Solivis Collective (C) 2025.
All rights reserved.

----- Contribengine 0.0.1BETA -----

I recommend using this with Rojo.

I've been making this engine as a bit of a proof of concept for a little and I'd like feedback.
If it's stupid please let me know, and what to change.

************************************************************************************
** WHAT IS IT? *********************************************************************
************************************************************************************
This engine is called Contribengine.
I named it that because I want to utilize community contributions to make this an extensive tool.

Feel free to suggest new names while it's still early in development.

Anyway, Contribengine is supposed to be super modular and lightweight.
I wanted to make it easy for developers to just plug in a module and have it just work (as long as it's a valid module for this tool).

I wanted Contribengine to be modeled a little bit like a lego set.
So, the modules that are plugged into Contribengine are named "Bricks"
and the core module that connects everything together for you is named the "Baseplate".

I should mention right now that there is not nearly enough code for this for a professional game.

I wanted to ask people to help contribute to the project.
If we made many Bricks then this would be a solid tool for any game.

************************************************************************************
** HOW DO I USE IT? ****************************************************************
************************************************************************************
Contribengine is easy to use.
I recommend you have an understanding on how modules work though.

You can take the basic code from GenericBrick and use that to create bricks.

To add bricks, just put them in the "bricks" folder and they'll automatically load, as long as all dependencies are present. Otherwise you'll have an error.

In either a Script, LocalScript, or both, just require the CONTRIBENGINE module. All bricks will load.
If you need to run a function (for initialization), just run it from the script that loaded the main module.

All bricks can access all bricks they need.
To make sure your bricks can access the bricks they need to function, add them as a dependency in the top of the file using the following format:

type/name

For example, to make GenericBrick a dependency you would do:

bricks/GenericBrick

Or, to use one of the core Bricks, do:

core/HierarchyService (just an example.)

The baseplate will automatically load it after all of the stuff it needs has been loaded.

To add functions to a brick, just add functions to the module the normal way. They will work from eachother.
Baseplate handles requires for you, so you don't need to worry about any recursive requiring.

Feel free to look through the code of each core brick as you need them to learn how to use them. Documentation is going to come soon.

************************************************************************************
** HOW DO I CONTRIBUTE? ************************************************************
************************************************************************************
To contribute to Contribengine, all you need to do is make a brick and share it with others!

By expanding the library of Contribengine, you make it more usable for other people.

************************************************************************************
** CONTRIBENGINE IS OPEN SOURCE ****************************************************
************************************************************************************
Contribengine prides itself in being completely open source and forkable.
Please take the time to report bugs to jahoobas if found.

Jahoobas is currently working on this project solo. So it would be very helpful for you to suggest things, help fix bugs, and contribute.
]]
