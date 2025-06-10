extends HBoxContainer

@onready var _label: Label = $Label

@export var label_text: String


func _ready() -> void:
	self._label.text = self.label_text
