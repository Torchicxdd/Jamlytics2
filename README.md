# Tropi Quest

A 2D bullet hell shoot-em-up built with [Godot](https://godotengine.org/) for **Jamlytics Jam #2**.

[Play on itch.io](https://torchicxdd.itch.io/tropi-quest)

## Overview

Tropi has escaped the dungeons of Entropy, regaining his true powers. However, he is not out of the woods yet as the Inferno Syndicate is tracking him down on his escape. Tropi, with his powers of **Fury**, **Poise**, and **Flow**, will have to find a way to escape the clutches of his trackers. Will he find a way out of the rain of bullets headed his way or will he have to go right back to the start?

## Controls

### Keyboard

| Action          | Key   |
|-----------------|-------|
| Movement        | Arrow Keys |
| Primary Fire    | Z     |
| Focus           | Shift |
| Pause           | P     |
| Fury Ability    | U     |
| Poise Ability   | I     |
| Flow Ability    | O     |
| All Forms Ability | K   |

### Controller

| Action          | Button |
|-----------------|--------|
| Movement        | D-Pad  |
| Primary Fire    | RT     |
| Focus           | LB     |
| Pause           | Menu   |
| Fury Ability    | X      |
| Poise Ability   | Y      |
| Flow Ability    | B      |
| All Forms Ability | A    |

## Project Structure

```
├── Audio/           # Sound effects (WAV)
├── builds/          # Exported builds (web)
├── Classes/         # Base classes (bullet, enemy, level, shaders)
├── Components/      # Reusable scene components
├── Configs/         # Configuration files
├── Entities/        # Game entities
│   ├── Player/
│   ├── Enemy1/
│   ├── EnemyBullet/
│   ├── Spawner/
│   ├── WaveManager/
│   └── WolfBoss/
├── Globals/         # Autoloaded singletons
│   ├── GameManager
│   ├── AudioManager
│   ├── LevelManager
│   ├── MenuManager
│   ├── SettingsManager
│   └── ...
├── Hud/             # HUD scenes and scripts
├── Stages/          # Scene hierarchy
│   ├── Levels/      # Level1–Level8 + common helpers
│   ├── Main/
│   ├── Menus/
│   └── Common/
└── themes/          # UI themes
```


