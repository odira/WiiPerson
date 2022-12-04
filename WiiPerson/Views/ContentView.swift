import SwiftUI

enum TabType: Int {
    case main
    case personsList
}

struct ContentView: View {
    @State private var selectedTab: TabType = .main
    var body: some View {
        TabView(selection: $selectedTab) {
            MainView()
                .tabItem {
                    Label("Main View", systemImage: "rectangle.on.rectangle.square")
                }
                .tag(TabType.main)
            
            PersonsListView()
                .tabItem {
                    Label("Persons List", systemImage: "person.3")
                }
                .tag(TabType.personsList)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
