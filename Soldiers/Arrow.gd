extends RigidBody2D

var projectile_speed = 300

func _ready():
	set_gravity_scale(0)

func shoot(start_pos, target_pos):
	self.global_position = start_pos
	var direction = (target_pos - start_pos).normalized()
	self.linear_velocity = direction * projectile_speed
