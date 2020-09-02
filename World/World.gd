extends Node2D
#instances
onready var music = $Background_Music
onready var mouse = get_node("Mouse_Follower")
onready var object_focus = get_node("/root/World/Camera_Controller/GUI/Right_Panel/VBoxContainer/Focus_Panel/VBoxContainer/Object_Title")
#params
var selectable_id = null
var targetable_id = null
var selected_object = null
var targeted_object = null
var waiting_building_location = false

func _ready():
	randomize()
	music.stop()
# flag each selected obj
func _unhandled_input(_event):
	if Input.is_action_just_pressed("select_subject"):
		if waiting_building_location:
			selected_object.set_position_building(mouse.global_position)
			waiting_building_location = false
			return
		if selected_object != null: selected_object.deselect_object()
		selectable_id = mouse.get_selectable_object()
		if selectable_id == null: 
			object_focus.set_text("")
			return
		selected_object = instance_from_id(selectable_id)
		object_focus.set_text(selected_object.select_object() if selected_object != null else "")
	if selected_object != null && Input.is_action_just_pressed("select_target") && selected_object.has_method("set_target"):
		selected_object.set_target(mouse.global_position)
		targetable_id = mouse.get_selectable_object()
		if targetable_id != null: 
			print("sending "+ str(targetable_id))
			selected_object.set_target_object(targetable_id)
		else:
			if selected_object.has_states(): selected_object.set_override_walk() 
		if selected_object.has_states(): selected_object.set_state(3)

func _on_Enable_Location_Selection(): waiting_building_location = true
func set_selected_object(object_id): selected_object = object_id
func set_target_object(object_id): targeted_object = object_id
func get_selected_object(): return selected_object
func get_target_object(): return targeted_object
