import utest.Runner;
import utest.ui.Report;

import gtfs.*;

class TestAll
{

    public static function main()
    {
        var r = new Runner();
        
        r.addCase(new TestServiceValidity());

        Report.create(r);
        r.run();
    }

}

