extends Node2D

@export_file("*.tscn") var end_scene: String
@export_file("*.tscn") var end_scene_l: String
@export_file("*.tscn") var end_scene_r: String

@onready var _marker: GenMarker = get_node("GenMarker")


func _ready() -> void:
	_marker.done_gen.connect(self._on_done_gen)


func _on_done_gen() -> void:
	var end_wall: Node2D = self.get_tree().get_nodes_in_group("Wall").reduce(
		func(acc: Node2D, curr: Node2D) -> Node2D:
			return (
				curr
				if curr.global_position.length_squared() > acc.global_position.length_squared()
				else acc if acc else acc
			)
	)

	if not end_wall:
		return

	var EndScene: Resource = load(self.end_scene)
	if end_wall.name == "WallL":
		EndScene = load(self.end_scene_l)
	elif end_wall.name == "WallR":
		EndScene = load(self.end_scene_r)

	end_wall.get_parent().add_child.call_deferred(EndScene.instantiate())
	end_wall.queue_free.call_deferred()
