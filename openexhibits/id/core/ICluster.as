////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	ICluster.as
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

public interface ICluster extends ITactualObject, IHistoryObject
{
	
	function get tactualObjects():Vector.<ITactualObject>;
	function get tactualObjectCount():uint;
	
	function addTactualObject(tO:ITactualObject):void;
	function removeTactualObject(tO:ITactualObject):void;
	
	function hasTactualObject(tO:ITactualObject):Boolean;
	function updateParams():void;
}

}