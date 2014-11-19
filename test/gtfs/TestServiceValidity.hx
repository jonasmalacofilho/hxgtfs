package gtfs;

import gtfs.Types;
import utest.Assert;

@:publicFields
class TestServiceValidity
{

    function new()
    {
        // NOOP
    }

    function testStorage()
    {
        var sv:ServiceValidity;

        sv = Monday;
        Assert.equals(cast(Monday, Int), cast(sv, Int));
        sv = Monday || Tuesday;
        Assert.equals(cast(Monday, Int) | cast(Tuesday, Int), cast(sv, Int));
        sv = Monday && Tuesday;
        Assert.equals(cast(Monday, Int) | cast(Tuesday, Int), cast(sv, Int));
    }

    function testVerification()
    {
        var s:Service = {
            id : "",
            validity : Monday || Tuesday,  // -> ServiceValidity
            startDate : null,
            endDate : null
        };

        // -> ValidityQuery
        Assert.isTrue(s.validity.validFor(Monday));
        Assert.isTrue(s.validity.validFor(Monday || Thursday));
        Assert.isFalse(s.validity.validFor(Thursday));
        Assert.isFalse(s.validity.validFor(Monday && Thursday));
    }

}

