import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["ampere", "usage", "results"]

  async search(event) {
    event.preventDefault();

    const ampere = this.ampereTarget.value;
    const usage = this.usageTarget.value;
    this.resultsTarget.innerHTML = "";

    try {
      const response = await fetch(`/plans/prices?ampere=${ampere}&usage=${usage}`);
      if (!response.ok) throw new Error("API request failed");
      const data = await response.json();
      if (Array.isArray(data) && data.length > 0) {
        data.forEach(plan => {
          const row = this.buildRow(plan);
          this.resultsTarget.appendChild(row);
        });
      } else {
        alert("該当するプランがありません。");
      }
    } catch (error) {
      alert("検索に失敗しました: " + error.message);
    }
  }

  buildRow(plan) {
    const row = document.createElement("tr");
    row.innerHTML = `
      <td>${plan.provider_name}</td>
      <td>${plan.plan_name}</td>
      <td>${plan.price}</td>
    `;
    return row;
  }
}
