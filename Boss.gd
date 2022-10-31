extends KinematicBody2D

var velocity = Vector2.ZERO
var dir = Vector2.ZERO
var speed = 1000
var is_attacking = false
var hurt = false
var dead = false

export var health = 15
export var Player : NodePath  = "../../../Player"
onready var player = get_node(Player)
onready var anim = $AnimatedSprite
onready var hitBox = $HitBox

const POINTS = 1

func _ready():
	pass

func _process(delta):
	if dead:
		return
	if health <= 0:
		dead = true
		anim.play("Die")
		var enemies = get_parent()
		for enemie in enemies.get_children():
			if enemie != self:
				enemie.queue_free()
		enemies.get_parent().get_node("Timer").stop()
		yield(get_tree().create_timer(1.5), "timeout")
		visible = false
		yield(get_tree().create_timer(0.2), "timeout")
		get_tree().change_scene("res://WinnScreen.tscn")
	
	if player in $Area2D.get_overlapping_bodies():
		if (is_attacking or hurt):
			return
		
		is_attacking = true
		anim.play("Attack")
		yield(get_tree().create_timer(0.9), "timeout")
		hitBox.get_node("CollisionShape2D").disabled = false
		yield(get_tree().create_timer(0.2), "timeout")
		hitBox.get_node("CollisionShape2D").disabled = true
		yield(get_tree().create_timer(0.4), "timeout")
		
		is_attacking = false
		if player.global_position.x > global_position.x:
			anim.flip_h = true
			hitBox.scale.x = -1
		else:
			anim.flip_h = false
			hitBox.scale.x = 1
		dir = (player.global_position - global_position).normalized()
		
	if !is_attacking and !hurt:
		move_and_slide(dir*speed*delta)
		anim.play("Move")

func _on_Timer_timeout():
	if dead:
		return
	if (is_attacking):
		return
	
	if player.global_position.x > global_position.x:
		anim.flip_h = true
		hitBox.scale.x = -1
	else:
		hitBox.scale.x = 1
		anim.flip_h = false
	
	dir = Vector2((player.global_position - global_position).x, (player.global_position - global_position).y * 3).normalized()


func _on_HurtBox_area_entered(area):
	if dead:
		return
	hurt = true
	health -= 1
	if (!is_attacking):
		anim.play("Hurt")
	yield(get_tree().create_timer(0.3), "timeout")
	hurt = false
	
