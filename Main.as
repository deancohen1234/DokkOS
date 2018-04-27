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
		
		private var vibration:Vibration;
		
		private var returnFrameIndex = 1;
		
		private var htmlStageView:StageWebView = new StageWebView()
		
		private var barcodeInstance:BarcodeReader;
		
		public function Main() 
		{
			gotoAndStop(1);
			qrSprite = new Sprite();
			Multitouch.inputMode=MultitouchInputMode.TOUCH_POINT; 
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
				else 										trace("Object value = " + JSON.stringify(e.dataSnapshot.value));
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
		
		private function SendNameToDatabase(s:String) :void
		{
			var myRef:DBReference = DB.getReference("UserNames");
			var ref:DBReference = DB.getReference("UserNames").child("users").child("-LAeDY16_RoXrrLxN-hH");
			myRef.addEventListener(DBEvents.VALUE_CHANGED, onDataChange2);
			ref.addEventListener(DBEvents.VALUE_CHANGED, onDataChange2);
			
			var userInfo:Object = new Object();
			userInfo.name = s;
			userInfo.timestamp = new Date().getTime();
			
			var key:String = myRef.child("users").push().key;			
			
			var map:Object = {};
			map["/users/" + key] = userInfo;
			
			myRef.updateChildren(map);
			
			//myRef.addEventListener(DBEvents.VALUE_CHANGED, onDataChange);
			//var myQuery:DBQuery = myRef.child("user").child("-LAeDY16_RoXrrLxN-hH").limitToFirst(100);
			//myQuery.addEventListener(DBEvents.VALUE_CHANGED, QueryAttempted);
			
		}
		
		private function QueryAttempted(e:DBEvents):void 
		{
			if (e.dataSnapshot.exists)
		{
			if (e.dataSnapshot.value is String) 		trace("String value = " + e.dataSnapshot.value);
			else if (e.dataSnapshot.value is Number) 	trace("Number value = " + e.dataSnapshot.value);
			else if (e.dataSnapshot.value is Boolean) 	trace("Boolean value = " + e.dataSnapshot.value);
			else if (e.dataSnapshot.value is Array) 	trace("Array value = " + JSON.stringify(e.dataSnapshot.value));
			else 										trace("Object value = " + JSON.stringify(e.dataSnapshot.value));
		}
		}
		
		public function DisplayMainMenu():void 
		{
			viewer_Button.addEventListener(TouchEvent.TOUCH_BEGIN, OnOpenPersonalBarcode);
			scanner_Button.addEventListener(TouchEvent.TOUCH_BEGIN, OnOpenBarcodeReader);
			scanner_Button.addEventListener(MouseEvent.CLICK, OnOpenBarcodeReader);
			hack_Button.addEventListener(TouchEvent.TOUCH_BEGIN, OnStartHack);
			trace("SEE MEEEE");
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
			qr.encode("Domo Arigat0 Mr. Roboto");
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
