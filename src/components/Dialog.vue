<template>
  <div>
    <el-row>
      <el-col :span="12">
        请选择项目及版本：
      </el-col>
      <el-col :span="4">
        <el-cascader
          expand-trigger="hover"
          :options="versionOptions"
          v-model="active.projectIdAndVersion"
          @change="changeVersion" />
      </el-col>
    </el-row>
    <el-row>
      <el-col :span="12" :offset="4">
        <el-input v-model="active.dialogText" placeholder="请输入对话内容" />
      </el-col>
      <el-col :span="2">
        <el-button icon="el-icon-message" circle @click="sendDialogText" />
      </el-col>
    </el-row>
    <el-row>
      <el-col :span="16" :offset="4">
        <!-- <el-input class="textarea-box"
          type="textarea"
          :autosize="{ minRows: 2, maxRows: 20}"
          placeholder=""
          resize="none"
          :disable="true"
          v-model="active.dialogResponse">
        </el-input> -->
        <div class="resonse-box">
          <pre style="text-align:left">{{active.dialogResponse}}</pre>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import axios from 'axios'
export default {
  name: 'dialogControl',
  data() {
    return {
      host: 'http://118.31.52.226:5000',
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
        return
      }
      if (this.active.dialogText == '') {
        this.$notify.error({
          title: '错误',
          message: '未填写对话语句！'
        })
        return
      }

      axios.get(this.host + '/nlu/predict', {
        params: {
          projectId: this.active.projectIdAndVersion[0],
          version: this.active.projectIdAndVersion[1],
          text: this.active.dialogText
        }
      })
      .then(res => {
        console.log(res.data)
        this.active.dialogResponse = res.data
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.resonse-box {
  display: inline-block;
  width: 100%;
  height: 500px;
  overflow-y: auto;
  border: 1px solid red;
  font-size: 14px;
}
.el-row {
  margin-bottom: 20px;
  &:last-child {
    margin-bottom: 0;
  }
}
</style>