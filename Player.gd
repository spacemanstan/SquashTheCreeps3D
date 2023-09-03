extends CharacterBody3D

# fast as fuck boi
var speed = 13

# guavatee
var gravity = 75

var target_velocity = Vector3.ZERO

# update the node every frame
func _physics_process(delta):
	# local var for input direction
	var direction = Vector3.ZERO

	# updated direction based on input
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_backward"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1

	# normalize updated direction
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(position + direction, Vector3.UP)

	# Ground velocity 
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Gravity (vertical velocity)
	if not is_on_floor():
		# `delta` represents the time in seconds since the last frame, ensuring frame rate-independent game logic.
		target_velocity.y = target_velocity.y - (gravity * delta)

	# move character
	velocity = target_velocity
	move_and_slide()
