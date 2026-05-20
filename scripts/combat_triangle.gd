extends Node2D

@onready var topLeft = $topLeft
@onready var topRight = $topRight
@onready var bottomLeft = $bottomLeft
@onready var bottomRight = $bottomRight
@onready var top = $top
@onready var center = $center

var topLeftActive
var topRightActive
var bottomLeftActive
var bottomRightActive
var topActive

var active = false

func _process(delta: float) -> void:
	
	var stick_input := Input.get_vector(
		"look_left",
		"look_right",
		"look_up",
		"look_down"
	)
	
	if stick_input.x > 0.5 and stick_input.y > 0.5:
		print("yes happening")
	
	if active:
		self.visible = true
		if Input.is_action_pressed("ui_1") or stick_input.x < -0.5:
			_top_left()
		elif Input.is_action_pressed("ui_2") or stick_input.x > 0.5:
			_top_right()
		elif stick_input.x < -0 and stick_input.y > 0 or Input.is_action_pressed("ui_3"):
			_bottom_left()
		elif stick_input.x > 0 and stick_input.y > 0 or Input.is_action_pressed("ui_4"):
			_bottom_right()
		elif Input.is_action_pressed("ui_5") or stick_input.y < -0.5:
			_top()
		else:
			_reset()
	else:
		self.visible = false
		

func _top_left():
	topLeftActive = true
	topRightActive = false
	bottomLeftActive = false
	bottomRightActive = false
	topActive = false
	
	topLeft.modulate = Color(1.0, 0.0, 0.0, 1.0)
	topRight.modulate = Color(1.0, 1.0, 1.0, 1.0)
	bottomLeft.modulate = Color(1.0, 1.0, 1.0, 1.0)
	bottomRight.modulate = Color(1.0, 1.0, 1.0, 1.0)
	top.modulate = Color(1.0, 1.0, 1.0, 1.0)
	center.modulate = Color(1.0, 1.0, 1.0, 1.0)

func _top_right():
	topLeftActive = false
	topRightActive = true
	bottomLeftActive = false
	bottomRightActive = false
	topActive = false
	
	topLeft.modulate = Color(1.0, 1.0, 1.0, 1.0)
	topRight.modulate = Color(1.0, 0.0, 0.0, 1.0)
	bottomLeft.modulate = Color(1.0, 1.0, 1.0, 1.0)
	bottomRight.modulate = Color(1.0, 1.0, 1.0, 1.0)
	top.modulate = Color(1.0, 1.0, 1.0, 1.0)
	center.modulate = Color(1.0, 1.0, 1.0, 1.0)

func _bottom_left():
	topLeftActive = false
	topRightActive = false
	bottomLeftActive = true
	bottomRightActive = false
	topActive = false
	
	topLeft.modulate = Color(1.0, 1.0, 1.0, 1.0)
	topRight.modulate = Color(1.0, 1.0, 1.0, 1.0)
	bottomLeft.modulate = Color(1.0, 0.0, 0.0, 1.0)
	bottomRight.modulate = Color(1.0, 1.0, 1.0, 1.0)
	top.modulate = Color(1.0, 1.0, 1.0, 1.0)
	center.modulate = Color(1.0, 1.0, 1.0, 1.0)

func _bottom_right():
	topLeftActive = false
	topRightActive = false
	bottomLeftActive = false
	bottomRightActive = true
	topActive = false
	
	topLeft.modulate = Color(1.0, 1.0, 1.0, 1.0)
	topRight.modulate = Color(1.0, 1.0, 1.0, 1.0)
	bottomLeft.modulate = Color(1.0, 1.0, 1.0, 1.0)
	bottomRight.modulate = Color(1.0, 0.0, 0.0, 1.0)
	top.modulate = Color(1.0, 1.0, 1.0, 1.0)
	center.modulate = Color(1.0, 1.0, 1.0, 1.0)

func _top():
	topLeftActive = false
	topRightActive = false
	bottomLeftActive = false
	bottomRightActive = false
	topActive = true
	
	topLeft.modulate = Color(1.0, 1.0, 1.0, 1.0)
	topRight.modulate = Color(1.0, 1.0, 1.0, 1.0)
	bottomLeft.modulate = Color(1.0, 1.0, 1.0, 1.0)
	bottomRight.modulate = Color(1.0, 1.0, 1.0, 1.0)
	top.modulate = Color(1.0, 0.0, 0.0, 1.0)
	center.modulate = Color(1.0, 1.0, 1.0, 1.0)

func _reset():
	topLeftActive = false
	topRightActive = false
	bottomLeftActive = false
	bottomRightActive = false
	topActive = false
	
	topLeft.modulate = Color(1.0, 1.0, 1.0, 1.0)
	topRight.modulate = Color(1.0, 1.0, 1.0, 1.0)
	bottomLeft.modulate = Color(1.0, 1.0, 1.0, 1.0)
	bottomRight.modulate = Color(1.0, 1.0, 1.0, 1.0)
	top.modulate = Color(1.0, 1.0, 1.0, 1.0)
	center.modulate = Color(1.0, 0.0, 0.0, 1.0)
