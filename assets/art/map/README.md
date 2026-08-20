# Dungeon Map Concepts

This directory contains the visual reference for the active Level 1 floor mask.
The image is concept art; explicit valid and void coordinates in `Board` remain
authoritative for gameplay.

## Default Level

- `level-1-winding-cavern.png`: the default Level 1 reference, with an S-shaped
  route, central void, curved silhouette, and broad tactical spaces.
- `level-1-floor-texture.png`: the production blue-gray stone texture displayed
  beneath the Level 1 grid. `BoardView` clips it to authoritative walkable cells,
  so artwork and movement rules cannot disagree.

## Shared Generation Brief

Top-down polished 2D dungeon concept art for a grid-based Godot game, using a
12-column by 8-row logical footprint, clearly readable stone tiles, connected
walkable space, substantial non-walkable void zones, curved boundaries, no
characters, no labels, no UI, and no watermark.
