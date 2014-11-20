package com.rocketmandevelopment.grid {
	import com.rocketmandevelopment.math.Vector2D;
	
	import flash.display.Graphics;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Cell {
		public var f:Number = 0;
		public var g:Number = 0;
		public var h:Number = 0;
		public var isClosed:Boolean = false;
		public var isStart:Boolean = false;
		public var isOpen:Boolean = false;
		public var isWalkable:Boolean = true;
		public var encounterID:int = -1;
		
		public var gridC:int;
		public var gridR:int;
		
		private var _neighbors:Array;
		
		public function get neighbors():Array {
			if(!_neighbors) {
				_neighbors = [];
				_neighbors.push(Grid.cellAt(gridC - 1, gridR - 1));
				_neighbors.push(Grid.cellAt(gridC, gridR - 1));
				_neighbors.push(Grid.cellAt(gridC + 1, gridR - 1));
				_neighbors.push(Grid.cellAt(gridC + 1, gridR));
				_neighbors.push(Grid.cellAt(gridC + 1, gridR + 1));
				_neighbors.push(Grid.cellAt(gridC, gridR + 1));
				_neighbors.push(Grid.cellAt(gridC - 1, gridR + 1));
				_neighbors.push(Grid.cellAt(gridC - 1, gridR));
				var len:int = _neighbors.length
				for(var i:int = len - 1; i >= 0; i--) {
					if(_neighbors[i] == null) {
						//trace( "if neighbors null");
						_neighbors.splice(i, 1);
					}
				}
			}
			return _neighbors;
		}
		
		public var parent:Cell;
		
		public function get position():Vector2D {
			return new Vector2D(_x, _y);
		}
		
		public var possibleActions:Array = [];
		public var visited:Boolean = false;
		
		/**
		 * setting and getting x and y
		 **/
		private var _x:int;
		
		public function set x(value:int):void {
			_x = value;
		}
		public function get x():int {
			return _x;
		}
		
		private var _y:int;
		
		public function set y(value:int):void {
			_y = value;
		}
		
		public function get y():int {
			return _y;
		}
		
		public function Cell(x:int, y:int) {
			_x = x;
			_y = y;
		}
		
		public function clear():void {
			f = 0;
			g = 0;
			h = 0;
			isClosed = false;
			isOpen = false;
			parent = null;
			isWalkable = true;
		}
		
		public function draw(g:Graphics, w:Number, h:Number):void {
			if(!isWalkable) {
				g.beginFill(0x000088);
			}
			g.drawRect(_x * w, _y * h, w, h);
			g.endFill();
		}
		
		public function reset():void {
			f = 0;
			g = 0;
			h = 0;
			isClosed = false;
			isOpen = false;
			parent = null;
		}
		
		public function toString():String {
			return "Cell(x: " + _x + " y: " + _y + ")"; // " f: "+ f +" g: "+g+" h: "+h + ")";
		}
	}
}