<template>
  <div class="main">
    <div class="left">
      <el-form>
        <el-form-item label="数据集" label-width='80px'>
          <el-select @change="selectDataSet" v-model="active.dataSetPath" placeholder="请选择数据集">
            <el-option v-for="data in dataSet" :label="data.name" :value="data.path" /> 
          </el-select>
        </el-form-item>
        <el-form-item>
          <pre style="text-align:left">{{active.dataSet}}</pre>
        </el-form-item>
      </el-form>
    </div>
    <div class="right">
      <el-cascader
        expand-trigger="hover"
        :options="versionOptions"
        v-model="active.projectIdAndVersion"
        @change="changeVersion" />
      <el-input v-model="active.dialogText" placeholder="请输入对话内容" />
      <el-button icon="el-icon-message" circle @click="sendDialogText" />
      意图猜测结果为：
      <pre style="text-align:left">{{active.dialogResponse}}</pre>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
export default {
  name: 'HelloWorld',
  props: {
    msg: String
  },
  data() {
    return {
      host: 'http://118.31.52.226:5000',
      dataSet: [],
      projects: [],
      versionOptions: [],
      active: {
        dataSetPath: null,
        dataSet: null,
        dialogText: '',
        dialogResponse: null,
        projectIdAndVersion: []
      }
      
    }
  },
  mounted() {
    axios.get(this.host + '/files')
    .then(res => {
      this.dataSet = res.data
    })
    this.getProjects()
  },
  methods: {
    getProjects() {
      this.versionOptions = []
      axios.get(this.host + '/projects')
      .then(res => {
        this.projects = res.data
        if ('projects' in res.data) {
          for (var projectId in res.data['projects']) {
            var children = []
            var versions = res.data['projects'][projectId]
            versions.forEach(version => {
              children.push({
                value: version.version,
                label: version.version
              })
            })
            this.versionOptions.push({
              value: projectId,
              label: projectId,
              children: children
            })
          }
        }
      })
    },
    changeVersion() {
      console.log(this.active.projectIdAndVersion)
    },
    sendDialogText() {
      if (this.active.projectIdAndVersion.length == 0) {
        this.$notify.error({
          title: '错误',
          message: '未选择项目和版本！'
        })
      }
      if (this.active.dialogText == '') {
        this.$notify.error({
          title: '错误',
          message: '未填写对话语句！'
        })
      }

      axios.get(this.host + '/nlu/predict', {
        params: {
          projectId: this.active.projectIdAndVersion[0],
          version: this.active.projectIdAndVersion[1],
          text: this.active.dialogText
        }
      })
      .then(res => {
        this.active.dialogResponse = res.data
      })
    },
    selectDataSet() {
      // axios.get(this.host + '/' + this.active.dataSetPath)
      axios.get(this.host + '/' + './static/json/demo-rasa_zh.json')
      .then(res => {
        this.active.dataSet = res.data
        console.log(res.data)
      })
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="scss">
.left, .right {
  position: absolute;
  width: 500px;
  height: 600px;
  display: inline-block;
  border: 1px solid red;
}
.left {
  left: 20px;
}
.right {
  left: 540px;
}
</style>
