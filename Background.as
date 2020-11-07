package {
	import flash.display.*;
	import flash.events.Event;

	public class Background extends Sprite {
		
		/** variabili *******************************************/
		private var reference	:BitmapData;
		private var tile		:Sprite;
		
		/** costruttore *****************************************/
		public function Background(bitmap:BitmapData)
		{
			addEventListener(Event.ADDED_TO_STAGE, initTile);
			reference 	= bitmap;
		}
		
		/** metodi **********************************************/
		private function initTile(e:Event):void
		{
			stage.scaleMode 	= StageScaleMode.NO_SCALE;
			stage.align 		= StageAlign.TOP_LEFT;
			removeEventListener(Event.ADDED_TO_STAGE, initTile);
			stage.addEventListener(Event.RESIZE, tileBG);
			tileBG();
		}
		
		private function tileBG(e:Event = null):void
		{
			// SE NON c'è NESSUN EVENTO = NULL
			var oldTile:Sprite 	= tile;
			
			tile = new Sprite();
			tile.graphics.beginBitmapFill(reference);
			tile.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			tile.graphics.endFill();

			addChild(tile);

			if (oldTile != null && oldTile != tile)
			{
				removeChild(oldTile);
			}
			
		}
				
	}
	
}
