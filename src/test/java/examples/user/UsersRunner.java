package examples.user;

import com.intuit.karate.junit5.Karate;

public class UsersRunner {

    @Karate.Test
    Karate getUsers() {
        return Karate.run("user").relativeTo(getClass()) .tags("@regression");
    }
}
