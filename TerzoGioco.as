package {
	import flash.display.*;
	import flash.text.*;
	import flash.media.*; 
	import flash.net.*;
	import flash.utils.Timer; // timer
	import flash.events.Event; // ATTENZIONE
	import flash.events.MouseEvent;
	import flash.events.TimerEvent; // timer
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	import id.core.Application;
	import id.core.TouchSprite;
	import id.core.ApplicationGlobals;
	import gl.events.TouchEvent;
	
	import caurina.transitions.*;
		
	public class TerzoGioco extends TouchSprite {
		
		/***********************************************************/
		/** variabili **********************************************/
		
		// sfondo
		//private var tile:Background = new Background(new Material05(0,0));
		
		// contatore
		private var indexMostro:int = 0;
		
		// coordinate
		var nuovaX:int;
		var nuovaY:int;
		var vecchiaX:int;
		var vecchiaY:int;
		
		// index array
		//private var index:int;
		private var colore:Boolean = false;
		
		// array per contenitori e musica
		private var containerArray:Array;
		
		private var disegniArray:Array;
		private var mostriArray:Array;
		private var timerArray:Array;
		private var timerRimuoviArray:Array;
		
		private var oggettiArray:Array;
		private var shuffledOggetti:Array;
		
		private var mp3Array:Array;
		private var mp3EffettiArray:Array;
		
		// timer
		var timer01:Timer;
		var timer02:Timer;
		var timer03:Timer;
		var timer04:Timer;
		var timer05:Timer;
		var timer06:Timer;
		var timer07:Timer;
		
		// contenitori --> TouchSprite
		var container_button_home = new TouchSprite();
		var container_screen_saver = new TouchSprite();
		var container_01 = new TouchSprite();
		var container_02 = new TouchSprite();
		var container_03 = new TouchSprite();
		var container_04 = new TouchSprite();
		var container_05 = new TouchSprite();
		var container_06 = new TouchSprite();
		var container_07 = new TouchSprite();
		var container_08 = new TouchSprite();
		var container_09 = new TouchSprite();
		var container_10 = new TouchSprite();
		
		var container_prato = new TouchSprite();
		
		
		// clip disegni
		var mostri01 = new Mostri();
		var mostri02 = new Mostri();
		
		// disegno corrente
		var currentGraphics:MovieClip;
		
		// timer
		var timerScreen:int = 300000;
		var timer = new Timer(timerScreen, 1);
		
		
		/*************************************************************/
		/** costruttore **********************************************/
		
		public function TerzoGioco() {
			addEventListener(Event.ADDED_TO_STAGE, addedHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
		}
		
		private function addedHandler(event:Event):void {
			
			mp3EffettiArray = ["sceltagioco.mp3"];
			
			mp3Array = ["corretto.mp3", "sbagliato.mp3", "giococompletato.mp3"];
			
			containerArray = [container_01, container_02, container_03, container_04, container_05,
							  container_06, container_07, container_08, container_09, container_10];
			
			disegniArray = [bucamostri01, bucamostri02, bucamostri03, bucamostri04, bucamostri05, 
							bucamostri06, bucamostri07];
			
			
			timerArray = [timer01, timer02, timer03, timer04, timer05, timer06, timer07];
			timerRimuoviArray = [timer01, timer02, timer03, timer04, timer05, timer06, timer07];
			
			// forme scelte a random
			oggettiArray = [];
			
			trace("### Schermata --> Primo Gioco aggiunta");
			//this.x = (stage.stageWidth - this.width) ;
			//this.y = (stage.stageHeight - this.height) ;
			
			// ***********************************
			// pulsanti --> home / prato screen saver
			
			container_prato.addChild(prato);
			//container_prato.addEventListener(TouchEvent.TOUCH_DOWN,suonoSbagliato);
			container_prato.addEventListener(TouchEvent.TOUCH_DOWN,screenSaver);
			addChild(container_prato);
			
			timer.addEventListener(TimerEvent.TIMER, onTimerFacce );
			
			function onTimerFacce(evt:TimerEvent):void
			{
				var e:Event = new Event('gotoHome');
				dispatchEvent(e);
			}
			timer.start();
			
			// ***********************************
			// classe --> mostri
			
			// conto i MovieClip dentro l'arraydisegniArray e prendo solo i MovieClip
			// poi imposto a visible=true uno dei MovieClip a random
			// mentre gli altri MovieClip non li considero e li lascio impostati a false
			for (var i:int = 0; i < disegniArray.length; i++){
				trace("Buca Mostro "+ i + ": "+disegniArray[i].name);
				
				// imposto tutti i MovieClip a visible=false
				for (var j:int = 0; j < disegniArray[i].numChildren; j++){
				   	if (disegniArray[i].getChildAt(j) is MovieClip) {
						trace("movieclip dentro la buca: "+j);
						disegniArray[i].getChildAt(j).visible = false;
						var nome:String = disegniArray[i].getChildAt(j).name;
				  }
				}
				// ATTENZIONE: chiamo la funzione aggiungiMostro()
				// per ogni istanza della classe Mostri contenuta in disegniArray
				aggiungiMostro(i);
				indexMostro = i;
			}			
			
			// ***********************************
			// pulsanti --> mostri
					
			for(var i:int = 0; i < disegniArray.length; i++) {
				this.x = 0;
				containerArray[i].addChild(disegniArray[i]);
				
				//disegniArray[i].y = 470;
				//disegniArray[i].x = 420+(i*90);
				
				//Tweener.addTween(pulsantiArray[i],{x: i*130,time:1.2,transition:"easeoutelastic"});
				//Tweener.addTween(pulsantiArray[i],{y: ((stage.stageHeight-pulsantiArray[i].height)/2),time:1,transition:"easeoutelastic"});
				
				//containerArray[i].blobContainerEnabled = true;
				containerArray[i].addEventListener(TouchEvent.TOUCH_DOWN, clickMostro);
				containerArray[i].addEventListener(TouchEvent.TOUCH_DOWN, screenSaver);
				addChild(containerArray[i]);
				
				//trace("Container x: " + containerArray[i].x);
				//trace("Pulsanti Array height: " + disegniArray[i].height);
			}
			
			// ***********************************
			// pulsanti --> home /prato
			
			container_button_home.addChild(button_Home);
			container_button_home.addEventListener(TouchEvent.TOUCH_DOWN,gotoHome);
			addChild(container_button_home);
				
			// on every played frame check if there is any collision detected
      		addEventListener(Event.ENTER_FRAME, checkIfHitTest);
			
			

		}
		private function removedHandler(event:Event):void {
			
		}
		
		/********************************************************/
		/** metodi **********************************************/
		
		// AGGIUNGI *********************************************************************
		
		private function aggiungiMostro(i:int){
			var timerAggiungi:int = randomTime(5000);
			timerArray[i] = new Timer(timerAggiungi, 1);
			timerArray[i].addEventListener(TimerEvent.TIMER, onTimerMostro );
			
			function onTimerMostro(evt:TimerEvent):void
			{
				var mostroScelto:int = randomRange(5,2);
				//trace("MOSTRO SCELTO: "+ mostroScelto);
				//trace("TARGET: "+indexMostro);
				var index:int = timerArray.indexOf(evt.target);
				//trace("INDEX ARRAY ---- AGGIUNGI: " + index);
				
				
				
				if (disegniArray[index].getChildAt(mostroScelto) is MovieClip) { //ERRORE
					disegniArray[index].getChildAt(mostroScelto).visible = true;
					disegniArray[index].getChildAt(mostroScelto).gotoAndStop(1);
					Tweener.addTween(disegniArray[index].getChildAt(mostroScelto),{y: -170,time:0.8,transition:"easeoutelastic"});								
				}
				rimuoviMostro(index);
			}
			timerArray[i].start();
		}
		
		// RIMUOVI *********************************************************************
		
		private function rimuoviMostro(i:int):void{
			// velocità rimozione mostro: 1 - 2 secondi
			var timerRimuovi:int = randomTime(3000);
			timerRimuoviArray[i] = new Timer(timerRimuovi, 1);
			timerRimuoviArray[i].addEventListener(TimerEvent.TIMER, onTimerRimuoviMostro );
			timerRimuoviArray[i].start();
		}
		
		function onTimerRimuoviMostro(evt:TimerEvent):void {
			
			
			var index:int = timerRimuoviArray.indexOf(evt.target);
			//trace("INDEX ARRAY ---- RIMUOVI: " + index);
			containerArray[index].removeEventListener(TouchEvent.TOUCH_DOWN, clickMostro);
			
			for (var j:int = 0; j < disegniArray[index].numChildren; j++){
				if (disegniArray[index].getChildAt(j).visible == true) {
					if (disegniArray[index].getChildAt(j) is MovieClip) {
						Tweener.addTween(disegniArray[index].getChildAt(j),{y: 0,time:0.8,transition:"easeoutelastic", onComplete:func});
						
						function func() {
							this.visible = false;
							
							for (var j:int = 0; j < disegniArray[index].numChildren; j++){
								if (disegniArray[index].getChildAt(j) is MovieClip) {
									disegniArray[index].getChildAt(j).visible = false;
									disegniArray[index].getChildAt(j).y = 0;
									
									}
								}
							containerArray[index].addEventListener(TouchEvent.TOUCH_DOWN, clickMostro);
							containerArray[index].addEventListener(TouchEvent.TOUCH_DOWN, screenSaver);
						} // func
					} // if
				} // if
				
			}
			aggiungiMostro(index);
		}
		
		
		private function randomRange(max:Number, min:Number = 1):Number
				{
					 return Math.floor(Math.random() * (max - min) + min);
				}
		
		private function randomTime(max:Number, min:Number = 1000):Number
				{
					 return Math.floor(Math.random() * (max - min) + min);
				}
		
		private function gotoHome(event:TouchEvent):void {
			trace("# Evento --> Attivazione Home");
			
			var e:Event = new Event('gotoHome');
			dispatchEvent(e);
			var channel:SoundChannel = new SoundChannel();
			var audioMp3 = mp3EffettiArray[0];
			var mysound:Sound = new Sound(); /* IMPORTANTE */
			mysound.load(new URLRequest("suoni/effetti/" + audioMp3));
			channel = mysound.play(0);
			
			timer.stop();
		}
		
		private function screenSaver(e:TouchEvent):void {
			timer.reset();
			timer.start();
		}
		
		private function suonoSbagliato(event:TouchEvent):void {
			trace("# Evento --> Attivazione suono sbagliato");
			var channel002:SoundChannel = new SoundChannel();
			var audioMp3 = mp3Array[1];
			var mysound:Sound = new Sound(); /* IMPORTANTE */
			mysound.load(new URLRequest("suoni/effetti/" + audioMp3));
			channel002 = mysound.play(1);
			
			
		}
		
		private function checkIfHitTest(e:Event):void {
			
		}
		
		private function suonoAvvertimento(isShow:Boolean):void {
		  if(isShow)
		  {
			var channel001:SoundChannel = new SoundChannel();
			var audioMp3 = mp3Array[0];
			var mysound:Sound = new Sound(); /* IMPORTANTE */
			mysound.load(new URLRequest("suoni/effetti/" + audioMp3));
			channel001 = mysound.play(0);
	 
		  }
		  else
		  {
			var channel002:SoundChannel = new SoundChannel();
			var audioMp3 = mp3Array[1];
			var mysound:Sound = new Sound(); /* IMPORTANTE */
			mysound.load(new URLRequest("suoni/effetti/" + audioMp3));
			channel002 = mysound.play(1);
		  }
		}
		
		private function clickMostro(e:TouchEvent):void {
			
			var index:int = containerArray.indexOf(e.target);
			trace("INDEX ARRAY: " + index);
			
			var hit:Boolean = true;
			
			for (var i:uint = 0; i < disegniArray[index].numChildren; i++){
				
				if (disegniArray[index].getChildAt(i).visible == true) {
					if (disegniArray[index].getChildAt(i) is MovieClip) {
						hit=false;
						var posizione:String = disegniArray[index].getChildAt(i).name;
						trace("Nome Mostro: "+posizione);
						
						trace("current: "+disegniArray[index].getChildAt(i).currentFrame);
						
						if (disegniArray[index].getChildAt(i).currentFrame == 1){
							disegniArray[index].getChildAt(i).play();
							timerRimuoviArray[index].removeEventListener(TimerEvent.TIMER, onTimerRimuoviMostro );
							suonoAvvertimento(true);
							trace(" *** MATCH OGGETTO *** ");
							//timerRimuoviArray[index].stop();
							
							
							// creare un array disegniDisattivatiArray in cui salvo quello che è temporaneamente 
							// disattivato ... si attiva solo se colpisco un altro mostro ovvero devo attivare 
							// tutti gli altri dentro disegniDisattivatiArray
							aggiungiMostro(index);	
						}
						
					}
				}
			}
			
			if (hit) {
				trace(" *** NO MATCH *** ");
				suonoAvvertimento(false);
			}
				
		} // fine Clickmostro
		
	}
}
