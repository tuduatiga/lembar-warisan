extends Control

@onready var _margin_container: MarginContainer = $MarginContainer
@onready var _settings_menu: SettingsMenu = $SettingsMenu

@onready
var _play_button: Button = $MarginContainer/GridContainer/VBoxContainer/VBoxContainer/PlayButton
@onready
var _settings_button: Button = $MarginContainer/GridContainer/VBoxContainer/VBoxContainer/SettingsButton
@onready
var _exit_button: Button = $MarginContainer/GridContainer/VBoxContainer/VBoxContainer/ExitButton

@onready var _game: PackedScene = preload("res://scenes/game.tscn")


func _ready() -> void:
	self._play_button.pressed.connect(self._on_play_button_pressed)
	self._settings_button.pressed.connect(self._on_settings_button_pressed)
	self._exit_button.pressed.connect(self._on_exit_button_pressed)

	self._settings_menu.exit_settings_menu.connect(self._on_exit_settings_menu)


func _on_play_button_pressed() -> void:
	self.get_tree().change_scene_to_packed(self._game)


func _on_settings_button_pressed() -> void:
	self._margin_container.hide()
	self._settings_menu.set_process(true)
	self._settings_menu.show()


func _on_exit_settings_menu() -> void:
	self._margin_container.show()


func _on_exit_button_pressed() -> void:
	self.get_tree().quit()
