Technology.destroy_all

technologies = [
  "Ruby",
  "Rails",
  "JavaScript",
  "TypeScript",
  "React",
  "Next.js",
  "Node.js",
  "Python",
  "Django",
  "Flask",
  "Java",
  "Spring",
  "PHP",
  "Laravel",
  "PostgreSQL",
  "MySQL",
  "MongoDB",
  "Redis",
  "Docker",
  "Kubernetes",
  "AWS",
  "GCP",
  "Azure",
  "Tailwind",
  "Bootstrap",
  "Flutter",
  "Swift",
  "Kotlin"
]

technologies.each do |tech|
  Technology.create!(name: tech)
end
