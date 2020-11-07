package {
	import flash.display.*;
	import flash.text.*;
	import flash.media.*; 
	import flash.net.*;
	import fl.motion.Color;
	import flash.utils.Timer; // timer
	import flash.events.Event; // ATTENZIONE
	import flash.events.TimerEvent; // timer
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Transform;
	import flash.geom.Point;
	
	import id.core.Application;
	import id.core.*;
	import id.core.ApplicationGlobals;
	import gl.events.TouchEvent;
	import gl.events.GestureEvent;
	
	import caurina.transitions.*;
		
	public class QuintoGioco extends TouchSprite {
		
		/***********************************************************/
		/** variabili **********************************************/
		
		// sfondo
		//private var tile:Background = new Background(new Material05(0,0));
		
		// index array
		private var count:int;
		
		
		// colore
		
		// coordinate
		var nuovaX:int;
		var nuovaY:int;
		var vecchiaX:int;
		var vecchiaY:int;
		
		// array per contenitori e musica
		private var containerArray:Array;
		private var pulsantiArray:Array;
		private var formeArray:Array;
		
		private var elencoFormeArray:Array;
		private var formeScelteArray:Array;
		private var shuffledForme:Array;
		
		private var oggettoAttualeCount:Array;
		private var oggettoAttualeX:Array;
		private var oggettoAttualeY:Array;
		private var oggettoPosizione:Array;
		
		private var mp3EffettiArray:Array;
		
		// GRIGLIA
		private var grigliaX:Array = new Array();
		private var grigliaY:Array = new Array();
		private var griglia:Array = new Array();
		// SUONI
		private var mp3Array:Array;
		private var channelArray:Array;
		
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
		var container_11 = new TouchSprite();
		var container_12 = new TouchSprite();
		
		// suoni		
		var channel01:SoundChannel = new SoundChannel();
		var channel02:SoundChannel = new SoundChannel();
		
		var timerScreen:int = 300000;
		var timerGlobale = new Timer(timerScreen, 1);
		
		/*************************************************************/
		/** costruttore **********************************************/
		
		public function QuintoGioco() {
			addEventListener(Event.ADDED_TO_STAGE, addedHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
		}
		
		private function addedHandler(event:Event):void {
			
			// creo le x e le y per la griglia --> MATRICE di X e Y
			for (var k:int = 70; k < this.sfondoRiferimento.width-100; k += 120)
			{
				for (var j:int = 70; j < this.sfondoRiferimento.height-50; j += 100)
				{
					griglia.push([k, j]);
				}
			}
			//trace(griglia);
			//trace("PROVA: " +griglia[0][0]);
			
			// ATTENZIONE: azzerro le x e y in posizione del contenitore buchi per le forme --> MATRICE di X e Y
			for(var asseX:int = 0; asseX < griglia.length; asseX++) {
							/*
							trace("VECCHIA coord: "+griglia[asseX]);
							trace("VECCHIA X: "+griglia[asseX][0]);
							trace("VECCHIA Y: "+griglia[asseX][1]);
							*/
							if(griglia[asseX][0] < 685 &&  griglia[asseX][0] > 315) {
								if(griglia[asseX][1]  < 450 &&  griglia[asseX][1] > 110) {
									//trace("ENTRO NELL'if");
									// ricalcolo x e y con un numero compreso tra 235 e 70 e poi 435 e 70
									griglia[asseX][0]= Math.floor(Math.random() * (235 - 70) + 70);
									griglia[asseX][1]= Math.floor(Math.random() * (435 - 70) + 70);
									//trace("NUOVA X: "+griglia[asseX][0]);
									//trace("NUOVA Y: "+griglia[asseX][1]);
								}
							}
			}
			//trace(griglia);
			
			// id oggetto attuale
			oggettoPosizione = [ ];
			
			for(var id:int=0; id<8; id++){
				var aggiornaPosizione:Boolean= new Boolean(false);
				oggettoPosizione.push(aggiornaPosizione);
			}
			
			// id oggetto attuale
			oggettoAttualeCount = [ ];
			
			for(var id:int=0; id<8; id++){
				var countOggetto:int = new int(0);
				oggettoAttualeCount.push(countOggetto);
			}
			
			// x oggetto attuale
			oggettoAttualeX = [ ];
			
			for(var id:int=0; id<8; id++){
				var oggettoX:int = new int(0);
				oggettoAttualeX.push(oggettoX);
			}
			
			// y oggetto attuale
			oggettoAttualeY = [ ];
			
			for(var id:int=0; id<8; id++){
				var oggettoY:int = new int(0);
				oggettoAttualeY.push(oggettoY);
			}
			
			trace(oggettoAttualeCount);
			trace(oggettoAttualeX);
			trace(oggettoAttualeY);
			
			// suoni
			mp3EffettiArray = ["sceltagioco.mp3"];
			
			mp3Array = ["corretto.mp3", "sbagliato.mp3", "giococompletato.mp3"];
			
			// container per il multitouch
			containerArray = [container_01, container_02, container_03, container_04, container_05,
							  container_06, container_07, container_08];
			
			// forme disponibili
			elencoFormeArray = [forma01, forma02, forma03, forma04, forma05, forma06, forma07, forma08,
								forma09, forma10, forma11, forma12, forma13, forma14, forma15, forma16];
			     
			// tutte le tipologie di forme
			formeArray = [cerchio, quadrato, triangolo, stella, cuore, poligono, rettangolo, rombo];
			
			// forme scelte a random
			formeScelteArray = [];
			
			cerchio.type = "cerchio";
			quadrato.type = "quadrato";
			triangolo.type = "triangolo";
			stella.type = "stella";
			cuore.type = "cuore";
			poligono.type = "poligono";
			rettangolo.type = "rettangolo";
			rombo.type = "rombo";
			
			forma01.type = "cerchio";
			forma02.type = "quadrato";
			forma03.type = "triangolo";
			forma04.type = "stella";
			forma09.type = "poligono";
			forma10.type = "rettangolo";
			forma11.type = "cuore";
			forma12.type = "rombo";
			
			forma05.type = "cerchio";
			forma06.type = "quadrato";
			forma07.type = "triangolo";
			forma08.type = "stella";
			forma13.type = "poligono";
			forma14.type = "rettangolo";
			forma15.type = "cuore";
			forma16.type = "rombo";
			 
			// randomizzo l'array per le FORME --> formeArray e creo shuffledForme
			shuffledForme = new Array(formeArray.length);
			var randomPos:Number = 0;
			for (var i:int = 0; i < shuffledForme.length; i++)
			{
				randomPos = int(Math.random() * formeArray.length);
				shuffledForme[i] = formeArray.splice(randomPos, 1)[0]; 
			}
			
			// creo l'elenco di forme per i PULSANTI --> elencoFormeArray
			for(var j:int = 0; j < shuffledForme.length-4; j++) {
				for(var i:int = 0; i < (elencoFormeArray.length); i++) {
					trace(elencoFormeArray[i].type);
					trace(shuffledForme[j].type);
					if(elencoFormeArray[i].type == shuffledForme[j].type){
						formeScelteArray.push(elencoFormeArray[i]);
					}
				}
				/*
				for(var i:int = 0; i < elencoFormeArray2.length; i++) {
					trace(elencoFormeArray2[i].type);
					trace(shuffledForme[j].type);
					if(elencoFormeArray2[i].type == shuffledForme[j].type){
						formeScelteArray.push(elencoFormeArray2[i]);
					}
				}
				*/
			}
			
			// sistemo x e y delle FORME SCELTE --> shuffledForme
			shuffledForme[0].x = 392;
			shuffledForme[0].y = 182;
			shuffledForme[1].x = 533;
			shuffledForme[1].y = 182;
			shuffledForme[2].x = 385;
			shuffledForme[2].y = 314;
			shuffledForme[3].x = 533;
			shuffledForme[3].y = 314;
				
			// visualizzo il tipo di forma per i pulsanti delle forme --> shuffledForme
			for(var j:int = 0; j < formeScelteArray.length; j++) {
				trace("PULSANTI SCELTI: "+formeScelteArray[j].type)
				
			}
			
			trace("### Schermata --> Primo Gioco aggiunta");
			
			// ***********************************
			// pulsanti --> screen
			
				container_screen_saver.addChild(screensaver);
				container_screen_saver.addEventListener(TouchEvent.TOUCH_DOWN,screenSaver);
			addChild(container_screen_saver);
			
			timerGlobale.addEventListener(TimerEvent.TIMER, onTimerFacce );
			
			function onTimerFacce(evt:TimerEvent):void
			{
				var e:Event = new Event('gotoHome');
				dispatchEvent(e);
			}
			timerGlobale.start();
			
			// ***********************************
			// ***********************************
			// pulsanti --> home
			
			container_button_home.addChild(button_Home);
			container_button_home.addEventListener(TouchEvent.TOUCH_TAP,gotoHome);
			addChild(container_button_home);
			
			// ***********************************
			// ***********************************
			// pulsanti --> forme
			
			caricaGioco();
				
			// on every played frame check if there is any collision detected
      		addEventListener(Event.ENTER_FRAME, checkIfHitTest);
			
			

		}
		private function removedHandler(event:Event):void {
			
		}
		
		/********************************************************/
		/** metodi **********************************************/
		
		private function caricaGioco():void {
						
			for(var i:int = 0; i < containerArray.length; i++) {
				this.x = 0;
				trace("disposizione oggetti");
				//this.sfondoRiferimento.width = stage.stageWidth;
				
				containerArray[i].addChild(formeScelteArray[i]);
				
				// questa funzione mi calcola un numero a random tra MAX e MIN
				function randomRange(max:Number, min:Number = 0):Number
				{
					 return Math.floor(Math.random() * (max - min) + min);
				}
				
				var risultato:int = randomRange(griglia.length);
				trace("RISULTATO: " +risultato);
				// la x e y sono assegnate prendendo una cella a random dalla MATRICE attreverso risultato
				formeScelteArray[i].x = griglia[risultato][0];
				formeScelteArray[i].y = griglia[risultato][1];
				
				formeScelteArray[i].cacheAsBitmapMatrix = formeScelteArray[i].transform.concatenatedMatrix;
				formeScelteArray[i].cacheAsBitmap = true;
				//trace(griglia[risultato][0]);
				//trace(griglia[risultato][1]);
				
				containerArray[i].blobContainerEnabled = true;
				
				//containerArray[i].addEventListener(TouchEvent.TOUCH_DOWN, startDrag_Touch);
				
				containerArray[i].addEventListener(GestureEvent.GESTURE_DRAG_1, startDrag_Gesture);
				containerArray[i].addEventListener(GestureEvent.GESTURE_DRAG_1, screenSaverGesture);
				/*containerArray[i].addEventListener(GestureEvent.GESTURE_DRAG_2, startDrag_Gesture);
				containerArray[i].addEventListener(GestureEvent.GESTURE_DRAG_2, startDrag_Gesture);
				containerArray[i].addEventListener(GestureEvent.GESTURE_DRAG_2, startDrag_Gesture);
				containerArray[i].addEventListener(GestureEvent.GESTURE_DRAG_2, startDrag_Gesture);*/
				containerArray[i].addEventListener(TouchEvent.TOUCH_UP, stopDrag_Release1);
				addChild(containerArray[i]);
				
			}
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
			
			timerGlobale.stop();
		}
		
		private function screenSaver(e:TouchEvent):void {
			timerGlobale.reset();
			timerGlobale.start();
			trace("SCREENSAVER RESET");
		}
		
		private function screenSaverGesture(e:GestureEvent):void {
			timerGlobale.reset();
			timerGlobale.start();
			trace("SCREENSAVER RESET");
		}
		
		private function checkIfHitTest(e:Event):void {
			/*for each (var movie:MovieClip in disegno01) {
			  
			}*/
		}
		
		private function suonoAvvertimento(isShow:Boolean):void {
			if(isShow) {
				trace("FORMA GIUSTA!");
				
				var channel001:SoundChannel = new SoundChannel();
				var audioMp3 = mp3Array[0];
				var mysound:Sound = new Sound(); /* IMPORTANTE */
				mysound.load(new URLRequest("suoni/effetti/" + audioMp3));
				channel001 = mysound.play(0);
			}
			else {
				trace("FORMA SBAGLIATA!");
				
				var channel002:SoundChannel = new SoundChannel();
				var audioMp3 = mp3Array[1];
				var mysound:Sound = new Sound(); /* IMPORTANTE */
				mysound.load(new URLRequest("suoni/effetti/" + audioMp3));
				channel002 = mysound.play(1);
			}
		}
		
		private function startDrag_Touch(e:TouchEvent):void{
			trace("-------------------------------------------------------------------------- CLICK");
			
			var index:int = containerArray.indexOf(e.target);
			trace("INDEX ARRAY: " + index);
			
			trace("TOUCH POINT ID: "+e.touchPointID);
			trace("RELATED OBJECT: "+e.relatedObject);
			trace("PRIMARY TOUCH ATTUALE: "+e.isPrimaryTouchPoint);
			trace("OGGETTO ATTUALE: "+e.tactualObject);
			trace("OGGETTO ATTUALE TARGET: "+e.tactualObject.target);
			trace("OGGETTO ATTUALE ID: "+e.tactualObject.id);
			trace("INDEX TARGET: " + e.target);
			
			//e.target.removeEventListener(TouchEvent.TOUCH_DOWN, startDrag_Press1);
			if(e.target.hasEventListener(TouchEvent.TOUCH_DOWN)){ 
				trace("HA UN LISTENER")
			}
			
			/*
			// ANIMAZIONE SUL CLICK
			Tweener.addTween(e.target.getChildAt(0),{rotation:10,time:0.2,transition:"easeOutQuart", onComplete:func});
			
			function func() {
				Tweener.addTween(e.target.getChildAt(0),{rotation:-10,time:0.2,transition:"easeOutQuart", onComplete:func2});
			}
			function func2() {
				Tweener.addTween(e.target.getChildAt(0),{rotation:0,time:0.8,transition:"easeoutelastic"});
			}
			*/
			
			e.target.startTouchDrag(e.tactualObject.target);
			
			oggettoAttualeCount[index]++;
			trace("COUNT ATTUALE: ***************: "+oggettoAttualeCount[index]);
			if(oggettoAttualeCount[index]==1){
			    // se e solo se ho il primo tocco mi salvo la posizione attuale
				oggettoAttualeX[index] = (e.target.x);
				oggettoAttualeY[index] = (e.target.y);
			   }
		}
		
		
		
		private function startDrag_Gesture(e:GestureEvent):void {
			
			var index:int = containerArray.indexOf(e.target);
			//trace("INDEX ARRAY: " + index);
			//trace("INDEX TARGET: " + e.target);
			
			/*
			Tweener.addTween(e.target.getChildAt(0),{scaleX:1.2,time:0.01,transition:"easeOutQuart"});
			Tweener.addTween(e.target.getChildAt(0),{scaleY:1.2,time:0.01,transition:"easeOutQuart"});
			*/
			
			e.target.getChildAt(0).scaleX = 0.8;
			e.target.getChildAt(0).scaleY = 0.8;
			
			// * GESTURE_DRAG_1 *******************************************
			if(e.type == GestureEvent.GESTURE_DRAG_1) {
				if(e.target.hasEventListener(GestureEvent.GESTURE_DRAG_1)){ 
					trace("HA UN LISTENER")
					e.target.removeEventListener(GestureEvent.GESTURE_DRAG_2, startDrag_Gesture);
				}
				oggettoAttualeCount[index]=1;
				trace("GESTURE -----------------------------------> DRAG_1");
			}
			
			// * GESTURE_DRAG_1 ********************************************
			else if(e.type == GestureEvent.GESTURE_DRAG_2) {
				if(e.target.hasEventListener(GestureEvent.GESTURE_DRAG_1)){ 
					trace("HA UN LISTENER")
					e.target.removeEventListener(GestureEvent.GESTURE_DRAG_1, startDrag_Gesture);
				}
				oggettoAttualeCount[index]=2;
				trace("GESTURE -----------------------------------> DRAG_2");
			}
			
			
			if (oggettoPosizione[index]==false){
				/*
				vecchiaX = (e.target.x);
				vecchiaY = (e.target.y);
				*/
				oggettoAttualeX[index] = (e.target.x);
				oggettoAttualeY[index] = (e.target.y);
				oggettoPosizione[index] = true;
				//trace("AGGIORNA");
			}
			
			e.target.x += e.dx;
        	e.target.y += e.dy;
			
			
			//trace("TARGET X: "+e.target.x);
			//trace("TARGET Y: "+e.target.y);
			
			trace("COUNT ATTUALE: ***************: "+oggettoAttualeCount[index]);
			
			
		}
		private function stopDrag_Release1(e:TouchEvent):void {
			/*
			e.target.addEventListener(GestureEvent.GESTURE_DRAG_1, startDrag_Gesture);
			e.target.addEventListener(GestureEvent.GESTURE_DRAG_2, startDrag_Gesture);
			*/
				
			var index:int = containerArray.indexOf(e.target);
			trace("INDEX ARRAY: " + index);
			
			oggettoAttualeCount[index] = oggettoAttualeCount[index]-1;
			trace("COUNT ATTUALE DOPO: ***************: "+oggettoAttualeCount[index]);
			 
			if(oggettoAttualeCount[index]<1)
				//e.target.addEventListener(GestureEvent.GESTURE_DRAG_2, startDrag_Gesture);
			
			/*
			Tweener.addTween(e.target.getChildAt(0),{scaleX:1.0,time:0.01,transition:"easeOutQuart"});
			Tweener.addTween(e.target.getChildAt(0),{scaleY:1.0,time:0.01,transition:"easeOutQuart"});
			*/
			
			e.target.getChildAt(0).scaleX = 1.0;
			e.target.getChildAt(0).scaleY = 1.0;
			
			/* solo per evento di tipo TOUCH *********/
			//e.target.stopTouchDrag(e.tactualObject.target);
			// myText.text = "NO MATCH";
			
			/* NON TOCCARE ***************************/
			var colore:Boolean = true;
			var hit:Boolean = false;
			
			/* serve solo per evento GESTURE *********/
			oggettoPosizione[index] = false;
			/*****************************************/
			
			for (var i:uint = 0; i < shuffledForme.length; i++){
				//trace("PULSANTE TIPO: "+pulsantiArray[index].type);
				//trace("FORMA TIPO: "+formeArray[i].type);
				
				//if(oggettoAttualeCount[index]<1){
					
					if(formeScelteArray[index].hitTestObject(shuffledForme[i]) ) {
						
						hit=true;
						
						if(formeScelteArray[index].type==shuffledForme[i].type && colore) {
								colore = false;
								//myText.text ="MATCH";
								
								trace(" *** COLLISSIONE OGGETTO *** ");
								
								e.target.visible = false;
								e.target.x = 0;
								e.target.y = 0;
								
								var myColorTransform = new ColorTransform();
								myColorTransform.color = formeScelteArray[index].color;
								shuffledForme[i].transform.colorTransform = myColorTransform;
								
								count++;
								if(count>7){
									timerGlobale.stop();
									trace("RICARICA GIOCO");
									count=0;
									
									trace("gioco finito!");
									// SUONO									
									var channel003:SoundChannel = new SoundChannel();
									var audioMp3 = mp3Array[2];
									var mysound:Sound = new Sound(); /* IMPORTANTE */
									mysound.load(new URLRequest("suoni/effetti/" + audioMp3));
									channel003 = mysound.play(2);
									
									// TIMER
									var timerAggiungi:int = 2000;
									var timer = new Timer(timerAggiungi, 1);
									timer.addEventListener(TimerEvent.TIMER, onTimerMostro );
									
									function onTimerMostro(evt:TimerEvent):void
									{
										var eventquinto:Event = new Event('ricaricaQuintoGioco');
										dispatchEvent(eventquinto);
										
									}
									
									timer.start();
								}
								else
								{
									suonoAvvertimento(true);
								}
								break;
								
						}
						/*e.target.x = oggettoAttualeX[index];
						e.target.y = oggettoAttualeY[index];*/
						/*Tweener.addTween(e.target,{x:oggettoAttualeX[index],time:0.01,transition:"easeOutQuart"});
						Tweener.addTween(e.target,{y:oggettoAttualeY[index],time:0.01,transition:"easeOutQuart"});*/
						e.target.x = 0;
						e.target.y = 0;
					}
				//}

			}
			// solo se hit = TRUE e colore = FALSE => non può suonare SBAGLIATO
			if (hit && colore) {
				suonoAvvertimento(false);		
			}
			if (!hit){
				e.target.x = 0;
				e.target.y = 0;
			}
						
			
		}
	}
}
