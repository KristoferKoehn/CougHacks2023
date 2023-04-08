extends Node3D

@onready var player = $player
@onready var spawner = $basins/spawner
@onready var scoreLabel = $scoreLabel
@onready var sounds = $sounds
@onready var bite = $sounds/bite
@onready var augh = $aughk

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	spawner.connect("fish_added", _on_fish_added)
	pass # Replace with function body.

func _on_fish_added(fish):
	fish.connect("fish_caught", _on_fish_caught)

func _on_fish_caught(value):
	score = score + value
	scoreLabel.text = "Score: " + str(score)
	bite.play()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sounds.global_position = player.global_position


func _on_timer_timeout():
	augh.play()
	
