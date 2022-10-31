extends KinematicBody2D

export var Player : NodePath = "../../../Player"
onready var player = get_node(Player)

var velocity = Vector2.ZERO

const POINTS = 1

func _ready():
	pass

func _process(delta):
	var dir = (player.global_position - global_position).normalized()
	if velocity.x > 0:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
	velocity = lerp(velocity, dir*6000, 1.0)
	
	move_and_slide(velocity*delta)


func _on_Area2D_area_entered(area):
	queue_free()
