<template>
  <v-container class="py-8 px-6">
    <v-row>
      <v-col>
        <div>契約アンペア数 [A]</div>
        <v-select outlined :items="amperes" v-model="select_ampere"></v-select>
        <div>使用量 [kWh] (半角数字で入力してください)</div>
        <v-text-field v-model="usage" outlined required></v-text-field>
        <v-btn :disabled="checkUsage" @click="simulationCharge"
          >結果を見る</v-btn
        >
      </v-col>
    </v-row>

    <v-row>
      <v-col>
        <div v-if="this.error != null">{{ error }}</div>
      </v-col>
      <v-col
        v-for="result_simulation in result_simulations"
        :key="result_simulation.provider_name"
      >
        <div>
          会社: {{ result_simulation.provider_name }} <br />
          プラン: {{ result_simulation.plan_name }} <br />
          プラン: {{ result_simulation.price }}円 <br />
        </div>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import axios from "axios";

export default {
  data: () => ({
    select_ampere: null,
    usage: "",
    result_simulations: null,
    amperes: [10, 15, 20, 30, 40, 50, 60],
    error: null,
  }),
  computed: {
    checkUsage: function () {
      if (this.usage.match(/[^0-9]/) || this.usage == "") {
        return true;
      } else {
        return false;
      }
    },
  },
  methods: {
    initializeParams() {
      this.select_ampere = null;
      this.usage = null;
      this.result_simulations = null;
      this.error = null;
    },
    async simulationCharge() {
      this.error = null;
      try {
        const res = await axios.get(`${process.env.VUE_APP_API_URL}`, {
          params: {
            ampere: this.select_ampere,
            usage: this.usage,
          },
        });
        if (!this.error) {
          console.log(res.data);
          this.result_simulations = res.data;
        }
      } catch (error) {
        this.result_simulations = null;
        if (error.response.status == 400)
          this.error = error.response.data.message;
        else this.error = "接続エラーが発生しました";
      }
    },
  },
};
</script>
