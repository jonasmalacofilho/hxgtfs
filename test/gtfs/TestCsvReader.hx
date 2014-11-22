package gtfs;

import gtfs.Reader;
import haxe.io.StringInput;
import utest.Assert;

@:access(gtfs.CsvReader)
class TestCsvReader {

    public function new()
    {
    }

    public function testBasicSplit()
    {
        var s = "agency_id,agency_name,agency_url\n";  // TODO fix no ending \n
        var o = new CsvReader(new StringInput(s));
        Assert.same(["agency_id", "agency_name", "agency_url"],
            o.splitLine(o.readLine()));
    }

    public function testEscapedSplit()
    {
        var s = "\"agency\"\"_\"\"id\",agency_name,agency_url\n";  // TODO fix no ending \n
        var o = new CsvReader(new StringInput(s));
        Assert.same(["agency\"_\"id", "agency_name", "agency_url"],
            o.splitLine(o.readLine()));
    }

}

