extends "res://submodules/Godot-State-Machine/StateMachine.gd"

func _ready():
	add_state("idle")
	add_state("walk")
	add_state("jump")
	add_state("fall")
	add_state("wall_cling")
	add_state("attack")
	call_deferred("set_state", states.idle)
	
func left_or_right(event):
	if event.is_action_pressed("ui_right"):
		return true
		
	if event.is_action_pressed("ui_left"):
		return true

func _input(event):
	if event.is_action_pressed("jump"):
		if in_grounded_states() or parent.can_buffer_jump():
			parent.stop_jump_buffer()
			parent.jump()
			set_state(states.jump)

		if state == states.wall_cling:
			parent.wall_jump()
			set_state(states.jump)
	
	if event.is_action_pressed("ui_down"):
		if state == states.wall_cling:
			set_state(states.fall)
	
	if left_or_right(event):
		if in_air_states():
			if parent.is_on_wall():
				return states.wall_cling
		

func _state_logic(delta):
	parent.apply_gravity(delta)
	
	if in_air_states():
		parent.air_movement(delta)
		
	match state:
		states.idle:
			parent.apply_friction()
		states.walk:
			parent.walk(delta)
		states.wall_cling:
			parent.wall_cling(delta)
	
	parent.apply_velocity(delta)


func in_grounded_states():
	return state in [states.idle, states.walk]


func in_air_states():
	return state in [states.jump, states.fall]


func _get_transition(delta):
	if in_grounded_states():
		parent.update_sprite_direction()
		
		if !parent.is_on_floor():
			return states.fall
	
	if in_air_states():
		if parent.wall_collision():
			return states.wall_cling
			
	match state:
		states.idle:
			if parent.input_x() != 0:
				return states.walk
				
		states.walk:
			if parent.input_x() == 0:
				return states.idle
				
		states.jump:
			if parent.motion.y > 0:
				return states.fall
			
			if parent.is_on_floor():
				return states.idle
			
		states.fall:
			if parent.is_on_floor():
				return states.idle
		
		states.wall_cling:
			parent.wall_cling_correction()
			
			if not parent.wall_collision():
				return states.jump
			
			if parent.is_on_floor():
				return states.idle
				
	return state

func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.animation.play("Stand")
		states.walk:
			parent.animation.play("Walk")
		states.jump:
			parent.animation.play("Jump")
		states.fall:
			parent.animation.play("Fall")
			if [states.idle, states.walk].has(old_state):
				parent.start_jump_buffer()
		states.wall_cling:
			parent.animation.play("Wall Cling")

func _exit_state(old_state, new_state):
	pass
