package gtfs;

import format.csv.Reader in CsvReader;
import gtfs.Types;
import haxe.io.BytesInput;
import haxe.io.Input;

class Reader {
    var zip:List<haxe.zip.Entry>;
    var ctx:Gtfs;

    function new()
    {
        ctx = cast { agencies : [] };
    }

    function openArchive(inp:Input)
    {
        zip = haxe.zip.Reader.readZip(inp);
        trace(zip.map(function (e) return e.fileName));
    }

    function readAgencies()
    {
        for (r in new CsvReader().reset(getFile("agency.txt"))) {
            // TODO
        }
    }

    function getFile(name:String):Input {
        var x = Lambda.find(zip, function (e) return e.fileName == name);
        // TODO check for null
        return new BytesInput(haxe.zip.Reader.unzip(x));
    }

}

