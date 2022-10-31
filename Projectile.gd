extends Area2D

var dir = Vector2.ZERO


func _ready():
	pass

func _process(delta):
	rotation = dir.angle()
	position += dir * delta * 150


func _on_Timer_timeout():
	queue_free()


func _on_Projectile_area_entered(area):
	queue_free()
