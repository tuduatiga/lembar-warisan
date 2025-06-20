extends Node2D

@onready var _canvas_layer: CanvasLayer = self.get_node("CanvasLayer")
@onready var _player: Player = self.get_node("Player")


func _ready() -> void:
	Engine.time_scale = 1

	self._canvas_layer.find_child("HearthBar").init(self._player)


