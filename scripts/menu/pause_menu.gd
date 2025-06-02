class_name PauseMenu extends Control

@onready var _resume_button: Button = $PanelContainer/MarginContainer/VBoxContainer/ResumeButton
@onready var _restart_button: Button = $PanelContainer/MarginContainer/VBoxContainer/RestartButton


func _ready() -> void:
	self.visible = false

	self._resume_button.button_down.connect(self._on_resume_button_pressed)
	self._restart_button.button_down.connect(self._on_restart_button_pressed)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		if self.get_tree().paused:
			self._resume()
		else:
			self._pause()


func _on_resume_button_pressed() -> void:
	print("masuk")
	self._resume()


func _on_restart_button_pressed() -> void:
	print("restart?")
	self.get_tree().reload_current_scene()


func _resume() -> void:
	self.get_tree().paused = false
	self.visible = false


func _pause() -> void:
	print("paused")
	self.get_tree().paused = true
	self.visible = true
