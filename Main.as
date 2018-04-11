package  {
	import flash.display.MovieClip;
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
	
	
	
	public class Main extends Sprite {
		

		private var startScreenSprite:Sprite;
		private var mainScreenSprite:Sprite;
		private var qrSprite:Sprite;
		
		private var vibration:Vibration;
		
		private var htmlStageView:StageWebView = new StageWebView()
		
		public function Main() 
		{
			qrSprite = new Sprite();
			Multitouch.inputMode=MultitouchInputMode.TOUCH_POINT; 
			htmlStageView.viewPort = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			//htmlStageView.stage = this.stage;
			trace("Working");
			DisplayStartScreen();
		}
		
		public function DisplayStartScreen():void

		{
			//instantiate the bitmap in the library by its identifier
			startScreenSprite = new Sprite();//create an image container

			addChild(startScreenSprite);//add it to the display list

			var libraryImage:Bitmap = new Bitmap(new StartScreen(0,0));
			libraryImage.x -= 10;
			libraryImage.y -= 10;
			//place the image in the image container

			startScreenSprite.addChild(libraryImage);
			
			startScreenSprite.addEventListener(TouchEvent.TOUCH_BEGIN, OnTouchTap);

		}
		
		public function DisplayMainScreen():void 
		{
			//instantiate the bitmap in the library by its identifier
			mainScreenSprite = new Sprite();//create an image container

			addChild(mainScreenSprite);//add it to the display list

			var libraryImage:Bitmap = new Bitmap(new MainScreen(0,0));
			//place the image in the image container

			mainScreenSprite.addChild(libraryImage);
			
			mainScreenSprite.addEventListener(TouchEvent.TOUCH_BEGIN, OnOpenBarcodeReader);
		}
		
		private function OnTouchTap(evt:TouchEvent):void 
		{
			trace("OnTouch");
			
			startScreenSprite.removeChildAt(0);
			
			DisplayMainScreen();
		}
		
		private function OnOpenPersonalBarcode(evt:TouchEvent):void 
		{	
			mainScreenSprite.removeChildAt(0);
			//vibrate
			if (Vibration.isSupported) 
			{
				vibration = new Vibration();
				vibration.vibrate(2000);
			}
			
			var sp:Sprite = new Sprite();
			var qr:QRCode = new QRCode();
			qr.encode("TEST");
			var img:Bitmap = new Bitmap(qr.bitmapData);
			img.scaleX = 4;
			img.scaleY = 4;
			sp.addChild(img);

			addChild(sp);
			
		}
		
		private function OnOpenBarcodeReader(evt:TouchEvent):void 
		{
			trace("You I can read yes.");
			var barcode:BarcodeReader = new BarcodeReader(stage);
			addChild(barcode);
		}

	}
	
}
