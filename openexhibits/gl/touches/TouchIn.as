////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	TouchIn.as
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

import id.core.TactualObjectState;
import id.core.ITactualObject;

public class TouchIn extends Touch
{

	////////////////////////////////////////////////////////////
	// Initialization: Override
	////////////////////////////////////////////////////////////
	override protected function initialize():void
	{
		_objCount = 1;
		_objState = TactualObjectState.TARGET_CHANGED ;
	}
	
	override public function get priority():uint
	{
        return 193;
	}
	
	////////////////////////////////////////////////////////////
	// Methods: Processing Override & Support
	////////////////////////////////////////////////////////////
	/**
	 * @see gl.core.Descriptor#process()
	 */
	override public function process(... tactualObjects:Array):Object
	{
		super.process();
		
		return { };
	}
	
}
	
}