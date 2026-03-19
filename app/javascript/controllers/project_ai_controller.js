import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["title", "shortDescription", "description", "button", "buttonText", "spinner"]
  static values = { url: String }

  async generate() {
    const title = this.titleTarget.value.trim()
    const shortDescription = this.shortDescriptionTarget.value.trim()

    if (!title || !shortDescription) {
      alert("Please fill in title and short description first.")
      return
    }

    this.startLoading()

    try {
      const response = await fetch(this.urlValue, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({
          title,
          short_description: shortDescription
        })
      })

      const data = await response.json()

      if (!response.ok) {
        throw new Error(data.error || "AI generation failed.")
      }

      this.descriptionTarget.value = data.description
    } catch (error) {
      alert(error.message)
    } finally {
      this.stopLoading()
    }
  }

  startLoading() {
    this.buttonTarget.disabled = true
    this.buttonTarget.classList.add("is-loading")
    this.buttonTextTarget.textContent = "Generating..."
  }

  stopLoading() {
    this.buttonTarget.disabled = false
    this.buttonTarget.classList.remove("is-loading")
    this.buttonTextTarget.textContent = "Generate with AI"
  }
}
