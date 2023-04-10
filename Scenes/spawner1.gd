extends Node3D
var fish_wun_scene = preload("res://Scenes/fish_wun.tscn")
var fish_too_scene = preload("res://Scenes/fish_too.tscn")
var fish_alfred_scene = preload("res://Scenes/fish_alfred.tscn")
@onready var timer = $Timer
var fish

var fish_count : int = 0

signal fish_added(fish)

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.connect("timeout", spawner)

func spawner():
	var fishnum = randi_range(0,2)
	fish_count += 1
	if fishnum == 0:
		fish = fish_wun_scene.instantiate()
		fish.scale /= randf_range(2,4)
		print("Fish Count: " + str(fish_count) + " - fish_wun added")
	if fishnum == 1:
		fish = fish_too_scene.instantiate()
		fish.scale /= randf_range(3,5)
		print("Fish Count: " + str(fish_count) + " - fish_too added")
	if fishnum == 2:
		fish = fish_alfred_scene.instantiate()
		fish.scale /= randf_range(4,5)
		print("Fish Count: " + str(fish_count) + " - fish_alfred added")
	add_child(fish)
	fish.global_position = Vector3(randf_range(-100,100),0,randf_range(-100,100)) 
	emit_signal("fish_added", fish)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

