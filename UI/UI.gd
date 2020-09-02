extends Control

onready var button_container = get_node("Rigth_Panel/VBoxContainer/Focus_Panel/VBoxContainer/Building_Buttons")
var buttons = false

func _physics_process(delta):
	if buttons : button_container.show()
	else: button_container.hide()

func hide_buttons(): buttons = false
func show_buttons(): buttons = true
func _on_TextureButton_pressed():
	print("pressed")


func _on_Building_1_pressed():
	print("building 1")


func _on_Building_2_pressed():
	print("Building 2")


func _on_Building_3_pressed():
	print("Building 3")
