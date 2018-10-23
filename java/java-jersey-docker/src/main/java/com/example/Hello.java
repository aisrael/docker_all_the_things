package com.example;

import javax.json.Json;
import javax.ws.rs.DefaultValue;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;

/**
 * Root resource (exposed at "myresource" path)
 */
@Path("hello")
public class Hello {

    /**
     * Method handling HTTP GET requests. The returned object will be sent
     * to the client as "text/plain" media type.
     *
     * @return String that will be returned as a text/plain response.
     */
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String get(@QueryParam("who") @DefaultValue("world") final String who) {
        return Json.createObjectBuilder()
        .add("data", Json.createObjectBuilder().add("greeting", "Hello, " + who + "!"))
        .build()
        .toString();
    }
}
