extends Node

# export to inspector to assign monsters 
@export var mob_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$UI/Retry.hide()


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
	var player_position = Vector3.ZERO
	
	if $Player != null:
		player_position = $Player.position 

	# initialize mob
	mob.initialize(mob_spawn_location.position, player_position)

	# add mob as child
	add_child(mob)

	# connect mob to score via squash to update score
	mob.squashed.connect($UI/ScoreLabel._on_mob_squashed.bind())


func _on_player_hit():
	$MobTimerWindDown.start()

func _on_mob_timer_wind_down_timeout():
	$MobTImer.stop()
	$UI/Retry.show()

func _input(event):
	if event is InputEventKey and $UI/Retry.visible:
		# This restarts the current scene.
		get_tree().reload_current_scene()
