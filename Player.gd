extends KinematicBody2D

const ACCELERATION = 10000
const MAX_SPEED = 105

const JUMP_FORCE = 200

const FRICTION = 0.25
const AIR_RES = 0.025

const GRAVITY = 500

var motion = Vector2.ZERO

onready var sprite = $Sprite
onready var animation = $AnimationPlayer

func _input(event):
	if event.is_action_pressed("jump"):
		jump()
	
	if event.is_action_pressed("ui_right"):
		sprite.flip_h = 0
	
	if event.is_action_pressed("ui_left"):
		sprite.flip_h = 1
	
	if event.is_action_pressed("ui_down"):
		if motion.y > 0 and !is_on_wall():
			motion.y = MAX_SPEED * 2
			

func jump():
	if is_on_floor():
		motion.y = -JUMP_FORCE
	
	if is_on_wall():
		motion.y = -JUMP_FORCE
		motion.x = MAX_SPEED * input_x() * -1


func get_left():
	return Input.get_action_strength("ui_left")


func get_right():
	return Input.get_action_strength("ui_right")


func input_x():
	return get_right() - get_left()


func wall_cling_correction():
	if is_on_wall():
		if input_x() == 1:
			sprite.flip_h = 0
	
		if input_x() == -1:
			sprite.flip_h = 1

func handle_animations():
	if is_on_floor() and input_x() == 0:
		animation.play("Stand")
	
	if is_on_floor() and input_x() != 0:
		animation.play("Walk")
		
	if not is_on_floor() and motion.y < 0:
		animation.play("Jump")
	
	if not is_on_floor() and motion.y > 0:
		animation.play("Fall")	
		
	if is_on_wall() and not is_on_floor():
		animation.play("Wall Cling")
	
	wall_cling_correction()
	

func walking_physics(delta):
	if is_on_floor():
		motion.x += input_x() * ACCELERATION * delta
		motion.x = lerp(motion.x, 0, FRICTION)

func jumping_physics(delta):
	if !is_on_floor():
		motion.x += input_x() * ACCELERATION * AIR_RES * delta

func wall_cling_physics(delta):
	if is_on_wall() and motion.y > 0:
		motion.y += GRAVITY * delta * AIR_RES
	else:
		motion.y += GRAVITY * delta 

func _physics_process(delta):
	walking_physics(delta)
	jumping_physics(delta)
	wall_cling_physics(delta)
	handle_animations()
			
	motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
	motion = move_and_slide(motion, Vector2.UP)
