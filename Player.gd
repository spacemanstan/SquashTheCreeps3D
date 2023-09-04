extends CharacterBody3D

# fast as fuck boi
@export var speed = 13 # m/s

# guavatee
@export var gravity = 75 # m/s^2

# Vertical impulse applied to the character upon jumping in meters per second.
@export var jump_impulse = 20 # m/s

# Vertical impulse applied to the character upon bouncing over a mob in
@export var bounce_impulse = 16 # m/s

var target_velocity = Vector3.ZERO

# used for jump delay
var can_jump = true

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

	# Jumping.
	if is_on_floor() and Input.is_action_pressed("move_jump") and can_jump:
		target_velocity.y = jump_impulse
		can_jump = false
		$JumpDelay.start()

	# iterate through all collisions this frame
	for index in range(get_slide_collision_count()):
		# get collision
		var collision = get_slide_collision(index)

#		# ground collision
		if (collision.get_collider() == null):
			if can_jump:
				$JumpDelay.start() # Start the timer only if can_jump is true
			can_jump = false
			continue # early exit for prevention again null indexing 

		# The collision normal is a 3D vector that is perpendicular to the plane where the collision occurred
		# For dot products, result greater than 0 means two vectors are at an angle of fewer than 90 degrees.

		if collision.get_collider().is_in_group("mob"):
			# who did we hit
			var victim = collision.get_collider()
			# death from above
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				# squash
				victim.squash()
				target_velocity.y = bounce_impulse
				can_jump = true
				$JumpDelay.stop()

	# move character
	velocity = target_velocity

	move_and_slide()

# re-enable jump on delay timer
func _on_jump_delay_timeout():
	can_jump = true
