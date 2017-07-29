package ;

class Input {
	public var mouseButtonDown:Bool = false;
	public var mousePos = new kha.math.Vector2();
	public var worldMousePos = new kha.math.Vector2();
	public var mouseScroll = 0;
	var project:Project;
	public function new(project:Project){
		kha.input.Mouse.get().notify(mouseDown,mouseUp,mouseMove,mouseWheel);
		kha.input.Keyboard.get().notify(keyDown,keyUp);
		this.project = project;
	}
	function keyDown (key:kha.Key,char:String){
		if (char == "r"){
			project.startBattle();
		}
	}
	function keyUp (key:kha.Key,char:String){}
	function mouseDown(a,b,c){
		mouseButtonDown = true;
	}
	function mouseUp(a,b,c){
		mouseButtonDown = false;
	}
	function mouseMove(a,b,c,d){
		mousePos.x = a;
		mousePos.y = b;
		
		worldMousePos.x = a/4;
		worldMousePos.y = b/4;
	}
	function mouseWheel(scroll){
		mouseScroll += scroll;
	}
}