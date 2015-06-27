

class Player
	constructor: (app) ->
		@ix = 0
		@iy = 0
		@kick = 0
		@pass = 0
		@app = app
	move_intent: (x, y, k, p) =>
		if @ix != x
			@ix += x
			@ix = Math.min(Math.max(@ix, -1), 1)
			@app.move_send @state()
		if @iy != y
			@iy += y
			@iy = Math.min(Math.max(@iy, -1), 1)
			@app.move_send @state()
		if @kick != k
			@kick += k
			@kick = Math.min(Math.max(@pass, -0), 1)
			@app.move_send @state()
		if @pass != p
			@pass += p
			@pass = Math.min(Math.max(@pass, 0), 1)

	state: () =>
		{
			x: @ix
			y: @iy
			k: @kick
			p: @pass
		}

module.exports = Player
