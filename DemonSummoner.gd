extends KinematicBody2D

export var Player : NodePath = "../../../Player"
onready var player = get_node(Player)
export var Demon : PackedScene

var velocity = Vector2.ZERO
var health = 4
var is_knocked = false

const POINTS = 1

func _ready():
	pass

func _process(delta):
	if velocity.x > 0:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
	
	if health <= 0:
		queue_free()
	
	if (!is_knocked):
		if (player.global_position - global_position).length() < 100:
			var dir = (player.global_position - global_position).normalized()
			velocity = lerp(velocity, dir*-2000, 0.009)
		else:
			var dir = (player.global_position - global_position).normalized()
			velocity = lerp(velocity, dir*2000, 0.009)
	else:
		velocity = lerp(velocity, Vector2.ZERO, 0.009)
	
	move_and_slide(velocity*delta)

func spawn():
	var demon = Demon.instance()
	demon.global_position = global_position + ((player.global_position - global_position).normalized()*20)
	get_parent().add_child(demon)


func _on_Timer_timeout():
	spawn()


func _on_Area2D_area_entered(area):
	health -= 1
	$Timer.start()
	is_knocked = true
	velocity = (player.global_position - global_position).normalized() * -8000
	yield(get_tree().create_timer(0.2), "timeout")
	is_knocked = false
	velocity = (player.global_position - global_position).normalized()*500
