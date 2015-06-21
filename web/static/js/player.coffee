

class Player
	constructor: (app) ->
		@ix = 0
		@iy = 0
		@kick = 0
		@app = app
	move_intent: (x, y) =>
		if @ix != x
			@ix += x
			@ix = Math.min(Math.max(@ix, -1), 1)
			@app.move_send @state()
		if @iy != y
			@iy += y
			@iy = Math.min(Math.max(@iy, -1), 1)
			@app.move_send @state()
	state: () =>
		{
			x: @ix
			y: @iy
			k: @kick
		}

module.exports = Player
