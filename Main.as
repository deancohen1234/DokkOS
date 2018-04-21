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
			DisplayStartScreen();
		}
		
		public function DisplayStartScreen():void

		{
			trace(startScreen);
			
			startScreen.addEventListener(TouchEvent.TOUCH_BEGIN, OnTouchTap);

		}
		
		private function OnTouchTap(evt:TouchEvent):void 
		{
			trace("OnTouch");
			gotoAndStop(2);
			DisplayMainMenu();
			
		}
		
		public function DisplayMainMenu():void 
		{
			viewer_Button.addEventListener(TouchEvent.TOUCH_BEGIN, OnOpenPersonalBarcode);
			scanner_Button.addEventListener(TouchEvent.TOUCH_BEGIN, OnOpenBarcodeReader);
			scanner_Button.addEventListener(MouseEvent.CLICK, OnOpenBarcodeReader);
			trace("SEE MEEEE");
		}
		
		private function OnOpenPersonalBarcode(evt:TouchEvent):void 
		{	
			//vibrate
			gotoAndStop(5);
			returnFrameIndex = 2;
			viewer_Return.addEventListener(TouchEvent.TOUCH_BEGIN, ReturnHome);
			if (Vibration.isSupported) 
			{
				vibration = new Vibration();
				vibration.vibrate(2000);
			}
			
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

	}
	
}
