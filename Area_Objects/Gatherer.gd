extends Area2D

func resource_finished():
	var resources = get_node(".").get_overlapping_areas()
	print(resources)
# breaks on hierarchy
func on_mine_depleted():
	print("mine depleted")

