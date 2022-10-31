extends Control


func _ready():
	pass


func _on_MainMenu_button_down():
	get_tree().change_scene("res://StartMenu.tscn")
