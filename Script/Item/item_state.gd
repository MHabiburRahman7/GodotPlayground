class_name ItemState

# Tracks the runtime state of an item, including quality, condition, and various flags.
var quality: String = "normal"
var condition: float = 1.0
var is_reserved: bool = false

# Flags representing completed item workflows.
# Workflow flags.
var packed: bool = false
var photo_taken: bool = false
var usable: bool = false
var sellable: bool = false
