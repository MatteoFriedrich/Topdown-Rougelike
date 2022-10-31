extends YSort

export var active = true

export var Enemies : NodePath
onready var enemies = get_node(Enemies)

export var slime : PackedScene
export var wizzard : PackedScene
export var demon : PackedScene
onready var enemy_pool = [slime, wizzard, demon]

export var MIN_POINTS = 5
export var MAX_POINTS = 15
var points = 0
var total_points = 0

func _ready():
	total_points = get_point_count()

func _process(delta):
	if (!active):
		return
	
	points = get_point_count()
	if points < MIN_POINTS:
		if total_points < MAX_POINTS:
			var spawner = randi() % 4
			var Enemie = enemy_pool[randi()%enemy_pool.size()]
			spawn(Enemie, spawner)
			yield(get_tree().create_timer(2), "timeout")
			spawner = randi() % 4
			Enemie = enemy_pool[randi()%enemy_pool.size()]
			spawn(Enemie, spawner)
			yield(get_tree().create_timer(2), "timeout")
			spawner = randi() % 4
			Enemie = enemy_pool[randi()%enemy_pool.size()]
			spawn(Enemie, spawner)
	
	if enemies.get_child_count() <= 0:
		get_parent().get_parent().get_parent().get_node("RoomChange").play("FadeIn")

func spawn(Enemie, spawn_point):
	var enemie = Enemie.instance()
	enemie.global_position = get_children()[spawn_point].global_position
	enemies.add_child(enemie)
	total_points += enemie.POINTS

func get_point_count():
	var count = 0
	var children = enemies.get_children()
	for child in children:
		count += child.POINTS
	return count


func _on_Timer_timeout():
	var spawner = randi() % 4
	var Enemie = enemy_pool[randi()%enemy_pool.size()]
	spawn(Enemie, spawner)
