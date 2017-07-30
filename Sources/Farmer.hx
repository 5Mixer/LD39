package ;

class Farmer extends Citizen {
	override public function new (project){
		super(project);
		tileType = NationGrid.Tile.Farmer;
		returned = true;
	}
	override public function render(g:kha.graphics2.Graphics){
		// if (activity == returning || returned) g.color = kha.Color.Red;
		g.drawSubImage(kha.Assets.images.Spritesheet,pos.x,pos.y,3*16,0,16,16);
		g.color = kha.Color.White;
	}
	
	override function idle () {
		
	}
}