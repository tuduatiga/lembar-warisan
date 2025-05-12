extends Area2D

var _timer: Timer
var _wait_time: float
var _time_scale: float


func _init(wait_time, time_scale = 0.5) -> void:
	self._wait_time = wait_time
	self._time_scale = time_scale


func _ready() -> void:
	self.body_entered.connect(_on_body_entered)

	_timer = Timer.new()
	_timer.one_shot = true  # By default, the timer will automatically restart.

	"""
	Note: Timers are affected by Engine.time_scale.
	The higher the time scale, the sooner timers will end.
	How often a timer processes may depend on the framerate or Engine.physics_ticks_per_second.

	sauce: https://docs.godotengine.org/en/stable/classes/class_timer.html
	"""
	_timer.wait_time = self._wait_time * self._time_scale  # README: Ku-* sama `_time_scale` supaya timenya ga terpengaruh sama `Engine.time_scale`
	_timer.timeout.connect(_on_timer_timeout)
	self.add_child(_timer)


func _on_body_entered(body: Node2D) -> void:
	body.get_node("CollisionShape2D").queue_free()

	Engine.time_scale = self._time_scale
	_timer.start()


func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0  # TODO: get value from GameManager

	self.get_tree().reload_current_scene()
