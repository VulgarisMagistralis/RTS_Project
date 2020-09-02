extends KinematicBody2D
var MAX_SPEED = 500
var speed = Vector2.ZERO
onready var camera = get_node("Camera2D")
onready var button_container = get_node("GUI/Right_Panel/VBoxContainer/Focus_Panel/VBoxContainer/Building_Buttons")
onready var text_container = get_node("GUI/Right_Panel/VBoxContainer/Focus_Panel/VBoxContainer/Object_Title")
func _ready():
	get_node("GUI/Game_Menu").hide()
	button_container.hide()
	text_container.set_text("")
	var zoom_vector = Vector2.ZERO
	zoom_vector.x = 1
	zoom_vector.y = 1
	camera.set_zoom(zoom_vector)

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = -Input.get_action_strength("ui_left") + Input.get_action_strength("ui_right")
	input_vector.y = -Input.get_action_strength("ui_up") + Input.get_action_strength("ui_down")
	input_vector = input_vector.normalized()
	speed = speed.move_toward(input_vector * MAX_SPEED, 1 / delta) # will definetely cause problems at some point
	speed = move_and_slide(speed)

func _input(event):
	var zoom = Vector2.ZERO
	zoom[0] = get_node("Camera2D").get("zoom").x
	zoom[1] = get_node("Camera2D").get("zoom").y
	if event is InputEventMouseButton:
		if(event.button_index == BUTTON_WHEEL_DOWN):
			if(zoom[0] - 0.05 < 1.9 && zoom[1] - 0.05 < 1):
				zoom[0] += 0.05
				zoom[1] += 0.05
				camera.set_zoom(zoom)
		if(event.button_index == BUTTON_WHEEL_UP and event.pressed):
			if(zoom[0] - 0.05 > 0.25 && zoom[1] - 0.05 > 0.5):
				zoom[0] -= 0.05
				zoom[1] -= 0.05
				camera.set_zoom(zoom)
	if event.is_action_pressed("Open_Menu"):
		get_node("GUI/Game_Menu").show()

func _on_Back_pressed():
	get_node("GUI/Game_Menu").hide()
