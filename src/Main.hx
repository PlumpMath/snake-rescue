
import luxe.GameConfig;
import luxe.Input;

import luxe.Vector;
import luxe.Color;
import phoenix.Texture;

import luxe.Parcel;
import luxe.ParcelProgress;

import mint.Control;
import mint.render.luxe.LuxeMintRender;
import mint.focus.Focus;

import AutoCanvas;

#if cpp
import luxe.gifcapture.LuxeGifCapture;
#end

class Main extends luxe.Game {
    
    public static var canvas: mint.Canvas;
    public static var rendering: LuxeMintRender;
    public static var focus: Focus;
    
    #if cpp
    var capture : LuxeGifCapture;
    #end
    
    override function config(config:GameConfig) {
        config.window.title = "Snake Rescue";
        config.window.width = 512;
        config.window.height = 512;
        config.window.fullscreen = false;
        
        return config;
    }

    override function ready() {
        
        // load all the graphics! Remember to add new graphics here!
        var parcel = new Parcel({
            textures: [
                {id: "assets/textures/Snake.png"}
            ]
        });
        
        // get a simple loading screen for all that stuff. Builtin will do
        new ParcelProgress({
            parcel: parcel,
            background: new Color().rgb(0xf94b04),
            oncomplete: assets_loaded // replacement for ready() since we're using it for the parcel,
            // and since it loads asynchronously
        });
        
        // load it!
        parcel.load();
    }
    
    var snake : entities.Pseudo3DSprite;
    
    function assets_loaded(_) { // we're ready to use all that stuff!
        // setup the mint canvas {
        rendering = new LuxeMintRender();
        
        var autocanvas = new AutoCanvas(Luxe.camera.view, {
            name:"canvas",
            rendering: rendering,
            options: { color:new Color(1,1,1,0.0) },
            scale: 2,
            x: 0, y:0, w: Luxe.screen.w/2, h: Luxe.screen.h/2
        });
        autocanvas.auto_listen();
        canvas = autocanvas; // turn that thing into an actual canvas!
        
        focus = new Focus(canvas); // apparently this is necessary
        // } mint canvas setup'd
        
        var image = Luxe.resources.texture("assets/textures/Snake.png");
        image.filter_min = image.filter_mag = FilterType.nearest;
        
        snake = new entities.Pseudo3DSprite({
            name: "Snake",
            texture: image,
            pos: new Vector(200, 200),
            size: new Vector(23, 23),
            scale: new Vector(2, 2),
            frames: 23
        });
        
        #if cpp
        capture = new LuxeGifCapture({
            width: Std.int(Luxe.screen.w/2),
            height: Std.int(Luxe.screen.h/2),
            fps: 50, 
            max_time: 3,
            quality: GifQuality.High,
            repeat: GifRepeat.Infinite,
            oncomplete: function(_bytes:haxe.io.Bytes) {
                var path = "snake.gif";
                sys.io.File.saveBytes(path, _bytes);
            }
        });
        #end
    }
    
    override public function onkeydown(event:KeyEvent) {
        #if cpp
        switch(event.keycode) {
            case Key.space:
                if(capture.state == CaptureState.Paused) {
                    capture.record();
                    trace('recording: active');
                } else if(capture.state == CaptureState.Recording) {
                    capture.pause();
                    trace('recording: paused');
                }
            case Key.key_r:
                capture.reset();
                trace('recording: reset');
            case Key.key_3:
                trace('recording: committed');
                capture.commit();
        }
        #end
    }
    
    override function onkeyup(event:KeyEvent) {
        if(event.keycode == Key.escape) {
            Luxe.shutdown();
        }
    }

    override function update(delta:Float) {
        if(snake==null)return;
        snake.rotation_z += 40*delta;
    }
    
    override function onmousemove(event:MouseEvent) {
        if(snake==null)return;
        snake.pos = event.pos;
    }
}
