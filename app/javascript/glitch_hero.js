export function heroGlitch() {
  const canvas = document.getElementById("hero-glitch-canvas")
  if (!canvas) return

  const ctx = canvas.getContext("2d")

  function resize() {
    canvas.width = canvas.offsetWidth
    canvas.height = canvas.offsetHeight
  }

  resize()
  window.addEventListener("resize", resize)

  function drawGlitch() {
    ctx.clearRect(0, 0, canvas.width, canvas.height)

    const lines = Math.random() * 3

    for (let i = 0; i < lines; i++) {
      const y = Math.random() * canvas.height
      const h = Math.random() * 2

      ctx.fillStyle = "rgba(0,255,160,0.08)"
      ctx.fillRect(0, y, canvas.width, h)

      if (Math.random() > 0.6) {
        ctx.fillStyle = "rgba(255,0,255,0.04)"
        ctx.fillRect(Math.random() * canvas.width, y, 80, h)
      }

      if (Math.random() > 0.7) {
        ctx.fillStyle = "rgba(0,200,255,0.05)"
        ctx.fillRect(Math.random() * canvas.width, y, 40, h)
      }
    }

    if (Math.random() > 0.92) {
      ctx.globalAlpha = 0.1
      ctx.fillStyle = "#00ff9c"
      ctx.fillRect(
        Math.random() * canvas.width,
        Math.random() * canvas.height,
        Math.random() * 120,
        Math.random() * 4
      )
      ctx.globalAlpha = 1
    }
  }

  setInterval(drawGlitch, 90)
}
