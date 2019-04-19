<template>
  <div class="about">
    <editor />
  </div>
</template>

<script>
// @ is an alias to /src
import editor from '@/components/Editor.vue'

export default {
  name: 'About',
  components: {
    editor
  }
}
</script>