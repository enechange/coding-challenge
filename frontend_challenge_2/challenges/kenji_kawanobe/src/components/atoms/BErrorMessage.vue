<template>
  <div class="a_error-message">
    <div class="a_error-message_icon">
      <i class="fas fa-exclamation-triangle"></i>
    </div>
    <p><slot name="message"></slot></p>
  </div>
</template>

<script lang="ts">
import { Component, Vue, Prop } from "vue-property-decorator";

@Component
export default class BErrorMessage extends Vue {
  @Prop({ type: Boolean, default: false }) isRequired!: boolean;
}
</script>

<style scoped lang="scss">
.a_error-message {
  display: flex;
  border-radius: 0.4rem;
  background: $required;
  color: $white;
  align-items: center;
  padding: 0rem 1rem;
  margin: 1.2rem 0;

  &_icon {
    margin-right: 0.5rem;
  }
}
</style>
