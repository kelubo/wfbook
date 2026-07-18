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

  // 初始状态：所有引脚拉低，电机刹车停止
  digitalWrite(IN1, LOW);
  digitalWrite(IN2, LOW);
  digitalWrite(IN3, LOW);
  digitalWrite(IN4, LOW);

  Serial.begin(9600);
  Serial.println("L298N 跳线帽使能模式，开始测试");
}

void loop() {
  // 1. 前进（两电机正转）
  Serial.println("前进");
  digitalWrite(IN1, HIGH);
  digitalWrite(IN2, LOW);
  digitalWrite(IN3, HIGH);
  digitalWrite(IN4, LOW);
  delay(6000);

  // 2. 后退（两电机反转）
  Serial.println("后退");
  digitalWrite(IN1, LOW);
  digitalWrite(IN2, HIGH);
  digitalWrite(IN3, LOW);
  digitalWrite(IN4, HIGH);
  delay(6000);

  // 3. 原地左转（左侧电机反转，右侧电机正转）
  Serial.println("原地左转");
  digitalWrite(IN1, LOW);
  digitalWrite(IN2, HIGH);   // 左轮反转
  digitalWrite(IN3, HIGH);
  digitalWrite(IN4, LOW);    // 右轮正转
  delay(6000);

  // 4. 原地右转（左侧电机正转，右侧电机反转）
  Serial.println("原地右转");
  digitalWrite(IN1, HIGH);
  digitalWrite(IN2, LOW);    // 左轮正转
  digitalWrite(IN3, LOW);
  digitalWrite(IN4, HIGH);   // 右轮反转
  delay(6000);

  // 5. 停止（刹车）
  Serial.println("刹车停止");
  digitalWrite(IN1, LOW);
  digitalWrite(IN2, LOW);
  digitalWrite(IN3, LOW);
  digitalWrite(IN4, LOW);
  delay(6000);
}