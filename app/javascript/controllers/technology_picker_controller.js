import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results", "selected", "hiddenFields"]
  static values = {
    searchUrl: String,
    selected: Array,
    inputName: String
  }

  connect() {
    this.selectedItems = Array.isArray(this.selectedValue) ? this.selectedValue : []
    this.renderSelected()
    this.renderHiddenFields()
  }

  search() {
    const query = this.inputTarget.value.trim()

    if (query.length === 0) {
      this.clearResults()
      return
    }

    const url = new URL(this.searchUrlValue, window.location.origin)
    url.searchParams.set("q", query)

    fetch(url, {
      headers: { Accept: "application/json" }
    })
      .then(response => response.json())
      .then(data => this.renderResults(data))
      .catch(error => console.error("Technology search failed:", error))
  }

  renderResults(items) {
    const filtered = items.filter((item) => {
      return !this.selectedItems.some((selected) => Number(selected.id) === Number(item.id))
    })

    if (filtered.length === 0) {
      this.resultsTarget.innerHTML = `
        <div class="tech-picker-empty">No matching technologies found.</div>
      `
      return
    }

    this.resultsTarget.innerHTML = filtered.map((item) => {
      return `
        <button
          type="button"
          class="tech-picker-result"
          data-id="${item.id}"
          data-name="${item.name}"
        >
          <span>${item.name}</span>
        </button>
      `
    }).join("")

    this.resultsTarget.querySelectorAll(".tech-picker-result").forEach((button) => {
      button.addEventListener("click", () => {
        this.addTechnology({
          id: Number(button.dataset.id),
          name: button.dataset.name
        })
      })
    })
  }

  addTechnology(item) {
    if (this.selectedItems.some((selected) => Number(selected.id) === Number(item.id))) return

    this.selectedItems.push(item)
    this.inputTarget.value = ""
    this.clearResults()
    this.renderSelected()
    this.renderHiddenFields()
    this.inputTarget.focus()
  }

  removeTechnology(event) {
    const id = Number(event.currentTarget.dataset.id)
    this.selectedItems = this.selectedItems.filter((item) => Number(item.id) !== id)

    this.renderSelected()
    this.renderHiddenFields()
  }

  renderSelected() {
    if (this.selectedItems.length === 0) {
      this.selectedTarget.innerHTML = `
        <div class="tech-picker-placeholder">No technologies selected yet.</div>
      `
      return
    }

    this.selectedTarget.innerHTML = this.selectedItems.map((item) => {
      return `
        <span class="tech-tag">
          <span>${item.name}</span>
          <button
            type="button"
            class="tech-tag-remove"
            data-id="${item.id}"
            aria-label="Remove ${item.name}"
          >
            ×
          </button>
        </span>
      `
    }).join("")

    this.selectedTarget.querySelectorAll(".tech-tag-remove").forEach((button) => {
      button.addEventListener("click", this.removeTechnology.bind(this))
    })
  }

  renderHiddenFields() {
    const uniqueIds = [...new Set(this.selectedItems.map((item) => String(item.id)))]
    const inputName = this.hasInputNameValue ? this.inputNameValue : "project[technology_ids][]"

    this.hiddenFieldsTarget.innerHTML = uniqueIds.map((id) => {
      return `<input type="hidden" name="${inputName}" value="${id}">`
    }).join("")
  }

  handleKeydown(event) {
    if (event.key === "Enter") {
      event.preventDefault()
    }

    if (event.key === "Escape") {
      this.clearResults()
      this.inputTarget.blur()
    }

    if (event.key === "Backspace" && this.inputTarget.value.trim() === "" && this.selectedItems.length > 0) {
      this.selectedItems.pop()
      this.renderSelected()
      this.renderHiddenFields()
    }
  }

  hideResults() {
    setTimeout(() => {
      this.clearResults()
    }, 150)
  }

  clearResults() {
    this.resultsTarget.innerHTML = ""
  }
}
