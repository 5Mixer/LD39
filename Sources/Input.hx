package ;

class Input {
	public var mouseButtonDown:Bool = false;
	public var mousePos = new kha.math.Vector2();
	public var worldMousePos = new kha.math.Vector2();
	public var mouseScroll = 0;
	public var keys = new Map<kha.Key,Bool >();
	public var chars = new Map<String,Bool >();
	var project:Project;
	public function new(project:Project){
		kha.input.Mouse.get().notify(mouseDown,mouseUp,mouseMove,mouseWheel);
		kha.input.Keyboard.get().notify(keyDown,keyUp);
		this.project = project;
	}
	function keyDown (key:kha.Key,char:String){
		
		keys.set(key,true);
		chars.set(char,true);

		if (char == " "){
			if (!project.inBattle)
				project.startBattle();
		}
		
	}
	function keyUp (key:kha.Key,char:String){
		
		keys.set(key,false);
		chars.set(char,false);

	}
	function mouseDown(a,b,c){
		mouseButtonDown = true;
	}
	function mouseUp(a,b,c){
		mouseButtonDown = false;
	}
	function mouseMove(a,b,c,d){
		mousePos.x = a;
		mousePos.y = b;
		
		worldMousePos = project.camera.screenToWorld(mousePos);
	}
	function mouseWheel(scroll){
		mouseScroll += scroll;
	}
}