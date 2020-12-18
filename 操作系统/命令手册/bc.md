# bc

```bash
echo "4 * 0.56" | bc
2.24

no=54;
result=`echo "$no * 1.5" | bc`
echo $result
81.0
```

* 设定小数精度（数值范围）

  ```bash
  echo "scale=2;3/8" | bc
  0.37
  ```

* 进制转换

  ```bash
  no=100
  echo "obase=2;$no" | bc
  1100100
  no=1100100
  echo "obase=10;ibase=2;$no" | bc
  100
  # ibase 输入数值的进制；obase 输出数值的进制。
  ```

* 计算平方以及平方根

  ```bash
  echo "sqrt(100)" | bc   #Square root
  echo "10^10" | bc
  ```