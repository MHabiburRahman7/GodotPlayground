extends Area2D

@export var target_scene: String       # e.g., InsideHouse.tscn
@export var spawn_location: String

func _ready():
	# Doors are initially disabled to prevent immediate trigger
	monitoring = false
	# Add to doors group for optional control
	add_to_group("doors")
	#if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		#connect("body_entered", Callable(self, "_on_body_entered"))

#func _on_body_entered(body):
	##var sender = get_sender()
	##print("Signal came from:", sender.name)
	#
	#if body == MainGame.player:
		#print("Player entered door! Location:", spawn_location)
		#MainGame.load_world(target_scene, spawn_location)
