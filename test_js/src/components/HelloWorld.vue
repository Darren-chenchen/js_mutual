<template>
  <div class="hello">
    <button @click="getPhoneInfo()">点击获取手机设备的信息</button>
    <p v-html="phoneInfo"></p>
    <button @click="getJson()" style="margin-top: 60px">点击调用原生方法，获取一串json</button>
    <p v-html="json"></p>
  </div>
</template>


<script>
  import Bridge from '../ios_wkwebview/bridge'

  export default {

  name: 'HelloWorld',
  data () {
    return {
      phoneInfo: '',
      json: ''
    }
  },
  created() {
  },
  mounted() {
    this.initEvent()
  },
  methods: {
    initEvent() {
      // for ios WKWebView
      // 注册showAlert事件，只要ios的WKWebView调用showAlert，就会接受到
      Bridge.registerEvent('showAlert', function (data, responseCallback) {
        responseCallback('让ios自己弹框')
      })
    },
    getPhoneInfo() {

      /// 针对ios的WKWebView
      Bridge.callEvent('getPhoneInfo', '', (data) => {
        this.phoneInfo = data
      })

      /// 针对安卓或者ios的UIViewView
      try {
        let phoneInfo = window.phone.getPhoneInfo()
        this.phoneInfo = phoneInfo
      } catch (e) {}
    },
    getJson() {

      /// 针对ios的WKWebView
      Bridge.callEvent('getJson', '', (data) => {
        let json = JSON.parse(data)
        this.json = json
      })

      /// 针对安卓或者ios的UIViewView
      try {
        let json = JSON.parse(window.phone.getJson())
        this.json = json
      } catch (e) {}
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
  .hello {
    display: flex;
    align-items: center;
    flex-direction: column;
  }
  .hello button {
    height: 40px;
    line-height: 40px;
    background-color: #67C23A;
    color: white;
    font-size: 16px;
    border-radius: 20px;
    border-color: transparent;
    padding: 0 20px;
    outline: none;
  }
  .hello p {
    width: 100%;
  }
</style>
