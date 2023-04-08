extends Node3D
var link = preload("res://Scenes/fish_wun.tscn")
var fish
var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func spawner():
	fish = link.instantiate()
	add_child(fish)
	fish.global_position = Vector3(randf_range(-100,100),0,randf_range(-100,100)) 
	fish.scale /= randf_range(2,4)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(delta)
	timer += 1
	if timer == 600:
		timer = 0
		spawner()

