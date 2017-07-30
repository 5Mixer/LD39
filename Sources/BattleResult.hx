package ;

class BattleResult {
	public var win:Bool;
	var project:Project;
	public var time = 0;
	public var fulltime = 120;
	public var losingNation:NationGrid;
	public function new (win:Bool,project:Project){
		this.win = win;
		this.project = project;
	}
	public function update (){
	}
	public function render(g:kha.graphics2.Graphics){
		// g.drawSubImage(kha.Assets.images.Spritesheet,10,y,2*16,3*16,16*3,16*2);

		time++;

		g.pushTransformation(g.transformation);
		g.transformation._00 = g.transformation._11 = 1;
		g.font = kha.Assets.fonts.mini;
		g.fontSize = 20*Camera.zoom;
		var string = win?"Victory!" : "Defeat!";
		var pos = project.camera.screenToWorld(new kha.math.Vector2(0,0));
		var xoff:Float = (project.frame % (g.font.width(g.fontSize,string)+20))-200;
		
		g.scissor(Math.floor(g.font.width(g.fontSize, "Day: "+project.day)),0,kha.System.windowWidth(),Camera.zoom*18);
		for (i in 0...16){
			g.drawString(string, xoff + (pos.x * Camera.zoom),(pos.y-1)*Camera.zoom);
			xoff += g.font.width(g.fontSize,string)+20;
		}
		g.disableScissor();

		g.color = kha.Color.fromBytes(30,40,50,Math.round(Math.min(256,(Math.sin(time/fulltime)*256*2))));
		g.fillRect(pos.x*Camera.zoom,pos.y*Camera.zoom,kha.System.windowWidth(),kha.System.windowHeight());


		g.transformation._00 = g.transformation._11 = Camera.zoom;
		g.popTransformation();
	}
}