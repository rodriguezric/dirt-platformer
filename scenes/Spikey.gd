extends KinematicBody2D

onready var animation = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("Crawl")

