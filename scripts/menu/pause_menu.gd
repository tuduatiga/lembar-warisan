class_name PauseMenu extends Control

@onready var _resume_button: Button = $PanelContainer/MarginContainer/VBoxContainer/ResumeButton
@onready var _restart_button: Button = $PanelContainer/MarginContainer/VBoxContainer/RestartButton
@onready var _exit_button: Button = $PanelContainer/MarginContainer/VBoxContainer/ExitButton

@onready var _main_menu: PackedScene = preload("res://scenes/menu/main_menu.tscn")


func _ready() -> void:
	self.hide()

	self._resume_button.button_down.connect(self._on_resume_button_pressed)
	self._restart_button.button_down.connect(self._on_restart_button_pressed)
	self._exit_button.button_down.connect(self._on_exit_button_pressed)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		if self.get_tree().paused:
			self._resume()
		else:
			self._pause()


func _on_resume_button_pressed() -> void:
	self._resume()


func _on_restart_button_pressed() -> void:
	self.get_tree().paused = false
	self.get_tree().reload_current_scene()


func _on_exit_button_pressed() -> void:
	pass


func _resume() -> void:
	self.hide()
	self.get_tree().paused = false


func _pause() -> void:
	self.show()
	self.get_tree().paused = true
