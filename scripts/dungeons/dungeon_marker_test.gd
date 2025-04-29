extends Marker2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var DungeonTest = load("res://scenes/dungeons/dungeon_test.tscn")
	var Wall = load("res://scenes/dungeons/wall.tscn")
	var options = [Wall, DungeonTest]
	var newPart = options.pick_random().instantiate()
	self.add_child.call_deferred(newPart)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
