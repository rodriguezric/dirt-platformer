extends KinematicBody2D

const ACCELERATION = 10000
const MAX_SPEED = 105

const JUMP_FORCE = 200

const FRICTION = 0.25
const AIR_RES = 0.05

const GRAVITY = 500

var motion = Vector2.ZERO
var direction = 1

onready var sprite = $Sprite
onready var animation = $AnimationPlayer
onready var state_machine = $StateMachine
onready var jump_buffer = $JumpBuffer
onready var left_foot = $LeftFoot
onready var right_foot = $RightFoot
onready var left_hand = $LeftHand
onready var right_hand = $RightHand

func air_movement(delta):
	motion.x += input_x() * ACCELERATION * delta * AIR_RES


func jump():
	motion.y = -JUMP_FORCE
	
	
func wall_jump():
	motion.y = -JUMP_FORCE
	motion.x = backwards() * MAX_SPEED
	sprite.flip_h = not sprite.flip_h


func wall_drop():
	position.x += backwards() * 1
	

func update_sprite_direction():
	if input_x() > 0: 
		sprite.flip_h = false
	
	if input_x() < 0:
		sprite.flip_h = true


func direction():
	return 1 if sprite.flip_h == false else -1
	
	
func backwards():
	return -1 * direction()


func apply_gravity(delta):
	motion.y += delta * GRAVITY
	

func apply_velocity(delta):
	motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
	motion = move_and_slide(motion, Vector2.UP)
	
	
func apply_friction():
	motion.x = lerp(motion.x, 0, FRICTION)	

	
func get_left():
	return Input.get_action_strength("ui_left")


func get_right():
	return Input.get_action_strength("ui_right")


func input_x():
	return get_right() - get_left()
	
	
func walk(delta):
	motion.x += input_x() * ACCELERATION * delta


func wall_cling(delta):
	if motion.y > 0:
		motion.y *= 0.5
	
	
func wall_cling_correction():
	if right_wall_collision():
		sprite.flip_h = false
		
	if left_wall_collision():
		sprite.flip_h = true
	
	
func start_jump_buffer():
	jump_buffer.start()
	
	
func stop_jump_buffer():
	jump_buffer.stop()
	
	
func can_buffer_jump():
	return not jump_buffer.is_stopped()


func foot_collisions():
	return (
		left_foot.is_colliding() or 
		right_foot.is_colliding()
	)
	
	
func hand_collisions():
	return (
		left_hand.is_colliding() or 
		right_hand.is_colliding()
	)


func wall_collision():
	return (
		hand_collisions() and 
		foot_collisions()
	)

func left_wall_collision():
	return (
		left_foot.is_colliding() and 
		left_hand.is_colliding()
	)
	
func right_wall_collision():
	return (
		right_foot.is_colliding() and 
		right_hand.is_colliding()
	)


