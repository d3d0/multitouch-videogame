////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	TactualObjectState.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.core
{
	
public class TactualObjectState
{
	
	// primary states -- driven by the tracking system
	
	public static const NONE:int		= 1;
	public static const ADDED:int		= 2;
	public static const UPDATED:int		= 4;
	public static const REMOVED:int		= 8;
	
	// secondary states -- driven by the validation system
	public static const OWNER_CHANGED:int	= 16;
	public static const TARGET_CHANGED:int	= 32;
	
}
	
}