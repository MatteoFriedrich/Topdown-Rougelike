extends Node2D

export var Room1 : PackedScene
export var Room2 : PackedScene
export var BossRoom : PackedScene


export var roomsBeforeBoss = 5

onready var rooms = [Room1, Room2]
#onready var rooms = [BossRoom]
onready var bossRooms = [BossRoom]
onready var roomChange = $RoomChange
onready var ysort = $YSort

func _ready():
	Engine.time_scale = 1
	add_new_room()

func add_new_room():
	if roomsBeforeBoss > 0:
		roomsBeforeBoss -= 1
		for child in ysort.get_children():
			if "Room" in child.name:
				child.queue_free()
	
		var room = rooms[randi() % rooms.size()].instance()
		ysort.add_child(room)
		ysort.get_node("Player").global_position = Vector2(495,547)
		roomChange.play("FadeOut")
	else:
		print("BossRoom")
		for child in ysort.get_children():
			if "Room" in child.name:
				child.queue_free()
	
		var room = BossRoom.instance()
		ysort.add_child(room)
		ysort.get_node("Player").global_position = Vector2(495,547)
		roomChange.play("FadeOut")
