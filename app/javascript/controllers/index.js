import { application } from "./application"
import TechnologyPickerController from "./technology_picker_controller"
import TechnologyFilterController from "./technology_filter_controller"

application.register("technology-picker", TechnologyPickerController)
application.register("technology-filter", TechnologyFilterController)
