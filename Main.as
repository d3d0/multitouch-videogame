package {
	
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.media.*; 
	import flash.net.*;
	import caurina.transitions.*;
	//import flashx.textLayout.formats.Float;
	
	public class Main extends MovieClip {
		
		/********************************************************/
		/** variabili **********************************************/
		
		// sfondo
		private var tile:Background = new Background(new Material05(0,0));
		
		// fullscreen
		private var fullscreen:Full;
		
		// musica
		private var mySound:Sound;
		private var myChannel:SoundChannel = new SoundChannel();
		private var myTransform:SoundTransform = new SoundTransform();
		
		// player
		private var contenitoreTotale:SceltaGioco;
		
		// variabili globali
		public var currentScreen:MovieClip;
		
		/********************************************************/
		/** costruttore *****************************************/
		
		public function Main() 
		{	
			var swfStage:Stage = this.stage;
			swfStage.quality = "medium";
            swfStage.scaleMode = StageScaleMode.NO_SCALE;
            swfStage.align = StageAlign.TOP_LEFT;
			swfStage.showDefaultContextMenu = false;
			//swfStage.displayState = StageDisplayState.FULL_SCREEN; // visibile solo nel .exe
			stage.addEventListener(Event.RESIZE, gestisciResize);
			
			addEventListener(Event.ADDED_TO_STAGE,init);
			addEventListener(Event.REMOVED_FROM_STAGE,destroy);
		}
		
		private function init(evt:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			trace("The application settings have been loaded!");
			
			// creo il mio oggetto di tipo SceltaGioco
			contenitoreTotale = new SceltaGioco();
			
			// assegno l'altezza in base alle proporzioni e calcolo la nuova larghezza
			/*
			var ratio:Number = contenitoreTotale.width/contenitoreTotale.height;
			altezzaGlobale = stage.stageHeight;
			contenitoreTotale.height = altezzaGlobale;
			larghezzaGlobale = contenitoreTotale.height*ratio;
			contenitoreTotale.width = larghezzaGlobale;
			*/
			
			// aggiungo allo stage la mia home e la setto come schermo corrente
			addChild(contenitoreTotale);
			currentScreen = contenitoreTotale;
			
			/** TWEENER *****************************************/
			Tweener.addTween(currentScreen,{x:((stage.stageWidth - contenitoreTotale.sfondoRiferimento.width) / 2),time:1.2,transition:"easeoutelastic"});
			Tweener.addTween(currentScreen,{y:((stage.stageHeight - contenitoreTotale.sfondoRiferimento.height) / 2),time:1,transition:"easeoutelastic"});
			
			
			/** NORMALE *****************************************/
			/*
			player.x=stage.stageWidth /2 - player.width/2;
			trace("player.width: " + player.width);
			player.y=stage.stageHeight/2 - player.height/2;
			trace("player.height: " + player.height);
			*/
						
			/** SFONDO *****************************************/
			addChildAt(tile,0);
			
			/** MUSICA *****************************************/
			/*
			mySound = new Sound();
			mySound.addEventListener(Event.COMPLETE, onSoundLoaded); 
			mySound.load(new URLRequest("audio/musica.mp3"));
			myChannel = mySound.play(0,1000);
			myTransform.volume = 0.1;
			myChannel.soundTransform = myTransform;
			
			// mySound.close();
			
			function onSoundLoaded(event:Event):void 
			{ 
				trace("MUSICA SOTTOFONDO CARICATA");
			}
			*/
			
		}
		
		// DESTROY
		private function destroy(evt:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE,destroy);
			removeChild(currentScreen);
		}
		
		/********************************************************/
		/** metodi **********************************************/
		
		
		// RESIZE / FULLSCREEN
		private function gestisciResize(e:Event):void {
			// assegno l'altezza in base alle proporzioni e calcolo la nuova larghezza
			var ratio:Number = stage.stageWidth/currentScreen.sfondoRiferimento.width;
			trace("RATIO: "+ratio);
			var proporzioneX:Number = currentScreen.sfondoRiferimento.width*ratio;
			contenitoreTotale.scaleX = ratio;
			trace("pprop"+proporzioneX);
			var proporzioneY:Number = currentScreen.sfondoRiferimento.height*ratio;
			contenitoreTotale.scaleY = ratio;
			trace("pprop"+proporzioneY);
			
			Tweener.addTween(currentScreen,{x:((stage.stageWidth - proporzioneX) / 2),time:1.2,transition:"easeoutelastic"});
			Tweener.addTween(currentScreen,{y:((stage.stageHeight - proporzioneY) / 2),time:1,transition:"easeoutelastic"});
			
			/*
			Tweener.addTween(currentScreen,{x:((stage.stageWidth - currentScreen.sfondoRiferimento.width) / 2),time:1.2,transition:"easeoutelastic"});
			Tweener.addTween(currentScreen,{y:((stage.stageHeight - currentScreen.sfondoRiferimento.height) / 2),time:1,transition:"easeoutelastic"});
			*/
			
			/** PULSANTE FULLSCREEN *****************************************/
			/*
			Tweener.addTween(fullscreen,{x:((stage.stageWidth - fullscreen.width) - 20),time:1.2,transition:"easeoutelastic"});
			Tweener.addTween(fullscreen,{y:((stage.stageHeight - fullscreen.height) - 20),time:1,transition:"easeoutelastic"});
			*/
			
			/** NORMALE *****************************************/
			/*
			player.x = (stage.stageWidth - player.width) / 2;
			player.y = (stage.stageHeight - player.height) / 2;
			fullscreen.x = (stage.stageWidth - fullscreen.width) - 20 ;
			fullscreen.y = (stage.stageHeight - fullscreen.height) - 20 ;
			*/
			
			glow_mc.x = (stage.stageWidth - glow_mc.width) / 2;
			glow_mc.y = (stage.stageHeight - glow_mc.height) ;
			
			/** TESTO *****************************************/
			//txtDimentions.text = (stage.stageWidth - player.width).toString() + "x" + (stage.stageHeight).toString();
		};
	}
}