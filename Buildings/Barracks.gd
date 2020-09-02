extends StaticBody2D

var barracks
var buildings = preload("res://Buildings/Building.gd")
onready var player = get_node("/root/World/Player_Stats")
onready var id_holder = get_node("/root/World/Camera_Controller/GUI/Right_Panel/VBoxContainer/Focus_Panel/VBoxContainer/ID_Holder")
onready var barracks_buttons = get_node("/root/World/Camera_Controller/GUI/Right_Panel/VBoxContainer/Focus_Panel/VBoxContainer/Barracks_Buttons")

func _init(health_val : int, team: int, states_available : bool, b_name : String): 
	barracks = buildings.Basic_Building.new(health_val, team, states_available, b_name, barracks_buttons, id_holder)
func select_object(): return barracks.select_object()
func deselect_object(): barracks.deselect_object()
func get_team(): return barracks.get_team()
func has_states(): return barracks.has_states()
#Signals
func _on_Selectable_mouse_entered(): barracks.mouse_on = true
func _on_Selectable_mouse_exited(): barracks.mouse_on = false
