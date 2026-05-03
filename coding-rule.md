# AI Coding Rules – Godot 4 Online Shop Simulator

## 🧠 Project Overview

This project is an offline simulation game built with:
- Godot 4 (GDScript + C# Mono)
- UI-heavy architecture
- Scene-based modular design

Game concept:
A character buys and sells items through an online shop simulation system.

---

# 🧠 Core Architecture Rule

> Scenes = Components  
> Scripts = Logic  
> Signals = Communication  
> Data = Separate Objects  

AI must strictly follow this architecture at all times.

---

# 📁 1. Naming Conventions

## Files
- snake_case.gd
- snake_case.cs

Example:
- shop_controller.gd
- item_data.gd

## Classes (GDScript)
- PascalCase
- Must use `class_name`

```gdscript
class_name ShopController
Functions
snake_case
func calculate_total_price():
Variables
snake_case
var total_price := 0
Constants
const MAX_ITEMS := 100
```

🧱 2. Scene Structure Rule

Each feature must follow this structure:

Feature
├── FeatureView (Control/UI Node)
├── FeatureController (Script)
└── FeatureData (Pure Data Object)

Example:

Shop
├── ShopView
├── ShopController.gd
├── ShopData.gd

🔗 3. Communication Rule (STRICT)
❌ FORBIDDEN
Direct node traversal logic
`get_parent().get_parent()` calls
Cross-scene direct access
✅ REQUIRED: SIGNALS

Child emits signals only:
```gdscript
signal item_bought(data)
```
Parent listens:
```gdscript
child.item_bought.connect(_on_item_bought)
```
Rule:

Child NEVER knows parent. Parent controls orchestration.

📦 4. Data Rule (No Raw Dictionaries)
❌ Forbidden
```gdscript
var item = {
    "name": "Book",
    "price": 10
}
```
✅ Required: Data Classes
```gdscript
class_name ItemData

var name: String
var price: float
var quantity: int
```

🧩 5. UI Rule
UI MUST NOT contain business logic
✅ Allowed
Emit signals
Handle visual state only
```gdscript
func _on_buy_pressed():
    emit_signal("buy_requested", item_data)
```

❌ Forbidden
Money calculation
Inventory modification
Game logic inside UI scripts

🧠 6. State Management Rule

Use enums for UI states:
```gdscript
enum ViewState {
    LIST,
    FORM,
    DETAIL
}
```

State switching must be centralized:

```gdscript
func set_view(state: ViewState):
    for s in views:
        views[s].visible = (s == state)
```

🧷 7. Node Reference Rule
Preferred: `@export` injection
```gdscript
@export var submit_button: Button
```

Use `@onready` only for fixed internal nodes
```gdscript
@onready var animation_player = $AnimationPlayer
```

⏱️ 8. Lifecycle Rule
❌ Forbidden
Accessing exported node references in `_init()`
✅ Allowed
`_ready()` or `_enter_tree()`

🧮 9. Input Validation Rule

All user input MUST be validated:
```gdscript
if not text.is_valid_float():
    return
```

Never trust raw input conversion.

🔌 10. Responsibility Rule

Each function must do ONE job only.

❌ Bad
validate + update UI + save data in one function
✅ Good
separated private functions:
```gdscript
func process_order():
    if not _is_valid():
        return
    _apply_order()
    _update_ui()
```

🧠 11. Mono (C#) + GDScript Rule
C# (Mono): heavy systems, simulation, logic (not required so far, only used when GDScript is not suitable)
GDScript: UI + scene orchestration, and simple manager logic

Rule:

GDScript can call C#, NOT the reverse (unless explicitly required)

🚫 12. Hard Prohibitions

AI MUST NOT:

Use deep `get_parent()` chains
Put logic inside UI nodes
Use uncontrolled global singletons
Skip input validation
Create overly large scripts (>300 lines without splitting)

🔁 13. Data Flow Rule

Standard flow:

UI → Signal → Controller → Data/System → Back to UI

No direct UI-to-system coupling.

🧠 14. Required Pattern Example
Submit Form
```gdscript
signal submitted(data: ItemData)

func _on_submit_pressed():
    if not price_input.text.is_valid_float():
        return

    var data := ItemData.new()
    data.name = name_input.text
    data.price = float(price_input.text)

    emit_signal("submitted", data)
```

Controller
```gdscript
func _on_form_submitted(data: ItemData):
    inventory.add_item(data)
    view.refresh_list()
```

🔑 Golden Rule
Use signals + data objects. Never directly couple nodes.

This is the most important rule in the entire project.