// 电机A（左侧）方向引脚
const int IN1 = 2;
const int IN2 = 3;

// 电机B（右侧）方向引脚
const int IN3 = 4;
const int IN4 = 5;

void setup() {
  // 初始化所有方向引脚为输出
  pinMode(IN1, OUTPUT);
  pinMode(IN2, OUTPUT);
  pinMode(IN3, OUTPUT);
  pinMode(IN4, OUTPUT);

  // 初始状态：刹车停止
  stopMotor();

  Serial.begin(9600);
  Serial.println("L298N 函数封装模式，跳线帽使能模式，开始测试");
}

void loop() {
  Serial.println("前进");
  goForward();
  delay(1000);

  Serial.println("后退");
  goBackward();
  delay(1000);

  Serial.println("原地左转");
  turnLeft();
  delay(1000);

  Serial.println("原地右转");
  turnRight();
  delay(1000);

  Serial.println("刹车停止");
  stopMotor();
  delay(6000);
}

// ================= 自定义运动函数（核心部分） =================

// 1. 前进：两电机正转
void goForward() {
  digitalWrite(IN1, HIGH);
  digitalWrite(IN2, LOW);
  digitalWrite(IN3, HIGH);
  digitalWrite(IN4, LOW);
}

// 2. 后退：两电机反转
void goBackward() {
  digitalWrite(IN1, LOW);
  digitalWrite(IN2, HIGH);
  digitalWrite(IN3, LOW);
  digitalWrite(IN4, HIGH);
}

// 3. 原地左转：左轮反转，右轮正转
void turnLeft() {
  digitalWrite(IN1, LOW);
  digitalWrite(IN2, HIGH);
  digitalWrite(IN3, HIGH);
  digitalWrite(IN4, LOW);
}

// 4. 原地右转：左轮正转，右轮反转
void turnRight() {
  digitalWrite(IN1, HIGH);
  digitalWrite(IN2, LOW);
  digitalWrite(IN3, LOW);
  digitalWrite(IN4, HIGH);
}

// 5. 刹车停止：所有引脚拉低（急停）
void stopMotor() {
  digitalWrite(IN1, LOW);
  digitalWrite(IN2, LOW);
  digitalWrite(IN3, LOW);
  digitalWrite(IN4, LOW);
}