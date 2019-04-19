<template>
  <div>
		<div class="left-box" :class="[showLeftBox?'open':'close']"> 
			<i :class="[showLeftBox?'el-icon-arrow-left':'el-icon-arrow-right']"
        @click="showLeftBox=!showLeftBox" class="switch-btn" />
			<div class="editor-container">
    		<editor class="editor-class" :editorData="editorData" />
			</div>
			<div class="menu">
				<el-button icon="el-icon-upload" circle />
			</div>
		</div>
		<div class="main-box">
			<dialogControl />
		</div>

  </div>
</template>
<script>
import axios from 'axios'
import dialogControl from '@/components/Dialog.vue'
import editor from '@/components/Editor.vue'
export default {
  name: 'nlu',
  components: {
    editor, dialogControl
  },
  data() {
    return {
      host: 'http://118.31.52.226:5000',
			showLeftBox: false,
			editorData: [],
			editorDataTmp: []
    }
	},
	mounted() {
		this.getEditorData()
	},
	methods: {
		getEditorData() {
			this.editorDataTmp = []


			new Promise((resolve, reject) => {
				this.getFiles((files) => {
					files.forEach(file => {
						this.getFileData(file['path'], (fileJson) => {
							this.editorDataTmp.push({
								name: file['name'],
								text: this.json2jsonString(fileJson),
								path: file['path']
							})
						})
					})
				})
				resolve()
			})
			.then(() => {
				console.log(this.editorDataTmp)
				this.editorData = this.editorDataTmp
			})
		},
		getFileData(path, callback) {
			axios.get(this.host + path)
			.then(res => {
				callback(res.data)
			})
		},
		json2jsonString(json) {
			return JSON.stringify(json, null, 2)
		},
		getFiles(callback) {
			var result
			axios.get(this.host + '/files')
			.then(res => {
				callback(res.data)
			})
		}
	}
}
</script>
<style lang="scss" scoped>
.left-box {
	z-index: 2;
	.editor-container {
		display: inline-block;
		overflow: auto;
		width: 100%;
		height: calc(100% - 60px);
	}
	.editor-class {
		width: 900px;
		height: 600px;
		float: left;
		margin-top: 40px;
	}
	.menu {
		display: inline-block;
		position: absolute;
		bottom: 0;
		width: 100%;
		height: 60px;
		left: 0;
	}
	position: absolute;
	display: inline-block;
	width: 900px;
	height: 100%;
	left: 0;
	top: 0;
	background-color: rgba(252, 252, 252, 1);
	border: 1px solid rgba(223,235,246,1);
	border-radius: 2px;
	transition: transform 0.5s;
	&.close {
		transform: translateX(calc(50px - 100%));
	}
	.switch-btn {
		position: absolute;
		top: 48%;
		right: 10px;
		padding: 10px 0;
		color: rgba(109, 145, 187, 1);
		font-weight: 2;
		cursor: pointer;
	}
}
.main-box {
	width: calc(100% - 50px);
	float: right;
	z-index: 1;
}
</style>