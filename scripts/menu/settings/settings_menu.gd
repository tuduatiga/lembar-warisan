class_name SettingsMenu extends Control

signal exit_settings_menu

@onready var _exit_button: Button = $MarginContainer/HBoxContainer/ExitButton


func _ready() -> void:
	self._exit_button.button_down.connect(self._on_exit_button_pressed)
	self.set_process(false)


func _on_exit_button_pressed() -> void:
	self.exit_settings_menu.emit()
