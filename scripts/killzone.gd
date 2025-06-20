extends Area2D

var _timer: Timer
var _wait_time: float
var _time_scale: float


func _init(wait_time: float, time_scale: float = 0.5) -> void:
	self._wait_time = wait_time
	self._time_scale = time_scale


func _ready() -> void:
	self.body_entered.connect(self._on_body_entered)

	self._timer = Timer.new()
	self._timer.one_shot = true  # By default, the timer will automatically restart.

	"""
	Note: Timers are affected by Engine.time_scale.
	The higher the time scale, the sooner timers will end.
	How often a timer processes may depend on the framerate or Engine.physics_ticks_per_second.

	sauce: https://docs.godotengine.org/en/stable/classes/class_timer.html
	"""
	# README: Ku-* sama `_time_scale` supaya timenya ga terpengaruh sama `Engine.time_scale`
	self._timer.wait_time = self._wait_time * self._time_scale
	self._timer.timeout.connect(self._on_timer_timeout)
	self.add_child(self._timer)


func _on_body_entered(body: Node2D) -> void:
	body.get_node("CollisionShape2D").queue_free()

	Engine.time_scale = self._time_scale
	self._timer.start()


func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0  # TODO: get value from GameManager

	self.get_tree().reload_current_scene()
