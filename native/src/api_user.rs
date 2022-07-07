// use flutter_rust_bridge::*;

// #[frb(dart_metadata=("freezed", "immutable" import "package:meta/meta.dart" as meta))]
pub struct UserItem {
    pub id: i32,
    pub user_name: String,
}
pub fn get_login_user() -> UserItem {
    UserItem {
        id: 12,
        user_name: "xixi".to_string(),
    }
}
