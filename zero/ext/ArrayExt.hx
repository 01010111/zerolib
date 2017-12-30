package zero.ext;

class ArrayExt 
{

    inline public static function strings_to_ints(array:Array<String>):Array<Int>
    {
        var a = [];
        for (s in array) a.push(Std.parseInt(s));
        return a;
    }

}