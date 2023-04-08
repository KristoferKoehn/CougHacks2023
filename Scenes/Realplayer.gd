extends CharacterBody3D
@onready var spring_arm_pivot = $SpringArmPivot
@onready var spring_arm = $SpringArmPivot/SpringArm3D
@onready var face = $fuck
@onready var indicator = $Indicator
@onready var aimer = $fuck/fishingaimer
@onready var mainCam = $SpringArmPivot/SpringArm3D/Camera3D
@onready var indicatorCam = $Indicator/IndicatorCam
@onready var pole = $fuck/Skeleton3D/BoneAttachment3D/fishing_pole
@onready var hat1 = $fuck/Skeleton3D/BoneAttachment3D2/foxydad
@onready var hat2 = $fuck/Skeleton3D/BoneAttachment3D2/theone
@onready var hat3 = $fuck/Skeleton3D/BoneAttachment3D2/thejohnson



var lure = preload("res://Scenes/hook.tscn")
var input_dir_lure 
var baitX
var baitY
var castState = 0
var bait
var hatcount = 0


#@onready var default_pos = get_position()

const sensitivity = 0.004

const AMPLITUDE = 0.2
const FREQUENCY = 1
var time = 0;


const SPEED = 45.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if event is InputEventMouseMotion:
		spring_arm_pivot.rotate_y(-event.relative.x*sensitivity)
		spring_arm.rotate_x(-event.relative.y*sensitivity)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)

func playerMovement():
	# Add the gravity.
	if not is_on_floor():
		pass
		#velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP,spring_arm_pivot.rotation.y)
	face.rotation.y=spring_arm_pivot.rotation.y
	#aimer.rotation.y=spring_arm_pivot.rotation.y
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)


	
	position.y = 0.5 + sin(time * FREQUENCY) * AMPLITUDE
	#print(sin(time * FREQUENCY)* AMPLITUDE)
	#print(aimer.get_collision_point())

func _physics_process(delta):
	if castState == 0:
		playerMovement()
	indicator.global_position = aimer.get_collision_point()
	time += delta
	
	if Input.is_action_just_pressed("cast_line"):
		bait = lure.instantiate()
		add_child(bait)
		
		if castState == 0 :
			bait.global_position = indicator.global_position
			baitX = indicator.global_position.x
			baitY = indicator.global_position.y
		castState = 1
		indicator.visible = false
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		indicatorCam.set_current(not indicatorCam.current)
		
		
	input_dir_lure = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	if castState == 1:
		bait.global_position.z += input_dir_lure[1]*0.005
		bait.global_position.x += input_dir_lure[0]*0.005
		
	
	if Input.is_action_just_pressed("return_line") and castState == 1:
		castState = 0
		bait.queue_free()
		indicator.visible = true
		mainCam.set_current(not mainCam.current)

	if Input.is_action_just_pressed("hatremove"):
		hat1.visible = false
		hat2.visible = false
		hat3.visible = false
		hatcount = 0
	if Input.is_action_just_pressed("hatchange"):
		hatcount += 1
		if hatcount ==1 :
			hat1.visible = true
			hat2.visible = false
			hat3.visible = false
		if hatcount ==2 :
			hat1.visible = false
			hat2.visible = true
			hat3.visible = false
		if hatcount ==3 :
			hat1.visible = false
			hat2.visible = false
			hat3.visible = true
		if hatcount ==4 :
			hatcount = 0
	
	move_and_slide()
