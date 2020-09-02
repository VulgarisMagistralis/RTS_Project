extends KinematicBody2D

var max_health = 15000
# exports
export(int) var team_no setget set_team, get_team
export(int) var speed  = 100
export(bool) var auto_attack = true
# instance
onready var timer = $Timer
onready var sprite = $Sprite
onready var attack_now = $Attack_Speed
onready var root_node = get_node("/root/World")
onready var arrow = preload("res://Soldiers/Arrow.tscn")
onready var soldier_focus = get_node("/root/World/Camera_Controller/GUI/Right_Panel/VBoxContainer/Focus_Panel/VBoxContainer/Object_Title")
# flags
var waiting = false
var is_hurt = false
var ally_hurt = false
var enemy_near = false
var under_attack = false
var task_available = false
var soldier_selected = false
# params
var enemy = null
var siege_def  = 0.1 # blocks (100-X)% damage on catapults
var blade_def  = 0.1 # blocks (100-X)% damage on blades
var pierce_def = 0.1 # blocks (100-X)% damage on arrows
var evasion = 10 # evades X%
var crit_mult = 2
var crit_chance = 4# out of 100
var base_damage = 30
var health = max_health
var healing_rate = 0.3
var soldier_type = SOLDIER_TYPE.MELEE
var animation = "idle_front"
var soldier_state = IDLE
var target = Vector2.ZERO
var velocity = Vector2.ZERO
var attack_rate = 2.1
var target_list = []
var targets_in_range = []
enum SOLDIER_TYPE{ MELEE, RANGE, SIEGE}
enum{ ATTACK, IDLE, HEAL, WALK}

func test_dummy():
	init_soldier_params([ 0.1, 0.1, 0.1, 10, 2, 4, max_health, 30])
	
func _ready():
	if team_no != 1:
		test_dummy()

func init_soldier_params(parameters):
	siege_def = parameters[0]
	pierce_def = parameters[1]
	blade_def = parameters[2]
	evasion = parameters[3]
	crit_chance = parameters[4]
	crit_mult = parameters[5]
	max_health = parameters[6]
	health = parameters[6]
	base_damage = parameters[7]

# combat area entered override timer
func _physics_process(_delta):
	if health < 0: queue_free()
	elif health < max_health: is_hurt = true
	sprite.play(animation)
	match soldier_state:
		IDLE:
			#animation = "idle_front" 
			search_task()
		WALK: 
			#animation = "run_front"
			walk()
		HEAL: heal()
		ATTACK:
			attack()
			attack_now.start(attack_rate)

func select_object():
	soldier_selected = true
	return (self.get_name() + "\n" +
	"Team number : " + str(get_team()) + "\n" +
	"Soldier Type: " + str(SOLDIER_TYPE.keys()[soldier_type]) + "\n" +
	"Siege Defense : " + str(siege_def * 100) + "%" + "\n" +
	"Blade Defense : " + str(blade_def * 100) + "%" + "\n" +
	"Pierce Defense: " + str(pierce_def * 100) +"%" + "\n" +
	"Critical Hit Chance:" + str(crit_chance) + "%" + "\n" +
	"Critical Multiplier:" + str(crit_mult) + "x" + "\n" +
	"Health : " + str(health))

func search_task():
#	if under_attack:
#		soldier_state = ATTACK
	if !target_list.empty():
		if targets_in_range.empty():
			move_to(instance_from_id(target_list[0]).global_position)
			return
		soldier_state = ATTACK
	else:
		if is_hurt:
			soldier_state = HEAL
		waiting = true
		timer.start(1)

func heal():
	manipulate_health(healing_rate, get_team(), 0)

func walk():
	velocity = (target - position).normalized() * speed
	if(target - position).length() > 2:  velocity = move_and_slide(velocity)
	else: soldier_state = IDLE

func attack():
	if !targets_in_range.empty() && targets_in_range.find(target_list[0]) > -1:
		instance_from_id(target_list[0]).manipulate_health(attack_modifier(), team_no, soldier_type)
	else:
		under_attack = false
		soldier_state = IDLE
	
func manipulate_health(value, team, attacker_type):
	if get_team() == team:
		if health < max_health:
			health += value
			if health > max_health:
				soldier_state = IDLE
				health = max_health
		else: is_hurt = false
	else:
		var inflicted_damage = defense(value, attacker_type)
		health -= inflicted_damage
		under_attack = true

func defense(incoming_damage, attacker_type):
	if rand_range(1,100) <= evasion: return 0 
	else:
		match attacker_type:
			SOLDIER_TYPE.MELEE: return (incoming_damage * (1 - blade_def))
			SOLDIER_TYPE.RANGE: return (incoming_damage * (1 - pierce_def))
			SOLDIER_TYPE.SIEGE: return (incoming_damage * (1 - siege_def))

func attack_modifier():
	var damage = base_damage
	if crit_chance >= rand_range(1,100): damage = crit_mult *  base_damage
	return damage

func move_to(coords):
	target = coords
	soldier_state = WALK

# short ones
func has_states(): return true
func get_team(): return team_no
func get_health(): return health
func set_team(team): team_no = team
func set_state(state): soldier_state = state
func deselect_object(): soldier_selected = false
func set_target(target_pos): target = target_pos
func set_override_walk(): soldier_state = WALK
func set_target_object(enemy_id): target_list.insert(0, enemy_id)
# Flag Signals
func _on_Attack_Speed_timeout(): attack()
func _on_Soldier_Scan_area_entered(area): if area.get_parent().get_node(".").get_team() != get_team(): target_list.append(area.get_parent().get_node(".").get_instance_id())
func _on_Soldier_Scan_area_exited(area): target_list.erase(area.get_parent().get_node(".").get_instance_id())
func _on_Combat_area_exited(area): targets_in_range.erase(area.get_parent().get_node(".").get_instance_id())
func _on_Timer_timeout(): waiting = false
func _on_Combat_area_entered(area): targets_in_range.append(area.get_parent().get_node(".").get_instance_id())
