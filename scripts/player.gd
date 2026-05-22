extends CharacterBody3D

@export var speed := 7.0
@export var acceleration := 30
@export var gravity := 30
@export var jump_strength := 10
@export var rotation_speed := 12.0
@export var cut_jump := 0.5

@export var weapon_strength := 2.0

@export var normal_camera_offset := Vector3(position.x, position.y + 1, position.z)
@export var aiming_camera_offset := Vector3(position.x + 0.75, position.y + 2, position.z + 0.3)
@export var camera_transition_speed := 5.0

var _last_movement_direction := Vector3.BACK

@onready var _spring_arm: SpringArm3D = $SpringArmPivot/SpringArm3D
@onready var _model = $body
@onready var _pivot = $SpringArmPivot
@onready var targetTriangle = $triangleTarget
@onready var spear = $body/spearPivot/spear
@onready var spearPivot = $body/spearPivot
@onready var spearCollision = $body/spearPivot/StaticBody3D
@onready var combatTriangle = $triangleTarget/SubViewport/combatTriangle
@onready var actionAnimator = $animators/actionAnimator
@onready var spearBlock = $body/spearPivot/block
@onready var parryTimer = $timers/parryTimer
@onready var getBlockedCollision = $body/spearPivot/blockDetection/CollisionShape3D

var aiming = false
var targetting = false

var targetEnemy

var lockedOn = false

func _ready() -> void:
	_reset_collision()
	targetTriangle.visible = false
	
	getBlockedCollision.disabled = true


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_click"):
		_attack()
	
	
	if Input.is_action_just_pressed("ui_q") and lockedOn:
		lockedOn = false
		_model.global_rotation.z = 0
		_model.global_rotation.x = 0
	elif Input.is_action_just_pressed("ui_q") and lockedOn == false:
		lockedOn = true

func _physics_process(delta):
	
	#print(spearBlock.name)
	
	if lockedOn:
		if combatTriangle.topRightActive:
			_block_top_right(delta)
		elif combatTriangle.topLeftActive:
			_block_top_left(delta)
		elif combatTriangle.bottomRightActive:
			_block_bottom_right(delta)
		elif combatTriangle.bottomLeftActive:
			_block_bottom_left(delta)
		elif combatTriangle.topActive:
			_block_up(delta)
		else:
			_block_middle(delta)
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_strength
	
	if Input.is_action_just_pressed("ui_q"):
		for enemy in get_tree().get_nodes_in_group("enemies"):
			targetTriangle.visible = true
			targetEnemy = enemy
			targetting = true
	
	if targetting:
		targetTriangle.global_position = targetEnemy.global_position
	
	#_pivot.global_transform.origin = global_transform.origin
	
	#Getting the Vectors for the movement directions
	var raw_input := Input.get_vector("ui_right", "ui_left", "ui_up", "ui_down")
	
	
	#Variables for making sure character direction and camera connect for later
	var forward := _spring_arm.global_basis.z
	var right := -_spring_arm.global_basis.x
	
	var move_direction := forward * raw_input.y + right * raw_input.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	
	
	
	var horizontal_velocity = velocity
	horizontal_velocity.y = 0
	var target = move_direction * speed
	horizontal_velocity = horizontal_velocity.move_toward(target, acceleration * delta)
	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z
	
	if !is_on_floor():
			velocity.y -= gravity * delta
	
	
	if Input.is_action_pressed("ui_e"):
		aiming = true
	if Input.is_action_just_released("ui_e"):
		aiming = false
		_spring_arm.position.x = 0
		_spring_arm.position.y = 0
	
	if aiming:
		_aiming()
	
	move_and_slide()
	
	if move_direction.length() > 0.2 and !aiming:
		_last_movement_direction = move_direction
		var target_angle := Vector3.BACK.signed_angle_to(-_last_movement_direction, Vector3.UP)
		
		if lockedOn:
			_model.look_at(targetEnemy.global_position)
		else:
			_model.global_rotation.y = lerp_angle(_model.rotation.y, target_angle, rotation_speed * delta)


func _input(event: InputEvent) -> void:
	if event.is_action_released("ui_accept"):
		if velocity.y > 0.0:
			velocity.y *= cut_jump

func _aiming():
	_spring_arm.position.x = 1
	_spring_arm.position.y = 0.5
	
	_model.global_rotation_degrees.y = _pivot.global_rotation_degrees.y


func _attack():
		if combatTriangle.topActive:
			actionAnimator.play("attack_up")
		elif combatTriangle.topLeftActive:
			actionAnimator.play("attack_left")
		elif combatTriangle.topRightActive:
			actionAnimator.play("attack_right")
		elif combatTriangle.bottomLeftActive:
			actionAnimator.play("attack_left_leg")
		elif combatTriangle.bottomRightActive:
			actionAnimator.play("attack_right_leg")
		else:
			actionAnimator.play("pierce_attack")


func _activate_right_leg_collision():
	for i in range(5, 11):
		spearCollision.set_collision_layer_value(i, false)
		spearCollision.set_collision_mask_value(i, false)
		
	spearCollision.set_collision_layer_value(9, true)
	spearCollision.set_collision_mask_value(9, true)

func _activate_left_leg_collision():
	for i in range(5, 11):
		spearCollision.set_collision_layer_value(i, false)
		spearCollision.set_collision_mask_value(i, false)
	
	spearCollision.set_collision_layer_value(8, true)
	spearCollision.set_collision_mask_value(8, true)

func _activate_right_collision():
	for i in range(5, 11):
		spearCollision.set_collision_layer_value(i, false)
		spearCollision.set_collision_mask_value(i, false)
	
	spearCollision.set_collision_layer_value(7, true)
	spearCollision.set_collision_mask_value(7, true)

func _activate_left_collision():
	for i in range(5, 11):
		spearCollision.set_collision_layer_value(i, false)
		spearCollision.set_collision_mask_value(i, false)
	
	spearCollision.set_collision_layer_value(6, true)
	spearCollision.set_collision_mask_value(6, true)

func _activate_up_collision():
	for i in range(5, 11):
		spearCollision.set_collision_layer_value(i, false)
		spearCollision.set_collision_mask_value(i, false)
	
	spearCollision.set_collision_layer_value(10, true)
	spearCollision.set_collision_mask_value(10, true)

func _activate_pierce_colliison():
	for i in range(5, 11):
		spearCollision.set_collision_layer_value(i, false)
		spearCollision.set_collision_mask_value(i, false)
	
	spearCollision.set_collision_layer_value(5, true)
	spearCollision.set_collision_mask_value(5, true)

func _reset_collision():
	for i in range(5, 11):
		spearCollision.set_collision_layer_value(i, false)
		spearCollision.set_collision_mask_value(i, false)

func _push_forward():
	self.velocity += -_model.global_transform.basis.z * 9


# functions for blocking attacks

func _block_top_right(delta):
	spearPivot.position = lerp(spearPivot.position, Vector3(1, 0, 0), delta * 10)
	spearPivot.rotation = Vector3(0, 0, 0)
	
	spearBlock.name = "blockTopRight"

func _block_top_left(delta):
	spearPivot.position = lerp(spearPivot.position, Vector3(-1, 0, 0), delta * 10)
	spearPivot.rotation = Vector3(0, 0, 0)
	spearBlock.name = "blockTopLeft"

func _block_bottom_right(delta):
	spearPivot.position = lerp(spearPivot.position, Vector3(1.3, -0.5, -0.3), delta * 10)
	spearPivot.rotation = Vector3(deg_to_rad(-90), deg_to_rad(45), 0)
	spearBlock.name = "blockBottomRight"

func _block_bottom_left(delta):
	spearPivot.position = lerp(spearPivot.position, Vector3(-1.1, -0.5, -0.3), delta * 10)
	spearPivot.rotation = Vector3(deg_to_rad(-90), deg_to_rad(-45), 0)
	spearBlock.name = "blockBottomLeft"

func _block_up(delta):
	spearPivot.position = lerp(spearPivot.position, Vector3(-0.7, 1, -0.8), delta * 10)
	spearPivot.rotation = Vector3(0, 0, deg_to_rad(-90))
	spearBlock.name = "blockUp"

func _block_middle(delta):
	spearPivot.position = lerp(spearPivot.position, Vector3(0.7, 0, 0), delta * 10)
	spearPivot.rotation = Vector3(deg_to_rad(-90), 0, 0)
	spearBlock.name = "blockMiddle"


func _on_block_detection_body_entered(body: Node3D) -> void:
	
	print(body.name)
	
	if actionAnimator.current_animation == "attack_right" and body.name == "blockTopRight":
		print("diediedie")
		_screw_you_left()
		

func _screw_you_left():
	actionAnimator.play("blocked_left")
