extends StaticBody2D

var buildings = preload("res://Buildings/Building.gd")
var barn
#onready var player = get_node("/root/World/Player_Stats")
onready var id_holder = get_node("/root/World/Camera_Controller/GUI/Right_Panel/VBoxContainer/Focus_Panel/VBoxContainer/ID_Holder")
onready var barn_buttons = get_node("/root/World/Camera_Controller/GUI/Right_Panel/VBoxContainer/Focus_Panel/VBoxContainer/Barn_Buttons")

func _init(health_val : int, team: int, states_available : bool, b_name : String): barn = buildings.Basic_Building.new(health_val, team, states_available, b_name, barn_buttons, id_holder)
func select_object(): return barn.select_object()
func deselect_object(): barn.deselect_object()
func get_team(): return barn.get_team()
func has_states(): return barn.has_states()
#Signals
func _on_Selectable_mouse_entered(): barn.mouse_on = true
func _on_Selectable_mouse_exited(): barn.mouse_on = false
