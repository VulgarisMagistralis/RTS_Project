extends KinematicBody2D
# consts
var MAX_HEALTH = 100
# instance
onready var sprite = $Sprite
onready var timer = $IDLE_Timer
onready var health_bar = $Health
onready var resource_timer = $Resource_Timer
onready var root_node = get_node("/root/World")
onready var player = get_node("/root/World/Player_Stats")
onready var id_holder = get_node("/root/World/Camera_Controller/GUI/Right_Panel/VBoxContainer/Focus_Panel/VBoxContainer/ID_Holder")
onready var worker_focus = get_node("/root/World/Camera_Controller/GUI/Right_Panel/VBoxContainer/Focus_Panel/VBoxContainer/Object_Title")
onready var button_container = get_node("/root/World/Camera_Controller/GUI/Right_Panel/VBoxContainer/Focus_Panel/VBoxContainer/Building_Buttons")
# exports
export(int) var speed  = 100
export(int) var team_no setget set_team, get_team
export(bool) var auto_flee = false
export(int) var consumption_rate = 10
# flags
var waiting = false
var mouse_on = false
var ally_hurt = false
var enemy_near = false
var target_reached = true
var task_available = false
var worker_selected = false
var area_available = false
var resource_available = false
var can_send_resources = true
var waiting_building = false
# params
var permit = false
var enemy = null
var building = null
var health = 100
var animation = "IDLE"
var person_to_heal = null
var target_resource
var current_resource
var secondary_tasks = []
var sentence_list = [] #audio stream array
var worker_state = IDLE
var target_task_position
var target = Vector2.ZERO
var velocity = Vector2.ZERO
var resource_quantity = [0, 0, 0]
var target_position = Vector2.ZERO
var position_for_building = Vector2.ZERO
var resources = ["gold", "wood", "food"]
var carried_resources = [resources, resource_quantity]
var building_list = {
	"Town Centre" : 0,
	"House" : 1,
	"Wall" : 2
}
enum{
	ATTACK,
	IDLE,
	HEAL,
	WALK,
	BUILD,
	FLEE,
	CONSUME
}
func _ready():
	hide_butons()
	pull_sentences(int(rand_range(0,4)))

func _physics_process(delta):
	if health <= 0 : queue_free()
	sprite.play(animation)
	if under_threat() && auto_flee: worker_state = FLEE
	match worker_state:
		IDLE:
			animation = "IDLE"
			if !waiting: search_task()
		WALK:
			#animation = "TURN_RIGHT"
			animation = "WALK_RIGHT"
			walk()
		HEAL:
			#animation = "heal"
			heal()
		FLEE:
			animation = "WALK_RIGHT"
			flee()
		BUILD:
			#animation = "build"
			build()
		ATTACK:
			#animation = "attack"
			attack(delta)
		CONSUME:
			animation = "MINE_RIGHT"
			consume_resource()

func select_object():
	print(carried_resources)
	load_buttons()
	talk()
	worker_selected = true
	health_bar.show()
	id_holder.set_text(str(get_instance_id()))
	return (self.get_name() + " \n" +
	"Team number : " + str(get_team()) + "\n" +
	"Health : " + str(health) + "\n")

func deselect_object():
	health_bar.hide()
	hide_butons()
	worker_selected = false
	worker_focus.set_text("")

func under_threat():
	var obj
	for o in secondary_tasks: 
		obj = instance_from_id(o).get_node(".")
		if obj.get_name().match("Soldier") && obj.get_team() != get_team(): return true
	return false

func heal(): 
	if is_hurt():
		print("Heal me boy")
		self.health += 1
	elif ally_hurt:
		print("healing")
	else: worker_state = IDLE

func flee(): # needs a proper algorithm
	var town_center = get_parent().get_node("Town_Center").global_position
	velocity = (town_center - position).normalized() * speed
	if(town_center - position).length() > 5: velocity = move_and_slide(velocity)
	elif resource_available: worker_state = CONSUME
	else : worker_state = IDLE

func attack(delta):
	if enemy != null: instance_from_id(enemy).manipulate_health(int(10 * delta),1)
	else: worker_state = IDLE

func consume_resource():
	if can_send_resources:
		send_resources()
		resource_timer.start(3)
		can_send_resources = false
	var resource_index = 0
	if "Wood" in current_resource.get_name(): resource_index = 2
	elif "Food" in current_resource.get_name(): resource_index = 1
	if current_resource.get_deposit() > consumption_rate:
		carried_resources[1][resource_index] += consumption_rate
		current_resource.decrease_deposit(consumption_rate)
	else:
		carried_resources[1][resource_index] += current_resource.get_deposit()
		current_resource.decrease_deposit(current_resource.get_deposit())
		send_resources()
		worker_state = IDLE

func talk():
	var greeting = $Hello
	greeting.stream = sentence_list[rand_range(0,5)]
	greeting.play()

func is_hurt():
	if health < MAX_HEALTH: return true
	return false

func manipulate_health(value, team, _soldier_type):
	if team == team_no: health += value
	else: health -= value

# wait not working
func search_task(): # heal / gather / repair
	if is_hurt(): heal()
	elif !secondary_tasks.empty():
		print(instance_from_id(secondary_tasks.front()).get_name())
	else:
		waiting = true 
		timer.start(4)

func resource_depleted():
	worker_state = IDLE
	print("resource finished")

func walk():
	velocity = (target - position).normalized() * speed
	if(target - position).length() > 5: velocity = move_and_slide(velocity)
	elif waiting_building: worker_state = BUILD
	elif resource_available: worker_state = CONSUME
	else : worker_state = IDLE

func move_to(coords):
	target = coords
	worker_state = WALK

func send_resources():
	print("SENDING RESOURCES")
	player.add_resources(carried_resources[1])
	carried_resources[1] = [0,0,0]

func pull_sentences(etnicity):
	var directory = Directory.new()
	var folders = []
	directory.open("res://Sounds/")
	directory.list_dir_begin()
	var folder = directory.get_next()
	while(folder != "" ):
		if not folder.begins_with("."): folders.append(folder)
		folder = directory.get_next()
	directory.list_dir_end()
	var directory2 = Directory.new()
	directory2.open("res://Sounds/" + folders[etnicity])
	directory2.list_dir_begin()
	var sentence_file = directory2.get_next()
	while(sentence_file != ""):
		if(sentence_file.ends_with("wav")):
			var sentence = load("res://Sounds/" + folders[etnicity] + "/" + sentence_file)
			sentence_list.append(sentence)
		sentence_file = directory2.get_next()
	directory2.list_dir_end()

func _on_Build_Building(building_name):
	worker_selected = true 
	var to_build = load("res://Buildings/" + building_name + ".tscn")
	building = to_build.new(2000, 1, false, building_name)
	waits_building(true)

func set_position_building(pos):
	position_for_building = pos
	building.set_position(position_for_building)
	move_to(pos)

#create buttons for these or keys ?
func exited_building(): # restore worker
	health_bar.show()
	get_node("Sprite").show()
	get_node("Shadow").show()
	get_node("World_collider").disabled = false
	get_node("Combat/CollisionPolygon2D").disabled = false
	get_node("Gatherer/CollisionShape2D").disabled = false
	get_node("Scan_Area/CollisionShape2D").disabled = false
	get_node("Selectable/CollisionPolygon2D").disabled = false
	get_node("Selectable").set_deferred("monitorable", true)
	get_node("Area_Availability/CollisionShape2D").disabled = false

func entered_building(): #remove worker
	health_bar.hide()
	get_node("Sprite").hide()
	get_node("Shadow").hide()
	get_node("World_collider").disabled = true
	get_node("Combat/CollisionPolygon2D").disabled = true
	get_node("Gatherer/CollisionShape2D").disabled = true
	get_node("Scan_Area/CollisionShape2D").disabled = true
	get_node("Selectable").set_deferred("monitorable", false)
	get_node("Selectable/CollisionPolygon2D").disabled = true
	get_node("Area_Availability/CollisionShape2D").disabled = true
	worker_selected = false

func build():
	if building != null:
		get_parent().add_child(building)
	else:
		worker_state = IDLE
		print("NO BUILDING")
	#clear other vars
	building = null

# short ones
func has_states(): return true
func get_team(): return team_no
func set_team(team): team_no = team
func get_object_type(): return get_name()
func set_state(state): worker_state = state
func set_override_walk(): worker_state = WALK
func set_target(target_pos): target = target_pos
func waits_building(value): waiting_building = value
func hide_butons(): if button_container != null: button_container.hide()
func load_buttons():if button_container != null: button_container.show()
# Flag Signals
func _on_IDLE_Timer_timeout(): waiting = false
func _on_Selectable_mouse_entered(): mouse_on = true
func _on_Selectable_mouse_exited(): mouse_on = false
func _on_Resource_Timer_timeout(): can_send_resources = true
func _on_Gatherer_area_exited(_area): resource_available = false
func _on_Worker_Scan_area_exited(area): secondary_tasks.erase(area.get_parent().get_node(".").get_instance_id())
func _on_Worker_Scan_area_entered(area): secondary_tasks.append(area.get_parent().get_node(".").get_instance_id())
func _on_Combat_area_entered(area): enemy = area.get_parent().get_node(".").get_instance_id()
func _on_Combat_area_exited(_area): enemy = null
func _on_Area_Availability_area_entered(_area): area_available = false
func _on_Area_Availability_area_exited(_area): area_available = true
func _on_Gatherer_area_entered(area):
	current_resource = area.get_parent()
	resource_available = true
