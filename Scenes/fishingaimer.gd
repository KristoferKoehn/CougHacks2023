extends RayCast3D
var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("rod_out"):
		rotation.x += 0.02
		print(rotation.x)
		if rotation.x > 1.3 :
			rotation.x = 1.3
	if Input.is_action_pressed("rod_in"):
		rotation.x -= 0.02
		print(rotation.x)
		if rotation.x < 0.3 :
			rotation.x = 0.3
