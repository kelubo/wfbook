# Rust

## 概述

Rust是一种系统级编程语言，注重安全性、并发性和性能，由Mozilla开发。

## Rust特性

- **内存安全**：无需垃圾回收，编译时检查
- **零成本抽象**：高性能，无运行时开销
- **并发安全**：所有权系统防止数据竞争
- **模式匹配**：强大的模式匹配功能
- **宏系统**：元编程能力

## 安装

```bash
# Linux/macOS
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Windows
# 下载安装程序：https://www.rust-lang.org/tools/install

# 验证安装
rustc --version
cargo --version
```

## 基础语法

### Hello World

```rust
fn main() {
    println!("Hello, World!");
}
```

### 变量和数据类型

```rust
// 不可变变量
let x = 5;

// 可变变量
let mut y = 10;
y = 20;

// 数据类型
let a: i32 = 42;      // 32位有符号整数
let b: f64 = 3.14;    // 64位浮点数
let c: bool = true;   // 布尔值
let d: char = 'A';    // 字符
let e: &str = "hello"; // 字符串切片
```

### 函数

```rust
fn add(a: i32, b: i32) -> i32 {
    a + b
}

fn main() {
    let result = add(10, 20);
    println!("Result: {}", result);
}
```

### 控制流

```rust
// if-else
let x = 10;
if x > 5 {
    println!("x is greater than 5");
} else {
    println!("x is less than or equal to 5");
}

// match
let number = 3;
match number {
    1 => println!("One"),
    2 => println!("Two"),
    3 => println!("Three"),
    _ => println!("Other"),
}

// loop
let mut counter = 0;
loop {
    counter += 1;
    if counter >= 5 {
        break;
    }
}

// while
while counter > 0 {
    counter -= 1;
}

// for
for i in 0..5 {
    println!("i: {}", i);
}
```

## 所有权系统

### 所有权规则

1. 每个值都有一个所有者
2. 值在任意时刻只能有一个所有者
3. 当所有者离开作用域，值将被丢弃

### 借用

```rust
fn calculate_length(s: &String) -> usize {
    s.len()
}

fn main() {
    let s1 = String::from("hello");
    let len = calculate_length(&s1);
    println!("Length of '{}' is {}", s1, len);
}
```

### 可变借用

```rust
fn append_world(s: &mut String) {
    s.push_str(", world!");
}

fn main() {
    let mut s = String::from("hello");
    append_world(&mut s);
    println!("{}", s);
}
```

## 结构体

### 定义和实例化

```rust
struct Rectangle {
    width: u32,
    height: u32,
}

impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.height
    }
    
    fn can_hold(&self, other: &Rectangle) -> bool {
        self.width > other.width && self.height > other.height
    }
    
    fn square(size: u32) -> Self {
        Self {
            width: size,
            height: size,
        }
    }
}

fn main() {
    let rect = Rectangle {
        width: 30,
        height: 50,
    };
    println!("Area: {}", rect.area());
    
    let square = Rectangle::square(20);
    println!("Square area: {}", square.area());
}
```

## 枚举

```rust
enum IpAddr {
    V4(u8, u8, u8, u8),
    V6(String),
}

enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(i32, i32, i32),
}

impl Message {
    fn call(&self) {
        match self {
            Message::Quit => println!("Quit"),
            Message::Move { x, y } => println!("Move to ({}, {})", x, y),
            Message::Write(s) => println!("Write: {}", s),
            Message::ChangeColor(r, g, b) => println!("Color: ({}, {}, {})", r, g, b),
        }
    }
}
```

## 错误处理

### Result类型

```rust
use std::fs::File;
use std::io::Read;

fn read_file_content(filename: &str) -> Result<String, std::io::Error> {
    let mut file = File::open(filename)?;
    let mut content = String::new();
    file.read_to_string(&mut content)?;
    Ok(content)
}

fn main() {
    match read_file_content("example.txt") {
        Ok(content) => println!("Content: {}", content),
        Err(e) => println!("Error: {}", e),
    }
}
```

### Option类型

```rust
fn find_index(arr: &[i32], target: i32) -> Option<usize> {
    for (i, &val) in arr.iter().enumerate() {
        if val == target {
            return Some(i);
        }
    }
    None
}

fn main() {
    let arr = [1, 2, 3, 4, 5];
    match find_index(&arr, 3) {
        Some(index) => println!("Found at index: {}", index),
        None => println!("Not found"),
    }
}
```

## 并发

### 线程

```rust
use std::thread;
use std::time::Duration;

fn main() {
    let handle = thread::spawn(|| {
        for i in 1..10 {
            println!("Thread: {}", i);
            thread::sleep(Duration::from_millis(100));
        }
    });
    
    for i in 1..5 {
        println!("Main: {}", i);
        thread::sleep(Duration::from_millis(100));
    }
    
    handle.join().unwrap();
}
```

### 消息传递

```rust
use std::sync::mpsc;
use std::thread;

fn main() {
    let (tx, rx) = mpsc::channel();
    
    thread::spawn(move || {
        let message = String::from("Hello from thread");
        tx.send(message).unwrap();
    });
    
    let received = rx.recv().unwrap();
    println!("Received: {}", received);
}
```

## Cargo

### 创建项目

```bash
# 创建新项目
cargo new my_project

# 构建项目
cargo build

# 运行项目
cargo run

# 测试项目
cargo test

# 构建发布版本
cargo build --release
```

### Cargo.toml

```toml
[package]
name = "my_project"
version = "0.1.0"
edition = "2021"

[dependencies]
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"
reqwest = "0.11"
```

## Rust与嵌入式

### 嵌入式开发

```rust
#![no_std]
#![no_main]

use cortex_m_rt::entry;
use panic_halt as _;
use stm32f1xx_hal::{pac, prelude::*, timer::Timer};

#[entry]
fn main() -> ! {
    let p = pac::Peripherals::take().unwrap();
    let mut flash = p.FLASH.constrain();
    let mut rcc = p.RCC.constrain();
    
    let clocks = rcc.cfgr.freeze(&mut flash.acr);
    
    let mut gpioa = p.GPIOA.split(&mut rcc.apb2);
    let mut led = gpioa.pa5.into_push_pull_output(&mut gpioa.crl);
    
    let mut timer = Timer::syst(cortex_m::peripheral::SYST::take(), &clocks);
    
    loop {
        led.set_high();
        timer.delay_ms(500u16);
        led.set_low();
        timer.delay_ms(500u16);
    }
}
```

## Rust与WebAssembly

### 编译为WebAssembly

```bash
# 安装wasm-pack
curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh

# 创建wasm项目
wasm-pack new wasm_example

# 构建
wasm-pack build --target web
```

### 使用WebAssembly

```rust
// lib.rs
use wasm_bindgen::prelude::*;

#[wasm_bindgen]
pub fn greet(name: &str) -> String {
    format!("Hello, {}!", name)
}

#[wasm_bindgen]
pub fn fibonacci(n: u32) -> u32 {
    match n {
        0 => 0,
        1 => 1,
        _ => fibonacci(n - 1) + fibonacci(n - 2),
    }
}
```

## 总结

Rust是一门现代系统编程语言，通过所有权系统实现内存安全，无需垃圾回收。它在嵌入式开发、系统编程、WebAssembly等领域具有广泛应用。