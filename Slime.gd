extends KinematicBody2D

export var Player : NodePath = "../../../Player"
onready var player = get_node(Player)

onready var timer = $Timer
onready var anim = $AnimatedSprite
var velocity = Vector2.ZERO
var dash_dir
var health = 1
var is_knocked = false
var dead = false
var is_attacking = false

const POINTS = 1

func _ready():
	pass

func _process(delta):
	if dead:
		$Area2D/CollisionShape2D.disabled = true
		return
	
	if health <= 0:
		anim.play("Die")
		$Timer1.stop()
		$Timer2.stop()
		dead = true
		
	if(!is_knocked):
		if (!is_attacking):
			anim.play("Move")
			if (player.global_position - global_position).length() > 120:
				var dir = (player.global_position - global_position).normalized()
				velocity = dir*2000
				
				var slime_dirs = []
				for body in $Area2D2.get_overlapping_bodies():
					if body.is_in_group("Slime"):
						slime_dirs.append((body.global_position - global_position).normalized())
				
				velocity += sum_vec_array(slime_dirs) * -500
			else:
				attack()
	else:
		velocity = lerp(velocity, Vector2.ZERO, 0.07)
	move_and_slide(velocity * delta)

func sum_vec_array(array):
	var sum = Vector2.ZERO
	for element in array:
		 sum += element
	return sum

func attack():
	#anim.stop()
	is_attacking = true
	anim.play("Attack")
	
	velocity = Vector2.ZERO
	$Timer1.start()
	yield(get_tree().create_timer(0.75), "timeout")
	dash_dir = (player.global_position - global_position).normalized()

func _on_Area2D_area_entered(area):
	health -= 1
	is_knocked = true
	$Timer1.stop()
	is_attacking = false
	velocity = (player.global_position - global_position).normalized() * -24000
	yield(get_tree().create_timer(0.2), "timeout")
	is_knocked = false

func _on_Timer1_timeout():
	$Timer2.start()
	velocity = (dash_dir) * 20000

func _on_Timer2_timeout():
	is_attacking = false


func _on_AnimatedSprite_animation_finished():
	if dead:
		queue_free()
