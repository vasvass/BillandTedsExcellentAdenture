# Bill & Ted's Excellent Adventure — iOS Platformer

A 2D side-scrolling platformer for iOS, inspired by the 1989 film *Bill & Ted's Excellent Adventure*. Play as Bill S. Preston, Esq. or Ted "Theodore" Logan as they travel through time in a phone booth, encounter historical figures, and learn about history along the way.

---

## Concept

Bill and Ted must collect historical figures across different eras to complete their history report — or face most egregious consequences. Traverse iconic time periods, solve era-specific challenges, and guide legendary figures back to the phone booth.

---

## Characters

### Bill S. Preston, Esq.
- Higher jump height — suited for vertical platforming challenges
- Special ability: **Air Guitar Shred** — stuns nearby enemies with a sonic wave
- Best for: elevated platforms, aerial traversal, musical encounters

### Ted "Theodore" Logan
- Higher run speed — suited for horizontal chase sequences
- Special ability: **Bogus Distraction** — confuses enemies, creating an opening to escape or collect items
- Best for: fast-paced runs, stealth sections, evasion encounters

### Character Switching
Players start by selecting one character at the main menu. At designated **Phone Booth Checkpoints** within each level, switching is available. Certain encounters and puzzles are tuned for a specific character, encouraging players to think ahead and plan their swap.

---

## Time Periods & Levels

| Era | Setting | Historical Figure | Challenge Type |
|-----|---------|-------------------|----------------|
| Ancient Greece (410 BC) | Athens agora & acropolis | Socrates | Philosophical riddle platforming |
| Medieval England (1305) | Castle & jousting grounds | Billy the Kid (anachronism) | Combat & evasion |
| The Mongol Empire (1209) | Steppe camps & fortresses | Genghis Khan | Chase sequence |
| The Old West (1879) | Desert canyons & saloons | Billy the Kid | Stealth & retrieval |
| Ancient Egypt (3000 BC) | Pyramids & sand dunes | Napoleon Bonaparte (anachronism) | Puzzle platforming |
| The French Revolution (1789) | Paris streets & palace | Joan of Arc | Rescue mission |
| The Future (2691) | Neo-San Dimas | Station | Boss encounter |

Each era has a distinct visual palette, ambient sound design, and era-appropriate enemy types (guards, soldiers, creatures).

---

## Gameplay Loop

1. **Start at San Dimas High School** — receive the history report assignment
2. **Enter the Phone Booth** — select a time destination
3. **Explore the era** — platform through the environment, avoid hazards, defeat or evade enemies
4. **Find the Historical Figure** — complete the era's main challenge to convince them to join
5. **Return to the Phone Booth** — advance to the next era or collect optional bonus items
6. **Boss / Final Act** — defeat Rufus's adversary and present the report

---

## Controls

| Action | Control |
|--------|---------|
| Move | D-pad / swipe |
| Jump | Jump button / tap |
| Double Jump | Second tap mid-air |
| Special Ability | Ability button (hold for charged version) |
| Switch Character | Phone Booth Checkpoint only |
| Interact / Collect | Proximity-based auto-collect + confirm button |
| Pause | Pause button |

---

## Audio

- **Background Music**: Driving rock tracks with a late-80s / early-90s feel — guitar-forward instrumentals that shift subtly per era (electric guitar for modern eras, period-adjacent instrumentation for ancient ones)
- **SFX**: Exaggerated comic sound effects for jumps, hits, special abilities, and phone booth travel
- **Voice Lines**: Short character quips triggered by key events ("Be excellent!", "Station!", "Bogus!")

---

## Technical Stack

| Component | Technology |
|-----------|-----------|
| Platform | iOS |
| Language | Swift |
| Game Engine | SpriteKit |
| Entity System | GameplayKit |
| Physics | SpriteKit Physics Engine |
| Audio | AVFoundation / SpriteKit Audio Nodes |
| Persistence | UserDefaults (progress) |

---

## Project Structure

```
BillandTedsExcellentAdventure/
├── Scenes/
│   ├── MenuScene.swift          — Main menu & character select
│   ├── GameScene.swift          — Core gameplay scene
│   ├── HUDScene.swift           — Heads-up display overlay
│   └── TransitionScene.swift    — Phone booth time travel transitions
├── Entities/
│   ├── PlayerEntity.swift       — Shared player base
│   ├── BillEntity.swift         — Bill-specific stats & abilities
│   ├── TedEntity.swift          — Ted-specific stats & abilities
│   ├── HistoricalFigure.swift   — NPC collectible entities
│   └── EnemyEntity.swift        — Era-specific enemies
├── Components/
│   ├── MovementComponent.swift
│   ├── PhysicsComponent.swift
│   ├── AnimationComponent.swift
│   └── AbilityComponent.swift
├── Levels/
│   ├── LevelLoader.swift        — Loads .sks level files
│   └── *.sks                    — One scene file per era
├── Audio/
│   ├── AudioManager.swift
│   └── *.mp3 / *.wav            — Music & SFX assets
└── Assets.xcassets/             — Sprites, backgrounds, UI art
```

---

## Roadmap

- [x] Project scaffolding (SpriteKit + GameplayKit)
- [ ] Main menu & character selection screen
- [ ] Core platformer mechanics (move, jump, double-jump)
- [ ] Bill & Ted entities with distinct stats
- [ ] Character switching at phone booth checkpoints
- [ ] Era 1: Ancient Greece level
- [ ] Era 2: Medieval England level
- [ ] Remaining eras
- [ ] Boss encounter (Future era)
- [ ] Audio system & rock soundtrack integration
- [ ] Historical figure dialogue / trivia popups
- [ ] Game Center leaderboards & achievements
- [ ] Polish pass (particles, screen transitions, juice)

---

*Be excellent to each other — and to your code.*
=======
