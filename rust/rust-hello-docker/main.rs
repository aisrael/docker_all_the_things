use std::env;

fn main() {
    let who = env::args().nth(1).unwrap_or(String::from("World"));

    println!("Hello, {}!", who);
}
