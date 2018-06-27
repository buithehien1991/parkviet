<template>
  <div class="base-loading">
    <div class="spinner"></div>
  </div>
</template>

<style lang="stylus" scoped>
  .base-loading
    flex-box()
    box-center()

    .spinner
      width 24px
      height 24px
      border-radius 50%
      border solid 3px transparent
      border-right-color #0084b4
      animation spinner .7s linear infinite

    &.overlay
      position absolute
      top 0
      bottom 0
      left 0
      right 0

  @keyframes spinner
    0%
      transform rotate(0deg)
    100%
      transform rotate(360deg)
</style>
