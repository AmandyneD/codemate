import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"

import TechnologyPickerController from "controllers/technology_picker_controller"
import TechnologyFilterController from "controllers/technology_filter_controller"
import HomeMotionController from "controllers/home_motion_controller"
import ProjectAiController from "controllers/project_ai_controller"
import GlitchWordController from "controllers/glitch_word_controller"

const application = Application.start()

application.debug = false
window.Stimulus = application

application.register("technology-picker", TechnologyPickerController)
application.register("technology-filter", TechnologyFilterController)
application.register("home-motion", HomeMotionController)
application.register("project-ai", ProjectAiController)
application.register("glitch-word", GlitchWordController)

document.addEventListener("turbo:load", () => {
  try {
    initNavbarGlitch()
  } catch (error) {
    console.error("Navbar glitch error:", error)
  }

  try {
    initHomeCtaGlitch()
  } catch (error) {
    console.error("Home CTA glitch error:", error)
  }
})

function initNavbarGlitch() {
  const btn = document.querySelector(".js-navbar-glitch")
  if (!btn) return

  const triggerGlitch = () => {
    btn.classList.remove("glitch-active")
    void btn.offsetWidth
    btn.classList.add("glitch-active")

    window.setTimeout(() => {
      btn.classList.remove("glitch-active")
    }, 220)
  }

  btn.addEventListener("mouseenter", triggerGlitch)
}

function initHomeCtaGlitch() {
  const btn = document.querySelector(".glitch-btn")
  if (!btn) return

  const triggerGlitch = () => {
    btn.classList.remove("glitch-active")
    void btn.offsetWidth
    btn.classList.add("glitch-active")

    window.setTimeout(() => {
      btn.classList.remove("glitch-active")
    }, 220)
  }

  btn.addEventListener("mouseenter", triggerGlitch)
}
