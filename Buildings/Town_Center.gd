extends StaticBody2D
# instance
onready var spawn_area = $Exit_Area
onready var root_node = get_node("/root/World")
onready var player = get_node("/root/World/Player_Stats")
var worker = preload("res://Worker/Worker.tscn")
#var soldier = preload("res://Soldiers/Soldier.tscn")
onready var building_focus = get_node("/root/World/Camera_Controller/GUI/Right_Panel/VBoxContainer/Focus_Panel/VBoxContainer/Object_Title")
onready var worker_ui_value =  get_node("/root/World/Camera_Controller/GUI/Left_Panel/VBoxContainer/Stat_Panel/Resources_List/Worker_Texture/TextureButton/Label")
onready var soldier_ui_value =  get_node("/root/World/Camera_Controller/GUI/Left_Panel/VBoxContainer/Stat_Panel/Resources_List/Soldier_Texture/TextureButton/Label")
onready var id_holder = get_node("/root/World/Camera_Controller/GUI/Right_Panel/VBoxContainer/Focus_Panel/VBoxContainer/ID_Holder")
onready var tc_buttons = get_node("/root/World/Camera_Controller/GUI/Right_Panel/VBoxContainer/Focus_Panel/VBoxContainer/Town_Center_Buttons")
# params
var health = 3000
var mouse_on = false
var town_center_selected = false
var target_position = Vector2.ZERO
var default_soldiers = [[0.8, 0.5, 0.6, 10, 3, 7, 1200, 40], [0.9, 0.6, 0.8, 13, 3, 9, 1000, 34], [0.2, 0.8, 0.6, 0, 3, 10, 2000, 80]]
# siege_defense, pierce_defense, blade_defense, evasion_percentage, critical_multiplier, critical_chance, health_value, damage

func _ready():
	hide_buttons()

func select_object():
	tc_buttons.show()
	town_center_selected = true
	id_holder.set_text(str(get_instance_id()))
	var total_resources = player.get_resources()
	return(get_name() + "\n" + 
	str((player.get_worker_list() if !player.get_worker_list().empty() else "")) +
	str(total_resources[0][0]) + " : " + str(total_resources[1][0]) + "\n" +
	str(total_resources[0][1]) + " : " + str(total_resources[1][1]) + "\n" +
	str(total_resources[0][2]) + " : " + str(total_resources[1][2]) + "\n" +
	"Team : " + str(player.get_team()) + "\n" + "Health: " + str(health))

func deselect_object(): # same as hide buttons ?
	tc_buttons.hide()
	town_center_selected = false
	
func spawn_worker():
	var worker_instance = worker.instance()
	worker_instance.set_position(spawn_area.global_position)
	worker_instance.set_team(player.get_team())
	get_parent().add_child(worker_instance)
	worker_instance.move_to(target_position)
	player.add_worker(worker_instance)
	update_worker_ui()

#func spawn_soldier(type):
#	var soldier_instance = soldier.instance()
#	soldier_instance.soldier_type = type
#	print(default_soldiers[type])
#	soldier_instance.init_soldier_params(default_soldiers[type])
#	soldier_instance.set_position(spawn_area.global_position)
#	soldier_instance.set_team(player.get_team())
#	get_parent().add_child(soldier_instance)
#	soldier_instance.move_to(target_position)
#	player.add_soldier(soldier_instance)
#	update_soldier_ui()
#
#func _on_Spawn_Soldier(type):
#	town_center_selected = true; spawn_soldier(type)

func _on_Spawn_Worker():
	town_center_selected = true; spawn_worker()

func hide_buttons():
	tc_buttons.hide()
	town_center_selected = false
#shorts
func get_name(): return "Town Center"
func has_states(): return false
func get_team(): return player.get_team()
func set_target(target): target_position = target
func update_soldier_ui(): soldier_ui_value.set_text("  " + str(player.get_soldier_list().size()))
func update_worker_ui(): worker_ui_value.set_text("  " + str(player.get_worker_list().size()))
#flags
func _on_Selectable_mouse_entered(): mouse_on = true
func _on_Selectable_mouse_exited(): mouse_on = false
