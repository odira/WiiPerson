import SwiftUI
import WiiKit

@main
struct WiiPersonApp: App {
    @StateObject var personnelModel = PersonnelModel()
    @StateObject var positionModel = PositionModel()
    @StateObject var personFilters = PersonFilters()
    
    var body: some Scene {
        WindowGroup {
            PersonsListView()
                .environmentObject(personnelModel)
                .environmentObject(positionModel)
                .environmentObject(personFilters)
        }
    }
}
