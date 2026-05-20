extends Node3D

@export var stick_sensitivity := 120.0 # degrees per second
@export var stick_deadzone := 0.15
@export var mouse_sensitivity := 0.05

@onready var camera = $SpringArm3D/Camera3D
@onready var player = $".."
@onready var targetTriangle = $"../triangleTarget/SubViewport/combatTriangle"

var lockOff = false
var lockedOn = false

var isLockedOn = false

var distanceToEnemy = 100
var monsterToLockOn

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# checks for locking on when pressing shift
	#if Input.is_action_just_pressed("ui_q"):
	#	$"../../playerAnimator".play("moveCamera")
	
	if Input.is_action_just_pressed("ui_q") && isLockedOn == false:
		isLockedOn = true
		targetTriangle.active = true
	elif Input.is_action_just_pressed("ui_q") && isLockedOn:
		lockOff = false
		lockedOn = false
		isLockedOn = false
		targetTriangle.active = false
		_locked_off()
	
	if isLockedOn:
		_lock_on()
	
	# Makes sure that if force locked off, it won't auto lock on if you continue to hold the lock on button
	
	
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	_handle_gamepad_view(delta)


func _unhandled_input(event):
	# basic mouse - camera functionality
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == 2 and lockedOn == false:
		rotation_degrees.x -= event.relative.y * mouse_sensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, -90.0, 30.0)
		
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)
		

func _lock_on():
	
	# OH MY GOD PLEASE PLEASE CLAMP THE SPRING ARM FOR LOCKING ON I THINK IT MIGHT FIX LIKE ALL OUR PROBLEMS
	
	
	# all of the lock on varaibles and functions
	
	lockedOn = true
	
	
	var enemy = get_tree().get_nodes_in_group("enemies")
	
	
	# checks the distance to all enemies in the enemies group and returns the enemy that is closest
	for monster in enemy:
		if distanceToEnemy > player.global_position.distance_to(monster.global_position):
			distanceToEnemy = self.global_position.distance_to(monster.global_position)
			monsterToLockOn = monster
			#print(monsterToLockOn)
	
	# locks on to the monster returned from the last loop
	if not monsterToLockOn == null:
		if camera.is_position_in_frustum(monsterToLockOn.global_position):
			camera.look_at(monsterToLockOn.global_position)
			look_at(monsterToLockOn.global_position)
			position.y = 2
		
		
		_check_alignment(monsterToLockOn)
		
		


func _on_pogo_body_body_entered(body):
	# self explanatory
	lockOff = true
	lockedOn = false


func _check_alignment(enemy):
	# checks if the player is above the enemy, thus disabling lock on to prevent stupid camera bs
	
	var objectOne = self.global_position
	var objectTwo = enemy.global_position
	
	#print(objectOne)
	#print(objectTwo)
	
	if objectTwo.z -0.25 < objectOne.z and objectOne.z < objectTwo.z + 0.25 and objectTwo.x -0.25 < objectOne.x and objectOne.x < objectTwo.x + 0.25:
		lockOff = true
		print("aligned")

func _locked_off():
	# resets all the variables affected by being locked on
	
	camera.rotation.z = 0
	camera.rotation.x = 0
	camera.rotation.y = 0
	
	position.y = 0
	position.x = 0
	position.z = 0
	lockedOn = false
	distanceToEnemy = 1000


func _handle_gamepad_view(delta):
	if lockedOn:
		return
	
	var stick_input := Input.get_vector(
		"look_left",
		"look_right",
		"look_up",
		"look_down"
	)
	
	
	#if stick_input.x < -0.5 and stick_input.y > 0.5:
		#print("southwesting")
	#if stick_input.x > 0.5 and stick_input.y > 0.5:
		#print("southeasting")
	
	if stick_input.length() < stick_deadzone:
		return
	
	rotation_degrees.x -= stick_input.y * stick_sensitivity * delta
	rotation_degrees.x = clamp(rotation_degrees.x, -90.0, 30.0)
	# Horizontal (Y rotation)
	
	rotation_degrees.y -= stick_input.x * stick_sensitivity * delta
	rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)
