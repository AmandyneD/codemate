import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["number"]

  connect() {
    this.hasAnimated = false

    this.observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting && !this.hasAnimated) {
            this.hasAnimated = true
            this.animateAll()
            this.observer.disconnect()
          }
        })
      },
      { threshold: 0.35 }
    )

    this.observer.observe(this.element)
  }

  disconnect() {
    if (this.observer) this.observer.disconnect()
  }

  animateAll() {
    this.numberTargets.forEach((element, index) => {
      const endValue = parseInt(element.dataset.value, 10) || 0
      const duration = 900 + index * 120

      element.classList.add("is-glitching")
      element.dataset.display = "0"

      setTimeout(() => {
        element.classList.remove("is-glitching")
      }, 220)

      this.animateValue(element, endValue, duration)
    })
  }

  animateValue(element, endValue, duration) {
    const start = 0
    const startTime = performance.now()

    const tick = (currentTime) => {
      const elapsed = currentTime - startTime
      const progress = Math.min(elapsed / duration, 1)
      const eased = 1 - Math.pow(1 - progress, 3)
      const currentValue = Math.floor(start + (endValue - start) * eased)

      element.textContent = currentValue
      element.dataset.display = currentValue

      if (progress < 1) {
        requestAnimationFrame(tick)
      } else {
        element.textContent = endValue
        element.dataset.display = endValue
        element.classList.add("is-glitch-end")

        setTimeout(() => {
          element.classList.remove("is-glitch-end")
        }, 180)
      }
    }

    requestAnimationFrame(tick)
  }
}
