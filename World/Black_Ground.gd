extends Sprite

onready var text_container = get_node("/root/World/Camera_Controller/CanvasLayer/Right_Panel/VBoxContainer/Focus_Panel/VBoxContainer/Object_Title")

func _input(event):
	if event.is_action_pressed("select_subject"):
		text_container.set_text("")

