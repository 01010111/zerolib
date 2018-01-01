package zero.ext;

using zero.ext.ArrayExt;

/**
 *  @author 01010111 
 */
class StringExt
{

    inline public static function csv_to_2d_int_array(csv:String):Array<Array<Int>>
    {
        var a:Array<Array<Int>> = [];
        var rows = csv.split('\n');
        for (row in rows) a.push(row.split(',').strings_to_ints());
        return a;
    }

}