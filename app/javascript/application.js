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
