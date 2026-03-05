# Dragon Hunter Extreme 🐉

**Dragon Hunter Extreme** is a fast-paced, top-down 2D arcade game built with the **LÖVE (Love2D)** framework and **Lua**. Navigate a beautiful, obstacle-filled terrain to hunt down a legendary dragon. Catch it quickly to maximize your score, but be careful—if you're too slow, the dragon flies away and your score takes a hit!



## 🎮 Gameplay Features

* **Speed-Based Scoring:** Points are calculated based on how fast you reach the dragon ($Points = \lceil Timer \times 20 \rceil$).
* **Intelligent Dragon AI:** The dragon features a state machine with an "Idle" hover animation and a smooth "Flying" transition (Linear Interpolation) when changing positions.
* **Dynamic Visuals ("Juice"):**
    * **Screen Shake:** High-intensity camera jitter on successful catches.
    * **Particle System:** Magical gold dust explosions upon collision.
    * **Flipping Sprites:** Both the player and dragon flip horizontally based on movement direction.
* **Expansive World:** A $1600 \times 896$ pixel world with diverse terrain (Trees and Rocks) and a centered follow-camera.
* **High-Stakes Penalty:** Missing a dragon deducts 20 points. If your score hits zero after your first catch, it's **Game Over**.



## 🛠️ Technical Implementation

### **Modular Architecture**
The project is built using Object-Oriented principles in Lua, utilizing metatables for clean module separation:
* `main.lua`: Manages the game state (START, PLAYING, LOST), camera transformations, and global effects.
* `player.lua`: Handles AABB collision sliding logic and frame-independent movement.
* `dragon.lua`: Manages state transitions (IDLE vs. FLYING) and hover math.
* `map.lua`: Implements a tile-based grid system with auto-scaling assets.

### **Collision & Physics**
The game uses a custom **Sliding Collision** system. By checking $X$ and $Y$ axis collisions independently, the player can glide along obstacles rather than getting "stuck," providing a professional feel to the movement.



## 🚀 Getting Started

### **Prerequisites**
You must have the **LÖVE** engine installed on your system.
* Download it here: [love2d.org](https://love2d.org/)

### **Installation & Running**
1.  Clone the repository:
    ```bash
    git clone [https://github.com/yourusername/dragon-hunter-extreme.git](https://github.com/yourusername/dragon-hunter-extreme.git)
    ```
2.  Navigate to the project folder:
    ```bash
    cd dragon-hunter-extreme
    ```
3.  Run the game:
    ```bash
    love .
    ```

## ⌨️ Controls

| Key | Action |
| :--- | :--- |
| **WASD / Arrows** | Move the Player |
| **Any Movement** | Start the Game (from Start Screen) |
| **R** | Restart Game (on Game Over screen) |

## 🎨 Asset Requirements
The game logic automatically scales assets to fit the **64px** tile size. Ensure the following files are in your root directory:
* `hungry-dino.png` (Player)
* `dragon.png` (Target)
* `grass.png`, `tree.png`, `rock.png` (Environment)

---
Developed as a final-year engineering project focused on game design and Lua-based state management.
