<script setup>
import { ref } from 'vue'
import axios from 'axios'

defineProps({
  msg: String,
})

const ampere = ref('')
const ampereOptions = [10, 15, 20, 30, 40, 50, 60]
const usage = ref('')
const electricityPrices = ref([])
const errorMessage = ref('')

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL

const fetchData = async () => {
  electricityPrices.value = []
  errorMessage.value = ''

  try {
    const response = await axios.get(`${API_BASE_URL}/electricity_prices`, {
      params: {
        ampere: ampere.value,
        usage: usage.value
      }
    })

    // 最も安い価格かどうかを識別できるようにする
    const minPrice = [...response.data].sort((a, b) => a.price - b.price)[0].price

    electricityPrices.value = response.data.map(plan => ({
      ...plan,
      isCheapest: plan.price === minPrice
    }))
  } catch (error) {
    errorMessage.value = error.response.data.error
  }
}
</script>

<template>
  <h1>{{ msg }}</h1>
  <div>
    <label>
      <div>
        契約アンペア数(A)
      </div>
      <select
        :value='ampere'
        @input='event => ampere = event.target.value'>
        <option v-for="option in ampereOptions" :key="option" :value="option">
          {{ option }}
        </option>
      </select>
    </label>
  </div>

  <div style='margin-top: 10px;'>
    <label>
      <div>
        1ヶ月の使用量(kWh)
        <span v-tooltip="'0以上の整数を入力してください'" class='info'>ℹ️</span>
      </div>
      <input
        type='text'
        :value='usage'
        @input='event => usage = event.target.value'>
    </label>
  </div>

  <div class='button'>
    <button @click='fetchData'>この条件で電力会社を比較</button>
  </div>

  <table v-if='electricityPrices.length' class="price-table">
    <thead>
      <tr>
        <th>電力会社</th>
        <th>プラン名</th>
        <th>料金</th>
        <th>最安</th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="(plan, index) in electricityPrices" :key="index">
        <td>{{ plan.provider_name }}</td>
        <td>{{ plan.plan_name }}</td>
        <td>{{ plan.price }} 円</td>
        <td>{{ plan.isCheapest ? '✅' : '' }}</td>
      </tr>
    </tbody>
  </table>

  <div v-if='errorMessage' class='error'>{{ errorMessage }}</div>
</template>

<style scoped>
input {
  width: 200px;
}
select {
  width: 210px;
}
.info {
  cursor: pointer;
}
.button {
  margin-top: 10px;
}
.price-table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 10px;
}
.price-table th,
.price-table td {
  text-align: left;
}
.error {
  color: #f15656;
  margin-top: 10px;
}
</style>
