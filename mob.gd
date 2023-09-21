extends CharacterBody3D

# Emitted when the player jumped on the mob.
signal squashed

# min + max speed in m/s
@export var min_speed = 10
@export var max_speed = 18

func squash():
	squashed.emit()
	queue_free()

# update the node every frame
func _physics_process(_delta):
	move_and_slide()

# This function will be called from the Main scene.
func initialize(start_position, player_position):
	# We position the mob by placing it at start_position
	# and rotate it towards player_position, so it looks at the player.
	
	# player pos without y so ensure same level 
	var player_position_level_y = player_position
	player_position_level_y.y = start_position.y
	
	look_at_from_position(start_position, player_position_level_y, Vector3.UP)
	# Rotate this mob randomly within range of -90 and +90 degrees,
	# so that it doesn't move directly towards the player.
	rotate_y(randf_range(-PI / 4, PI / 4))

	# We calculate a random speed (integer)
	var random_speed = randi_range(min_speed, max_speed)
	# We calculate a forward velocity that represents the speed.
	velocity = Vector3.FORWARD * random_speed
	# We then rotate the velocity vector based on the mob's Y rotation
	# in order to move in the direction the mob is looking.
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	
	$Animation.speed_scale = random_speed / min_speed

func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free() # destroy instance
