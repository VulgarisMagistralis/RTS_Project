
class Basic_Building:
	onready var button_path : Node2D
	onready var id_holder : Node2D
	var building_name : String
	var display_info : String
	var team_number : int
	var health : float
	var mouse_on : bool
	var available_states : bool
	var building_selected : bool
	
	func _init(health_val : int, team: int, states_available : bool, b_name : String, buttons : Node2D, id_place : Node2D):
		button_path = buttons
		button_path.hide()
		health = health_val
		team_number = team
		available_states = states_available
		building_name = b_name
		id_holder = id_place
		id_holder.set_text(str(get_instance_id()))
	
	func select_object() -> String:
		building_selected = true
		button_path.show()
		return display_info
	
	func deselect_object() -> void:
		building_selected = false
		button_path.hide()
	
	func get_team() -> int: return team_number
	func has_states() -> bool: return available_states

class Complex_Building:
	pass
