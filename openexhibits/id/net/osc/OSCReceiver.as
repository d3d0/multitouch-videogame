////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	OSCReceiver.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.net.osc
{

import id.core.IDisposable;
import id.events.OSCReceiverEvent;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.DataEvent;
import flash.events.SecurityErrorEvent;
import flash.net.XMLSocket;
import flash.utils.getTimer;

/**
 * 
 */
public class OSCReceiver extends XMLSocket implements IDisposable
{

    /**
     * @private
     */
	private var _oscPacket:OSCPacket;

	////////////////////////////////////////////////////////////
	// Constructors, Destructors, and Initializers
	////////////////////////////////////////////////////////////
	public function OSCReceiver()
	{
		super();
		
		addEventListener(Event.CLOSE, closeHandler);
		addEventListener(Event.CONNECT, connectHandler);
		addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		addEventListener(DataEvent.DATA, dataHandler);
	}
	
	public function Dispose():void
	{
		removeEventListener(Event.CLOSE, closeHandler);
		removeEventListener(Event.CONNECT, connectHandler);
		removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		removeEventListener(DataEvent.DATA, dataHandler);
		
		close();
	}
	
	////////////////////////////////////////////////////////////
	// Methods: Private
	////////////////////////////////////////////////////////////
	private function parseXML(xml:XML):void
	{
		//trace("\nparsing data...");
		//trace(xml.toXMLString());
		
		var idx:uint, idk:uint;
		var data:XMLList = xml.MESSAGE.(@NAME == "/tuio/2Dcur");

		//trace(data);

		var alive:XMLList = data.ARGUMENT.(@VALUE == "alive");
		var aliveList:XMLList = alive.length() ? alive.parent().ARGUMENT.(@VALUE != "alive") : null ;
		if (aliveList)
		{
			_oscPacket = null;
			_oscPacket = new OSCPacket();
			
			for(idx=0; idx<aliveList.length(); idx++)
			{
				var item:XML = aliveList[idx];
				_oscPacket.appendAlive(new OSCBundle([item.@TYPE, item.@VALUE]));
			}
		}

		if(!_oscPacket)
		{
			return;
		}

		// if alive was parsed but none had, dispatch and return
		if (!_oscPacket.hasAlive() && aliveList)
		{
			dispatchEvent(new OSCReceiverEvent(OSCReceiverEvent.PACKET_RECEIVED, false, false, _oscPacket));
			return;
		}

		// if alive not parsed and none had, return to await alive
		/*if (!_oscPacket.hasAlive())
		{
			return;
		}*/
		
		var set:XMLList = data.ARGUMENT.(@VALUE == "set");
		for(idx=0; idx<set.length(); idx++)
		{
			var args:XMLList = set[idx].parent().ARGUMENT.(@VALUE != "set");
			
			var oscBundle:OSCBundle = new OSCBundle();
			for(idk=0; idk<args.length(); idk++)
			{
				oscBundle.appendValue(args[idk].@TYPE, args[idk].@VALUE);
			}

			_oscPacket.appendSet(oscBundle);
		}
		
		if(!_oscPacket.hasSet() && set.length())
		{
			// what about has alive, but not set?  Will this ever happen??
		}
		
		if(_oscPacket.isComplete())
		{
			dispatchEvent(new OSCReceiverEvent(OSCReceiverEvent.PACKET_RECEIVED, false, false, _oscPacket));
		}
	}
	
	////////////////////////////////////////////////////////////
	// Events: Socket
	////////////////////////////////////////////////////////////
	private function closeHandler(event:Event):void
	{
	
	}
	
	private function connectHandler(event:Event):void
	{
	
	}
	
	private function errorHandler(event:Event):void
	{
	
	}
	
	private function securityErrorHandler(event:Event):void
	{
	
	}
	
	private function dataHandler(event:DataEvent):void
	{
		var data:XML = new XML(event.data);
		if (data.localName() == "OSCPACKET")
		{
			parseXML(data);
		}
		
		//event.stopImmediatePropagation();
	}
	
}
}