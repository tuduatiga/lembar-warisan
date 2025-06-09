extends Control

const _WINDOW_MODE: Array[String] = [
	"Fullscreen",
	"Borderless Fullscreen",
	"Window",
	"Borderless Window",
]

@onready var _option_button: OptionButton = $HBoxContainer/OptionButton


func _ready() -> void:
	for window_mode in self._WINDOW_MODE:
		self._option_button.add_item(window_mode)

	self._option_button.item_selected.connect(self._on_item_selected)


func _on_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		3:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
