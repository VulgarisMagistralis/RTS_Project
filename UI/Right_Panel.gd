extends TextureRect

signal build_building(building_name)
signal selected_building(bulding_type)
signal enable_location_selection()
signal spawn_worker()
signal spawn_soldier()

onready var barn_buttons = get_node("/root/World/Camera_Controller/GUI/Right_Panel/VBoxContainer/Focus_Panel/VBoxContainer/Barn_Buttons")
onready var tc_buttons = get_node("/root/World/Camera_Controller/GUI/Right_Panel/VBoxContainer/Focus_Panel/VBoxContainer/Town_Center_Buttons")
onready var armoury_buttons = get_node("/root/World/Camera_Controller/GUI/Right_Panel/VBoxContainer/Focus_Panel/VBoxContainer/Armoury_Buttons")
onready var barracks_buttons = get_node("/root/World/Camera_Controller/GUI/Right_Panel/VBoxContainer/Focus_Panel/VBoxContainer/Barracks_Buttons")
onready var mouse = get_node("/root/World/Mouse_Follower")
onready var world = get_node("/root/World")
# params
var blade_damage = 0
var arrow_damage = 0
var blade_defence = 0
var pierce_defence = 0
var training_level = 0
var projectile_damage = 0

#func _ready():
#	tc_buttons.hide()
#	barn_buttons.hide()
#	armoury_buttons.hide()
#	barracks_buttons.hide()

func error(line):
	print("@" + str(line))
	return
#signals
func _on_Town_Center_pressed():
	var subject_id = get_node("VBoxContainer/Focus_Panel/VBoxContainer/ID_Holder").get_text()
	var worker_instance = instance_from_id(int(subject_id))
	if self.connect("build_building", worker_instance, "_on_Build_Building"): error(15)
	if self.connect("selected_building", mouse, "_on_Received_Building"): error(16)
	if self.connect("enable_location_selection", world, "_on_Enable_Location_Selection"): error(17)
	emit_signal("build_building", "Town_Center")
	emit_signal("selected_building", 0, subject_id)
	emit_signal("enable_location_selection")
	disconnect("selected_building", mouse, "_on_Received_Building")
	disconnect("build_building", worker_instance, "_on_Build_Building")
	disconnect("enable_location_selection", world, "_on_Enable_Location_Selection")

func _on_Armoury_pressed():
	var subject_id = get_node("VBoxContainer/Focus_Panel/VBoxContainer/ID_Holder").get_text()
	var worker_instance = instance_from_id(int(subject_id))
	if self.connect("build_building", worker_instance, "_on_Build_Building"): error(28)
	if self.connect("selected_building", mouse, "_on_Received_Building"): error(29)
	if self.connect("enable_location_selection", world, "_on_Enable_Location_Selection"): error(30)
	emit_signal("build_building", "Armoury")
	emit_signal("selected_building", 1, subject_id)
	emit_signal("enable_location_selection")
	disconnect("selected_building", mouse, "_on_Received_Building")
	disconnect("build_building", worker_instance, "_on_Build_Building")
	disconnect("enable_location_selection", world, "_on_Enable_Location_Selection")

func _on_Barracks_pressed():
	var subject_id = get_node("VBoxContainer/Focus_Panel/VBoxContainer/ID_Holder").get_text()
	var worker_instance = instance_from_id(int(subject_id))
	if self.connect("build_building",worker_instance,"_on_Build_Building"): error(41)
	if self.connect("selected_building", mouse, "_on_Received_Building"): error(42)
	if self.connect("enable_location_selection", world, "_on_Enable_Location_Selection"): error(43)
	emit_signal("build_building", "Barracks")
	emit_signal("selected_building", 2, subject_id)
	emit_signal("enable_location_selection")
	disconnect("selected_building", mouse, "_on_Received_Building")
	disconnect("build_building", worker_instance, "_on_Build_Building")
	disconnect("enable_location_selection", world, "_on_Enable_Location_Selection")

func _on_Barn_pressed():
	var subject_id = get_node("VBoxContainer/Focus_Panel/VBoxContainer/ID_Holder").get_text()
	var worker_instance = instance_from_id(int(subject_id))
	if self.connect("build_building",worker_instance,"_on_Build_Building"): error(54)
	if self.connect("selected_building", mouse, "_on_Received_Building"): error(55)
	if self.connect("enable_location_selection", world, "_on_Enable_Location_Selection"): error(56)
	emit_signal("build_building", "Barn")
	emit_signal("selected_building", 3, subject_id)
	emit_signal("enable_location_selection")
	disconnect("selected_building", mouse, "_on_Received_Building")
	disconnect("build_building", worker_instance, "_on_Build_Building")
	disconnect("enable_location_selection", world, "_on_Enable_Location_Selection")
	
func _on_Worker_pressed():
	var subject_id = get_node("VBoxContainer/Focus_Panel/VBoxContainer/ID_Holder").get_text()
	var town_instance = instance_from_id(int(subject_id))
	if self.connect("spawn_worker", town_instance, "_on_Spawn_Worker"): error(37)
	emit_signal("spawn_worker")
	disconnect("spawn_worker", town_instance, "_on_Spawn_Worker")

func _on_Soldier_pressed():
	print("spawn soldier..")
#	var subject_id = get_node("VBoxContainer/Focus_Panel/VBoxContainer/ID_Holder").get_text()
#	var town_instance = instance_from_id(int(subject_id))
#	if self.connect("spawn_soldier", town_instance, "_on_Spawn_Soldier"): error(43)
#	emit_signal("spawn_soldier", 0)
#	disconnect("spawn_soldier", town_instance, "_on_Spawn_Soldier")

func _on_Archer_pressed():
	print("spawn archer..")
#	var subject_id = get_node("VBoxContainer/Focus_Panel/VBoxContainer/ID_Holder").get_text()
#	var town_instance = instance_from_id(int(subject_id))
#	if self.connect("spawn_soldier", town_instance, "_on_Spawn_Soldier"): error(50)
#	emit_signal("spawn_soldier", 1)
#	disconnect("spawn_soldier", town_instance, "_on_Spawn_Soldier")

func _on_Catapult_pressed():
	print("spawn catapult..")
#	var subject_id = get_node("VBoxContainer/Focus_Panel/VBoxContainer/ID_Holder").get_text()
#	var town_instance = instance_from_id(int(subject_id))
#	if self.connect("spawn_soldier", town_instance, "_on_Spawn_Soldier"): error(57)
#	emit_signal("spawn_soldier", 2)
#	disconnect("spawn_soldier", town_instance, "_on_Spawn_Soldier")

func _on_Blade_pressed():
	print("Upgrading blade damage..")

func _on_Training_pressed(): # increase crit and evasion
	print("Upgrading soldier stats..")
	
func _on_Pierce_pressed():
	print("Upgrading piercing damage..")

func _on_Pierce_Defence_pressed():
	print("Upgrading pierce defence..")

func _on_Blade_Defence_pressed():
	print("Upgrading blade defence..")

func _on_Catapult_Projectile_pressed():
	print("Upgrading catapult damage..")

func _on_Farm_Better_pressed():
	print("Upgrading farm..")

func _on_Gather_Better_pressed():
	print("Upgrading gathering..")

func _on_Mine_Better_pressed():
	print("Upgrading mining..")
