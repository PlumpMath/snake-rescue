package ;

import luxe.GameConfig;
import luxe.Input;
import phoenix.Texture;
import phoenix.RenderTexture;

import luxe.Color;
import luxe.Vector;
import entities.Pseudo3D;

import luxe.States;
import states.PlayState;

import luxe.Parcel;

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
    
    public static var backgroundBatcher : phoenix.Batcher;
    public static var foregroundBatcher : phoenix.Batcher;
    public static var foregroundTarget : phoenix.RenderTexture;
    public static var display_sprite : luxe.Sprite;
    
    public static var sprites : Array<Pseudo3D>;
    public static var colliders : Array<differ.shapes.Shape>;
    public static var player : entities.Player;
    var stateMachine : States;
    var playState : PlayState;
    
    public static var creators : Map<String, OptionalPseudo3DOptions -> Pseudo3D>;
    
    #if cpp
    var capture : LuxeGifCapture;
    #end
    
    override function config(config:GameConfig) {
        config.window.title = "Snake Rescue";
        config.window.width = 512;
        config.window.height = 512;
        config.window.resizable = false;
        config.window.fullscreen = false;
        
        return config;
    }

    override function ready() {
        Luxe.camera.size = new Vector(256, 256);
        
        phoenix.Texture.default_filter = FilterType.nearest;
        
        sprites = [];
        colliders = [];
        creators = new haxe.ds.StringMap();
        
        // load all the graphics! Remember to add new graphics here!
        var parcel = new Parcel({
            textures: [
                {id: "assets/textures/Background.png"},
                {id: "assets/textures/Overlay.png"}
            ],
            shaders: [
                {id: "outline", vert_id: "assets/shaders/default.vert", frag_id: "assets/shaders/outline.frag"}
            ],
            jsons: [
                {id: "assets/entities.json"},
                {id: "assets/levels/level0.json"}
            ]
        });
        
        var entloader = new EntitiesLoader();
        // get a simple loading screen for all that stuff. Builtin will do
        
        new DestroyParcelProgress({
            parcel: parcel,
            oncomplete: entloader.load.bind(_, this) // for loading and making creators for all entities
        });
        
        // load it!
        parcel.load();
    }
    
    public function assets_loaded(_) { // we're ready to use all that stuff!
        // setup batchers {
        backgroundBatcher = Luxe.renderer.create_batcher({
            name: "backgroundBatcher",
            camera: Luxe.camera.view,
            layer: 1
        });
        
        foregroundBatcher = Luxe.renderer.create_batcher({
            name: "foregroundBatcher",
            camera: Luxe.camera.view,
            layer: 2
        });
        
        var defBatcher = Luxe.renderer.batcher;
        foregroundTarget = new phoenix.RenderTexture({
            id: "foregroundTarget",
            width: Std.int(defBatcher.view.viewport.w),
            height: Std.int(defBatcher.view.viewport.h)
        });
        
        var outlineShader = Luxe.resources.shader("outline");
        outlineShader.set_vector2("pixelSize", new Vector(1/256, 1/256));
        
        display_sprite = new luxe.Sprite({
            texture: foregroundTarget,
            size: new Vector(256, 256),
            pos: new Vector(0, 0),
            centered: false,
            batcher: foregroundBatcher,
            depth: 0,
            shader: outlineShader
        });
        
        defBatcher.on(prerender, function(_) {
            Luxe.renderer.target = foregroundTarget;
            Luxe.renderer.clear(new Color(1, 1, 1, 0));
        });
        
        defBatcher.on(postrender, function(_) {
            Luxe.renderer.target = null;
        });
        // } batchers setup'd
        
        // setup the mint canvas {
        rendering = new LuxeMintRender();
        
        var autocanvas = new AutoCanvas(Luxe.camera.view, {
            name:"canvas",
            rendering: rendering,
            options: { color:new Color(1,1,1,0.0) },
            scale: 1,
            x: 0, y:0, w: Luxe.screen.w/2, h: Luxe.screen.h/2
        });
        autocanvas.auto_listen();
        canvas = autocanvas; // turn that thing into an actual canvas!
        
        focus = new Focus(canvas); // apparently this is necessary
        // } mint canvas setup'd
        
        stateMachine = new States({ name: "stateMachine" });
        playState = new PlayState({ name: "playState" });
        
        stateMachine.add(playState);
        stateMachine.set("playState");
        
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
        
    }
}
