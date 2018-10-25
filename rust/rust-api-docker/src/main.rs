extern crate iron;
extern crate params;
extern crate router;
extern crate rustc_serialize;

use iron::prelude::*;
use iron::status;
use iron::mime::Mime;
use params::{Params, Value};
use router::Router;
use rustc_serialize::json;

#[derive(RustcEncodable)]
struct JsonResponse {
  data: String
}

fn main() {
    fn hello_world(req: &mut Request) -> IronResult<Response> {
        let who = match req.get_ref::<Params>().unwrap().find(&["who"]) {
            Some(&Value::String(ref name)) => name,
            _ => "World"
        };

        let content_type = "application/json".parse::<Mime>().unwrap();
        let response = JsonResponse { data: format!("Hello, {}!", who) };

        return Ok(Response::with((content_type, status::Ok, json::encode(&response).unwrap())));
    }

    let mut router = Router::new();
    router.get("/world", hello_world, "index");

    println!("Server started on 8080");
    Iron::new(router).http("0.0.0.0:8080").unwrap();
}
