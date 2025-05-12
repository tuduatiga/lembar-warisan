extends Node2D


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_R:
			self.get_tree().reload_current_scene()
