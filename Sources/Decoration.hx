package ;

class Decoration {
	var x:Int = 0;
	var y:Int = 0;
	var id:Int = 0;
	public function new (x:Int,y:Int){
		this.x = x;
		this.y = y;
		id = Math.floor(Math.random()*8);
	}
	public function render(g:kha.graphics2.Graphics){
		g.drawSubImage(kha.Assets.images.Spritesheet,x,y,id*16,32,16,16);
	}
}