extends CharacterBody3D


const SPEED = 2.0
const JUMP_VELOCITY = 4.5
const TRACK_DIST = 5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var armature = $Armature
@onready var timer = $Timer
#@onready var lure = get_parent().get_parent().get_node("hook/balls")

#@onready var lure := get_tree().get_root().get_scene("hook").get_node("balls")

var rng = RandomNumberGenerator.new()

var y_upper = 0
var y_lower = -43

var x_upper = 100
var x_lower = -100

var z_upper = 100
var z_lower = -100


func _ready():
	timer.connect("timeout", move)
	timer.wait_time = 1
	set_rand_vel()

func move():
	# get the poisiton of the lure
	#var lure_pos = lure.global_position
	#var error  = lure_pos-global_position
	#var motionVec = (error).normalized() # find the direction of motion of the fish to approach the lure

	#if (error.length() < TRACK_DIST): # if the distance toi the llure is less than the track threshold, trck
		#velocity.x = motionVec.x * SPEED
		#velocity.y = motionVec.y * SPEED
		#velocity.y = motionVec.y * SPEED
	#else:
	set_rand_vel() # no lure in range, so random movements




func set_rand_vel():
	if(global_position.y >= 0):
		velocity.y = rng.randi_range(-3, -1) * SPEED
	elif(global_position.y <= -40):
		velocity.y = rng.randi_range(0, 5) * SPEED
	else:
		velocity.y = rng.randi_range(-5, 5) * SPEED


	if(global_position.x >= 100):
			velocity.x = rng.randi_range(-3, 0) * SPEED
	elif(global_position.x <= -100):
		velocity.x = rng.randi_range(0, 5) * SPEED
	else:
		velocity.x = rng.randi_range(-5, 5) * SPEED


	if(global_position.z >= 100):
		velocity.z = rng.randi_range(-3, 0) * SPEED
	elif(global_position.z <= -100):
		velocity.z = rng.randi_range(0, 5) * SPEED
	else:
		velocity.z = rng.randi_range(-5, 5) * SPEED
	
	#velocity.z = rng.randi_range(-5, 5) * SPEED
	
	armature.rotation.y = atan(velocity.z / velocity.x)


func isInBounds() -> bool:
	var inBounds = true
	if(global_position.y > y_upper):
		inBounds = false
	if(global_position.y < y_lower):
		inBounds = false
	
	if(global_position.x > x_upper):
		inBounds = false
	if(global_position.x < x_lower):
		inBounds = false

	if(global_position.z > z_upper):
		inBounds = false
	if(global_position.z < z_lower):
		inBounds = false
	
	return inBounds

func _physics_process(delta):
	if(!isInBounds()):
		set_rand_vel()
	
	move_and_slide()
