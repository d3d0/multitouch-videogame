////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	Cluster.as
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

import flash.display.DisplayObject;
import flash.utils.getTimer;

use namespace id_internal;

public class Cluster extends TactualObject implements ICluster, ITactualObject, IHistoryObject
{
	
	////////////////////////////////////////////////////////////
	// Variables
	////////////////////////////////////////////////////////////
	private static var count:int = 0;

	private var _tactualObjects:Vector.<ITactualObject> = new Vector.<ITactualObject>();

	////////////////////////////////////////////////////////////
	// Constructors, Destructors, and Initializers
	////////////////////////////////////////////////////////////
	public function Cluster(tactualObjects:Vector.<ITactualObject>)
	{
		super(TactualObjectType.CLUSTER);

		for each(var tO:ITactualObject in tactualObjects)
		{
			_tactualObjects.push(tO);
		}
		
		//calculatePosition();
		
		id = count;
		
		count++;
	}
	
	/*override public function Dispose():void
	{
		super.Dispose();
		
	}*/

	////////////////////////////////////////////////////////////
	// Properties: Public
	////////////////////////////////////////////////////////////
	public function get tactualObjects():Vector.<ITactualObject> { return _tactualObjects;}
	public function get tactualObjectCount():uint { return _tactualObjects.length; }
	
	override public function get state():uint
	{
		// how do I manage this...
		return 0;
	}
	
	override public function get owner():DisplayObject
	{
		return _tactualObjects.length ? _tactualObjects[0].owner : null ;
	}
	
	override public function get target():DisplayObject
	{
		return _tactualObjects.length ? _tactualObjects[0].target : null ;
	}
	
	////////////////////////////////////////////////////////////
	// Methods: Private
	////////////////////////////////////////////////////////////
	public function updateParams():void
	{
		var _x:int = 0;
		var _y:int = 0;
		
		for each(var tO:ITactualObject in _tactualObjects)
		{
			_x += tO.x;
			_y += tO.y;
		}
		
		_x /= tactualObjectCount;
		_y /= tactualObjectCount;
		
		dx = x - _x;
		dy = y - _y;

		x = _x;
		y = _y;
	}
	
	////////////////////////////////////////////////////////////
	// Methods: Public
	////////////////////////////////////////////////////////////
	public function addTactualObject(tO:ITactualObject):void
	{
		_tactualObjects.push(tO);
		
		segment();
		//calculatePosition();
	}
	
	public function removeTactualObject(tO:ITactualObject):void
	{
		var index:int = _tactualObjects.indexOf(tO);
		if (index == -1)
			return;
		
		_tactualObjects.splice(index, 1);
		
		segment();
		//calculatePosition();
	}
	
	public function hasTactualObject(tO:ITactualObject):Boolean
	{
		var index:int = _tactualObjects.indexOf(tO);
		return index != -1 ? true : false ;
	}
	
	////////////////////////////////////////////////////////////
	// Methods: Overrides
	////////////////////////////////////////////////////////////
	override public function info():Object
	{
		//calculatePosition();
		//trace(id + ":", "pushing @", ApplicationGlobals.application.currentFrame, x, y);
		
		return {
			time: getTimer(),
			
			x: _x,
			y: _y
		}
	}

}
	
}