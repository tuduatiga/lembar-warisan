class_name Pocong extends CharacterBody2D

const _MOVEMENT_SPEED: float = 100.0

var _animated_sprite: AnimatedSprite2D
var _navigation_agent: NavigationAgent2D


func _ready() -> void:
	self._animated_sprite = self.find_child("AnimatedSprite2D")
	self._navigation_agent = self.find_child("NavigationAgent2D")

	self._navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))


func set_movement_target(movement_target: Vector2) -> void:
	self._navigation_agent.set_target_position(movement_target)


func _physics_process(_delta) -> void:
	if self.velocity.x:
		self._animated_sprite.flip_h = self.velocity.x < 0

	if NavigationServer2D.map_get_iteration_id(self._navigation_agent.get_navigation_map()) == 0:
		return

	if self._navigation_agent.is_navigation_finished():
		return

	var new_velocity: Vector2 = (
		self.global_position.direction_to(self._navigation_agent.get_next_path_position())
		* self._MOVEMENT_SPEED
	)

	if self._navigation_agent.avoidance_enabled:
		self._navigation_agent.set_velocity(new_velocity)
	else:
		self._on_velocity_computed(new_velocity)


func _on_velocity_computed(safe_velocity: Vector2) -> void:
	self.velocity = safe_velocity
	self.move_and_slide()
