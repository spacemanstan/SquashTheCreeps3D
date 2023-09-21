extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector3(-25, 1, 0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.x < 50 :
		position.x += 0.1
	else :
		position.x = -15
	pass
