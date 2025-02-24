extends AttackEmitter

@export var burst_count = 8

func fire():
	for _i in range(burst_count):
		super()
