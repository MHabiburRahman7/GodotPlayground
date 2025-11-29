extends CharacterBody2D

@export var move_speed: float = 40.0
@export var move_time: float = 1.5   # seconds to walk
@export var idle_time: float = 2.0   # seconds to idle
@export var directions := [
	Vector2.LEFT,
	Vector2.RIGHT,
	Vector2.UP,
	Vector2.DOWN
]

var timer := 0.0
var state := "idle"
var dir := Vector2.ZERO

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")


func _ready():
	animation_tree.active = true
	_enter_idle_state()


func _physics_process(delta):
	timer -= delta

	match state:
		"idle":
			if timer <= 0:
				_enter_walk_state()

		"walk":
			velocity = dir * move_speed
			move_and_slide()

			if timer <= 0:
				_enter_idle_state()

	_update_animation()
	_update_flip()


func _enter_idle_state():
	state = "idle"
	dir = Vector2.ZERO
	velocity = Vector2.ZERO
	timer = idle_time


func _enter_walk_state():
	state = "walk"
	timer = move_time

	# pick random direction
	dir = directions[randi() % directions.size()]


func _update_animation():
	if state == "walk":
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")


func _update_flip():
	# flip the sprite horizontally if moving left/right
	var sprite = $Sprite2D  # or whatever node the visual is under AnimationTree
	if dir.x < 0:
		sprite.flip_h = true
	elif dir.x > 0:
		sprite.flip_h = false
