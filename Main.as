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
			
			mainScreenSprite.addEventListener(TouchEvent.TOUCH_BEGIN, OnOpenPersonalBarcode);
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
			
			/*var webView:StageWebView = new StageWebView();
			webView.stage = this.stage;
			webView.viewPort = new Rectangle( 0, 0, stage.stageWidth, stage.stageHeight );

		var htmlString:String = "<!DOCTYPE HTML>" +
								"<html>" +
									"<body>" +
										"<h1>Example</h1>" +
										"<p>King Phillip cut open five green snakes.</p>" +
									"</body>" +
								"</html>";

			
			//webView.loadString( htmlString, "text/html" );
			var file:File = File.applicationDirectory;
			file = file.resolvePath("index-svg.html")	
			
			var workingFile:File = File.createTempFile();
			file.copyTo( workingFile, true );
			
			webView.loadURL(workingFile.url);*/
			
			var sp:Sprite = new Sprite();
			var qr:QRCode = new QRCode();
			qr.encode("TEST");
			var img:Bitmap = new Bitmap(qr.bitmapData);
			img.scaleX = 4;
			img.scaleY = 4;
			sp.addChild(img);

			addChild(sp);
			
			//webView.loadString( htmlString, "text/html" );
			
			//var htmlLoader:HTMLLoader = new HTMLLoader();
			//var addressDestination:URLRequest = new URLRequest("www.youtube.com");
			
			//htmlLoader.width = 400; 
			//htmlLoader.height = 600; 
			
			//htmlLoader.load(addressDestination);
			//htmlLoader.addEventListener(Event.COMPLETE, onComplete);
			
			//trace(file.exists);
			//addChild(htmlLoader);
			//webView.loadString(file.toString(), "text/html" )
		}
		
		private function onComplete (evt:Event):void {
			trace("Completed");
		}

	}
	
}
