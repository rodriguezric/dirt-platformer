extends "res://submodules/Godot-State-Machine/StateMachine.gd"

func _ready():
	add_state("idle")
	add_state("walk")
	add_state("jump")
	add_state("wall_cling")
	

func _enter_state(new_state, old_state):
	pass
