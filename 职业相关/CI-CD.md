# CI/CD

## 概述

CI/CD（持续集成/持续部署）是一种软件开发实践，通过自动化构建、测试和部署流程，提高开发效率和软件质量。

## CI/CD流程

```
代码提交 → 持续集成 → 自动化测试 → 持续部署 → 生产环境
```

## CI/CD工具

### GitHub Actions

#### 基本配置

```yaml
# .github/workflows/main.yml
name: CI/CD

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v2
    
    - name: Set up Python
      uses: actions/setup-python@v2
      with:
        python-version: '3.9'
    
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements.txt
    
    - name: Run tests
      run: |
        python -m pytest tests/
    
    - name: Build Docker image
      run: |
        docker build -t my-app .
    
    - name: Deploy to production
      if: github.ref == 'refs/heads/main'
      run: |
        docker push my-app
```

#### 工作流语法

```yaml
# 触发条件
on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]
  schedule:
    - cron: '0 2 * * *'

# 环境变量
env:
  DATABASE_URL: ${{ secrets.DATABASE_URL }}

# 缓存依赖
- name: Cache dependencies
  uses: actions/cache@v2
  with:
    path: ~/.cache/pip
    key: ${{ runner.os }}-pip-${{ hashFiles('requirements.txt') }}
```

### GitLab CI

#### 基本配置

```yaml
# .gitlab-ci.yml
stages:
  - build
  - test
  - deploy

build:
  stage: build
  script:
    - npm install
    - npm run build

test:
  stage: test
  script:
    - npm test

deploy:
  stage: deploy
  script:
    - docker build -t my-app .
    - docker push my-app
  only:
    - main
```

#### 环境配置

```yaml
# 环境变量
variables:
  DATABASE_URL: $DATABASE_URL

# 缓存
cache:
  paths:
    - node_modules/

# 并行测试
test:
  parallel:
    matrix:
      - TEST_SUITE: [unit, integration, e2e]
```

### Jenkins

#### 基本配置

```groovy
// Jenkinsfile
pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                sh 'npm install'
                sh 'npm run build'
            }
        }
        
        stage('Test') {
            steps {
                sh 'npm test'
            }
        }
        
        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                sh 'docker build -t my-app .'
                sh 'docker push my-app'
            }
        }
    }
    
    post {
        success {
            echo 'Build successful!'
        }
        failure {
            echo 'Build failed!'
        }
    }
}
```

## CI/CD最佳实践

### 自动化测试

```yaml
# 单元测试
- name: Run unit tests
  run: python -m pytest tests/unit/

# 集成测试
- name: Run integration tests
  run: python -m pytest tests/integration/

# 端到端测试
- name: Run E2E tests
  run: cypress run
```

### 代码质量

```yaml
# 代码检查
- name: Run lint
  run: flake8 .

# 代码覆盖率
- name: Run coverage
  run: coverage run -m pytest

# 安全扫描
- name: Run security scan
  uses: snyk/actions/python@master
  env:
    SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
```

### 版本管理

```yaml
# 语义化版本
- name: Bump version
  uses: actions/github-script@v3
  with:
    script: |
      const version = require('./package.json').version
      console.log(`Current version: ${version}`)
```

### 部署策略

#### 蓝绿部署

```yaml
# 蓝绿部署
deploy:
  stage: deploy
  script:
    - ./deploy-blue-green.sh
  only:
    - main
```

#### 滚动部署

```yaml
# 滚动部署
deploy:
  stage: deploy
  script:
    - ./deploy-rolling.sh
  only:
    - main
```

#### 金丝雀部署

```yaml
# 金丝雀部署
deploy:
  stage: deploy
  script:
    - ./deploy-canary.sh
  only:
    - main
```

## CI/CD监控

### 监控指标

```yaml
# 构建时间
- name: Record build time
  uses: actions/github-script@v3
  with:
    script: |
      const startTime = Date.now()
      // ... build steps ...
      const buildTime = Date.now() - startTime
      console.log(`Build time: ${buildTime}ms`)

# 测试覆盖率
- name: Record test coverage
  run: coverage report --show-missing
```

### 告警配置

```yaml
# 构建失败告警
- name: Send failure notification
  if: failure()
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    text: Build failed!
```

## 总结

CI/CD是现代软件开发的核心实践，通过自动化构建、测试和部署流程，可以提高开发效率和软件质量。选择合适的CI/CD工具取决于团队规模、技术栈和部署需求。