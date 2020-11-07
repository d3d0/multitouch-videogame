////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	GestureLibrary.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Paul Lacey (paul(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com). 
//				
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package gl
{	
	import gl.events.GestureEvent;
	
	import gl.gestures.GestureDrag;
	import gl.gestures.GestureDrag_1;
	import gl.gestures.GestureDrag_2;
	
	import gl.gestures.GestureFlick;
	import gl.gestures.GestureFlick_1;
	import gl.gestures.GestureFlick_2;
	
	import gl.gestures.GestureHold;
	
	import gl.gestures.GestureRotate;
	import gl.gestures.GestureRotate_2;
	
	import gl.gestures.GestureScale;
	import gl.gestures.GestureScale_2;
	
	import gl.gestures.GestureScroll;
	
	import gl.gestures.GestureTilt;
	import gl.gestures.GestureTilt_XZ;
	import gl.gestures.GestureTilt_YZ;
	
	import gl.gestures.GestureTap;
	import gl.gestures.GestureTap_1;
	import gl.gestures.GestureTap_2;
	
	import gl.gestures.GestureDoubleTap;
	import gl.gestures.GestureDoubleTap_1;
	import gl.gestures.GestureDoubleTap_2;
	
	import id.modules.IModuleFactory;
	import id.system.Requires;
	import id.system.SystemRegisterType;
	
	public class GestureLibrary extends GestureCore implements IModuleFactory
	{
		public function GestureLibrary()
		{
			super();
			
			Requires.establish
			(
				GestureLibrary,
				SystemRegisterType.LIBRARY,
				{
					"Common": "0.0.0.1",
					"GestureCore": "2.1.0.0",
					"GestureWorks": "2.1.0.0"
				}
			);
	
			activatorEvent = null;
			activators =
			{
			};
			
			gestureEvent = GestureEvent;
			
			gestures =
			{				
				gestureDrag: GestureDrag,
				gestureDrag_1: GestureDrag_1,
				gestureDrag_2: GestureDrag_2,
				
				gestureFlick: GestureFlick,
				gestureFlick_1: GestureFlick_1,
				gestureFlick_2: GestureFlick_2,
				
				gestureHold: GestureHold,
				
				gestureRotate: GestureRotate,
				gestureRotate_2: GestureRotate_2,
				
				gestureScale: GestureScale,
				gestureScale_2: GestureScale_2,
				
				gestureScroll: GestureScroll,
							
				gestureTilt: GestureTilt,
				gestureTilt_XZ: GestureTilt_XZ,
				gestureTilt_YZ: GestureTilt_YZ,
	
				gestureTap: GestureTap,
				gestureTap_1: GestureTap_1,
				gestureTap_2: GestureTap_2,
	
				gestureDoubleTap: GestureDoubleTap,
				gestureDoubleTap_1: GestureDoubleTap_1,
				gestureDoubleTap_2: GestureDoubleTap_2
			};
		}
	}
}