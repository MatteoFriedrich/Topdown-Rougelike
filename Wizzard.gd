extends KinematicBody2D

export var Player : NodePath = "../../../Player"
onready var player = get_node(Player)

export var Projectile : PackedScene

var velocity = Vector2.ZERO
var health = 2
var is_knocked = false

const POINTS = 2

func _ready():
	yield(get_tree().create_timer(randf()*3), "timeout")
	$Timer.start()

func _process(delta):
	
	
	if health <= 0:
		queue_free()
		
	if (!is_knocked):
		if (player.global_position - global_position).length() < 300:
			var dir = (player.global_position - global_position).normalized()
			velocity = dir*-1000
		else:
			var dir = (player.global_position - global_position).normalized()
			velocity = dir*1000
	move_and_slide(velocity*delta)


func _on_Timer_timeout():
	yield(get_tree().create_timer(0.2), "timeout")
	var projectile = Projectile.instance()
	projectile.dir = (player.global_position - global_position).normalized()
	projectile.global_position = global_position
	get_parent().get_parent().add_child(projectile)
	


func _on_Area2D_area_entered(area):
	health -= 1
	$Timer.start()
	is_knocked = true
	velocity = (player.global_position - global_position).normalized() * -8000
	yield(get_tree().create_timer(0.2), "timeout")
	is_knocked = false
