My tileset — tileset for Godot 4
Made with SimplePixelArt — https://simplepixelart.com/tilesets/editor

1. Copy my-tileset-85_tiles-test-1_tileset.tres and my-tileset-85_tiles-test-1_tileset_32x32.png into your Godot 4 project, in the same folder.
2. Open my-tileset-85_tiles-test-1_tileset.tres — the atlas and the terrain sets are already filled in.
3. Add a TileMapLayer node, assign this TileSet, then paint from the Terrains tab.

Terrains built as "wang16" use Match Sides; "blob47" ones use Match Corners and Sides;
"corner16" ones use Match Corners. Solid tiles carry a collision box on physics layer 0,
and animated tiles play from my-tileset-85_tiles-test-1_tileset_anim.png (atlas source 1).
Move the files apart and Godot will ask you to re-point the texture.
