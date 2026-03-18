const homeGlitch = () => {
  const btn = document.querySelector(".js-glitch")
  if (!btn) return

  let timeoutId

  const trigger = () => {
    btn.classList.add("glitch-active")

    window.setTimeout(() => {
      btn.classList.remove("glitch-active")
    }, 160)
  }

  const loop = () => {
    const delay = Math.random() * 5000 + 4000

    timeoutId = window.setTimeout(() => {
      trigger()
      loop()
    }, delay)
  }

  loop()

  document.addEventListener(
    "turbo:before-cache",
    () => {
      if (timeoutId) window.clearTimeout(timeoutId)
      btn.classList.remove("glitch-active")
    },
    { once: true }
  )
}

export { homeGlitch }
