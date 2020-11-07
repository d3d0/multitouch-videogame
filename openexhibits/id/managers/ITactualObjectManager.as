////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	ITactualObjectManager.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.managers
{
	
import id.core.ICluster;
import id.core.IDisposable;
import id.core.ITactualObject;

import flash.display.DisplayObject;
import flash.utils.Dictionary;
	
/**
 * @private
 */
public interface ITactualObjectManager extends IValidationManagerClient, IDisposable
{

	function get tactualClusters():Vector.<ITactualObject>;
	function get tactualObjects():Vector.<ITactualObject>;
	function get tactualObjectCount():int;

	function addTactualObject(tO:ITactualObject):void;
	function removeTactualObject(tO:ITactualObject):void;

	//function getTactualObjectsAtPosition(x:Number, y:Number):Vector.<ITactualObject>;
	//function getTactualObjectsByTarget(target:DisplayObject):Vector.<ITactualObject>;

	/*
	function get owner():ITouchObject;
	
	function get tactualObjects():Dictionary;
	function get clusters():Array;
	function get pushQueue():Array;

	function get tactualObjectCount():int;
	
	function addTactualObject(tO:ITactualObject):void;
	function removeTactualObject(tO:ITactualObject):void;
	
	function addAssociatedTactualObject(tO:ITactualObject):void;
	function removeAssociatedTactualObject(tO:ITactualObject):void;
	
//	function cluster(... args):ICluster; // force a cluster from the gesture modules
	
	function hasTactualObjects():Boolean;
//	function hasClusters():Boolean;
	
	function validate():void;
	*/
}
	
}