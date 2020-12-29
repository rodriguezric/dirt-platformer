extends Area2D

export var dialog: Array
signal sign_show_text
var colliding_with_player: bool 

func show_sign():
	if (colliding_with_player):
		emit_signal("sign_show_text", [] + dialog)


func _input(event):
	if (event.is_action_pressed("ui_up")):
		show_sign()


func _on_Area2D_body_entered(body):
	colliding_with_player = true


func _on_Area2D_body_exited(body):
	colliding_with_player = false
