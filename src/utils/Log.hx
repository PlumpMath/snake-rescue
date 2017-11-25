package utils;

class Log {
    public static function log(msg) {
        #if web
            js.Browser.window.console.log(msg);
        #elseif cpp
            Sys.println(msg);
        #else
            trace(msg);
        #end
    }
}
