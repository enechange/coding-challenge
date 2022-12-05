<script setup>
import { ref } from "vue";

const ampere = ref(30);
const amount = ref(100);
const results = ref([]);

const simurate = () => {
  fetch(`/api/plan/simurate?ampere=${ampere.value}&amount=${amount.value}`).then((res) => res.json()).then((data) => {
    results.value = data.data.plan_prices;
  });
};

simurate();
</script>

<template>
  <div class="flex min-h-full items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
    <div class="w-full max-w-lg space-y-8">
      <div>
        <h1 class="mt-6 text-center text-3xl font-bold tracking-tight text-gray-900">
          電気料金シミュレーター
        </h1>
        <p class="mt-2 text-center text-sm text-gray-600">契約アンペア数と使用量を入力して、送信ボタンを押してください。</p>
      </div>
      <div class="mt-2 mb-2 text-center">
        <form class="overflow-hidden shadow sm:rounded-md" @submit.prevent="simurate">
          <div class="bg-white px-4 py-5 sm:p-6">
            <div class="grid grid-cols-6 gap-6">
              <div class="col-span-6 sm:col-span-3">
                <label for="ampere" class="block text-sm font-medium text-gray-700 text-left">契約アンペア数 (A)</label>
                <select v-model="ampere" id="ampere" name="ampere" class="mt-1 block w-full rounded-md border border-gray-300 bg-white py-2 px-3 shadow-sm focus:border-indigo-500 focus:outline-none focus:ring-indigo-500 sm:text-sm">
                  <option value="10">10A</option>
                  <option value="15">15A</option>
                  <option value="20">20A</option>
                  <option value="30">30A</option>
                  <option value="40">40A</option>
                  <option value="50">50A</option>
                  <option value="60">60A</option>
                </select>
              </div>
              <div class="col-span-6 sm:col-span-3">
                <label for="amount" class="block text-sm font-medium text-gray-700 text-left">使用量 (kWh)</label>
                <input v-model="amount" type="number" name="amount" id="amount" autocomplete="given-name" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm" step="1" min="0">
              </div>
            </div>
          </div>
          <div class="bg-gray-50 px-4 py-3 text-right sm:px-6">
            <button type="submit" class="inline-flex justify-center rounded-md border border-transparent bg-indigo-600 py-2 px-4 text-sm font-medium text-white shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2">送信</button>
          </div>
        </form>
      </div>
      <div class="mt-2">
        <table class="table-auto w-full">
          <thead>
            <tr>
              <th class="px-4 py-2">プラン名</th>
              <th class="px-4 py-2">電力会社名</th>
              <th class="px-4 py-2">金額</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="result of results" :key="result.id" class="odd:bg-gray-100">
              <td class="px-4 py-2 text-sm">{{ result.plan_name }}</td>
              <td class="px-4 py-2 text-sm">{{ result.provider_name }}</td>
              <td class="text-right whitespace-nowrap px-4 py-2">{{ result.price.toLocaleString() }}円</td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="mt-2 text-center">
        APIドキュメントは<a href="/docs/" class="text-blue-600">こちら</a>
      </div>
    </div>
  </div>
</template>
