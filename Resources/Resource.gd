extends StaticBody2D
# instance
onready var resource_focus = get_node("/root/World/Camera_Controller/GUI/Right_Panel/VBoxContainer/Focus_Panel/VBoxContainer/Object_Title")
# params
var mine_deposit = 60000
var mouse_on = false
var resource_name = "Gold Mine"

func _physics_process(_delta):
	if mine_deposit == 0: self.queue_free()

# shorts
func select_object(): return get_name() + " " + str(mine_deposit)
func get_name(): return resource_name
func decrease_deposit(mined): mine_deposit -= mined
func get_deposit(): return mine_deposit
# flags
func _on_Selectable_mouse_entered(): mouse_on = true
func _on_Selectable_mouse_exited(): mouse_on = false
