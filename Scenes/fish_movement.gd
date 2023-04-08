extends CharacterBody3D


const SPEED = 2.0
const JUMP_VELOCITY = 4.5
const TRACK_DIST = 5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var armature = $Armature
@onready var timer = $Timer
@onready var hitbox = $CollisionShape3D

var rng = RandomNumberGenerator.new()

var canSeeHook = false;
var hookRef;

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

	if !canSeeHook:
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
	
	print("howdy")
	
	armature.global_rotation.y = atan(velocity.z / velocity.x)


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


	if canSeeHook:
		if (hookRef != null):

			#look_at(hookRef.global_position)
			var distance = self.global_position - hookRef.global_position
			self.velocity = distance.normalized() * -SPEED
			armature.global_rotation.y = Math.PI - atan(velocity.x / velocity.z)
			move_and_slide()
			return
		else:
			canSeeHook = false;

	if(!isInBounds()):
		set_rand_vel()

	move_and_slide()


func _process(delta):
	pass



func _on_area_3d_area_entered(area):
	if area.get_name() == "hook":
		print("frfr sheesh")
		canSeeHook = true;
		hookRef = area;

