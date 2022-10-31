extends VBoxContainer


func _ready():
	pass


func _on_StartButton_button_down():
	get_tree().change_scene("res://Main.tscn")


func _on_QuitButton_button_down():
	get_tree().quit()

