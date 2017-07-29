package ;

class Input {
	public var mouseButtonDown:Bool = false;
	public var mousePos = new kha.math.Vector2();
	public var worldMousePos = new kha.math.Vector2();
	public var mouseScroll = 0;
	public function new(){
		kha.input.Mouse.get().notify(mouseDown,mouseUp,mouseMove,mouseWheel);
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
		
		worldMousePos.x = a/4;
		worldMousePos.y = b/4;
	}
	function mouseWheel(scroll){
		mouseScroll += scroll;
	}
}