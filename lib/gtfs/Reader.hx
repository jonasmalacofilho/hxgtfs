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
        for (r in csvIterator(getFile("agency.txt"))) {
            // TODO
        }
    }

    // TODO improve lib csv API, then remove
    function csvIterator(inp:Input)
    {
        var r = new CsvReader(",", "\"", "\n");  // FIXME support Unicode multiple EOL
        r.reset(null, inp);
        return r;
    }

    function getFile(name:String):Input {
        var x = Lambda.find(zip, function (e) return e.fileName == name);
        // TODO check for null
        return new BytesInput(haxe.zip.Reader.unzip(x));
    }

}

