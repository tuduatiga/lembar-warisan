extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.area_entered.connect(_area_entered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _area_entered(area: Area2D) -> void:
	var WallL = load("res://scenes/dungeons/wall_l.tscn")
	var newWallL = WallL.instantiate()
	self.get_parent().get_parent().add_child.call_deferred(newWallL)
	print(area)
	self.get_parent().queue_free()
	pass
