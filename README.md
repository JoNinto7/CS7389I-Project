# Drift: A Motion-Driven Radial Menu System for Stationary VR

This project implements a motion-based radial menu system for stationary VR using controller-relative input. Users interact through flicking, tilting, and smooth directional motions to trigger spatial menu actions. The system is built in Godot and uses Godot XR Tools for pickup and snap functionality.

---

## Project Overview

A custom interaction system for stationary VR enabling fast, orientation-agnostic menu navigation using:

- **Flicking** – Quick wrist-based directional motions
- **Tilting** – Sustained wrist orientation toward directional targets
- **Smooth Motioning** – Gradual controller movement across space

The radial menu appears at the controller, follows its position, and remains stable regardless of rotation or user view direction.

---

## Features

- Controller-relative motion recognition (local-space velocity and tilt)
- Directional menu selection with flicks, tilts, or smooth motions
- Four-option radial menu: Restart, Exit, Instructions, Back
- Menu triggered by controller button press and confirmed on grip release
- Diegetic in-world 3D UI — no raycasting or screen-space UI
- Built-in completion detection using snap zones

---

## Puzzle Environment

A small VR scene with interactive object placement:

- Players assemble a board using miniature props: table, chair, bed, carpet, drawer, lamp
- Objects snap to target locations using Godot XR Tools’ SnapZone system
- Completion updates an in-world label and allows restart or exit through the menu

---

## Dependencies

- [Godot XR Tools (v4.4.0)](https://godotengine.org/asset-library/asset/1698) – MIT License  
- [KayKit: Furniture Bits](https://kaylousberg.com) – Creative Commons Zero (CC0) License

---

## Setup Instructions

1. Clone or download the repository
2. Open the project in Godot 4.3 or newer
3. Enable the OpenXR plugin in project settings
4. Launch `main.tscn` with a compatible VR headset connected

---

## License and Credits

- Motion-based control logic and radial menu implementation are original
- Uses publicly licensed assets and tools listed above
- This project is intended for educational and experimental purposes
