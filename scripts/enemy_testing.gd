extends CharacterBody3D

@export var leftArm := 10
@export var rightArm := 10
@export var leftLeg := 10
@export var rightLeg := 10
@export var head := 50
@export var health := 70

@onready var bodyCollision = $limbsAreas/body
@onready var leftArmCollision = $limbsAreas/leftArm
@onready var rightArmCollision = $limbsAreas/rightArm
@onready var leftLegCollision = $limbsAreas/leftLeg
@onready var rightLegCollision = $limbsAreas/rightLeg
@onready var headCollision = $limbsAreas/up
@onready var spearPivot = $spearPivot
@onready var spearBlock = $spearPivot/block
@onready var blockTimer = $timers/blockTimer

var blockRight
var blockLeft
var blockLeftLeg
var blockRightLeg
var blockUp
var blockBody

var player

func _ready() -> void:
	if get_tree().current_scene.find_child("player", true, false) != null:
		player = get_tree().current_scene.find_child("player", true, false)
	
	blockTimer.timeout.connect(_on_block_timer_timeout.bind(get_process_delta_time()))
	
	blockTimer.start(0.5)
	
	print("startingTimer")

func _physics_process(delta: float) -> void:
	self.look_at(player.global_position)


#func _block_right():
	#bodyCollision.disabled = false
	#leftArmCollision.disabled = false
	#rightArmCollision.disabled = true
	#leftLegCollision.disabled = false
	#rightLegCollision.disabled = true
	#headCollision.disabled = false
#func _block_left():
	#bodyCollision.disabled = false
	#leftArmCollision.disabled = true
	#rightArmCollision.disabled = false
	#leftLegCollision.disabled = true
	#rightLegCollision.disabled = false
	#headCollision.disabled = false
#func _block_up():
	#bodyCollision.disabled = true
	#leftArmCollision.disabled = false
	#rightArmCollision.disabled = false
	#leftLegCollision.disabled = false
	#rightLegCollision.disabled = false
	#headCollision.disabled = true
#func _block_down():
	#bodyCollision.disabled = false
	#leftArmCollision.disabled = false
	#rightArmCollision.disabled = false
	#leftLegCollision.disabled = true
	#rightLegCollision.disabled = true
	#headCollision.disabled = false


func _break_right_arm():
	health -= 30
func _break_left_arm():
	health -= 30
func break_right_leg():
	health -= 30
func _break_left_leg():
	health -= 30
func _break_head():
	health -= 100


func _on_body_body_entered(body: Node3D) -> void:
	health -= player.weapon_strength
	print(health)


func _on_left_arm_body_entered(body: Node3D) -> void:
	health -= player.weapon_strength
	leftArm -= player.weapon_strength
	print(health)


func _on_right_arm_body_entered(body: Node3D) -> void:
	health -= player.weapon_strength
	rightArm -= player.weapon_strength
	print(health)


func _on_left_leg_body_entered(body: Node3D) -> void:
	health -= player.weapon_strength
	leftLeg -= player.weapon_strength
	print(health)


func _on_right_leg_body_entered(body: Node3D) -> void:
	health -= player.weapon_strength
	rightLeg -= player.weapon_strength
	print(health)


func _on_up_body_entered(body: Node3D) -> void:
	health -= player.weapon_strength
	head -= player.weapon_strength
	print(health)




# enemy blocking function

func _block_top_right(delta):
	spearPivot.position = lerp(spearPivot.position, Vector3(1, 0, 0), delta * 10)
	spearPivot.rotation = Vector3(0, 0, 0)
	
	spearBlock.name = "blockTopRight"
	
	blockTimer.start(0.5)
	

func _block_top_left(delta):
	spearBlock.name = "blockTopLeft"
	spearPivot.position = lerp(spearPivot.position, Vector3(-1, 0, 0), delta * 10)
	spearPivot.rotation = Vector3(0, 0, 0)
	
	blockTimer.start(0.5)

func _block_bottom_right(delta):
	spearPivot.position = lerp(spearPivot.position, Vector3(1.3, -0.5, -0.3), delta * 10)
	spearPivot.rotation = Vector3(deg_to_rad(-90), deg_to_rad(45), 0)
	spearBlock.name = "blockBottomRight"
	
	blockTimer.start(0.5)

func _block_bottom_left(delta):
	spearPivot.position = lerp(spearPivot.position, Vector3(-1.1, -0.5, -0.3), delta * 10)
	spearPivot.rotation = Vector3(deg_to_rad(-90), deg_to_rad(-45), 0)
	spearBlock.name = "blockBottomLeft"
	
	blockTimer.start(0.5)

func _block_up(delta):
	spearPivot.position = lerp(spearPivot.position, Vector3(-0.7, 1, -0.8), delta * 10)
	spearPivot.rotation = Vector3(0, 0, deg_to_rad(-90))
	spearBlock.name = "blockUp"
	
	blockTimer.start(0.5)

func _block_middle(delta):
	spearPivot.position = lerp(spearPivot.position, Vector3(0.7, 0, 0), delta * 10)
	spearPivot.rotation = Vector3(deg_to_rad(-90), 0, 0)
	spearBlock.name = "blockMiddle"
	
	blockTimer.start(0.5)


func _on_block_timer_timeout(delta) -> void:
	var random = randi_range(1, 6)
	
	print("happening")
	
	match random:
		1:
			_block_top_left(delta)
		2:
			_block_top_right(delta)
		3:
			_block_bottom_left(delta)
		4:
			_block_bottom_right(delta)
		5:
			_block_up(delta)
		6:
			_block_middle(delta)
