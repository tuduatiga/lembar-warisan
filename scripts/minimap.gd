extends Panel

const UNVISITED_COLOR = Color(0.45, 0.45, 0.45, 1.0)
const VISITED_COLOR = Color(0.65, 0.65, 0.65, 1.0)
const ROOM_RECT_SIZE = 32.0
const SCALE = 7.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


func _draw() -> void:
	var player_pos: Vector2 = self.get_node("/root/Game/Player").global_position

	var nearest_pos: Vector2 = Vector2.INF
	for dungeon_area in self.get_tree().get_nodes_in_group("DungeonArea"):
		if dungeon_area is DungeonArea:
			if dungeon_area._visited:
				var dungeon_dist_sq: float = player_pos.distance_squared_to(dungeon_area.global_position)
				if dungeon_dist_sq < player_pos.distance_squared_to(nearest_pos):
					nearest_pos = dungeon_area.global_position
	
	if nearest_pos == Vector2.INF:
		nearest_pos = Vector2.ZERO
			
	var origin: Vector2 = (
		self.size / 2.0 - (nearest_pos / SCALE)
	)
	
	var first_dungeon_area: Variant = self.get_tree().get_first_node_in_group("DungeonArea")
	if first_dungeon_area:
		draw_line(origin, origin + first_dungeon_area.global_position / SCALE, VISITED_COLOR if first_dungeon_area._visited else UNVISITED_COLOR, ROOM_RECT_SIZE / 4)
	draw_rect(
		Rect2(
			origin.x - ROOM_RECT_SIZE / 2,
			origin.y - ROOM_RECT_SIZE / 2,
			ROOM_RECT_SIZE,
			ROOM_RECT_SIZE
		),
		VISITED_COLOR
	)

	for dungeon_area in self.get_tree().get_nodes_in_group("DungeonArea"):
		if dungeon_area is DungeonArea:
			var dungeon_pos: Vector2 = (
				origin + dungeon_area.global_position / SCALE - Vector2.ONE * ROOM_RECT_SIZE / 2.0
			)

			var other_dungeon_areas: Array[Node] = (
				dungeon_area.owner.find_children("*", "GenMarker")
				. map(
					func(gen_marker: Node) -> Variant: return (
							gen_marker
							. find_children("*", "Marker2D")
							. map(
								func(marker: Node) -> Array[Node]: return marker.get_child(0).find_children("*", "DungeonArea", false)
							)
							. reduce(
								func(acc: Array[Node], other_das: Array[Node]) -> Array[Node]: return acc + other_das,
								[] as Array[Node]
							)
						)
				)
				. reduce(
					func(acc: Array[Node], other_das: Array[Node]) -> Array[Node]: return acc + other_das,
					[] as Array[Node]
				)
			)

			for other_dungeon_area in other_dungeon_areas:
				draw_line(origin + dungeon_area.global_position / SCALE, origin + other_dungeon_area.global_position / SCALE, VISITED_COLOR if other_dungeon_area._visited else UNVISITED_COLOR, ROOM_RECT_SIZE/4)

			draw_rect(
				Rect2(dungeon_pos.x, dungeon_pos.y, ROOM_RECT_SIZE, ROOM_RECT_SIZE),
				VISITED_COLOR if dungeon_area._visited else UNVISITED_COLOR
			)
	
	draw_rect(
		Rect2(
			self.size.x / 2.0 - ROOM_RECT_SIZE / 2,
			self.size.y / 2.0 - ROOM_RECT_SIZE / 2,
			ROOM_RECT_SIZE,
			ROOM_RECT_SIZE
		),
		Color.WHITE,
		false,
		2.0
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
