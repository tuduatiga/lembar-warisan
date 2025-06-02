extends Node2D

@onready var _canvas_layer: CanvasLayer = self.get_node("CanvasLayer")
@onready var _player: Player = self.get_node("Player")


func _ready() -> void:
	Engine.time_scale = 1

	self._canvas_layer.find_child("HearthBar").init(self._player)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_R:
			self.get_tree().reload_current_scene()
