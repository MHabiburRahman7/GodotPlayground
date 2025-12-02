extends Node

@export var player: CharacterBody2D
@export var start_map: PackedScene      # assign e.g., OutsideHouse.tscn in editor
@export var start_spawn_name: String = "SpawnPoint"

var current_map: Node = null

#func _ready():	
	#if not player:
		#player = $Player
#
	#if start_map:
		#load_world(start_map, start_spawn_name)

## ----------------------------
#func load_world(map_scene: PackedScene, spawn_name: String):
	## Remove old map
	#if current_map:
		#print("currently contains : ", current_map.name, " and removing it")
		#current_map.queue_free()
		#current_map = null
#
	## Instantiate new map
	#current_map = map_scene.instantiate()
	#$MapHolder.add_child(current_map)
	#print("Attempting to instantiate:", current_map.name, " spawn_name ", spawn_name)
	#
	## Disable doors while moving player
	#for door in current_map.get_tree().get_nodes_in_group("doors"):
		#door.monitoring = false
#
	## Move player to spawn point FIRST
	#var spawn = current_map.get_node_or_null(spawn_name)
	#if spawn:
		#print("Spawning : ", player.name)
		#player.global_position = spawn.global_position
	#else:
		#print("Spawn point not found:", spawn_name)
#
	## Enable all doors AFTER player is positioned
	#for door in current_map.get_tree().get_nodes_in_group("doors"):
		#door.enable_door()
