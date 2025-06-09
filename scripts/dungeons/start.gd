extends Node2D

@export_file("*.tscn") var end_scene: String
@export_file("*.tscn") var end_scene_l: String
@export_file("*.tscn") var end_scene_r: String

@onready var _marker: GenMarker = get_node("GenMarker")


func _ready() -> void:
	self._marker.done_gen.connect(self._on_done_gen1)


func _on_done_gen1() -> void:
	await get_tree().create_timer(0).timeout

	var done_gen2: bool = self.get_tree().get_nodes_in_group("GenArea").all(
		func(node: Node) -> bool:
			return (
				(
					node
					. get_overlapping_areas()
					. filter(func(area: Area2D) -> bool: return area is GenArea)
					. size()
				)
				== 0
			)
	)

	if done_gen2:
		self._on_done_gen2()


func _on_done_gen2() -> void:
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

	self.get_tree().root.get_node("Game").find_child("MinimapPanel").queue_redraw.call_deferred()

	await get_tree().create_timer(1).timeout
	self.get_tree().root.get_node("Game").find_child("LoadingScreen").hide()
