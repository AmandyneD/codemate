import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "category", "results", "selected", "hiddenFields"]
  static values = {
    searchUrl: String,
    selected: Array
  }

  connect() {
    console.log("technology-picker connected")
    console.log("selectedValue:", this.selectedValue)

    this.selectedItems = this.selectedValue || []
    this.renderSelected()
    this.renderHiddenFields()
  }

  search() {
    console.log("technology-picker search triggered")

    const query = this.inputTarget.value.trim()
    const category = this.categoryTarget.value

    const url = new URL(this.searchUrlValue, window.location.origin)

    if (query.length > 0) {
      url.searchParams.set("q", query)
    }

    if (category.length > 0) {
      url.searchParams.set("category", category)
    }

    console.log("fetching:", url.toString())

    fetch(url, {
      headers: { Accept: "application/json" }
    })
      .then(response => response.json())
      .then(data => {
        console.log("results:", data)
        this.renderResults(data)
      })
      .catch(error => {
        console.error("Technology search failed:", error)
      })
  }

  renderResults(items) {
    const filtered = items.filter(item => {
      return !this.selectedItems.some(selected => selected.id === item.id)
    })

    if (filtered.length === 0) {
      this.resultsTarget.innerHTML = `<div class="tech-picker-empty">No matching technologies found.</div>`
      return
    }

    this.resultsTarget.innerHTML = filtered.map(item => {
      return `
        <button
          type="button"
          class="tech-picker-result"
          data-id="${item.id}"
          data-name="${item.name}"
          data-category="${item.category}"
        >
          <span>${item.name}</span>
          <small>${item.category}</small>
        </button>
      `
    }).join("")

    this.resultsTarget.querySelectorAll(".tech-picker-result").forEach(button => {
      button.addEventListener("click", () => {
        this.addTechnology({
          id: Number(button.dataset.id),
          name: button.dataset.name,
          category: button.dataset.category
        })
      })
    })
  }

  addTechnology(item) {
    if (this.selectedItems.some(selected => selected.id === item.id)) return

    this.selectedItems.push(item)
    this.inputTarget.value = ""
    this.resultsTarget.innerHTML = ""

    this.renderSelected()
    this.renderHiddenFields()
  }

  removeTechnology(event) {
    const id = Number(event.currentTarget.dataset.id)
    this.selectedItems = this.selectedItems.filter(item => item.id !== id)

    this.renderSelected()
    this.renderHiddenFields()
  }

  renderSelected() {
    if (this.selectedItems.length === 0) {
      this.selectedTarget.innerHTML = `<div class="tech-picker-placeholder">No technologies selected yet.</div>`
      return
    }

    this.selectedTarget.innerHTML = this.selectedItems.map(item => {
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

    this.selectedTarget.querySelectorAll(".tech-tag-remove").forEach(button => {
      button.addEventListener("click", this.removeTechnology.bind(this))
    })
  }

  renderHiddenFields() {
    this.hiddenFieldsTarget.innerHTML = this.selectedItems.map(item => {
      return `<input type="hidden" name="project[technology_ids][]" value="${item.id}">`
    }).join("")
  }

  handleKeydown(event) {
    if (event.key === "Enter") {
      event.preventDefault()
    }
  }
}
