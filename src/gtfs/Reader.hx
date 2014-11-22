package gtfs;

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
        for (r in CsvReader.open(getFile("agency.txt"))) {
            // TODO
        }
    }

    function getFile(name:String):Input {
        var x = Lambda.find(zip, function (e) return e.fileName == name);
        // TODO check for null
        return new BytesInput(haxe.zip.Reader.unzip(x));
    }

}

class CsvReader {
    var inp:Input;

    function splitLine(line)
    {
        trace(line);
        var v = [];
        var pre = 0, cur = 0, end = 0;
        var quoted = false;
        while (cur < line.length) {
            switch (line.charAt(cur)) {
            case "\"":
                if (!quoted) {
                    quoted = true;
                    pre = cur + 1;
                } else if (cur + 1 < line.length && line.charAt(cur + 1) == "\"") {
                    end = ++cur;
                } else {
                    quoted = false;
                    end = cur - 1;
                }
            case ",":
                if (!quoted && cur != pre) {
                    v.push(StringTools.replace(line.substring(pre, end + 1), "\"\"", "\""));
                    pre = cur + 1;
                } else {
                    end = cur;
                }
            case all:
                end = cur;
            }
            cur++;
        }
        if (cur != pre)
            v.push(StringTools.replace(line.substring(pre, end + 1), "\"\"", "\""));
        trace(v);
        return v;
    }

    function readHeader()
    {
        trace(splitLine(readLine()));
    }

    // normalize CRLF into LF
    function readLine()
    {
        var raw = inp.readUntil("\n".code);
        return StringTools.replace(raw, "\r", "");
    }

    function new(inp)
    {
        this.inp = inp;
    }

    public function hasNext()
    {
        return false;
    }

    public function next():Dynamic
    {
        return null;
    }

    public static function open(inp:Input)
    {
        var x = new CsvReader(inp);
        x.readHeader();
        return x;
    }
}

