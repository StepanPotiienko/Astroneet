extends Node3D


@onready var celestial_bodies := []


const G: float = 6.67e3


func _ready():
	for i in get_children():
		if i is RigidBody3D:
			celestial_bodies.append(i)


func _physics_process(delta):
	for body1 in celestial_bodies:
		for body2 in celestial_bodies:
			if body1 != body2:
				orbit(delta, body1, body2)


func pow_vector(vec: Vector3, to: float):
	vec.x *= to
	vec.y *= to
	vec.z *= to

	return Vector3(vec.x, vec.y, vec.z).normalized()

"""

For planet to be static (not moving on its orbit), it has to satisfy following equation:
	|F_a|=|F_G|, where F_a is force that is pushing the planet closer to the centre of the system, 
	and F_G is a gravitational force.
	By simplifying, we've got:
		GM-v^2=-m,
		where G is a gravitational constant, M is the mass of the star, v is an orbital velocity of the planet,
		and m is the planet's mass.
	By now the planet should be static, yet we have to figure out how to move it.

"""

func orbit(delta, body1, body2):
	var gravitational_force = (body2.global_transform.origin - body1.global_transform.origin).normalized() \
	* G * body1.mass * body2.mass \
	/ pow((body2.global_transform.origin.distance_to(body1.global_transform.origin)), 2)
	
	var starting_point = Vector3(-251, 0, 0)
		
	# v = x-x0/t
	var velocity: Vector3 = body1.global_transform.origin - starting_point / 1
	
	var central_force = body1.mass * pow_vector(velocity, 2) \
	/ (body1.global_transform.origin - starting_point).x

	body1.apply_central_impulse(central_force + gravitational_force * delta)
