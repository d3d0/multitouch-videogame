////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	TouchDown.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Paul Lacey (paul(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com). 
//				
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package gl.touches
{

import id.core.ITactualObject;
import id.core.TactualObjectState;

/**
 * Touch down, for use when a user taps with a single finger. This is
 * similar to the <code>MOUSE_DOWN</code> AS3 event, and will register before
 * a user lifts the finger to complete the tap.
 * 
 * <p>This gesture is made available for event listening via the <code>TouchEvent.TOUCH_DOWN</code>
 * reference.</p>
 * 
 * <p>The <code>TouchEvent</code> instance passed to an event handler for this gesture
 * will contain no additional informational properties aside from what is innately available
 * on the <code>TouchEvent</code>.</p>
 * 
 * @includeExample TouchDownExample.as
 */
public class TouchDown extends Touch
{
    
    ////////////////////////////////////////////////////////////
    // Initialization: Override
    ////////////////////////////////////////////////////////////
    override protected function initialize():void {
        _objCount = 1;
        _objState = TactualObjectState.ADDED | TactualObjectState.TARGET_CHANGED ;
    }
    
    override public function get priority():uint
    {
        return 256;
        //return (_priority | (1<<8)) | 128 ;
    }
    
    ////////////////////////////////////////////////////////////
    // Methods: Processing Override & Support
    ////////////////////////////////////////////////////////////
    /**
     * @see gl.core.Descriptor#process()
     */
    override public function process(... tactualObjects:Array):Object {
        super.process();
        
        return { };
    }
    
}
    
}