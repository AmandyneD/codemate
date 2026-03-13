import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["reveal", "parallax"]

  connect() {
    this.handleScroll = this.handleScroll.bind(this)
    this.setupReveal()
    window.addEventListener("scroll", this.handleScroll, { passive: true })
    this.handleScroll()
  }

  disconnect() {
    window.removeEventListener("scroll", this.handleScroll)
    if (this.observer) this.observer.disconnect()
  }

  setupReveal() {
    this.observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add("is-visible")
          }
        })
      },
      { threshold: 0.15 }
    )

    this.revealTargets.forEach((el) => this.observer.observe(el))
  }

  handleScroll() {
    const scrollY = window.scrollY || window.pageYOffset

    this.parallaxTargets.forEach((el) => {
      const speed = parseFloat(el.dataset.speed || "0.35")
      // compute offset relative to the section top so movement is stable
      const sectionTop = this.element.offsetTop
      let offset = (sectionTop - scrollY) * speed

      // clamp to avoid huge transforms when far away
      const max = 400
      if (offset > max) offset = max
      if (offset < -max) offset = -max

      el.style.transform = `translate3d(0, ${offset}px, 0)`

      // optional debug: add data-debug="true" on the controller element
      if (this.element.dataset.debug === "true") {
        // eslint-disable-next-line no-console
        console.debug('home-motion', { scrollY, sectionTop, speed, offset })
      }
    })
  }
}
