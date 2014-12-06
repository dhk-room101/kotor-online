//cell has Encounter ID and character has Dialogue ID and party has Get Party By Encounter ID
package packages.map
{
	import com.rocketmandevelopment.grid.Cell;
	import com.rocketmandevelopment.grid.Grid;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import packages.characters.*;
	
	import starling.events.*;
	import starling.rootsprites.StarlingFrontSprite;
	
	public class MapLogic extends Object
	{
		public function MapLogic()
		{
			return;
		}
		
		public function initializeMap(): void
		{
			populateMap();
			setWeapons();
		}
			
		//TO DO         private function portraitClick(arg1:flash.events.MouseEvent):void

		public function populateMap(): void
		{
			//create the grid,  the cells  in the grid have 3-D coordinates, but the grid basically is one plane at an angle, with no depth
			Grid.createGrid(128,128);
			
			//get the statically assigned objects for the current map
			//TO DO programmatically create objects on map
			var cells: Array = MapObjects.getMapObjects(Main.MAP.mapID);
			trace( "map",Main.MAP.mapID, "has",  cells.length, "special cells");
			
			for each (var cell:Cell in cells)
			{
				//trace( "encounter ID",  cell.encounterID);
				Grid.cellAt(cell.gridC, cell.gridR).encounterID = cell.encounterID;
				if(cell.encounterID == 0)//this is starting point in the map
				{
					var selectedCharacter: Character = Main.selectedCharacter;
					//selectedCharacter.cells.splice(0,1);
					selectedCharacter.cells.push(cell);
				}
				else
				{
					var character: Character = NPC.getNPCByEncounterID(cell.encounterID);
					character.cells.push(cell);
					if( character.avatar == null)	var avatar: Avatar = new Avatar( character, true);
					avatar.setAvatar(character);
					
					//Main.MAP.allCharacters[cell.encounterID] = character;
					Main.MAP.allCharacters.push(character);
				}
			}
			
			//setting current grid
			var _grid:Grid = Grid.getGrid();
			_grid.gridID = Main.MAP.mapID;
			Main.mapGrids[Main.MAP.mapID] = _grid;
			Main.currentGrid = Main.mapGrids[Main.MAP.mapID];
			positionObjects();
		}
		
		public function positionObjects(): void
		{
			for each (var character: Character in Main.MAP.allCharacters)
			{
				var cell: Cell = character.cells[0];

				character.routeVector = Grid.cellAt(cell.gridC, cell.gridR).position;
				
				//startCell(cell);
				if(character.selected == false)
				{
					for( var m:int=0;m< character.characterMesh.length;m++)
					{
						character.characterMesh[m].position = character.routeVector;
						character.characterMesh[m].rotation = new Vector3D(0,45,0);
					}
				}
				else//this is the selected character, so the camera is positioned relative to its position
				{
					for(m=0;m<character.characterMesh.length;m++)
					{
						character.characterMesh[m].position = character.routeVector;
					}
					Main.away3dView.camera.position = character.routeVector.add(Main.cameraDelta).subtract(Main.MAP3D.adjustCamera);
				}
			}
		}
		
		/*public function startCell(cell:Cell): void
		{
		var _sStart:Sprite = new Sprite;
		_sStart.name= "cellStart";
		var _iStart:Image = new Image(Assets.getAtlas("SPECIALS").getTexture("square_red"));
		_iStart.alpha = 0.5;
		_iStart.width = Main.cellSize;
		_iStart.height = Main.cellSize;
		var _string: String = String(cell.gridC) + " " +  String(cell.gridR);
		var _text:TextField = new TextField( Main.cellSize,Main.cellSize,_string, "Helvetica", 10, 0x000000);
		_sStart.x = Main.mapGrids[Main.MAP.mapID].grid[cell.gridC][cell.gridR].x;
		_sStart.y = Main.mapGrids[Main.MAP.mapID].grid[cell.gridC][cell.gridR].y;
		//trace( "Sprite",_sStart.x,_sStart.y, "out of",Main.APP_WIDTH,Main.APP_HEIGHT);
		_sStart.addChild(_iStart);
		_sStart.addChild(_text);
		addChild(_sStart);
		}*/
		
		public function setWeapons(): void
		{
			//setting weapon for active characters on current map
			for each (var character: Character in Main.MAP.allCharacters)
			{
				if(character.activeWeapon != -1)
					Weapon.setWeapon(character,character.activeWeapon);
			}
		}
	}
}