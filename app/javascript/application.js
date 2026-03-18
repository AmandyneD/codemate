import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import TechnologyPickerController from "controllers/technology_picker_controller"
import TechnologyFilterController from "controllers/technology_filter_controller"
import HomeMotionController from "controllers/home_motion_controller"
import ProjectAiController from "controllers/project_ai_controller"

const application = Application.start()

application.debug = false
window.Stimulus = application

application.register("technology-picker", TechnologyPickerController)
application.register("technology-filter", TechnologyFilterController)
application.register("home-motion", HomeMotionController)
application.register("project-ai", ProjectAiController)

document.addEventListener("turbo:load", () => {
  try {
    const btn = document.querySelector(".js-navbar-glitch")
    if (!btn) return

    let timeoutId = null
    let audioEnabled = false

    const playGlitchSound = () => {
      if (!audioEnabled) return

      const audio = new Audio("/sounds/glitch-click.mp3")
      audio.volume = 0.08
      audio.play().catch(() => {})
    }

    const triggerGlitch = () => {
      btn.classList.remove("glitch-active")
      void btn.offsetWidth
      btn.classList.add("glitch-active")

      playGlitchSound()

      window.setTimeout(() => {
        btn.classList.remove("glitch-active")
      }, 220)
    }

    btn.addEventListener("mouseenter", triggerGlitch)
    btn.addEventListener("click", triggerGlitch)

    document.addEventListener("click", () => {
      audioEnabled = true
    }, { once: true })

    const rareLoop = () => {
      const delay = Math.random() * 9000 + 8000
      timeoutId = window.setTimeout(() => {
        triggerGlitch()
        rareLoop()
      }, delay)
    }

    rareLoop()

    document.addEventListener("turbo:before-cache", () => {
      if (timeoutId) window.clearTimeout(timeoutId)
      btn.classList.remove("glitch-active")
    }, { once: true })
  } catch (error) {
    console.error("Navbar glitch error:", error)
  }
})
