extends Node3D
var fish_wun_scene = preload("res://Scenes/fish_wun.tscn")
var fish_too_scene = preload("res://Scenes/fish_too.tscn")
var fish_alfred_scene = preload("res://Scenes/fish_alfred.tscn")
var fish
var timer = 0

signal fish_added(fish)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func spawner():
	var fishnum = randi_range(0,2)
	if fishnum == 0:
		fish = fish_wun_scene.instantiate()
		fish.scale /= randf_range(2,4)
	if fishnum == 1:
		fish = fish_too_scene.instantiate()
		fish.scale /= randf_range(3,5)
	if fishnum == 2:
		fish = fish_alfred_scene.instantiate()
		fish.scale /= randf_range(4,5)
	add_child(fish)
	emit_signal("fish_added", fish)
	fish.global_position = Vector3(randf_range(-100,100),0,randf_range(-100,100)) 
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(delta)
	timer += 1
	if timer == 600:
		timer = 0
		spawner()

