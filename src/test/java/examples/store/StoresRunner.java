package examples.store;

import com.intuit.karate.junit5.Karate;

public class StoresRunner {

    @Karate.Test
    Karate getStores() {
        return Karate.run("store").relativeTo(getClass());
    }
}
