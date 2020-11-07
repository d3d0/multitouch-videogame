////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	FloscSettings.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.data.flosc
{

import id.utils.Enumerable;

public class FloscSettings extends Enumerable
{
	
	public function FloscSettings()
	{
		_items =
		{
			Host: "127.0.0.1",
			Port: 3000,
			
			AutoReconnect: true,
			EnforceSize: false,
			Width: 1280,
			Height: 720
		};

	}
	
}

}