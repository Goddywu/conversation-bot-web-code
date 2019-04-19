// require elementUI sass
<template>
  <div>
		<!-- start -->
  	<div id="editor">
			<div class="nav"> 
				<div class="nav-file"> 
					<span v-for="(file, i) in files" :class="{'active': i==activeFile.fileIndex}">
						<el-tooltip effect="light" :content="file.name" placement="bottom-start" :open-delay="1000">
							<div class="text" @click="changeFile(i)">{{file.name}}</div>
						</el-tooltip>
						<i :class="i==activeFile.fileIndex && editing ? 'el-icon-edit-outline' : 'el-icon-close'" 
							@click="deleteFile(i)" />
					</span>
				</div>
				<div class="nav-button">
					<i class="el-icon-circle-plus-outline" @click="dialogFormVisible=true" />
					<i class="el-icon-refresh" v-show="editing" @click="saveActiveFile" />
				</div>
			</div>
			<div class="text-area">
				<div class="line-bar"> 
					<span v-for="i in activeRowNum">{{i}}</span>
				</div>
				<textarea @keyup.meta.83.native="changeEditing" v-model="activeFile.text" id="text-area-id" wrap="hard" 
					:rows="Math.max(22, activeRowNum)" />
			</div>
  	</div>
		<!-- end -->

		<el-dialog id="dialog" title="新建文件" :visible.sync="dialogFormVisible">
			<el-form>
				<el-form-item label="文件名称" label-width="80px">
					<el-input v-model="newFileName" autocomplete="off"></el-input>
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button @click="dialogFormVisible = false">取 消</el-button>
				<el-button type="primary" @click="dialogFormVisible = false;addNewFile()">确 定</el-button>
			</div>
		</el-dialog>
  </div>
</template>

<script>
import { setTimeout } from 'timers';
export default {
  name: 'editor',
  data() {
    return {
			files: [
				{
					name: 'new.json',
					text: ''
				}
				// {
				// 	name: 'apachespark.json',
				// 	text: 'xxx\r\nxxx\r\n\r\nxxxxxxxxxxxx'
				// },
				// {
				// 	name: 'book.json',
				// 	text: '222\r\n\r\n2xxxxxxx\r\nxxxxxxxxxxx'
				// }
			],
			activeFile: {
				text: '',
				fileIndex: Number
			},
			editing: false,
			dialogFormVisible: false,
			newFileName: ''
    }
	},
	props: ['editorData'],
	watch: {
		activeFile: {
			handler(newActive, oldActive) {
				if (newActive.fileIndex != oldActive.fileIndex) return
				this.editing = true
			},
			deep: true
		},
		editorData(n, o) {
			if (n != null && typeof(n) != 'undefined' && n.length != 0) {
				this.files = n
				console.log(this.files)
				console.log(11111)
				this.changeFile(0)
			}
		}
	},
	computed: {
		activeRowNum() {
			return this.activeFile.text.split(/\r*\n/).length
		}
	},
  mounted() {
	},
	methods: {
		changeEditing() {
			console.log('change edit!!!!')
		},
		addNewFile() {
			this.files.push({
				name: this.newFileName,
				text: ''
			})
			this.newFileName = ''
			this.changeFile(this.files.length - 1)
		},
		deleteFile(fileIndex) {
			let addFirstFile = () => {
				if (this.files.length == 0) {
					this.files.push({
						name: 'new.json',
						text: ''
					})
				}
			}

			this.$confirm('删除文件' + this.files[fileIndex].name + '、?')
			.then(_ => {
				if (this.activeFile.fileIndex == fileIndex) {
					this.files.splice(fileIndex, 1)
					this.changeFile(fileIndex - 1)
				} else if (this.activeFile.fileIndex > fileIndex) {
					this.files.splice(fileIndex, 1)
					this.changeFile(this.activeFile.fileIndex - 1)
				} else {
					this.files.splice(fileIndex, 1)
				}
				addFirstFile()
			})
			.catch(_ => {
				addFirstFile()
			})
		},
		changeFile(fileIndex) {
			if (fileIndex == this.activeFile.fileIndex) return
			if (this.editing) {
				this.$confirm('您编辑了内容，是否保存？')
				.then(_ => {
					this.saveActiveFile(fileIndex)
					this.switchActiveFile(fileIndex)
				})
				.catch(_ => { this.switchActiveFile(fileIndex) })
			} else {
				this.switchActiveFile(fileIndex)
			}
		},
		saveActiveFile(fileIndex) {
			this.editing = false
			this.files[this.activeFile.fileIndex].text = this.activeFile.text
		},
		switchActiveFile(fileIndex) {
			this.editing = false
			this.activeFile = {
				text: this.files[fileIndex].text,
				fileIndex: fileIndex
			}
		}
	}
}
</script>

<style scoped lang="scss">
#editor {
	width: 800px;
	height: 600px;
	// width: 100%;
	// height: 100%;
	display: inline-block;
	.nav {
		font-family: "Helvetica Neue", Arial, Helvetica, sans-serif;
		width: calc(100% - 50px);
		height: 60px;
		position: relative;
		background-color: rgb(60, 60, 76);
		padding-left: 50px;
		.nav-file {
			width: calc(100% - 230px);
			overflow-x: auto;
			display: inline-block;
			height: 100%;
			float: left;
			font-size: 0;
			span {
				display: inline-block;
				font-size: 15px;
				line-height: 30px;
				height: calc(100% - 20px);
				float: left;
				margin-top: 20px;
				cursor: pointer;
				width: 100px;
				box-sizing: border-box;
				color: rgb(237, 237, 237);
				border-right: 1px solid rgb(44, 44, 60);
				div {
					padding-left: 10px;
					overflow: hidden; 
					text-overflow: ellipsis;
					white-space: nowrap;
					display: inline-block;
					width: calc(100% - 40px);
					height: 100%;
					float: left;
				}
				.el-icon-close:hover {
					color: rgb(153, 10, 219);
				}
				.el-icon-edit-outline:hover {
					&::before {
					color: rgb(153, 10, 219);
						content: "\E60F";
					}
				}
			}
			.active {
				background-color: rgb(40, 42, 53);
				border-right: 1px solid rgb(44, 44, 60);
			}
		}
		button {
			height: 40px;
			margin-left: 10px;
		}
		.nav-button {
			i {
				color:  rgb(255, 255, 255);
				cursor: pointer;
				&:hover {
					color: rgb(153, 10, 219);
				}
			}
			padding: 10px 0;
			width: 230px;
			position: absolute;
			right: 0;
		}
	}
	.text-area {
		background-color: rgb(255, 255, 255);
		display: inline-block;
		height: calc(100% - 60px);
		width: 100%;
		overflow-y: auto;
		.line-bar {
			padding: 5px 0px;
			display: inline-block;
			width: 50px;
			min-height: calc(100% - 10px);
			float: left;
			font-size: 0;
    	background-color: rgb(60, 60, 76);
			span {
				display: inline-block;
				width: calc(100% - 8px);
				height: 22px;
				margin: 0;
				padding: 0 4px;
				text-align: center;
				line-height: 22px;
				color: rgb(100, 115, 160);
				font-size: 12px;
			}
		}
		textarea {
			display: inline-block;
			width: calc(100% - 70px);
			min-height: calc(100% - 10px);
			float: left;
			border: none;
			background-color: rgb(40, 42, 53);
			caret-color: rgb(255, 255, 255);
			color: rgb(255, 255, 255);
			cursor: text;
			resize: none;
			padding: 5px 10px;
			font-size: 20px;
			line-height: 22px;
			font-family: "SFMono-Regular", Consolas, "Liberation Mono", Menlo, Courier, monospace;
		}
	}
}
</style>