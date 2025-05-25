extends Camera2D

var desired_offset: Vector2
var max_offset: int = 30
var min_offset: int = -30

func _process(_delta: float) -> void:
	desired_offset = (self.get_global_mouse_position() - self.global_position) * 0.5
	desired_offset.x = clamp(desired_offset.x, min_offset, max_offset)
	desired_offset.y = clamp(desired_offset.y, min_offset / 1.5, max_offset / 1.5)

	self.global_position = self.get_parent().global_position + desired_offset
