extends Node2D

export(NodePath) var door
var result
signal tp_player

func _physics_process(delta):
	var space_state = get_world_2d().direct_space_state
	
	result = space_state.intersect_ray(position, position + Vector2(8, 0))
	
#	{
#	   position: Vector2 # point in world space for collision
#	   normal: Vector2 # normal in world space for collision
#	   collider: Object # Object collided or null (if unassociated)
#	   collider_id: ObjectID # Object it collided against
#	   rid: RID # RID it collided against
#	   shape: int # shape index of collider
#	   metadata: Variant() # metadata of collider
#	}
	
func _input(event):
	if event.is_action_pressed("ui_up"):
		emit_signal("tp_player", get_node(door).position)
