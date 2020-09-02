extends StaticBody2D

var armoury
var buildings = preload("res://Buildings/Building.gd")
onready var player = get_node("/root/World/Player_Stats")
onready var id_holder = get_node("/root/World/Camera_Controller/GUI/Right_Panel/VBoxContainer/Focus_Panel/VBoxContainer/ID_Holder")
onready var armoury_buttons = get_node("/root/World/Camera_Controller/GUI/Right_Panel/VBoxContainer/Focus_Panel/VBoxContainer/Armoury_Buttons")

func _init(health_val : int, team: int, states_available : bool, b_name : String): armoury = buildings.Basic_Building.new(health_val, team, states_available, b_name, armoury_buttons, id_holder)
func select_object(): return armoury.select_object()
func deselect_object(): armoury.deselect_object()
func get_team(): return armoury.get_team()
func has_states(): return armoury.has_states()
#Signals
func _on_Selectable_mouse_entered(): armoury.mouse_on = true
func _on_Selectable_mouse_exited(): armoury.mouse_on = false
