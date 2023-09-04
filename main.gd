extends Node

# export to inspector to assign monsters 
@export var mob_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_mob_t_imer_timeout():
	# instansiate mob scene
	var mob = mob_scene.instantiate()

	# sample random position on spawn path 
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	
	# random offset, progress ratio is a part of PathFollow3D
	mob_spawn_location.progress_ratio = randf()

	# get player pos
	var player_position = $Player.position if $Player != null else  Vector3.ZERO

	# initialize mob
	mob.initialize(mob_spawn_location.position, player_position)

	# add mob as child
	add_child(mob)


func _on_player_hit():
	$MobTimerWindDown.start()

func _on_mob_timer_wind_down_timeout():
	$MobTImer.stop()
