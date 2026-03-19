import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.setAttribute("data-text", this.element.textContent.trim())
    this.isDisconnected = false
    this.loop()
  }

  disconnect() {
    this.isDisconnected = true

    if (this.timer) clearTimeout(this.timer)
    if (this.glitchTimeout) clearTimeout(this.glitchTimeout)

    this.element.classList.remove(
      "glitch-mode-1",
      "glitch-mode-2",
      "glitch-mode-3",
      "glitch-mode-4",
      "glitch-mode-5"
    )
  }

    loop() {
      if (this.isDisconnected) return

      const delay = this.random(2000, 4000)

      this.timer = setTimeout(() => {
        this.triggerGlitch()
        this.loop()
      }, delay)
    }

  triggerGlitch() {
    const classes = [
      "glitch-mode-1",
      "glitch-mode-2",
      "glitch-mode-3",
      "glitch-mode-4",
      "glitch-mode-5"
    ]

    const mode = classes[this.randomInt(0, classes.length)]

    this.element.classList.remove(...classes)
    void this.element.offsetWidth
    this.element.classList.add(mode)

    const duration = this.random(90, 180)

    this.glitchTimeout = setTimeout(() => {
      this.element.classList.remove(...classes)
    }, duration)
  }

  random(min, max) {
    return Math.random() * (max - min) + min
  }

  randomInt(min, max) {
    return Math.floor(this.random(min, max))
  }
}
