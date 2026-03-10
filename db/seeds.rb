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


puts "Creating 5 complete demo projects..."

user = User.first || User.create!(
  email: "demo@codemate.dev",
  password: "password",
  display_name: "Demo User"
)

demo_projects = [
  {
    title: "Airbnb Clone",
    short_description: "Build a marketplace like Airbnb",
    description: "Full stack marketplace project with listings, bookings, authentication, dashboard and payments.",
    category: "web_app",
    estimated_duration: "one_month",
    max_collaborators: 4,
    status: "open",
    technologies: [ "Ruby", "Rails", "PostgreSQL", "HTML", "CSS", "JavaScript", "Bootstrap" ]
  },
  {
    title: "AI Recipe Generator",
    short_description: "Generate recipes with AI",
    description: "An AI-powered app that suggests recipes based on ingredients, food preferences and dietary restrictions.",
    category: "ai",
    estimated_duration: "two_weeks",
    max_collaborators: 3,
    status: "open",
    technologies: [ "Python", "OpenAI API", "PostgreSQL", "HTML", "CSS", "JavaScript" ]
  },
  {
    title: "Habit Tracker",
    short_description: "Track your daily habits",
    description: "A productivity web app with habit streaks, reminders, progress stats and a clean dashboard.",
    category: "web_app",
    estimated_duration: "weekend",
    max_collaborators: 2,
    status: "open",
    technologies: [ "Ruby", "Rails", "PostgreSQL", "HTML", "CSS" ]
  },
  {
    title: "Fitness Mobile App",
    short_description: "Track workouts and progress",
    description: "A mobile fitness app with workout plans, progress tracking and daily reminders.",
    category: "mobile_app",
    estimated_duration: "three_months",
    max_collaborators: 5,
    status: "open",
    technologies: [ "React Native", "JavaScript", "CSS" ]
  },
  {
    title: "Open Source Finder",
    short_description: "Discover open source projects",
    description: "A platform to explore beginner-friendly open source repositories by language, stack and contribution level.",
    category: "tool",
    estimated_duration: "one_week",
    max_collaborators: 3,
    status: "open",
    technologies: [ "Rails", "PostgreSQL", "JavaScript", "GitHub Actions", "HTML", "CSS" ]
  }
]

demo_projects.each do |attrs|
  tech_names = attrs.delete(:technologies)

  project = Project.find_or_initialize_by(title: attrs[:title])
  project.assign_attributes(attrs)
  project.save!

  technologies = Technology.where(name: tech_names)
  project.technologies = technologies

  Collaboration.find_or_create_by!(
    user: user,
    project: project
  ) do |collaboration|
    collaboration.owner = true
    collaboration.status = "accepted"
  end
end

puts "5 complete demo projects created 🚀"
