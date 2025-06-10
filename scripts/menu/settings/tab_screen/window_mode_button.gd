extends Control

const _WINDOW_MODES: Array[Dictionary] = [
	{
		"name": "Fullscreen",
		"mode": DisplayServer.WINDOW_MODE_FULLSCREEN,
		"borderless": false,
	},
	{
		"name": "Borderless Fullscreen",
		"mode": DisplayServer.WINDOW_MODE_FULLSCREEN,
		"borderless": true,
	},
	{
		"name": "Windowed",
		"mode": DisplayServer.WINDOW_MODE_WINDOWED,
		"borderless": false,
	},
	{
		"name": "Borderless Window",
		"mode": DisplayServer.WINDOW_MODE_WINDOWED,
		"borderless": true,
	}
]

@onready var _option_button: OptionButton = $SettingsOptionButton/OptionButton


func _ready() -> void:
	for window_mode in self._WINDOW_MODES:
		self._option_button.add_item(window_mode["name"])

	self._option_button.item_selected.connect(self._on_item_selected)


func _on_item_selected(index: int) -> void:
	var selected_config: Dictionary = self._WINDOW_MODES[index]

	DisplayServer.window_set_mode(selected_config["mode"])
	DisplayServer.window_set_flag(
		DisplayServer.WINDOW_FLAG_BORDERLESS, selected_config["borderless"]
	)
