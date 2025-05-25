class_name Pocong extends CharacterBody2D

const _MOVEMENT_SPEED: float = 100.0

var _animated_sprite: AnimatedSprite2D
var _navigation_agent: NavigationAgent2D

var _health_component: HealthComponent

func _ready() -> void:
	self._animated_sprite = self.find_child("AnimatedSprite2D")
	self._navigation_agent = self.find_child("NavigationAgent2D")

	self._navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))

	self._health_component = self.find_child("HealthComponent")
	self._health_component.damage_taken.connect(_on_damage_taken)

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

func _on_damage_taken(health: int) -> void:
	print(health)
	self.modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	self.modulate = Color.WHITE

	if health <= 0:
		self.queue_free()
