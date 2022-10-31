extends KinematicBody2D

export var speed = 200
export var friction = 0.1
export var acceleration = 0.095

var can_move = true
var can_dash = true
var is_attacking = false
var rev_attack = false

var velocity = Vector2()
onready var direction = get_input().normalized()

onready var anim = $AnimatedSprite
onready var animplay = $AnimationPlayer
onready var sword_rot_pos = $Position2D2

var health = 10

func get_input():
	var input = Vector2()
	if Input.is_action_pressed('right'):
		input.x += 1
	if Input.is_action_pressed('left'):
		input.x -= 1
	if Input.is_action_pressed('down'):
		input.y += 1
	if Input.is_action_pressed('up'):
		input.y -= 1
	return input

func _process(delta):
	$Node/TextureProgress.value = health
	if health <= 0:
		get_tree().change_scene("res://StartMenu.tscn")
	
	if get_input().normalized() != Vector2.ZERO:
		direction = get_input().normalized()
	
	if (!is_attacking):
		#sword_rot_pos.look_at(get_global_mouse_position())
		sword_rot_pos.rotation = direction.angle()
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)
	if can_move:
		if get_input().normalized().length() > 0:
			velocity = lerp(velocity, direction * speed, acceleration)
		else:
			velocity = lerp(velocity, Vector2.ZERO, friction)
		
		
		if Input.is_action_just_pressed("dash") and can_dash:
			$DashAudio.play()
			var start_vel = velocity
			velocity = direction * (800/2)
			can_move = false
			$HitBox/CollisionShape2D.disabled = true
			can_dash = false
			yield(get_tree().create_timer(0.2), "timeout")
			$HitBox/CollisionShape2D.disabled = false
			velocity = start_vel
			can_move = true
			yield(get_tree().create_timer(0.6), "timeout")
			can_dash = true
		
		if Input.is_action_just_pressed("attack") and (!is_attacking):
			#$AudioStreamPlayer.play()
			if rev_attack:
				animplay.play("AttackRev")
				rev_attack = false
			else:
				animplay.play("Attack")
				rev_attack = true
			
			is_attacking = true
			can_move = false
			yield(get_tree().create_timer(0.5), "timeout")
			is_attacking = false
			can_move = true
	
	if (!is_attacking):
		if get_input().normalized() != Vector2.ZERO:
			anim.play("Move")
			if direction.x > 0:
				anim.flip_h = false
			elif direction.x < 0:
				anim.flip_h = true
			elif direction.y > 0:
				anim.flip_h = true
			elif direction.y < 0:
				anim.flip_h = false
		else:
			anim.play("Idle")
	
	#velocity = move_and_slide(velocity * delta)
	move_and_slide(velocity)

func mod(a,b):
	var c = a/b
	var d = c-floor(c)
	return d*b


func _on_HitBox_area_entered(area):
	health -= 1
	$DamageAudio.play()
	frameFrezze(0.1, 0.4)

func frameFrezze(timescale, duration):
	Engine.time_scale = timescale
	yield(get_tree().create_timer(duration * timescale), "timeout")
	Engine.time_scale = 1
