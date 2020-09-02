extends Node2D
# params
var worker_list = []
var soldier_list = []
export(int) var team_no = 1 setget ,get_team
var resource_quantity = [0, 0, 0]
var resources = ["gold", "food", "wood"]
var total_resources = [resources, resource_quantity]
# siege_defense, pierce_defense, blade_defense, evasion_percentage, critical_multiplier, critical_chance, health_value, damage
# instance
onready var gold_ui_value = get_node("/root/World/Camera_Controller/GUI/Left_Panel/VBoxContainer/Stat_Panel/Resources_List/Gold_Texture/TextureButton/Label")
onready var food_ui_value = get_node("/root/World/Camera_Controller/GUI/Left_Panel/VBoxContainer/Stat_Panel/Resources_List/Food_Texture/TextureButton/Label")
onready var wood_ui_value = get_node("/root/World/Camera_Controller/GUI/Left_Panel/VBoxContainer/Stat_Panel/Resources_List/Wood_Texture/TextureButton/Label")
onready var worker_ui_value =  get_node("/root/World/Camera_Controller/GUI/Left_Panel/VBoxContainer/Stat_Panel/Resources_List/Worker_Texture/TextureButton/Label")
onready var building_focus = get_node("/root/World/Camera_Controller/GUI/Right_Panel/VBoxContainer/Focus_Panel/VBoxContainer/Object_Title")

func _ready():
	add_resources([200,200,200])

func add_resources(add_resources): #other ways didnt work for some reason
	total_resources[1][0] += add_resources[0]
	total_resources[1][1] += add_resources[1]
	total_resources[1][2] += add_resources[2]
	gold_ui_value.set_text("    " + str(total_resources[1][0]))
	food_ui_value.set_text("    " + str(total_resources[1][1]))
	wood_ui_value.set_text("    " + str(total_resources[1][2]))
#shorts
func get_team(): return team_no
func get_name(): return "Player"
func get_resources(): return total_resources # would be better to return only necessary to worker
func get_worker_list(): return worker_list
func add_worker(worker): worker_list.append(worker)
func add_soldier(soldier): soldier_list.append(soldier)
func get_soldier_list(): return soldier_list
func update_workers(): worker_ui_value.set_text("  " + str(worker_list.size()))
