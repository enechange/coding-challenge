<template>
  <div>
    <div class="info-area py-8">
      <v-row>
        <v-col class="text-center">
          <h3>簡単シミュレーション</h3>
        </v-col>
      </v-row>
      <v-row>
        <v-col class="text-center">
          お手元に検針票をご用意し、シミュレーションをお試しください！
        </v-col>
      </v-row>
    </div>
    <div class="ampere mt-8">
      <v-row>
        <v-col class="title">
          ご契約のアンペア数を入力してください（単位：A）
        </v-col>
      </v-row>
      <v-row>
        <InputTextbox
          :params="ampereParams"
          ref="formAmpere"
        />
      </v-row>
    </div>
    <div class="amount mt-8">
      <v-row>
        <v-col class="title">
          電気のご使用量を入力してください（単位：kwh）
        </v-col>
      </v-row>
      <v-row>
        <InputTextbox
          :params="amountParams"
          ref="formAmount"
        />
      </v-row>
    </div>
    <v-row>
      <v-col class="mb-12">
        <v-btn
          @click="getSimulations"
          color="primary"
          block
        >
          結果を見る
        </v-btn>
      </v-col>
    </v-row>

    <div
      v-if="simulations.length"
    >
      <div class="info-area py-8">
        <v-row>
          <v-col class="text-center">
            <h3>シミュレーション結果</h3>
          </v-col>
        </v-row>
      </div>
      <div
        v-for="(simulation, i) in simulations"
        :key="simulation.plan_name"
      >
        <v-row>
          <v-col class="title mt-12">
            シミュレーション結果 {{ i + 1 }}
          </v-col>
        </v-row>

        <v-row>
          <v-col>
            電力会社名: {{ simulation.provider_name}}
          </v-col>
        </v-row>

        <v-row>
          <v-col>
            プラン名: {{ simulation.plan_name}}
          </v-col>
        </v-row>

        <v-row>
          <v-col>
            電気料金: {{ toLocalString(simulation.price) }}円
          </v-col>
        </v-row>
      </div>
    </div>
  </div>
</template>

<script>
import Vue from 'vue';
import InputTextbox from '@/components/molecules/InputTextbox.vue';

export default Vue.extend({
  name: 'Simulation',
  components: {
    InputTextbox,
  },
  data: () => ({
    ampereParams: {
      placeholder: 'ご契約のアンペア数',
      maxLength: '2',
      suffix: 'A',
    },
    amountParams: {
      placeholder: '電気の使用量',
      maxLength: '10',
      suffix: 'kwh',
    },
    simulations: [],
  }),
  methods: {
    toLocalString(numString) {
      return Number(numString).toLocaleString();
    },
    async getSimulations() {
      this.simulations.splice(0, this.simulations.length);

      const ampere = this.$refs.formAmpere.inputText || '';
      const amount = this.$refs.formAmount.inputText || '';

      const result = await this.$store.dispatch('callCalculation', {
        ampere,
        amount,
      });

      this.simulations.push(...result.data.simulations);
    },
  },
});
</script>
<style lang="scss" scoped>
@import './src/assets/styles/vars.scss';

.info-area {
  background-color: $color-grey-05;
}
.title {
  padding: 0.25em 0.5em;
  border-left: solid 5px $color-red-02;
}
</style>
