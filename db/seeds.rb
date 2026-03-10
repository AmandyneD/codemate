technologies = {
  frontend: [
    "HTML",
    "CSS",
    "JavaScript",
    "TypeScript",
    "React",
    "Next.js",
    "Vue.js",
    "Nuxt",
    "Angular",
    "Sass",
    "Tailwind CSS",
    "Bootstrap"
  ],

  backend: [
    "Ruby",
    "Rails",
    "Python",
    "Django",
    "Flask",
    "Java",
    "Spring Boot",
    "PHP",
    "Laravel",
    "Node.js",
    "Express",
    "C#",
    ".NET"
  ],

  mobile: [
    "Swift",
    "Kotlin",
    "Flutter",
    "React Native"
  ],

  database: [
    "PostgreSQL",
    "MySQL",
    "SQLite",
    "MongoDB",
    "Redis"
  ],

  devops: [
    "Docker",
    "Kubernetes",
    "GitHub Actions",
    "CI/CD",
    "Terraform",
    "Nginx"
  ],

  cloud: [
    "AWS",
    "Google Cloud",
    "Azure",
    "Heroku",
    "Vercel"
  ],

  ai: [
    "OpenAI API",
    "LangChain",
    "RAG",
    "Hugging Face",
    "TensorFlow",
    "PyTorch"
  ],

  data: [
    "Pandas",
    "NumPy",
    "dbt",
    "Airflow",
    "Power BI",
    "Tableau"
  ],

  crm: [
    "Salesforce",
    "Apex",
    "LWC",
    "SOQL",
    "Flow",
    "HubSpot"
  ],

  design: [
    "Figma",
    "Adobe Photoshop",
    "Adobe Illustrator"
  ],

  testing: [
    "RSpec",
    "Capybara",
    "Jest",
    "Cypress",
    "Minitest",
    "Postman"
  ],

  other: [
    "Notion",
    "Zapier",
    "Make"
  ]
}

technologies.each do |category, names|
  names.each do |name|
    tech = Technology.find_or_initialize_by(slug: name.parameterize)

    tech.name = name
    tech.category = category.to_s
    tech.approved = true

    tech.save! if tech.changed?
  end
end

puts "Seeded #{Technology.count} technologies"
