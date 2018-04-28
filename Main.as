package  {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.external.ExternalInterface;
	import flash.html.HTMLLoader; 
	
	import flash.display.BitmapData;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.geom.Rectangle;
	import flash.filesystem.File;
	
	import flash.media.StageWebView;
	
	import org.qrcode.QRCode;
	
	import com.myflashlab.air.extensions.firebase.core.Firebase;
	import com.myflashlab.air.extensions.firebase.db.*;
	import com.myflashlab.air.extensions.firebase.auth.*;

	
	import com.adobe.nativeExtensions.Vibration;
	import com.myflashlab.air.extensions.barcode.Barcode;
	import com.myflashlab.air.extensions.barcode.BarcodeEvent;
	import com.myflashlab.air.extensions.nativePermissions.PermissionCheck;
	import com.myflashlab.air.extensions.dependency.OverrideAir;
	
	import BarcodeReader;
	
	
	
	//import BarcodeMaterials;
	
	
	
	public class Main extends MovieClip {
		

		private var startScreenSprite:Sprite;
		private var mainScreenSprite:Sprite;
		private var qrSprite:Sprite;
		private var m_IsOpenScreen:Boolean = true;
		
		private var vibration:Vibration;
		
		private var returnFrameIndex = 1;
		
		private var htmlStageView:StageWebView = new StageWebView()
		
		private var barcodeInstance:BarcodeReader;
		
		private var m_PersonalString:String;
		
		private var m_IDArray:Array;
		
		public function Main() 
		{
			m_IDArray = new Array();
			
			gotoAndStop(1);
			qrSprite = new Sprite();
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT; 
			htmlStageView.viewPort = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			//htmlStageView.stage = this.stage;
			trace("Working");
			SetupFirebase();
			DisplayStartScreen();
		}
		
		private function SetupFirebase():void
		{
			trace ("Setting up firebase");
			Firebase.init();
			//initilize firebase realitme database
			DB.init();
			
		}
		
		function onDataChange2(e:DBEvents):void
		{
			if (e.dataSnapshot.exists)
			{
				if (e.dataSnapshot.value is String) 		trace("String value = " + e.dataSnapshot.value);
				else if (e.dataSnapshot.value is Number) 	trace("Number value = " + e.dataSnapshot.value);
				else if (e.dataSnapshot.value is Boolean) 	trace("Boolean value = " + e.dataSnapshot.value);
				else if (e.dataSnapshot.value is Array) 	trace("Array value = " + JSON.stringify(e.dataSnapshot.value));
				else
				{
					trace("Object value = " + JSON.stringify(e.dataSnapshot.value));
					var object = JSON.parse(JSON.stringify(e.dataSnapshot.value));
					/*if (object.hackNumber == 100) 
					{
						OnStartHack(null);
					}*/
					//OnStartHack(null);
				}
			}
		}
		
		public function DisplayStartScreen():void

		{
			trace(startScreen);
			
			confirmName_Button.addEventListener(TouchEvent.TOUCH_BEGIN, OnTouchTap);

		}
		
		private function OnTouchTap(evt:TouchEvent):void 
		{
			if (currentFrame == 1)
			{
				trace("Sending data to database");
				SendNameToDatabase(inputTextBox.text);
			}
			
			

			trace("OnTouch");
			gotoAndStop(2);
			DisplayMainMenu();
			
		}
		
		private function OnGetUserDataCallback(e:DBEvents):void
		{
			if (e.dataSnapshot.exists)
			{
				if (e.dataSnapshot.value is String) 		trace("String value = " + e.dataSnapshot.value);
				else if (e.dataSnapshot.value is Number) 	trace("Number value = " + e.dataSnapshot.value);
				else if (e.dataSnapshot.value is Boolean) 	trace("Boolean value = " + e.dataSnapshot.value);
				else if (e.dataSnapshot.value is Array) 	trace("Array value = " + JSON.stringify(e.dataSnapshot.value));
				else
				{
					var object = JSON.parse(JSON.stringify(e.dataSnapshot.value));
					trace (object.name + "Get Callback   Hacknumber:" + object.hackNumber);
					
					//Re-upload data to hack
					var myRef:DBReference = DB.getReference("UserNames");
					
					
					if (!m_IsOpenScreen)
					{
						OnStartHack(null);
					}
					m_IsOpenScreen = false;
					
					//myRef.child("users").child(m_PersonalString).child("hackNumber").setValue(Math.random());
					
				}
			}
		}
		
		private function GetUserData(id:String) :void 
		{
			var searchRef:DBReference = DB.getReference("UserNames").child("users").child(id)
			searchRef.child("users").child(id).child("hackNumber").setValue(Math.random());
		}
		
		private function SendNameToDatabase(s:String) :void
		{
			var myRef:DBReference = DB.getReference("UserNames");
			//var ref:DBReference = DB.getReference("UserNames").child("users").child("-LAeDY16_RoXrrLxN-hH");
			//var searchRef:DBReference = DB.getReference("UserNames").child("users").child("-LB7wm3pS0KX46uiMGCK")
			myRef.addEventListener(DBEvents.SINGLE_VALUE_CHANGED, onDataChange2);
			//ref.addEventListener(DBEvents.VALUE_CHANGED, onDataChange2);
			//searchRef.addEventListener(DBEvents.VALUE_CHANGED, onDataChange2);
			
			var userInfo:Object = new Object();
			userInfo.name = s;
			userInfo.timestamp = new Date().getTime();
			userInfo.hackNumber = 0;
			
			var key:String = myRef.child("users").push().key;
			m_PersonalString = key;
			
			var map:Object = {};
			map["/users/" + key] = userInfo;
			
			myRef.updateChildren(map);
			
			var searchRef:DBReference = DB.getReference("UserNames").child("users").child(m_PersonalString)
			searchRef.addEventListener(DBEvents.VALUE_CHANGED, OnGetUserDataCallback);
			
		}
		
		private function QueryAttempted(e:DBEvents):void 
		{
			if (e.dataSnapshot.exists)
			{
				if (e.dataSnapshot.value is String) 		trace("String value = " + e.dataSnapshot.value);
				else if (e.dataSnapshot.value is Number) 	trace("Number value = " + e.dataSnapshot.value);
				else if (e.dataSnapshot.value is Boolean) 	trace("Boolean value = " + e.dataSnapshot.value);
				else if (e.dataSnapshot.value is Array) 	trace("Array value = " + JSON.stringify(e.dataSnapshot.value));
				else
				{
					trace("Object value = " + JSON.stringify(e.dataSnapshot.value));
					var object = JSON.parse(JSON.stringify(e.dataSnapshot.value));
					trace (object.name + "   " + object.hackNumber);
				}
			}
		}
		
		public function DisplayMainMenu():void 
		{
			for (var i:int; i < m_IDArray.length; i++) 
			{
				var s:String = m_IDArray[i];
				
				hackList.text = hackList.text + s + "\n";
			}
			
			viewer_Button.addEventListener(TouchEvent.TOUCH_BEGIN, OnOpenPersonalBarcode);
			scanner_Button.addEventListener(TouchEvent.TOUCH_BEGIN, OnOpenBarcodeReader);
			scanner_Button.addEventListener(MouseEvent.CLICK, OnOpenBarcodeReader);
			hack_Button.addEventListener(TouchEvent.TOUCH_BEGIN, OnHackButtonPress);
			trace("SEE MEEEE");
		}
		
		private function OnHackButtonPress(evt:TouchEvent):void 
		{
			HackAllMyEnemies();
		}
		
		private function OnOpenPersonalBarcode(evt:TouchEvent):void 
		{	
			//vibrate
			gotoAndStop(5);
			returnFrameIndex = 2;
			viewer_Return.addEventListener(TouchEvent.TOUCH_BEGIN, ReturnHome);
			/*if (Vibration.isSupported) 
			{
				vibration = new Vibration();
				vibration.vibrate(2000);
			}*/
			
			var sp:Sprite = new Sprite();
			var qr:QRCode = new QRCode();
			qr.encode(m_PersonalString);
			var img:Bitmap = new Bitmap(qr.bitmapData);
			img.scaleX = 4;
			img.scaleY = 4;
			sp.addChild(img);

			addChild(sp);
			
		}
		
		private function OnOpenBarcodeReader(evt:TouchEvent):void 
		{
			returnFrameIndex = 2;
			
			trace("You I can read yes.");

			
			var barcode:BarcodeReader = new BarcodeReader(stage);
			barcode.addEventListener("CALLBACK", CustomCallback);
			
			barcodeInstance = barcode;
			
			//addChild(barcode);
			
			gotoAndStop(7);
			//setChildIndex(barcode, 0);
			//setChildIndex(reader_Return, numChildren - 1);
			reader_Return.addEventListener(TouchEvent.TOUCH_BEGIN, ReturnHome);
			
		}
		
		private function CustomCallback(evt:Event):void 
		{
			trace("Callback worked");
			trace(evt.target.m_Data);
			
			//Change value for target to trigger a hack
			//GetUserData(evt.target.m_Data);
			m_IDArray.push(evt.target.m_Data);
			
			//gotoAndStop(2);
			
			barcodeInstance = null;
			//DisplayMainMenu();
			//ResetButtonDepths();
			ReturnHome(null);
		}
		
		private function ResetButtonDepths():void
		{
			setChildIndex(reader_Return, numChildren - 1);
			setChildIndex(viewer_Return, numChildren - 1);
		}
		
		private function ReturnHome(evt:Event):void 
		{
			//gotoAndStop(1);
			var i:int = 0;
			//gotoAndStop(returnFrameIndex);
			for (i = 0; i < numChildren; i++) 
			{
				if (getChildAt(i) is Sprite) 
				{
					trace (getChildAt(i).name);
					removeChildAt(i);
				}
			}
			//gotoAndStop(2);
			OnTouchTap(null);
			
		}
		
		private function HackAllMyEnemies() 
		{
			for (var i:int; i < m_IDArray.length; i++) 
			{
				var s:String = m_IDArray[i];
				GetUserData(s);
			}
		}
		
		private function OnStartHack (evt:Event):void 
		{
			gotoAndPlay(9);
			if (Vibration.isSupported) 
			{
				vibration = new Vibration();
				vibration.vibrate(12000);
			}
			addEventListener(Event.ENTER_FRAME, OnEnterFrame);
		}
		
		private function OnEnterFrame(evt:Event):void 
		{
			if (currentFrame == 288)
			{
				ReturnHome(null);
				removeEventListener(Event.ENTER_FRAME, OnEnterFrame);
			}
		}

	}
	
}
