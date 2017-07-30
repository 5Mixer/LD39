package ;

class Head extends Particle {
	var starty = 0.;
	var fall = 4;
	override public function new (pos:kha.math.Vector2){
		super(pos.add(new kha.math.Vector2(3,0)));
		velocity = new kha.math.Vector2((Math.random()*8)-4,-3);
		life = 80 + Math.floor(Math.random() * 40);
		starty = pos.y;
		fall = 4+Math.floor(Math.random()*4);
	}
	override public function render(g:kha.graphics2.Graphics){
		g.drawSubImage(kha.Assets.images.Spritesheet,pos.x,pos.y,7*16,16,16,16);
	}
	override public function update (){
		super.update();
		if (pos.y > starty+fall){
			velocity.y *= -.7;
		}else{
			velocity.y += .8;
		}
	}
}