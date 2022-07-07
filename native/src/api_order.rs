use anyhow::Error;
use std::path::Path;
use std::result::Result::Ok;
use std::{
    fs::{File, OpenOptions},
    io::{Read, Write},
};

// #[frb(dart_metadata=("freezed", "immutable" import "package:meta/meta.dart" as meta))]
pub struct OrderItem {
    pub id: i32,
    pub title: String,
}
pub fn get_orders(offset: i32, limit: i32) -> Vec<OrderItem> {
    let mut result: Vec<OrderItem> = Vec::new();
    result.push(OrderItem {
        id: 12,
        title: "hahaha".to_string(),
    });
    result
}

// 测试写文件
pub fn write_file(filepath: String, content: String) {
    match OpenOptions::new()
        .write(true)
        .append(true)
        .create(true)
        .open(Path::new(&filepath))
    {
        Ok(mut f) => match f.write(content.as_bytes()) {
            Ok(_) => {}
            Err(e) => {
                println!("{:?}", e)
            }
        },
        Err(e) => {
            println!("{:?}", e);
        }
    }
}

// 测试读文件
pub fn read_file(filepath: String) -> Result<String, Error> {
    let resut = match File::open(Path::new(&filepath)) {
        Ok(mut f) => {
            let mut str = String::new();
            match f.read_to_string(&mut str) {
                Ok(_) => Ok(str),
                Err(e) => Err(Error::new(e)),
            }
        }
        Err(e) => Err(Error::new(e)),
    };
    resut
}
