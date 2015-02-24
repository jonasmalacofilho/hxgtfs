package gtfs;

import format.csv.*;
import utest.Assert;

class TestCsvReader {

    public function new() {}

    function split(line)
    {
        return Reader.read(line)[0];
    }

    public function test01_BasicSplit()
    {
        var s = "agency_id,agency_name,agency_url";
        Assert.same(["agency_id", "agency_name", "agency_url"], split(s));
        Assert.same(["agency_id", "agency_name", "agency_url"], split(StringTools.trim(s)));
    }

    public function test02_EscapedSplit()
    {
        var s = "\"agency\"\"_\"\"id\",agency_name,agency_url\n";
        Assert.same(["agency\"_\"id", "agency_name", "agency_url"], split(s)); 
    }

}

