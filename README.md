Tile-Cutter (by Jeff LaMarche)
=================

Tile Cutter is an open source under the non-viral MIT license.    
Tile Cutter will take a large image and split it up into smaller tiles. I created this for use in a CATiledLayer-backed view for an iPad application, but it could be used for a number of other purposes.


This Fork (by Stepan Generalov)
================

In this fork of Tile Cutter there was added some things:

1. Plist file, that have info about tiles position and source image size.
2. Skipping of absolutely transparent tiles
3. Command Line Tool

There's some minor issues in this fork, that i probably will not fix, cause everything is working fine for me now:

1. You can't choose other than PNG file type in commandLine tool.
2. You can't set suffix in GUI.
3. There's no progressBar in commandLine tool. Here's a link, that maybe can help you with implementing non-duplicating progress bar: http://en.wikipedia.org/wiki/ANSI_escape_code

If you're using Tile-Cutter and experiencing some issues - feel free to open new Issues or Pull Requests in this Repo.


