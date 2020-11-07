////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	Application.as
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
	// first frame imports
	{
	import flash.errors.IllegalOperationError;
	import id.aggregators.sbf.SimpleBestFit; SimpleBestFit;
	import id.data.flosc.Flosc; Flosc;
	import id.data.flosc.FloscSettings; FloscSettings;
	import id.data.simulator.Simulator; Simulator;
	import id.data.simulator.SimulatorSettings; SimulatorSettings;
	}
	
	import id.data.native.Native; Native;
	import id.data.native.NativeSettings; NativeSettings;
	import gl.GestureLibrary;
	import id.ui.SplashScreen;
	import id.configuration.XmlConfigurator;
	import id.data.InputTypes;
	import id.debug.TactualObjectDebugger;
	import id.events.DataProviderEvent;
	import id.managers.DataManager;
	import id.managers.ValidationManager;
	import id.modules.IModuleFactory;
	import id.structs.DescriptorPriorityQueue;
	import id.system.SystemRegister;
	import id.system.SystemRegisterType;
	import id.tracker.Tracker;
	import id.ui.CountdownTimer;
	import id.utils.StringUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import id.system.SystemHook;
	import id.utils.FontLoader;
	
	use namespace id_internal;
	
	/**
	 * The Application class exists as the base object for all document classes
	 * in both CS4 and CS5.  To begin developing your multi touch enabled
	 * application, you first extend this object as the document class.  At the
	 * moment, the Flash Player MovieClip exists as the superclass to the
	 * Application object, which allows for fully functional timeline based UI
	 * development.
	 * 
	 * <p>Multiple <code>Application</code> objects are not yet supported.  If
	 * loading one swf into another, it is reccomended that the second swf's
	 * content object extend <code>TouchSprite</code> and not
	 * <code>Application</code>.  Using the <code>ApplicationProxy</code>
	 * will enable remote, external instantiation of the necessairy GestureWorks
	 * management and targeting pathways.</p>
	 * 
	 * <strong>Properties</strong>
	 * <pre>
	 *  blobContainer="undefined"
	 *  blobContainerEnabled="true"
	 *  touchChildren="true"
	 *  topLevel="true"
	 * </pre>
	 * 
	 * @see id.core.ApplicationProxy
	 * 
	 * @includeExample examples/ApplicationExample.as
	 * @includeExample examples/ApplicationXMLExample.as
	 * 
	 * @langversion 3.0
	 * @playerversion AIR 1.5
	 * @playerversion Flash 10
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 1.5
	 */
	public class Application extends TouchMovieClip
	{
		//--------------------------------------------------------------------------
		//
		//  Config: License Manager
		//
		//--------------------------------------------------------------------------
		
		//CONFIG::LICENSE_MANAGER
		//{
		//private var _countdownTimer:CountdownTimer;
	   // private var _licenseKey:String;
		//}
		
		//--------------------------------------------------------------------------
		//
		//  SystemRegister: GestureWorks
		//
		//--------------------------------------------------------------------------
		
		public static var register:SystemRegister = new SystemRegister
		(
			"GestureWorks",
			id_internal::VERSION,
			SystemRegisterType.LIBRARY
		);
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var _inputTypes:InputTypes;
		private var _settingsPath:String;
		
		/* params */
		private var _defaults:Object =
		{
		};
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *  
		 * @langversion 3.0
		 * @playerversion AIR 1.5
		 * @playerversion Flash 10
		 * @playerversion Flash Lite 4
		 * @productversion GestureWorks 1.5
		 */ 
		
		public function Application()
		{
			ApplicationGlobals.descriptorClass = GestureLibrary;
			
			var lib:Class = ApplicationGlobals.descriptorClass;
			
			var descriptorModule:IModuleFactory = new lib();
			var descriptorAssembly:Object = descriptorModule.create();
			var descriptorList:Object = { };
			
			descriptorList[DescriptorAssembly.ACTIVATORS] = 
			descriptorAssembly[DescriptorAssembly.ACTIVATORS] || {} ;
			
			descriptorList[DescriptorAssembly.GESTURES] = 
			descriptorAssembly[DescriptorAssembly.GESTURES] || {} ;
				
			descriptorList[DescriptorAssembly.PATHS] = 
			descriptorAssembly[DescriptorAssembly.PATHS] || {} ;
			
			descriptorList[DescriptorAssembly.TOUCHES] =
			descriptorAssembly[DescriptorAssembly.TOUCHES] || {} ;
			
			ApplicationGlobals.descriptorModule = descriptorModule;
			ApplicationGlobals.descriptorAssembly = descriptorAssembly;
			ApplicationGlobals.descriptorList = descriptorList;
			ApplicationGlobals.descriptorPriorityQueue = createPrimitiveQueue(descriptorAssembly);
			
			var activatorEvent:Class = descriptorAssembly[DescriptorAssembly.ACTIVATOR_EVENT];
			
			TouchObjectGlobals.activatorEvent = activatorEvent;
			
			var gestureEvent:Class = descriptorAssembly[DescriptorAssembly.GESTURE_EVENT];
			
			TouchObjectGlobals.gestureEvent = gestureEvent;
			TouchObjectGlobals.affineTransform_release_event = gestureEvent[TouchObjectGlobals.affineTransform_release];
			TouchObjectGlobals.affineTransform_rotate_event = "Rotate";
			TouchObjectGlobals.affineTransform_scale_event = "Scale";
			TouchObjectGlobals.affineTransformations = true;
			
			var descriptor:Object;
			var descriptorCast:IDescriptor;
			var descriptorMap:Object = {};
			
			for(var k:String in ApplicationGlobals.descriptorList)
			{
				for(var j:String in ApplicationGlobals.descriptorList[k])
				{
					descriptor = ApplicationGlobals.descriptorList[k][j];
					
					descriptorCast = descriptor as IDescriptor;
					
					if (descriptorCast)
					{
						descriptorCast.tracker = Tracker.getInstance();
					}
			
					descriptorMap[descriptor.name] = j
				}
			}
			
			ApplicationGlobals.descriptorMap = descriptorMap;
			
			super();
			
			blobContainerEnabled = true;
			topLevel = true;
			
			// do not re-order
			ApplicationGlobals.application = this;
			ApplicationGlobals.dataManager = DataManager.getInstance();
			
			ApplicationGlobals.tracker = Tracker.getInstance();		
			ApplicationGlobals.tracker.validationManager = ValidationManager.getInstance();
			
			ApplicationGlobals.validationManager = ValidationManager.getInstance();
		}
		
		/**
		 * This method is called when the default constructor has finished,
		 * the stage becomes available, and the data manager has loaded and 
		 * parsed the "application.xml" file, to ensure data availability.
		 * 
		 * <p>This is an advanced method which allows you to override it
		 * for child creation if data has been externalized to xml.  It 
		 * provides a pathway to obtaining externalized data during runtime.</p>
		 * 
		 * <p>You do not call this method directly, GestureWorks calls the
		 * <code>initialize()</code> method in response to object instantiation
		 * and the application.xml data becoming available.</p>
		 * 
		 * @includeExample Application#initialize.as
		 * 
		 * @langversion 3.0
		 * @playerversion AIR 1.5
		 * @playerversion Flash 10
		 * @playerversion Flash Lite 4
		 * @productversion GestureWorks 1.5
		 */
		
		override protected function initialize():void
		{
			super.initialize();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The gesture library's class definition. The Application object will
		 * initialize with the defined gesture library if this property is called
		 * before the implementing class performs a call to <code>super()</code>.
		 * If set after the call, an exception is thrown as the Application has 
		 * defaulted to the built in library.
		 * 
		 * @throws flash.errors.IllegalOperationError Calls to establish the class
		 * definition may only be made once, and before the Application initializes.
		 * <code>super()</code>.
		 * 
		 * @langversion 3.0
		 * @playerversion AIR 1.5
		 * @playerversion Flash 10
		 * @playerversion Flash Lite 4
		 * @productversion GestureWorks 1.5
		 */
		public function get GestureLibraryrary():Class { return ApplicationGlobals.descriptorClass; }
		public function set GestureLibraryrary(library:Class):void
		{
			if(ApplicationGlobals.descriptorClass)
			{
				throw new IllegalOperationError("You may only define one gesture library!");
			}
			
			ApplicationGlobals.descriptorClass = library;
		}
		
		public function get settingsPath():String { return _settingsPath; }
		public function set settingsPath(value:String):void
		{
			_settingsPath = value;
		}
	
		//--------------------------------------------------------------------------
		//
		//  Methods: Private
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * This method creates a priority queue based on the availablity of the 
		 * touch events.
		 */
		private function createPrimitiveQueue(assembly:Object):DescriptorPriorityQueue
		{
			var queue:DescriptorPriorityQueue = new DescriptorPriorityQueue();
			
			var descriptor:IDescriptor;
			for each (descriptor in assembly[DescriptorAssembly.TOUCHES])
			{
				queue.addDescriptor(descriptor);
			}
			
			return queue;
		}
	
		//--------------------------------------------------------------------------
		//
		//  Method Overrides: TouchObjectContainer
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		override public function getTouchObjectUnderPoint(pt:Point):ITouchObject
		{
			if(!numChildren)
				return this;
	
			return super.getTouchObjectUnderPoint(pt);
		}
	
		//--------------------------------------------------------------------------
		//
		//  Method Overrides: TouchObject
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		override id_internal function addedToStageHandler(event:Event):void
		{
			ApplicationGlobals.dataManager.addEventListener(Event.COMPLETE, dataManager_completeHandler);
			ApplicationGlobals.dataManager.addEventListener(IOErrorEvent.IO_ERROR, dataManager_errorHandler);
			ApplicationGlobals.dataManager.addEventListener(SecurityErrorEvent.SECURITY_ERROR, dataManager_errorHandler);
			
			if(!_settingsPath)
			{
				ApplicationGlobals.dataManager.data = ApplicationSettings.Settings;
				dataManager_completeHandler(null);
			}
			else
			{
				ApplicationGlobals.dataManager.dataPath = _settingsPath;
			}
	
			stage_resizeHandler(null);
			stage.addEventListener(Event.RESIZE, stage_resizeHandler);
		}
	
		//--------------------------------------------------------------------------
		//
		//  Events: Data Manager
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function dataManager_completeHandler(event:Event):void
		{
			var touchCore:XMLList = ApplicationGlobals.dataManager.touchCore;
			
			FontLoader.url = touchCore.FontLibraryPath;
			
			if(!touchCore)
			{
				throw new ArgumentError("Application.xml must have <TouchCore></TouchCore>");
			}
			
			if(StringUtil.isEmpty(touchCore.InputTypes))
			{
				throw new ArgumentError("Application.xml must have <InputTypes></InputTypes>");
			}
			
			if(StringUtil.isEmpty(touchCore.InputSettings))
			{
				throw new ArgumentError("Application.xml must have <InputSettings></InputSettings>");
			}
			
			ApplicationGlobals.tactualObjectDebugger = new TactualObjectDebugger();
			ApplicationGlobals.tactualObjectDebugger.tracker = Tracker.getInstance();
			ApplicationGlobals.tactualObjectDebugger.validationManager = ValidationManager.getInstance();
	
			ApplicationGlobals.aggregator = new SimpleBestFit();
			ApplicationGlobals.aggregator.tracker = Tracker.getInstance();
			ApplicationGlobals.aggregator.validationManager = ValidationManager.getInstance();
			
			if(touchCore.TrackerSettings)
			{
				ApplicationGlobals.tracker.frequency = touchCore.TrackerSettings.Frequency;
				ApplicationGlobals.tracker.ghostTolerance = touchCore.TrackerSettings.GhostTolerance;
			}
			
			_inputTypes = new InputTypes(touchCore.InputTypes);
	
			if(touchCore.Degradation != "never")
			{
				var simulator:Object = _inputTypes["Simulator"];
				if(!simulator)
				{
					throw new Error("Application.xml must have a defined simulator if degradation is desired!");
				}
	
				ApplicationGlobals.simulator = new Simulator();
				ApplicationGlobals.simulator.settings = XmlConfigurator.Create
				(
					simulator.clsSettings,
					XML(touchCore.InputSettings[simulator.xml.Settings].toXMLString())
				);
				ApplicationGlobals.simulator.validationManager = ApplicationGlobals.validationManager;
				ApplicationGlobals.simulator.tracker = ApplicationGlobals.tracker;
				ApplicationGlobals.simulator.bloom();
			}
	
			var inputProvider:*;
	
			if(touchCore.InputProvider != "")
			{
				var inputType:Object = _inputTypes[touchCore.InputProvider];
				if(!inputType)
				{
					throw new ArgumentError
					(
						"Application.xml must use a defined InputProvider. '" +
						touchCore.InputProvider +
						"' was not found!"
					);
				}
				
				inputProvider = new inputType.cls();
				inputProvider.settings = XmlConfigurator.Create
				(
					inputType.clsSettings,
					XML(touchCore.InputSettings[inputType.xml.Settings].toXMLString())
				);
	
				if(inputProvider is SystemHook)
				inputProvider.validationManager = ApplicationGlobals.validationManager;
				inputProvider.tracker = ApplicationGlobals.tracker;
				
				ApplicationGlobals.trackerInputProvider = inputProvider;
			}
			
			// setup input provider swapping
			if(touchCore.InputProvider && touchCore.Degradation == "auto")
			{
				ApplicationGlobals.trackerInputProvider.addEventListener(DataProviderEvent.ERROR, inputProvider_errorHandler);
				ApplicationGlobals.trackerInputProvider.addEventListener(DataProviderEvent.ESTABLISHED, inputProvider_establishedHandler);
			}
			
			// setup the debug mode
			if(touchCore.Debug == "true")
			{
				ApplicationGlobals.tactualObjectDebugger.start();
			}
			
			// start the data input provider
			if(ApplicationGlobals.trackerInputProvider)
			{
				ApplicationGlobals.trackerInputProvider.bloom();
			}
			
			var splashScreen:SplashScreen = new SplashScreen();
						
			initialize();
		}
		
		/**
		 * @private
		 */
		private function dataManager_errorHandler(event:IOErrorEvent):void
		{
			ApplicationGlobals.dataManager.data = ApplicationSettings.Settings;
			dataManager_completeHandler(null);
		}
	
		//--------------------------------------------------------------------------
		//
		//  Events: Input Provider
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function inputProvider_errorHandler(event:DataProviderEvent):void
		{
			ApplicationGlobals.simulator.start();
		}
		
		/**
		 * @private
		 */
		private function inputProvider_establishedHandler(event:DataProviderEvent):void
		{
			ApplicationGlobals.simulator.stop();
		}
	
		//--------------------------------------------------------------------------
		//
		//  Events: Stage
		//
		//--------------------------------------------------------------------------
		/**
		 * @private
		 */
		private function stage_resizeHandler(event:Event):void
		{
			graphics.beginFill(0x000000, 0.0);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
		}
		
	}
	
}