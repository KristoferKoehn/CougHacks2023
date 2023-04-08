extends CharacterBody3D
@onready var spring_arm_pivot = $SpringArmPivot
@onready var spring_arm = $SpringArmPivot/SpringArm3D
@onready var armature = $Armature
@onready var antree = $AnimationTree
@onready var facing = $SpringArmPivot/SpringArm3D/RayCastFacing

@onready var tracker = $Armature/Skeleton3D/BoneAttachment3D/tracker
var link = preload("res://experimental/linker.tscn")
var link_spawned = 0
var linked

var BRAKE
const SPEED = 16.0
const JUMP_VELOCITY = 15.0
const LERP_VAL = 0.15
const hover = 5
const hover_in_place = 9.8
const ramp_up = 0.15

const airfriction = 0.005
const groundfriction = 3

#jump and shunt handling values
var shunttimer = 0 
var shuntstate = 0
var jumptimer = 0
var jumpstate = 0
var boosttimer = 0 
var booststate = 0
var shuntx = 0 
var shuntz = 0

var DASH = 120
var DASHSPEED = 0
var BOOST = 1
var BOOSTMAX = 5
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var strafe_dir = Vector3.ZERO
var strafe = Vector3.ZERO
#shoulder joint angle variables
var yarmangle = Vector3()
var xarmangle = Vector3()
var skel

const mouse = 0.005

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	skel = get_node("Armature/Skeleton3D")
	
	
func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if event is InputEventMouseMotion:
		spring_arm_pivot.rotate_y(-event.relative.x*mouse)
		spring_arm.rotate_x(-event.relative.y*mouse)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)

func animation_handler():
	if BOOST == BOOSTMAX:
		antree.set("parameters/boostgrid/blend_position",Vector2(strafe_dir.x,-strafe_dir.z))		
	if BOOST == 1:
		antree.set("parameters/walkgrid/blend_position",Vector2(strafe_dir.x,-strafe_dir.z))
	
	if Input.is_action_pressed("rightclick"):
		antree.set("parameters/shootingwalkingright/blend_amount",1)
		antree.set("parameters/shootingboostingright/blend_amount",1)
		armature.rotation.y = spring_arm_pivot.rotation.y
	else:
		antree.set("parameters/shootingwalkingright/blend_amount",0)
		antree.set("parameters/shootingboostingright/blend_amount",0)
		armature.rotation.y = spring_arm_pivot.rotation.y
	if Input.is_action_pressed("leftclick"):
		antree.set("parameters/shootingwalkingleft/blend_amount",1)
		antree.set("parameters/shootingboostingleft/blend_amount",1)
	else:
		antree.set("parameters/shootingwalkingleft/blend_amount",0)
		antree.set("parameters/shootingboostingleft/blend_amount",0)
		
func boost_handler():
	if Input.is_action_pressed("boost"):
		BOOST = BOOST + ramp_up
		if BOOST > BOOSTMAX:
			BOOST = BOOSTMAX
		antree.set("parameters/boosthandler/blend_amount",BOOST/BOOSTMAX)

	if not Input.is_action_pressed("boost"):
		BOOST = BOOST - (ramp_up*3)
		if BOOST < 1.0 :
			BOOST = 1.0
		antree.set("parameters/boosthandler/blend_amount",(1-(1/BOOST)))
	
func shunt_handler():
	jumptimer += 1
	shunttimer += 1
	if jumptimer > 60 :
		jumptimer = 0 
		jumpstate = 0
	if shunttimer > 20 :
		shunttimer = 0
		shuntstate = 0
	if shuntstate == 1 and shuntstate != 2: 
		shunttimer = 0 
		shuntstate = 2
	if shuntstate ==2 and shuntstate != 1:
		DASHSPEED += 0.0667*DASH
		if shunttimer > 15:
			DASHSPEED -= 0.2*DASH
		if shunttimer == 20:
			shuntstate = 0
			DASHSPEED = 0
			shuntx = 0 
			shuntz = 0
	if Input.is_action_just_pressed("ui_accept") and shuntstate != 1 and shuntstate != 2:
		shuntstate = 1
		if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			shuntx = 1
		if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
			shuntz = 1
	
func momentum_handler(direction,input):
	if is_on_floor():
		BRAKE = groundfriction
	else:
		BRAKE = airfriction
	if direction:
		velocity.x = (direction.x * SPEED*BOOST) + (direction.x*DASHSPEED)
		velocity.z = (direction.z * SPEED*BOOST) + (direction.z*DASHSPEED)
		armature.rotation.y = spring_arm_pivot.rotation.y
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, BRAKE)
			velocity.z = move_toward(velocity.z, 0, BRAKE)
		else:
			velocity.x = velocity.x - (airfriction*velocity.x)
			velocity.z = velocity.z - (airfriction*velocity.z)
	
	
func shooting_handler():

	if Input.is_action_just_pressed("leftclick"):
		print("BANG")
	
func part_handler():
	if link_spawned==0:
		linked = link.instantiate()
		add_child(linked)
		print(linked.position)
		link_spawned=1
	linked.set_global_position(tracker.global_position)
	linked.set_global_rotation(armature.global_rotation)

	print(tracker.global_rotation.z)


func _physics_process(delta):
	
	shooting_handler()
	
	if not is_on_floor():
		velocity.y -= gravity * delta
		if Input.is_action_pressed("boost"):
			velocity.y += hover * delta
		if Input.is_action_pressed("boost") and not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_up") and not Input.is_action_pressed("ui_down"):
			velocity.y += hover_in_place * delta
			
	if is_on_floor() and Input.is_action_just_pressed("boost"):
		jumpstate +=1
	if jumpstate > 1:
		velocity.y = JUMP_VELOCITY
		jumpstate = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	strafe_dir = (transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	direction = direction.rotated(Vector3.UP,spring_arm_pivot.rotation.y)
	rotation.y = spring_arm_pivot.rotation.y
	
	part_handler()
	
	momentum_handler(direction,input_dir)
	animation_handler()
	boost_handler()
	shunt_handler()
	if not is_on_floor():
		antree.set("parameters/boosthandler/blend_amount",1)
	
	move_and_slide()
