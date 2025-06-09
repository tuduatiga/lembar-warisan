class_name SettingsMenu extends Control

signal exit_settings_menu

@onready var _exit_button: Button = $MarginContainer/VBoxContainer/ExitButton


func _ready() -> void:
	self.hide()
	self.set_process(false)

	self._exit_button.pressed.connect(self._on_exit_button_pressed)


func _on_exit_button_pressed() -> void:
	self.exit_settings_menu.emit()
	self.hide()
	self.set_process(false)
