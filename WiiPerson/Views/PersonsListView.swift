import SwiftUI
import WiiKit

struct PersonsListView: View {
    @EnvironmentObject var personnelModel: PersonnelModel
    @EnvironmentObject var personFilters: PersonFilters
    
    @State private var isPresentedSearchSheet = false
    @State private var isPresentedAddSheet = false
    @State private var isPresentedConfirmationSheet = false
    
    @State private var searchExpr: String = ""
    
    @State private var selectedPerson: Person = Person.samples[0]
    
    var filteredPersons: [Person] {
        var results = personnelModel.persons
        
        if !searchExpr.isEmpty {
            results = results.filter { $0.surname.contains(searchExpr.lowercased().capitalized) }
        }
    
//        switch personFilters.byValid {
//        case .all:
//            break
//        case .valid:
//            results.removeAll(where: {!$0.valid!})
//        case .invalid:
//            results.removeAll(where: {$0.valid!})
//        }
    
        if !personFilters.byName.isEmpty {
            results = results.filter { $0.name.contains(personFilters.byName.lowercased().capitalized) }
        }
        if !personFilters.byMiddlename.isEmpty {
            results = results.filter { $0.middleName.contains(personFilters.byMiddlename.lowercased().capitalized) }
        }
        if !personFilters.bySurname.isEmpty {
//            results.removeAll(where: { $0.surname.range(of: personFilters.bySurname, options: .caseInsensitive) == nil })
            results = results.filter { $0.surname.contains(personFilters.bySurname.lowercased().capitalized) }
        }
    
        results = results.filter { personFilters.byShiftNum == 0 || $0.shiftNum == personFilters.byShiftNum }
    
        return results
    }
    
    @State var personData = Person.Data()
    
    // MARK: - View
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredPersons) { person in
                    NavigationLink(destination: PersonDetailView(person: person)) {
                        PersonCard(for: person)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            withAnimation {
                                selectedPerson = person
                                isPresentedConfirmationSheet.toggle()
                            }
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                    .confirmationDialog(
                        "Are you sure?",
                        isPresented: $isPresentedConfirmationSheet,
                        titleVisibility: .visible
                    ) {
                        Button("Yes", role: .destructive) {
                            withAnimation {
                                personnelModel.sqlPersonDELETE(selectedPerson)
//                                personnelModel.reload()
                            }
                        }
                        .keyboardShortcut(.defaultAction)
                        
                        Button("No", role: .cancel) {}
                    } message: {
                        Text("You are going to delete person...")
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .searchable(text: $searchExpr, prompt: "Search by surname")
            .autocapitalization(.none)
            .navigationBarTitle("???????????? ????????????????????")
            .navigationBarItems(
                leading:
                    HStack {
                        Button(action: { isPresentedAddSheet.toggle() }) {
                            Image(systemName: "plus")
                        }
                    },
                trailing:
                    HStack {
                        Button(action: { isPresentedSearchSheet.toggle() }) {
                            Image(systemName: "magnifyingglass")
                        }
                        Button(action: { personFilters.update() }) {
                            Image(systemName: "repeat")
                        }
                    }
            )
            .sheet(isPresented: $isPresentedAddSheet) {
                addPersonView(isPresented: $isPresentedAddSheet)
            }
            .sheet(isPresented: $isPresentedSearchSheet) {
                PersonFiltersView(isPresented: self.$isPresentedSearchSheet, personFilters: personFilters)
            }
        }
    }
}

// MARK: - Preview

struct PersonsListView_Previews: PreviewProvider {
    static var previews: some View {
        PersonsListView()
            .environmentObject(PersonnelModel())
            .environmentObject(PersonFilters())
    }
}

// MARK: - Additional Views

extension PersonsListView {
    func addPersonView(isPresented: Binding<Bool>) -> some View {
        NavigationView {
            PersonEditView(data: self.$personData)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Dismiss") {
                            personData = Person.Data()
                            isPresentedAddSheet.toggle()
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add") {
//                            let newPerson = Person(data: personData)
                            personnelModel.sqlPersonINSERT(data: personData)
//                            personnelModel.reload()
                            isPresentedAddSheet.toggle()
                        }
                    }
                }
        }
    }
}
