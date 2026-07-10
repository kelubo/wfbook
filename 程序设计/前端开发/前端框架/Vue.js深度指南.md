# Vue.js深度指南

## 概述

Vue.js是一款渐进式JavaScript框架，用于构建用户界面。它的核心库只关注视图层，易于上手且便于与第三方库或既有项目整合。

---

## 一、Vue基础

### 1.1 Vue核心概念

```
Vue核心概念
        │
        ├─ 响应式系统：数据驱动视图更新
        ├─ 组件化：将UI分解为可复用组件
        ├─ 虚拟DOM：提高DOM操作效率
        └─ 模板语法：声明式渲染数据
```

### 1.2 Vue实例

```
Vue实例创建
const app = new Vue({
  el: '#app',
  data: {
    message: 'Hello Vue!'
  },
  methods: {
    greet() {
      return this.message
    }
  },
  computed: {
    reversedMessage() {
      return this.message.split('').reverse().join('')
    }
  }
})
```

### 1.3 模板语法

```
模板语法示例
<div id="app">
  <!-- 文本插值 -->
  <p>{{ message }}</p>
  
  <!-- 指令 -->
  <p v-if="seen">现在你看到我了</p>
  
  <!-- 绑定属性 -->
  <a v-bind:href="url">链接</a>
  
  <!-- 事件绑定 -->
  <button v-on:click="greet">点击</button>
  
  <!-- 双向绑定 -->
  <input v-model="message">
</div>
```

---

## 二、组件系统

### 2.1 组件定义

```
组件定义
Vue.component('my-component', {
  props: ['title'],
  data() {
    return {
      count: 0
    }
  },
  template: `
    <div>
      <h3>{{ title }}</h3>
      <p>计数: {{ count }}</p>
      <button @click="count++">增加</button>
    </div>
  `
})
```

### 2.2 组件通信

```
组件通信方式
        │
        ├─ 父传子：props
        │   ├─ 父组件：<child :message="msg"></child>
        │   └─ 子组件：props: ['message']
        │
        ├─ 子传父：$emit
        │   ├─ 子组件：this.$emit('update', value)
        │   └─ 父组件：<child @update="handleUpdate"></child>
        │
        ├─ 兄弟组件通信：EventBus或Vuex
        │
        └─ 跨层级通信：provide/inject
            ├─ 父组件：provide: { theme: 'dark' }
            └─ 子组件：inject: ['theme']
```

### 2.3 插槽

```
插槽使用
        │
        ├─ 默认插槽
        │   <slot></slot>
        │
        ├─ 具名插槽
        │   <slot name="header"></slot>
        │   <template v-slot:header>...</template>
        │
        └─ 作用域插槽
            <slot :user="user"></slot>
            <template v-slot:default="slotProps">{{ slotProps.user.name }}</template>
```

---

## 三、Vue Router

### 3.1 路由配置

```
路由配置
import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from './views/Home.vue'
import About from './views/About.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/about',
    name: 'About',
    component: About
  },
  {
    path: '/user/:id',
    name: 'User',
    component: () => import('./views/User.vue')
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
```

### 3.2 路由导航

```
路由导航方式
        │
        ├─ 声明式导航
        │   <router-link to="/home">首页</router-link>
        │
        ├─ 编程式导航
        │   this.$router.push('/home')
        │   this.$router.replace('/home')
        │   this.$router.go(-1)
        │
        └─ 路由守卫
            ├─ 全局守卫：router.beforeEach
            ├─ 路由守卫：beforeEnter
            └─ 组件守卫：beforeRouteEnter
```

---

## 四、Vuex状态管理

### 4.1 Vuex核心概念

```
Vuex核心概念
        │
        ├─ state：状态存储
        ├─ mutations：同步修改状态
        ├─ actions：异步操作
        ├─ getters：计算属性
        └─ modules：模块划分
```

### 4.2 Vuex配置

```
Vuex配置
import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    count: 0
  },
  mutations: {
    increment(state) {
      state.count++
    }
  },
  actions: {
    incrementAsync({ commit }) {
      setTimeout(() => {
        commit('increment')
      }, 1000)
    }
  },
  getters: {
    doubleCount(state) {
      return state.count * 2
    }
  },
  modules: {}
})
```

### 4.3 Vuex使用

```
Vuex使用
        │
        ├─ 获取状态：this.$store.state.count
        ├─ 获取getter：this.$store.getters.doubleCount
        ├─ 提交mutation：this.$store.commit('increment')
        ├─ 分发action：this.$store.dispatch('incrementAsync')
        └─ map辅助函数
            import { mapState, mapGetters, mapMutations, mapActions } from 'vuex'
```

---

## 五、Vue 3新特性

### 5.1 组合式API

```
组合式API
import { ref, computed, onMounted } from 'vue'

export default {
  setup() {
    const count = ref(0)
    const doubleCount = computed(() => count.value * 2)
    
    function increment() {
      count.value++
    }
    
    onMounted(() => {
      console.log('组件挂载')
    })
    
    return {
      count,
      doubleCount,
      increment
    }
  }
}
```

### 5.2 响应式系统改进

```
响应式系统改进
        │
        ├─ ref：创建响应式基本类型
        ├─ reactive：创建响应式对象
        ├─ computed：创建计算属性
        ├─ watch：监听响应式变化
        └─ watchEffect：自动追踪依赖
```

### 5.3 其他新特性

```
Vue 3其他新特性
        │
        ├─ 碎片(Fragments)：支持多个根节点
        ├─ Teleport：传送组件到DOM的另一个位置
        ├─ Suspense：等待异步组件加载
        ├─ 全局API重构：Vue.createApp()替代new Vue()
        └─ TypeScript支持：更好的类型推断
```

---

## 六、性能优化

### 6.1 Vue性能优化策略

```
Vue性能优化策略
        │
        ├─ 响应式优化
        │   ├─ 使用Object.freeze()冻结不需要响应式的对象
        │   ├─ 使用v-once渲染一次后不再更新
        │   └─ 使用v-memo缓存渲染结果
        │
        ├─ 列表渲染优化
        │   ├─ 使用key提高Diff效率
        │   ├─ 使用虚拟列表处理大量数据
        │   └─ 使用Lazyload懒加载图片
        │
        ├─ 组件优化
        │   ├─ 使用异步组件按需加载
        │   ├─ 使用keep-alive缓存组件状态
        │   └─ 拆分大型组件为多个小组件
        │
        └─ 打包优化
            ├─ 使用Tree Shaking移除未使用代码
            ├─ 使用Code Splitting分割代码
            └─ 使用CDN加载第三方库
```

### 6.2 Vue性能监控

```
Vue性能监控工具
        │
        ├─ Vue DevTools：浏览器扩展，调试Vue应用
        ├─ Lighthouse：性能审计工具
        ├─ Chrome Performance：性能分析工具
        └─ Vue Performance Devtool：Vue性能分析插件
```

---

## 总结

Vue.js是一款强大的前端框架，通过组件化、响应式和虚拟DOM等核心特性，使前端开发更加高效和便捷。Vue 3的组合式API进一步提升了代码组织和复用能力。