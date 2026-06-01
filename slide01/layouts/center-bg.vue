<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{
  background?: string
}>()

const style = computed(() => ({
  backgroundImage: props.background ? `url('${props.background}')` : undefined,
  backgroundSize: 'cover',
  backgroundPosition: 'center',
  width: '100%',
  height: '100%',
}))
</script>

<template>
  <div class="slidev-layout center h-full grid place-content-center" :style="style">
    <slot />
  </div>
</template>

<style>
.slidev-layout * {
  -webkit-text-size-adjust: none;
  text-size-adjust: none;
}
.slidev-layout h1 { font-size: xxx-large; line-height: 1.1; font-weight: 800; }
.slidev-layout h2 { font-size: xx-large; line-height: 1.2; font-weight: 700; }
.slidev-layout h3 { font-size: x-large; line-height: 1.3; font-weight: 600; margin: auto 2.5%; text-align: center;}
.slidev-layout h4 { font-size: large; line-height: 1.4; font-weight: 500; margin: auto 2.5% }
.slidev-layout h5 { font-size: medium; line-height: 1.5; font-weight: 400; margin: auto 2.5% }
.slidev-layout h6 { font-size: small; line-height: 1.6; font-weight: 300; margin: auto 2.5% }
.slidev-layout p  { font-size: 0.9em; line-height: 1.7; margin: auto 4%; }
.slidev-layout ul          { list-style-type: disc; padding-left: 1.5rem; margin: auto 4% ; font-size: 0.9em; line-height: 1.7;}
.slidev-layout ol          { list-style-type: decimal; padding-left: 1.5rem; margin: auto 4%; font-size: 0.9em; line-height: 1.7;}
.slidev-layout ul ul       { list-style-type: circle; font-size: 0.8em;}
.slidev-layout ul ul ul    { list-style-type: square; font-size: 0.7em;}
.slidev-layout li          { margin: 0.25rem 0; }
.slidev-layout table       { border-collapse: collapse; width: 100%; }
.slidev-layout td          { border: 1px solid rgba(255,255,255,0.5); padding: 0.5rem 1rem; background: rgba(255,255,255,0.166); font-size: 0.75rem; }
.slidev-layout th          { border: 1px solid rgba(255,255,255,0.5); padding: 0.5rem 1rem; background: rgba(255,255,255,0.33); font-weight: 600; font-size: 0.85rem; }
</style>