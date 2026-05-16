extends Node
class_name DemandSystem

# DemandSystemSingleton drives customer orders using weighted demand sampling.
@export var min_delay: float = 2.0
@export var max_delay: float = 4.0
@export var weight_decay_rate: float = 0.01
@export var min_weight: float = 1.0

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var _store_system: StoreSystem = StoreSystemSingleton
@onready var _order_system: OrderSystem = OrderSystemSingleton

func _ready() -> void:
	rng.randomize()
	call_deferred("_start_demand_loop")

func _start_demand_loop() -> void:
	if _store_system == null or _order_system == null:
		push_warning("DemandSystemSingleton: StoreSystemSingleton or OrderSystemSingleton missing")
		return
	_spawn_loop()

func _spawn_loop() -> void:
	var delay: float = rng.randf_range(min_delay, max_delay)
	var timer: SceneTreeTimer = get_tree().create_timer(delay)
	timer.timeout.connect(func() -> void:
		_spawn_order()
		_decay_demand_weights()
		_spawn_loop()
	)

func _spawn_order() -> void:
	var entries: Array[StoreItemEntry] = _store_system.get_catalog_entries()
	if entries.is_empty():
		return
	var total_weight: float = 0.0
	for entry in entries:
		total_weight += max(min_weight, entry.demand_weight)
	if total_weight <= 0.0:
		total_weight = float(entries.size())
	var roll: float = rng.randf_range(0.0, total_weight)
	var cumulative: float = 0.0
	var chosen: StoreItemEntry = entries[0]
	for entry in entries:
		cumulative += max(min_weight, entry.demand_weight)
		if roll <= cumulative:
			chosen = entry
			break
	chosen.demand_weight *= 1.2 # Hardcoded modifier: AI-visible sale boost (+20%).
	_order_system.create_order(str(chosen.id))

func _decay_demand_weights() -> void:
	for entry in _store_system.get_catalog_entries():
		entry.demand_weight = max(min_weight, entry.demand_weight * (1.0 - weight_decay_rate))
